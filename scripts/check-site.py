#!/usr/bin/env python3
"""Tarkistaa rakennetun sivuston (oletuksena public/).

1. Sisäiset linkit: jokainen sivuston sisäinen href/src osoittaa olemassa olevaan
   tiedostoon, ja #ankkuri löytyy kohdesivulta.
2. CSP-yhteensopivuus: sivuilla ei ole inline-tyylejä, inline-skriptejä eikä
   on*-tapahtumankäsittelijöitä, joita Content-Security-Policy estäisi.
3. Pakolliset tiedostot: security.txt, PGP-avain, jakokuva ja blogin RSS-syöte.

Ulkoisia linkkejä ei tarkisteta, koska niiden vastaukset vaihtelevat (esim.
LinkedIn estää botit) ja tekisivät tarkistuksesta epäluotettavan.
"""

import sys
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit

SITE_HOSTS = {"topiautio.fi", "www.topiautio.fi"}
LINK_ATTRS = {"href", "src"}
# JSON-LD ja muut data-lohkot eivät ole suoritettavaa koodia, joten CSP ei estä niitä.
DATA_SCRIPT_TYPES = {"application/ld+json"}
REQUIRED_FILES = [
    ".well-known/security.txt",
    "pgp-key.asc",
    "og-image.png",
    "blogi/index.xml",
]


class PageParser(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.links = []
        self.ids = set()
        self.problems = []
        self._script_type = None
        self._script_has_src = False

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if "id" in attrs:
            self.ids.add(attrs["id"])
        if tag == "a" and "name" in attrs:
            self.ids.add(attrs["name"])
        for name, value in attrs.items():
            if name in LINK_ATTRS and value is not None:
                self.links.append((tag, value))
            if name == "style":
                self.problems.append(f"inline-tyyli <{tag} style=…>")
            if name.startswith("on"):
                self.problems.append(f"tapahtumankäsittelijä <{tag} {name}=…>")
        if tag == "style":
            self.problems.append("<style>-lohko")
        if tag == "script":
            self._script_type = (attrs.get("type") or "text/javascript").lower()
            self._script_has_src = "src" in attrs

    def handle_endtag(self, tag):
        if tag == "script":
            self._script_type = None

    def handle_data(self, data):
        if (
            self._script_type is not None
            and not self._script_has_src
            and self._script_type not in DATA_SCRIPT_TYPES
            and data.strip()
        ):
            self.problems.append("inline-skripti <script>")


def resolve(site: Path, page: Path, url: str):
    """Palauttaa (tiedosto, ankkuri) sisäiselle linkille tai None ulkoiselle."""
    parts = urlsplit(url)
    if parts.scheme in ("mailto", "tel", "data", "javascript"):
        return None
    if parts.scheme or parts.netloc:
        if parts.netloc not in SITE_HOSTS:
            return None
    path = unquote(parts.path)
    if not path:
        target = page
    elif path.startswith("/"):
        target = site / path.lstrip("/")
    else:
        target = page.parent / path
    if target.is_dir() or path.endswith("/"):
        target = target / "index.html"
    return target.resolve(), parts.fragment


def main() -> int:
    site = Path(sys.argv[1] if len(sys.argv) > 1 else "public").resolve()
    if not site.is_dir():
        print(f"Hakemistoa '{site}' ei ole. Rakenna sivusto ensin.", file=sys.stderr)
        return 1

    pages = {}
    for html in sorted(site.rglob("*.html")):
        parser = PageParser()
        parser.feed(html.read_text(encoding="utf-8"))
        pages[html.resolve()] = parser

    errors = [f"puuttuva tiedosto: {name}" for name in REQUIRED_FILES if not (site / name).is_file()]
    for page, parser in pages.items():
        rel = page.relative_to(site)
        for problem in parser.problems:
            errors.append(f"{rel}: CSP estäisi: {problem}")
        for tag, url in parser.links:
            resolved = resolve(site, page, url)
            if resolved is None:
                continue
            target, fragment = resolved
            if not target.is_file():
                errors.append(f"{rel}: rikkinäinen linkki <{tag}> {url}")
                continue
            if fragment and target.suffix == ".html":
                target_ids = pages[target].ids if target in pages else set()
                if fragment not in target_ids:
                    errors.append(f"{rel}: ankkuria #{fragment} ei löydy: {url}")

    if errors:
        print("\n".join(errors))
        print(f"\n{len(errors)} virhettä {len(pages)} sivulla.", file=sys.stderr)
        return 1
    print(f"OK: {len(pages)} sivua, sisäiset linkit ja CSP-yhteensopivuus kunnossa.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
