# manga2kindle

Convert a manga PDF (one you own and downloaded locally) into a Kindle-ready file,
with correct manga settings — right-to-left reading, double-page splitting, and
e-ink-appropriate resizing. It's a thin wrapper around
[KCC (Kindle Comic Converter)](https://github.com/ciromattia/kcc).

Hand it a PDF, get back an `.epub` you can send to your Kindle.

## Install

```bash
git clone https://github.com/wasihussain914/manga2kindle.git
cd manga2kindle
python3 -m venv .venv
. .venv/bin/activate
pip install pymupdf "git+https://github.com/ciromattia/kcc.git"
```

## Usage

```bash
./manga2kindle.sh "One Piece v1.pdf"
```

That produces `One Piece v1.epub` next to the input, converted for a Kindle
Paperwhite in manga (right-to-left) mode. Then get it onto your Kindle via the
**Send to Kindle** app/email, or copy it over USB into the `documents/` folder.

### Options (environment variables)

| Var       | Default | Notes |
|-----------|---------|-------|
| `PROFILE` | `KPW5`  | Kindle device profile. Others: `KPW6`, `KO` (Oasis), `KV` (Voyage), `K11` (basic 11th gen), `KS` (Scribe). Run `.venv/bin/kcc-c2e --help` for the full list. |
| `FORMAT`  | `EPUB`  | `EPUB` (recommended for Send-to-Kindle) or `MOBI` (needs `kindlegen`). |
| `EXTRA`   | —       | Extra flags passed straight to `kcc-c2e`. |

```bash
# Different device + MOBI output into a folder
PROFILE=KPW6 FORMAT=MOBI ./manga2kindle.sh chapter.pdf ~/Kindle/

# Color manga, higher JPEG quality
EXTRA="--forcecolor --jpeg-quality 92" ./manga2kindle.sh book.pdf
```

## Notes

- Modern Kindles accept **EPUB** through Send-to-Kindle, so that's the default.
  `--nokepub` is applied so you get a plain `.epub` (not Kobo's `.kepub.epub`).
- KCC reads images out of the PDF directly — no manual extraction needed.
- For **MOBI** output you need Amazon's `kindlegen` binary on your PATH.
- This is for manga/comics **you legally own**. Don't be a pirate.
