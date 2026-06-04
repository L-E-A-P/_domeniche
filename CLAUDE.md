# Convenzione immagini gallerie (repo `_dapdi`)

Le immagini delle gallerie sono organizzate **sempre** con questa struttura, una cartella per **fotografo** identificato dalla sua sigla:

```
img/EVENTO/<sigla-fotografo>/org/    foto originali scattate (full-res) — NON pubblicate, sorgente
img/EVENTO/<sigla-fotografo>/edit/   resize alleggerite, CON logo + nome del fotografo — aperte nel lightbox
img/EVENTO/<sigla-fotografo>/thumb/  miniature mostrate nella griglia
```

`org/`, `edit/`, `thumb/` contengono gli **stessi nomi file**. Questa struttura deve valere SEMPRE.
Convenzione `EVENTO`: `AAAA-MM-GG-dapdi-<n-romano>` (es. `2024-03-24-dapdi-iii`).

## Sigle fotografo
- `ac` = Alice Cortegiani
- `dt` = Davide Tedesco
- altre sigle in uso nei repo LEAP: `gmd`, `lz`, `gs`
- nome esteso da normalizzare a sigla: `marco-iacobucci`

## Import di una galleria
Usare lo script (resize via `sips`):

```bash
bin/import-domenica.sh <cartella-originali> <evento> <sigla>
# es: bin/import-domenica.sh ~/Downloads/3a-domenica 2024-03-24-dapdi-iii ac
```
Genera `img/<evento>/<sigla>/{org,edit,thumb}` e stampa la riga `{% include gallery %}` da incollare nella pagina.

## Pagine e URL
Le pagine markdown stanno alla **radice** del repo (`001-prima-domenica.md`, ...): URL `/domeniche/<slug>/`.
Il motore del tema (`so-leap-theme/_includes/gallery`) prende le miniature da `thumb/` e le immagini complete del lightbox da `edit/`. Le immagini di questo repo vivono nella **collezione** (`site.collections[].files`); path include `dapdi/img/...`.

## TODO futuro
Watermark automatico (logo + nome fotografo) sulle immagini in `edit/`, rigenerandole da `org/`.
