# kschwede.github.io

Migrated GitHub Pages version of Karl Schwede's academic website.

## Repository structure

- `_layouts/default.html`: shared two-column page layout.
- `_includes/sidebar.html`: shared navigation derived from the legacy `sidebar.html`.
- `assets/css/site.css`: single shared stylesheet for the migrated site.
- `index.html`: real homepage for the GitHub Pages site.
- `home.html`: backward-compatibility redirect to `index.html`.
- `sidebar.html`: backward-compatibility redirect for the old frame sidebar URL.
- Top-level content pages such as `contact.html`, `papers.html`, `Slides.html`, `StudentsAndPostdocs.html`, `notes.html`, `M2.html`, and `linkplaces.html`: migrated to the shared layout.
- Course and seminar directories such as `math2200/`, `math6310/`, `math7800/`, `M2RTG/`, `MichiganClasses/`, `Camp2014/`, and `readingseminar/`: preserved in place, with their `index.html` pages adapted to the shared layout where practical.
- `FRG/`: preserved with a static `index.html` replacement for the legacy PHP entry point.
- Legacy archival files such as `index.old.html`, `index.restored.html`, and older subsite content remain in the repository for reference.
- `DocumentAccessibility.md`: preserved from the preexisting repository.

## Local preview

This repository uses light Jekyll templating for the shared layout and include files.

1. Install Jekyll if it is not already available: `gem install jekyll bundler`
2. From the repository root, run: `jekyll serve`
3. Open the local server URL shown by Jekyll, typically `http://127.0.0.1:4000/`

If you only need to inspect copied static assets, a simple file server also works, but the shared layout and include files require Jekyll to render correctly.

## GitHub Pages deployment

This repository is intended to deploy directly from the `main` branch root as a user site.

1. Push the repository to GitHub as `<username>.github.io`
2. In GitHub, open `Settings -> Pages`
3. Set the source to `Deploy from a branch`
4. Select branch `main` and folder `/ (root)`
5. Save the settings

No custom GitHub Actions workflow is required for this migration.

## Notes

- A stable `cv.pdf` alias is provided alongside the dated CV filename.
- The legacy frame entry points were replaced with a shared responsive layout plus redirect stubs for backward compatibility.
- See `MIGRATION_REPORT.md` for the URL mapping, changed-file summary, and unresolved items.
