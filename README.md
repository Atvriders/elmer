# Elmer — Ham Radio Catalog & Connection Guide

> In ham radio, an **Elmer** is the mentor who patiently helps a newcomer get on the air.
> This is that mentor as a dataset + tool.

An exhaustive, source-audited dataset of **ham radios**, **digital-mode / CAT interfaces**, and the
**software** that talks to a radio — plus the **exact connection settings** for every combination and a
**searchable browser tool** to look them up.

## What's here

| File | Rows | What it is |
|---|---:|---|
| `ham_radios.csv` | 2,025 | Every ham radio — mfr, model, type, bands, modes, era, notes |
| `sound_card_interfaces.csv` | 72 | Digital-mode sound-card interfaces (SignaLink, Digirig, DRA…) |
| `cat_control_interfaces.csv` | 76 | CAT / rig-control interfaces (CT-62, CI-V, RIGtalk…) |
| `ham_software.csv` | 657 | Every program that interacts with a radio |
| `radio_connection_profiles.csv` | 2,025 | **Best PC-connection setup + all CAT/audio/PTT settings per radio**, with sources & verdicts |
| `software_connection_profiles.csv` | 657 | How each program sets rig / audio / PTT / ALC, with sources & verdicts |
| `connection_recipes.csv` | 3,716 | Turnkey **radio × software** worked settings (CAT-capable radios) |
| `AUDIT_DISCREPANCIES.csv` | 615 | Every value corrected during the source audit (was → corrected → note) |
| `CONNECTION_RULES.md` | — | Universal rules: ALC/drive, PTT priority, COM-port discovery, Digirig/SignaLink setup |
| `ham_radio_master.xlsx` | — | All of the above as one multi-sheet workbook |
| `connection-guide.html` | — | **Interactive settings finder** — open in any browser |

## The interactive guide (`connection-guide.html`)

Open it in a browser. **Search a radio → (if it has no built-in codec) pick your sound-card interface
→ search a program → read every required setting**, with clickable sources and a confirmed/corrected/
uncertain verdict on each. Works offline (fully self-contained), light & dark themes, copy-to-clipboard.

## Run it (Docker)

The interactive guide + all data are served as a static site. GitHub Actions builds a multi-arch
image and publishes it to GHCR on every push to `master`.

```bash
docker compose pull && docker compose up -d
# → http://localhost:3025
```

The bundled `docker-compose.yml` uses the prebuilt image `ghcr.io/atvriders/elmer:latest` and maps
host port **3025** → container 80. To build locally instead: `docker build -t elmer . && docker run -p 3025:80 elmer`.

## How the data was built

1. Manufacturer/category research fan-out enumerated the radios, interfaces, and software.
2. A second pass produced the best connection setup + settings for every radio and program.
3. A **source audit** cross-referenced every CAT-capable radio (336) and every program (657) against
   authoritative sources (radio manuals, Hamlib, RigPix, Digirig cable pages, official app docs),
   correcting values and attaching source URLs. Verdicts: **radios** 223 confirmed / 103 corrected /
   10 uncertain / 1,689 no-CAT; **software** 594 confirmed / 48 corrected / 15 uncertain.

## Caveats

- The **COM-port number** is assigned by your PC (Device Manager / `/dev/ttyUSB*` / `/dev/cu.*`) and
  cannot be pre-filled — baud/bits/parity are radio properties and *are* listed.
- Values are cross-referenced where a source is shown, but **always confirm against your radio's own
  manual** before wiring up, especially exact menu numbers (they vary by firmware) and obscure models.
- "Every radio ever made" is unbounded; the long tail of vintage/regional variants is where any gaps are.
