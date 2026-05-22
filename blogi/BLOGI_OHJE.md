# Blogin käyttöohje

Tämä dokumentti selittää kuinka lisätä uusia artikkeleita topiautio.fi-sivustolle.

## Rakenne

```
/blogi/
  index.html                 # Blogin pääsivu (artikkelien listaus)
  blogi-tyylit.css           # Yleiset blogin tyylit
  /julkaisut/
    MALLI.html               # Malli uusille artikkeleille (kopioi tämä)
    julkaisu-tyylit.css      # Artikkelikohtaiset tyylit
    /[artikkelin-slug]/
      index.html             # Yksittäinen artikkeli
```

## Uuden artikkelin lisääminen

### Vaihe 1: Luo uusi kansio
Luo kansio `blogi/julkaisut/` alle. Käytä kuvaavaa nimeä (esim. `windows11-cachyos`):

```bash
mkdir -p blogi/julkaisut/windows11-cachyos
```

### Vaihe 2: Kopioi malli
Kopioi `MALLI.html` uuteen kansioon `index.html`-nimellä:

```bash
cp blogi/julkaisut/MALLI.html blogi/julkaisut/windows11-cachyos/index.html
```

### Vaihe 3: Muokkaa artikkelia
Avaa `index.html` ja:

1. **Päivitä metatiedot head-osioon:**
   - `[ARTIKKELIN OTSIKKO - Päivitä tämä!]` → Artikkelin otsikko
   - `[ARTIKKELIN KUVAUS - Päivitä tämä!]` → Lyhyt kuvaus (SEO)
   - `[AVAINSANAT - Päivitä tämä!]` → Hakusanoja
   - `[PP.KK.YYYY]` → Julkaisupäivä
   - `[REITTI]` → Artikkelin reitti (esim. `windows11-cachyos`)

2. **Kirjoita sisältö:**
   - Korvaa `<!-- MUOKKAA TÄMÄN JÄLKEEN -->` ja `<!-- MUOKKAUS PÄÄTTYY TÄHÄN -->` välinen teksti omalla sisällölläsi
   - Käytä tarjottuja H2/H3/H4-otsikoita, koodilohkoja ja listoja rakenteiden ohjauksena

3. **Lisää koodiesimerkkejä** (valinnainen):
   ```html
   <pre><code class="language-bash">
   $ komento tässä
   output täällä
   </code></pre>
   ```

   Tuetut kielitunnisteet: `bash`, `python`, `html`, `css`, `javascript`, `java`, jne.

### Vaihe 4: Päivitä blogin pääsivu
Muokkaa `blogi/index.html` ja lisää uusi artikkeli `.posts-list`-osioon:

```html
<article class="post-card">
    <h3><a href="/blogi/julkaisut/windows11-cachyos/">Artikkelin otsikko</a></h3>
    <div class="post-meta">
        <span class="post-date"><span class="material-symbols-outlined">calendar</span>25.01.2025</span>
        <span class="post-reading-time"><span class="material-symbols-outlined">schedule</span>8 min luku</span>
    </div>
    <p>Lyhyt kuvaus artikkelista. Tämä teksti näkyy listalla.</p>
</article>
```

### Vaihe 5: Lisää navigaatio (valinnainen)
Jos haluat linkittää artikkelit toisiinsa, päivitä `post-nav`-osio artikkelissa:

```html
<div class="post-nav-item prev">
    <a href="/blogi/julkaisut/[EDELLINEN-ARTIKKELI]/">← Edellinen artikkeli</a>
</div>
<div class="post-nav-item next">
    <a href="/blogi/julkaisut/[SEURAAVA-ARTIKKELI]/">Seuraava artikkeli →</a>
</div>
```

## Rakenteen parhaita käytäntöjä

### HTML-rakenne
- **H2** = Pääosio (esim. "Johdanto", "Asennus")
- **H3** = Alaosio (esim. "DNS-konfiguraatio")
- **H4** = Alakohtia (esim. "Koodi-esimerkki")

### Koodiblokki
```html
<pre><code class="language-bash">
$ sudo apt update
$ sudo apt install package
</code></pre>
```

### Sisäisen koodin korostus
```html
<p>Käytä komentoa <code>sudo systemctl restart service</code> palvelun uudelleenkäynnistämiseen.</p>
```

### Lainaus
```html
<blockquote>
  Tämä on tärkeä huomautus tai lainaus artikkelista.
</blockquote>
```

### Luettelo
```html
<ul>
  <li>Ensimmäinen kohta</li>
  <li>Toinen kohta</li>
  <li>Kolmas kohta</li>
</ul>
```

## Tyylit ja CSS

**Älä muokkaa tyylitiedostoja** (`blogi-tyylit.css`, `julkaisu-tyylit.css`) ellei sinulla ole erityistä syytä. Kaikki sisältö-osion styling on jo määritelty.

Jos haluat lisätä kuvia, käytä normaaleja img-tageja:
```html
<img src="image.png" alt="Kuvan kuvaus">
```

Kuvat muokkautuvat automaattisesti responsiiviksi.

## Saatavilla olevat CSS-luokat

Jos haluat käyttää mukautettuja elementtejä, nämä luokat on saatavilla:

- `.post-card` - Artikkelikortti (blogin pääsivulla)
- `.post-meta` - Metatiedot (pvm, luku-aika)
- `.post-content` - Sisältöalue (sisäiset tyylit)
- `.post-header` - Otsikkosarja
- `.post-footer` - Alinmuistutus
- `.cta-link` - Call-to-action -nappi

## Esimerkkiartikkeli

Katsomalla `MALLI.html` näet täyden rakenteen kommentteilla. Kopio siitä ja aloita sieltä.

## Vianmääritys

**Ongelma:** Artikkeli näyttää oudolta tai tyylit eivät toimineet.
- Varmista, että kopioit kaikki stylesheet-linkit `<head>`-osioon.
- Tarkista, että polut ovat oikein (`/styles.css`, `/blogi/blogi-tyylit.css`, `/blogi/julkaisut/julkaisu-tyylit.css`).

**Ongelma:** Koodi ei näy kunnolla.
- Varmista, että käytät `<pre><code>` -rakennetta.
- Lisää kielitunnus: `class="language-bash"`.

**Ongelma:** Linkit eivät toimi.
- Absoluutiset polut alkavat `/blogi/julkaisut/...`.
- Suhteelliset polut käyttävät `../` tai `../../`.

---

Onnea kirjoittamiseen! 🚀
