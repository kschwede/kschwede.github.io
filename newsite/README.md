# GitHub Pages Migration

This directory contains a GitHub Pages-ready migration of the legacy academic site from `oldsite/`.

## Repository Structure

- `_layouts/default.html`: shared Jekyll page wrapper.
- `_includes/sidebar.html`: shared sidebar navigation.
- `assets/css/site.css`: shared stylesheet for the migrated pages.
- Root `*.html` pages: preserved legacy filenames, now rendered through the shared Jekyll layout.
- Course directories and downloadable assets: copied over with original filenames wherever practical.
- `MIGRATION_REPORT.md`: migration notes, URL mapping summary, changed files, and unresolved issues.

## Local Preview

Because the migrated root pages use Jekyll front matter, preview with Jekyll rather than a plain static file server.

1. `cd newsite`
2. Run `jekyll serve` if Jekyll is installed globally, or `bundle exec jekyll serve` if you are using Bundler in the target repository.
3. Open the local URL printed by Jekyll, usually `http://127.0.0.1:4000/`.

## GitHub Pages Deployment

This output is intended to be dropped into the root of a user-site repository named `<username>.github.io`.

1. Copy the contents of `newsite/` into the root of the `<username>.github.io` repository.
2. Commit and push to the `main` branch.
3. In GitHub Pages settings, publish from the branch root if GitHub asks for a source.
4. No custom GitHub Actions workflow is required for this migration.

## Notes

- `index.html` remains the real homepage.
- A compatibility `home.html` redirect was added to point to `index.html`.
- A compatibility `publication.html` redirect was added to point to `publications.html`.
- The root HTML pages were cleaned up to remove legacy frame/target assumptions and old Utah-hosted internal links where matching local files existed.
