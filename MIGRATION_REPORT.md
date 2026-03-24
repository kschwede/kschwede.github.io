# Migration Report

Date: 2026-03-23

## Summary

Legacy content from `public_html/` was copied into the GitHub Pages repository root and migrated to a light Jekyll layout with a shared sidebar, a single shared stylesheet, and compatibility stubs for the former frame entry points.

Jekyll rendering was verified locally with `jekyll build`.

An accessibility cleanup pass was also completed on the migrated site content, including improved global focus and link styling, semantic course-page headers, better top-level heading structure, accessible table/button behavior on the reading seminar page, and improved image alt text on the active FRG site.

## Old URL to new URL mapping

| Old URL | New URL |
| --- | --- |
| `/index.html` | `/` |
| `/home.html` | `/home.html` redirecting to `/` |
| `/sidebar.html` | `/sidebar.html` redirecting to `/` |
| `/contact.html` | `/contact.html` |
| `/papers.html` | `/papers.html` |
| `/StudentsAndPostdocs.html` | `/StudentsAndPostdocs.html` |
| `/Slides.html` | `/Slides.html` |
| `/notes.html` | `/notes.html` |
| `/linkplaces.html` | `/linkplaces.html` |
| `/linkpeople.html` | `/linkpeople.html` |
| `/M2.html` | `/M2.html` |
| `/seminars.html` | `/seminars.html` |
| `/math2200/index.html` and other course-directory `index.html` pages | Same URL path, now rendered within the shared layout where migrated |
| `/readingseminar/index.html` | `/readingseminar/index.html` |
| `/FRG/index.php` | `/FRG/` via new static `FRG/index.html` |
| `http://www.math.utah.edu/~schwede/...` internal links | Converted to site-relative GitHub Pages paths where migrated |

## Files changed

- Added shared layout files: `_config.yml`, `_layouts/default.html`, `_includes/sidebar.html`, `assets/css/site.css`
- Added `.gitignore` for Jekyll build artifacts
- Replaced the frame shell with a real homepage in `index.html`
- Added backward-compatibility stubs in `home.html` and `sidebar.html`
- Added stable CV alias `cv.pdf`
- Migrated top-level content pages: `contact.html`, `papers.html`, `StudentsAndPostdocs.html`, `Slides.html`, `notes.html`, `linkplaces.html`, `linkpeople.html`, `M2.html`, `seminars.html`
- Migrated teaching and seminar entry pages: `Camp2014/index.html`, `Camp2016/index.html`, `frob/index.html`, `M2RTG/index.html`, `M2RTG/Fall23.html`, `MichiganClasses/math185/index.html`, `MichiganClasses/math185-Fall2007/index.html`, `MichiganClasses/math186/index.html`, `MichiganClasses/math217/index.html`, `MichiganClasses/math632/index.html`, `math1260/index.html`, `math2200/index.html`, `math2200-fall2022/index.html`, `math2200-fall2024/index.html`, `math2200-spring2018/index.html`, `math311/index.html`, `math3210/index.html`, `math3210-fall2018/index.html`, `math435/index.html`, `math435-spring2011/index.html`, `math5310/index.html`, `math5320/index.html`, `math5320-spring2020/index.html`, `math536/index.html`, `math538/index.html`, `math538-fall2011/index.html`, `math5405/index.html`, `math6130/index.html`, `math6140/index.html`, `math6310/index.html`, `math6310-fall2017/index.html`, `math6310-fall2019/index.html`, `math6310-fall2021/index.html`, `math6320/index.html`, `math6350/index.html`, `math7800/index.html`, `math7830/index.html`, `math7830-spring2017/index.html`, `readingseminar/index.html`
- Added GitHub Pages compatible FRG entry page: `FRG/index.html`
- Updated lingering internal self-links in `FRG-Old/faculty.html` and `FRG-Old/index.html`
- Replaced the repository README with GitHub Pages migration instructions
- Improved accessibility across the active site pages:
  - strengthened global keyboard focus, link visibility, and responsive reading styles in `_layouts/default.html` and `assets/css/site.css`
  - converted repeated legacy course-page headers from centered/font-based markup to semantic `header` and `dl` structures
  - added page-level headings and cleaner list/table markup on `linkplaces.html`, `linkpeople.html`, `seminars.html`, `notes.html`, `M2.html`, `Camp2014/index.html`, `Camp2016/index.html`, and `StudentsAndPostdocs.html`
  - converted `readingseminar/index.html` abstract toggles from clickable table cells and fake links to real buttons with proper table headers
  - added or improved descriptive alt text on active image-based pages including `FRG/index.html`
- Removed unlinked non-site artifacts after repository-wide reference checks: `index.old.html`, `index.restored.html`, `FRG/index.php`, `FRG/index_body.php`, `M2RTG/Backup.html`, `math7800/WStest.html`, `MichiganClasses/math185-Fall2007/.DS_Store`, `MichiganClasses/math185-Fall2007/TempX.out`, and `MichiganClasses/math217/.DS_Store`

## Redirects and compatibility stubs added

- `home.html` now redirects to `/`
- `sidebar.html` now redirects to `/`
- `cv.pdf` aliases the dated `1-2026CV.pdf`
- `FRG/index.html` serves as the GitHub Pages replacement for the legacy PHP entry point

## Unresolved issues

- Some archival subsites copied from `public_html/` remain in the repository and are not linked from the new layout
- The archival `FRG-Old/` subsite still contains legacy presentational HTML and was left largely unchanged to preserve the copied archive
