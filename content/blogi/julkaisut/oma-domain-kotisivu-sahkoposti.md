---
title: "Oma domain, kotisivu ja sähköposti: näin pystytin topiautio.fi:n"
date: 2026-10-13
draft: true
slug: "oma-domain-kotisivu-sahkoposti"
description: "Miten hankin .fi-verkkotunnuksen, ohjasin sen Cloudflaren kautta GitHub Pagesiin ja Proton Mailiin, ja mitä kokonaisuus maksaa."
summary: "Oma verkkotunnus, kotisivu ja sähköposti ilman palvelimen ylläpitoa. Tässä mitä tein, mitä se maksaa ja mitä vaihtoehtoja on."
readingTime: "6 min luku"
keywords:
  - verkkotunnus
  - .fi-domain
  - Cloudflare
  - GitHub Pages
  - Proton Mail
  - DNS
---

Halusin itselleni osoitteen, jonka voi laittaa CV:hen ja joka on minun, vaikka vaihtaisin joskus sähköpostipalvelua tai sivuston alustaa. Lopputulos on topiautio.fi: kotisivu osoitteessa [topiautio.fi](https://topiautio.fi/) ja sähköposti muotoa topi@topiautio.fi.

Kokonaisuus koostuu neljästä palasta:

| Osa | Palvelu | Hinta |
| --- | --- | --- |
| Verkkotunnus | Webbikettu | 19,95 €/v |
| Nimipalvelu (DNS) | Cloudflare | ilmainen |
| Kotisivu | GitHub Pages | ilmainen |
| Sähköposti | Proton Mail | 7,99 €/kk (Ultimate) |

## 1. Verkkotunnus

Halusin .fi-päätteen. Traficom ylläpitää listaa [.fi-verkkotunnusvälittäjistä](https://www.traficom.fi/fi/fi-verkkotunnukset/fi-verkkotunnuksen-hakeminen-ja-kayttaminen/etsi-verkkotunnusvalittaja), eli yrityksistä, joiden kautta verkkotunnuksen voi rekisteröidä. Kävin listaa läpi ja päädyin [Webbikettuun](https://webbikettu.fi/), jolla hinta oli 19,95 € vuodessa.

Minulle tärkein ehto oli, että nimipalvelimet saa vaihtaa itse. Webbiketussa se onnistuu, joten verkkotunnuksen DNS-asetuksia ei tarvitse hallita välittäjän omassa paneelissa.

<!-- KUVA: Webbiketun nimipalvelinasetukset -->

## 2. Nimipalvelu Cloudflareen

Vaihdoin verkkotunnuksen nimipalvelimiksi Cloudflaren nimipalvelimet. Cloudflaren ilmaisessa paketissa DNS-tietueita on helppo hallita yhdessä paikassa, ja muutokset näkyvät nopeasti.

Käytännössä:

1. Lisää verkkotunnus Cloudflareen. Cloudflare kertoo kaksi nimipalvelinta.
2. Vaihda ne verkkotunnusvälittäjän paneelissa vanhojen tilalle.
3. Odota, että muutos leviää. Minulla siihen meni <!-- TÄYDENNÄ: kauanko? --> .

Tämän jälkeen kaikki muut asetukset tehdään Cloudflaren DNS-näkymässä.

<!-- KUVA: Cloudflaren DNS-tietueet -->

## 3. Kotisivu GitHub Pagesiin

Sivusto on rakennettu [Hugolla](https://gohugo.io/), ja sen lähdekoodi on [GitHubissa](https://github.com/topiautio/topiautio-kotisivu). GitHub Actions rakentaa sivun jokaisen pushin jälkeen ja julkaisee sen GitHub Pagesiin. GitHub Pages on ilmainen julkisille repositorioille.

Jotta sivu näkyy omassa osoitteessa, tarvitaan kaksi asiaa:

- **GitHubissa:** repositorion Pages-asetuksiin oma verkkotunnus ja ”Enforce HTTPS” päälle.
- **Cloudflaressa:** juuriverkkotunnukselle A-tietueet GitHubin osoitteisiin ja `www`-aliverkkotunnukselle CNAME-tietue. Ajantasaiset osoitteet löytyvät [GitHubin ohjeesta](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site).

Yksi vinkki tietoturvan puolelta: [vahvista verkkotunnus GitHub-tililläsi](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/verifying-your-custom-domain-for-github-pages). Silloin kukaan muu ei voi ottaa verkkotunnustasi käyttöön omalle Pages-sivulleen, jos oma sivusi on vaikka hetken pois päältä.

## 4. Sähköposti Proton Mailiin

Sähköpostini on [Proton Mailissa](https://proton.me/mail). Oma verkkotunnus vaatii maksullisen tilauksen. Minulla on Ultimate-paketti, joka maksaa 7,99 € kuussa. Pelkkään sähköpostiin oman verkkotunnuksen kanssa riittää myös halvempi paketti, joten vertaa [Protonin hintoja](https://proton.me/mail/pricing) itse.

Kun verkkotunnuksen lisää Protoniin, Proton antaa listan DNS-tietueita, jotka lisätään Cloudflareen:

- **TXT-vahvistustietue,** jolla todistat omistavasi verkkotunnuksen
- **MX-tietueet,** jotka ohjaavat saapuvan postin Protonille
- **SPF (TXT),** joka kertoo, mitkä palvelimet saavat lähettää postia nimissäsi
- **DKIM (CNAME),** jolla lähtevät viestit allekirjoitetaan
- **DMARC (TXT),** joka kertoo vastaanottajalle, mitä tehdä viesteille, jotka eivät läpäise SPF- ja DKIM-tarkistuksia

Kopioi arvot suoraan Protonin hallintapaneelista. Cloudflaressa sähköpostin tietueiden pitää olla tilassa **DNS only** (harmaa pilvi), eli niitä ei saa ohjata Cloudflaren välityspalvelimen kautta.

<!-- KUVA: Protonin verkkotunnusasetukset, kaikki tarkistukset vihreällä -->

<!-- TÄYDENNÄ: menikö jokin pieleen tai kestikö jokin yllättävän kauan? -->

## 5. Sivu hakukoneisiin

Sivu ei ilmesty hakutuloksiin heti, vaikka se olisi netissä. Sitä voi nopeuttaa:

- **[Google Search Console](https://search.google.com/search-console):** vahvista verkkotunnus TXT-tietueella Cloudflaressa ja lähetä sivukartta. Hugo tekee sivukartan automaattisesti osoitteeseen `/sitemap.xml`.
- **[Bing Webmaster Tools](https://www.bing.com/webmasters):** sama juttu Bingille. Asetukset voi tuoda suoraan Search Consolesta. Bingin hakemistoa käyttävät myös esimerkiksi DuckDuckGo ja Ecosia, joten tällä yhdellä saa katettua useamman hakukoneen.

Brave Searchilla on oma hakemistonsa, mutta sille ei ole vastaavaa työkalua. Sivu löytyy sinne ajan kanssa.

## Ylläpito

Tämä oli minulle koko jutun paras puoli: ylläpidettävää ei käytännössä ole. Ei palvelinta, jota päivittää, eikä tietokantaa. Ainoa pakollinen kulu on verkkotunnus, 19,95 € vuodessa.

Sivua muokatessani teen muutokset ja pushaan ne GitHubiin. GitHub Pages ja Cloudflare hoitavat loput, ja muutos näkyy sivulla parissa minuutissa.

Koodin kirjoitan Codexin tai Claude Coden avulla, joista maksan noin 23 € kuussa. Pidän koodin kirjoittamista käsin todella tylsänä. Minua kiinnostaa enemmän järjestelmien ja kokonaisuuksien suunnittelu: mitä palveluja käytetään, miten ne liittyvät toisiinsa ja missä kohtaa jokin voi mennä rikki.

## Jos haluat tehdä saman

Valintani eivät ole ainoita oikeita. Jokaiselle palalle on vaihtoehtoja:

- **Verkkotunnus:** välittäjiä on paljon. Jos haluat .fi-päätteen, aloita [Traficomin listasta](https://www.traficom.fi/fi/fi-verkkotunnukset/fi-verkkotunnuksen-hakeminen-ja-kayttaminen/etsi-verkkotunnusvalittaja). Tarkista, että nimipalvelimet saa vaihtaa itse.
- **Kotisivu:** GitHub Pagesin sijaan [Cloudflare Pages](https://pages.cloudflare.com/), [Netlify](https://www.netlify.com/) tai [Vercel](https://vercel.com/). Kaikissa on ilmainen taso pienelle staattiselle sivulle.
- **Sähköposti:** Protonin sijaan esimerkiksi [Tuta](https://tuta.com/). Sähköpostipalvelimen voi periaatteessa hostata itsekin, mutta silloin vastuu toimitettavuudesta ja tietoturvasta on kokonaan omasi.

Kun verkkotunnus on oma, mikään näistä valinnoista ei ole lopullinen. Palvelua voi vaihtaa muuttamalla DNS-tietueita, ja osoite pysyy samana.
