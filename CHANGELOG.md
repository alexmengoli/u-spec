# Changelog

All notable changes to this project will be documented in this file.

## [v1.1.0] - 2026-10-28

### Changed
- Reduced the spec context required by the `archive` skill:
  - For area-scoped changes, it now reads only global specs whose titles or `Goals` indicate relevance (instead of every global spec), and only area-specific specs for areas actually involved.
  - For global-scoped changes, it now reads area-specific specs only for areas actually involved (instead of every spec in the relevant areas).

## [v1.0.0] - 2026-10-27

### Added
- Initial release: four skills for lightweight spec-driven development, with no CLI or dependencies.
  - `propose` — read applicable specs, investigate locally, ask until material doubts are resolved, then prepare one change document.
  - `change` — revise a change document (including during implementation); requires fresh approval; no code changes.
  - `apply` — implement approved tasks, run checks, and record progress and evidence in the change file.
  - `archive` — consolidate current requirements into one spec and preserve the complete change as a flat Markdown archive.
- README with installation and workflow instructions.
