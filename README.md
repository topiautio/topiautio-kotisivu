# topiautio-kotisivu

Topi Aution portfolio- ja CV-sivusto (https://topiautio.fi/).

Sivuston tuotantoversio rakennetaan Hugolla ja julkaistaan suoraan juuripolkuun:

- `/` → portfolio
- `/blogi/` → blogi
- `/cv/` → CV

Suomenkielinen sivusto IT-harjoitteluun ja junior-rooleihin (painotus: kyberturvallisuus, järjestelmähallinta, tietoverkot) Jyväskylän alueella.

## Tech
- Hugo (static site generator)
- HTML5 + CSS3
- Self-hosted DM Serif Display, DM Sans ja DM Mono -fontit
- GitHub Pages (CNAME: topiautio.fi)

## Hugo-rakenne
- `config.toml` sisältää sivuston perusasetukset. Hugo rakentaa sivuston `public/`-hakemistoon ja käyttää tuotannossa osoitetta `https://topiautio.fi/`.
- `content/` sisältää Hugon sivut ja blogiartikkelien metatiedot.
- `layouts/` sisältää sivujen renderöintipohjat. Nykyiset pohjat on migroitu pois erillisestä legacy-HTML-polkuhaun varassa toimivasta renderöinnistä, jotta Hugo-build on itsenäisempi.
- `static/` sisältää Hugon julkaisuun kopioimat staattiset tiedostot kuten CSS:n, paikalliset fontit, faviconin, robots.txt:n ja CNAME:n.

## Paikallinen kehitys
1. `git clone https://github.com/topiautio/topiautio-kotisivu.git`
2. `cd topiautio-kotisivu`
3. `hugo server`
4. Avaa Hugon ilmoittama osoite selaimessa.

## Build

```bash
scripts/build-site.sh
```

Skripti rakentaa tuotantosivuston `public/`-kansioon. Tämä vastaa GitHub Pagesiin julkaistavaa rakennetta. Älä muokkaa build-outputia käsin, vaan tee Hugo-muutokset `content/`, `layouts/`, `static/` tai `config.toml` -tiedostoihin.

## Uuden blogiartikkelin lisääminen
1. Luo Markdown-tiedosto kansioon `content/blogi/julkaisut/`, esimerkiksi `content/blogi/julkaisut/uusi-artikkeli.md`.
2. Lisää front matter:

```yaml
---
title: "Artikkelin otsikko"
date: 2026-07-15
slug: "uusi-artikkeli"
description: "Lyhyt kuvaus artikkelista."
summary: "Lyhyt listauksessa näkyvä tiivistelmä."
readingTime: "8 min luku"
---
```

3. Kirjoita artikkelin sisältö front matterin jälkeen Markdownina. Blogilista ja artikkelisivu muodostuvat automaattisesti sisältötiedoston tiedoista.
4. Aja `hugo server` ja tarkista sivu selaimessa.

## Tarkistukset

GitHub Actions ajaa jokaisessa PR:ssä ja main-pushissa buildin jälkeen seuraavat tarkistukset. Jos jokin epäonnistuu, `build`-tarkistus on punainen eikä sivustoa julkaista.

```bash
scripts/build-site.sh
npm ci --ignore-scripts                                   # pa11y-ci ja puppeteer
python3 scripts/check-site.py public                      # sisäiset linkit, CSP-yhteensopivuus, pakolliset tiedostot
CHROME_BIN=/usr/bin/google-chrome scripts/check-accessibility.sh public     # WCAG 2 AA (pa11y-ci)
CHROME_BIN=/usr/bin/google-chrome node scripts/capture-site-screenshots.mjs public screenshots
```

- **Linkit ja CSP:** `check-site.py` tarkistaa, että sisäiset linkit ja ankkurit toimivat ja ettei sivuilla ole inline-tyylejä tai -skriptejä, jotka sivuston Content-Security-Policy (`config.toml`, `contentSecurityPolicy`) estäisi. Tyylit kuuluvat `static/`-kansion CSS-tiedostoihin ja skriptit `.js`-tiedostoihin. Ulkoisia linkkejä ei tarkisteta.
- **Saavutettavuus:** `check-accessibility.sh` ajaa pa11y-ci:n (HTML_CodeSniffer ja axe) jokaiselle sivukartan sivulle. Axen kontrastitarkistus on ohitettu, koska se ei osaa laskea kontrastia liukuväritaustoja vasten. Kontrastin tarkistaa HTML_CodeSniffer.
- **Kuvakaappaukset:** PR-buildit tallentavat jokaisesta sivusta kuvakaappauksen Actionsin `site-screenshots`-artefaktiksi 14 päiväksi. Chromen polun voi antaa `CHROME_BIN`-muuttujalla. Ubuntun snap-paketin `chromium-browser` ei toimi CI- ja container-ympäristöissä.

## Tietoturva ja jakaminen

- `/.well-known/security.txt` luodaan jokaisessa buildissa pohjasta `assets/security.txt`. Sen `Expires`-päiväys on 11 kuukautta buildista, joten sivusto pitää julkaista uudelleen vähintään kerran vuodessa.
- `static/pgp-key.asc` on Proton Mailin julkinen avain osoitteelle topi@topiautio.fi.
- Jakokuva `static/og-image.png` (1200×630) luodaan tiedostosta `scripts/og-image.html`. Ohje on tiedoston alussa.
- Sivujen otsikot, kuvaukset ja avainsanat ovat sisältötiedostojen front matterissa (`seoTitle`, `description`, `shareTitle`, `shareDescription`, `keywords`). Yhteinen `<head>` on tiedostossa `layouts/partials/head.html`.
