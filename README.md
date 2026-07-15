# topiautio-kotisivu

Topi Aution portfolio- ja CV-sivusto (https://topiautio.fi/), rakennettuna Hugolla.

Suomenkielinen sivusto IT-harjoitteluun ja junior-rooleihin (painotus: kyberturvallisuus, järjestelmähallinta, tietoverkot) Jyväskylän alueella.

## Tech
- Hugo (static site generator)
- HTML5 + CSS3
- Google Fonts (Lato + Material Symbols)
- GitHub Pages (CNAME: topiautio.fi)

## Hugo-rakenne
- `config.toml` sisältää sivuston perusasetukset, yhteiset parametrit ja päävalikon.
- `content/` sisältää Hugon sivut ja blogiartikkelien metatiedot.
- `layouts/` sisältää sivujen renderöintipohjat. Nykyiset pohjat on migroitu pois erillisestä legacy-HTML-polkuhaun varassa toimivasta renderöinnistä, jotta Hugo-build on itsenäisempi.
- `static/` sisältää Hugon julkaisuun kopioimat staattiset tiedostot kuten CSS:n, faviconin, robots.txt:n ja CNAME:n.

## Paikallinen kehitys
1. `git clone https://github.com/topiautio/topiautio-kotisivu.git`
2. `cd topiautio-kotisivu`
3. `hugo server`

## Build

```bash
hugo --minify
```

Hugo tuottaa julkaistavan sivuston oletuksena `public/`-kansioon. Älä muokkaa build-outputia käsin, vaan tee muutokset `content/`, `layouts/`, `static/` tai `config.toml` -tiedostoihin.

## Uuden blogiartikkelin lisääminen
1. Luo Markdown-tiedosto kansioon `content/blogi/julkaisut/`, esimerkiksi `content/blogi/julkaisut/uusi-artikkeli.md`.
2. Lisää front matter:

```yaml
---
title: "Artikkelin otsikko"
date: 2026-07-15
url: "/blogi/julkaisut/uusi-artikkeli/"
description: "Lyhyt kuvaus artikkelista."
summary: "Lyhyt listauksessa näkyvä tiivistelmä."
readingTime: "8 min luku"
---
```

3. Lisää artikkelin sisältö tai sitä vastaava sivupohja `layouts/blogi/single.html`-rakenteeseen, kunnes blogiartikkelit on siirretty kokonaan Markdown-renderöintiin.
4. Aja `hugo server` ja tarkista sivu selaimessa.

## Chromium-pohjainen kuvakaappausvarmennus

Ubuntu voi asentaa `chromium-browser`-paketin snap-käynnistimenä, joka ei toimi kaikissa container- tai CI-ympäristöissä. Käytä tällöin snapista riippumatonta Chromium/Chrome-binääriä, esimerkiksi Google Chrome for Testing -pakettia tai `google-chrome-stable`-asennusta, ja anna tarvittaessa polku `CHROME_BIN`-ympäristömuuttujalla.

```bash
hugo --destination public --cleanDestinationDir
CHROME_BIN=/usr/bin/google-chrome scripts/capture-site-screenshots.sh public screenshots
```

Skripti tallentaa kuvakaappaukset etusivusta, blogilistauksesta, CV:stä ja Snapchat-artikkelista `screenshots/`-kansioon.
