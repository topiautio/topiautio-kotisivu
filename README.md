# topiautio-kotisivu

Topi Aution portfolio- ja CV-sivusto (https://topiautio.fi/).

Sivuston nykyinen staattinen versio palvellaan vielä juuripoluissa. Hugo-versio toimii rinnakkaisena migraatiodemona `/hugo/`-etuliitteen alla:

- `/` → nykyinen staattinen etusivu
- `/hugo/` → Hugolla rakennettu etusivu
- `/blogi/` → nykyinen staattinen blogi
- `/hugo/blogi/` → Hugolla rakennettu blogi
- `/cv/` → nykyinen staattinen CV
- `/hugo/cv/` → Hugolla rakennettu CV

Suomenkielinen sivusto IT-harjoitteluun ja junior-rooleihin (painotus: kyberturvallisuus, järjestelmähallinta, tietoverkot) Jyväskylän alueella.

## Tech
- Hugo (static site generator)
- HTML5 + CSS3
- Google Fonts (Lato + Material Symbols)
- GitHub Pages (CNAME: topiautio.fi)

## Hugo-rakenne
- `config.toml` sisältää sivuston perusasetukset. Hugo rakentaa sivuston oletuksena `public/hugo/`-hakemistoon ja käyttää tuotannossa osoitetta `https://topiautio.fi/hugo/`.
- `content/` sisältää Hugon sivut ja blogiartikkelien metatiedot.
- `layouts/` sisältää sivujen renderöintipohjat. Nykyiset pohjat on migroitu pois erillisestä legacy-HTML-polkuhaun varassa toimivasta renderöinnistä, jotta Hugo-build on itsenäisempi.
- `static/` sisältää Hugon julkaisuun kopioimat staattiset tiedostot kuten CSS:n, faviconin, robots.txt:n ja CNAME:n.

## Paikallinen kehitys
1. `git clone https://github.com/topiautio/topiautio-kotisivu.git`
2. `cd topiautio-kotisivu`
3. `hugo server`
4. Avaa Hugon ilmoittama `/hugo/`-osoite selaimessa.

## Build

```bash
scripts/build-site.sh
```

Skripti rakentaa Hugo-version `public/hugo/`-kansioon ja kopioi nykyisen staattisen sivun `public/`-kansion juureen. Tämä vastaa GitHub Pagesiin julkaistavaa rakennetta. Älä muokkaa build-outputia käsin, vaan tee Hugo-muutokset `content/`, `layouts/`, `static/` tai `config.toml` -tiedostoihin.

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

3. Blogilista muodostuu automaattisesti front matterin tiedoista. Nykyisen artikkelipohjan sisältö on vielä `layouts/blogi/single.html`-tiedostossa; seuraava migraatiovaihe on siirtää artikkelirungot Markdowniin.
4. Aja `hugo server` ja tarkista sivu selaimessa.

## Chromium-pohjainen kuvakaappausvarmennus

Ubuntu voi asentaa `chromium-browser`-paketin snap-käynnistimenä, joka ei toimi kaikissa container- tai CI-ympäristöissä. Käytä tällöin snapista riippumatonta Chromium/Chrome-binääriä, esimerkiksi Google Chrome for Testing -pakettia tai `google-chrome-stable`-asennusta, ja anna tarvittaessa polku `CHROME_BIN`-ympäristömuuttujalla.

```bash
scripts/build-site.sh
CHROME_BIN=/usr/bin/google-chrome scripts/capture-site-screenshots.sh public/hugo screenshots
```

Skripti tallentaa kuvakaappaukset etusivusta, blogilistauksesta, CV:stä ja Snapchat-artikkelista `screenshots/`-kansioon.
