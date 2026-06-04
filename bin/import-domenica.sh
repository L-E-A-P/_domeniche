#!/usr/bin/env bash
# Importa una galleria domenica nella convenzione org/edit/thumb.
# Uso: import-domenica.sh <cartella-originali> <evento> <sigla>
#   es: import-domenica.sh ~/Downloads/3a-domenica 2024-03-24-dapdi-iii ac
# Genera img/<evento>/<sigla>/{org,edit,thumb} con stessi nomi file
#   org   = originali rinominati <evento>-NN.<ext>
#   edit  = resize altezza 1080 (watermark in un passo successivo)
#   thumb = 400x300 (cover-crop, assume sorgenti landscape)
set -euo pipefail

SRC="${1:?serve la cartella degli originali}"
EVENTO="${2:?serve lo slug evento, es 2024-03-24-dapdi-iii}"
SIGLA="${3:?serve la sigla fotografo, es ac}"

# La radice del repo = cartella padre di bin/
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$ROOT/img/$EVENTO/$SIGLA"
mkdir -p "$DEST/org" "$DEST/edit" "$DEST/thumb"

# Raccoglie gli originali (jpg/jpeg/png), ordinati, e li rinomina <evento>-NN.<ext>
i=0
find "$SRC" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
  | sort | while IFS= read -r f; do
    i=$((i+1))
    n=$(printf '%02d' "$i")
    ext="$(echo "${f##*.}" | tr '[:upper:]' '[:lower:]')"
    name="$EVENTO-$n.$ext"
    cp "$f" "$DEST/org/$name"
    # edit: altezza 1080
    sips --resampleHeight 1080 "$DEST/org/$name" --out "$DEST/edit/$name" >/dev/null
    # thumb: solo ridimensionamento (lato lungo max 400), NESSUN crop.
    # La griglia del tema croppa da sola (aspect-ratio:1 + object-fit:cover),
    # quindi non serve ritagliare qui: si evita anche ogni padding.
    sips --resampleHeightWidthMax 400 "$DEST/edit/$name" --out "$DEST/thumb/$name" >/dev/null
    echo "  $name"
done

echo
echo "Fatto. Incolla nella pagina:"
echo "{% include gallery path=\"domeniche/img/$EVENTO/$SIGLA/\" %}"
