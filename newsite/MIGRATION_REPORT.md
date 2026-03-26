# Migration Report

## Summary

- Imported the legacy site from `oldsite/` into `newsite/`.
- Excluded non-site junk files from the migrated copy: `AGENTS.md`, `__MACOSX/`, and `.DS_Store`.
- Preserved the existing top-level page filenames and downloadable asset filenames wherever practical.
- Added a light Jekyll layout, shared sidebar include, and shared stylesheet for maintainability on GitHub Pages.

## Old URL -> New URL Mapping

All imported legacy pages and assets keep the same path unless noted below.

| Old URL / path | New URL / path | Notes |
| --- | --- | --- |
| `/index.html` | `/index.html` | Homepage kept at the same URL with shared layout styling. |
| `/publications.html` | `/publications.html` | Same URL; internal Utah-hosted file links rewritten to local files when present. |
| `/home.html` | `/home.html` | Added compatibility redirect to `/index.html`. |
| `/publication.html` | `/publication.html` | Added compatibility redirect to `/publications.html`. |
| `/index1.html` | `/index1.html` | Preserved as a compatibility stub because the original Keynote player assets were missing from the source import. |
| `/m4800/`, `/m7875/`, `/m78751/`, `/waccess/` | same paths | Imported intact. |

## Files Changed

Changed imported pages:

- `index.html`
- `publications.html`
- `index1.html`
- `m131113.html`
- `m131114.html`
- `m1320-006.html`
- `m1320-009.html`
- `m4800.html`
- `m5440_2018.html`
- `m5620.html`
- `m5750.html`
- `m6610.html`
- `m661011.html`
- `m661014.html`
- `m6610_2018.html`
- `m6620.html`
- `m662012.html`
- `m662015.html`
- `m662017.html`
- `m662019.html`
- `m6630.html`
- `m663013.html`
- `m6630_2020.html`
- `m679012.html`
- `m787515.html`
- `math4800.html`
- `movsat.html`

Added files:

- `_config.yml`
- `_layouts/default.html`
- `_includes/sidebar.html`
- `assets/css/site.css`
- `README.md`
- `MIGRATION_REPORT.md`
- `home.html`
- `publication.html`

Imported intact without intended structural changes:

- All copied PDFs, images, ZIP files, TeX files, MATLAB files, and course directories from `oldsite/` except excluded junk files.

## Redirects / Stubs Added

- `home.html`: meta-refresh redirect to `index.html`.
- `publication.html`: meta-refresh redirect to `publications.html`.
- `index1.html`: compatibility stub explaining that the original slide-player export was missing from the source tree.

## Unresolved Issues

- `index1.html` originally redirected to `assets/fallback/index.html` and `assets/player/KeynoteDHTMLPlayer.html`, but those files were not present in `oldsite/`.
- Some course pages reference homework PDFs that were not present in the source tree:
  - `m661011.html`: `hw1661011.pdf`, `hw2661011.pdf`, `hw3661011.pdf`, `hw4661011.pdf`, `hw5661011.pdf`
  - `m6620.html`: `hw16620.pdf`, `hw26620.pdf`, `hw26620bonus.pdf`, `hw36620.pdf`, `hw46620.pdf`, `hw56620.pdf`
  - `m662017.html`: `hw1662017.pdf`, `hw2662017.pdf`, `hw3662017.pdf`, `hw4662017.pdf`, `hw5662017.pdf`

## Notes for Maintenance

- The migrated root pages remain plain HTML content with minimal cleanup so they stay easy to hand-maintain.
- The shared styling is centralized in `assets/css/site.css`.
- The shared wrapper lives in `_layouts/default.html`, and the sidebar navigation lives in `_includes/sidebar.html`.
