---
name: archive
description: "Use when asked to archive or finalize a completed u-spec change. Consolidate current requirements into one spec and preserve the complete change as one flat Markdown archive."
---

# Archive

Consolidate verified behavior and preserve its implementation record. Respond in
the user's language. Do not implement, fix code or auto-commit.
Write all workflow Markdown files in English, including saved questions and
evidence. Preserve exact identifiers, paths, commands, UI literals and quotations.

## Boundaries

- Resolve the target project root; ask if ambiguous. All writes stay inside
  `<project-root>/u-spec/{changes,specs,archive}/`. Each directory contains only
  direct `.md` files; no subdirectories, temporary files or extra artifacts.
- Read only the selected change, matching baseline and necessary verification
  evidence. Preserve unrelated files and never overwrite an existing archive.

## Procedure

1. Select `changes/<id>.md` by explicit ID or single unambiguous candidate; otherwise
   ask, listing filenames. Never infer completion from an archive filename alone.
2. Read the entire change. Require `Status: done`, every task `[x]`, no unresolved
   questions, and passing evidence for every requirement and required project
   gate. Missing, skipped, failed or unavailable checks block archival. Reuse
   complete, current passing evidence; if code has changed since verification,
   rerun only the affected checks before proceeding.
   Report gaps and return to `apply`; never invent evidence or force completion.
   Require `Scope: global` (project-wide rules) or `Scope: area:<id>` (one area,
   e.g. `area:login`), with stable English lowercase kebab-case area IDs. Clarify
   missing/ambiguous Scope via `change`. Scan current spec titles/Scope. For an
   area-scoped change, read every spec for the involved areas and only global
   specs whose titles or Goals indicate relevance to the change or target spec;
   read a global spec if relevance is unclear. For a global-scoped change, read
   every global spec. A global request does not automatically involve every area:
   read area-specific specs only for areas actually involved. Determine involved
   areas from the request and nearby code; ask if unclear rather than loading
   other areas speculatively. Unresolved conflicts block archival and require
   `change`, renewed approval and verification.
3. Check `Base`: `new` means `specs/<id>.md` must not exist; otherwise its exact-byte
   SHA-256 must match. A conflict requires reconciliation via `change`, renewed
   approval and verification. Do not discard other changes or reset Base silently.
4. Prepare the consolidated `specs/<id>.md` with only the existing title, `Scope`
   immediately below it, `Goal` and complete `Requirements`, keeping requirement
   IDs and acceptance examples. Preserve the approved Scope in the archive too.
   It describes current behavior, not a delta. Preserve unchanged requirements;
   remove only explicitly superseded ones. Do not include status, Base, tasks,
   implementation narrative or verification history in the consolidated spec.
5. Choose `archive/YYYY-MM-DD-<id>.md` using the current date; on collision append
   `-2`, `-3`, etc. Write the full change there with `Status: archived`, leaving
   its original Base, tasks and evidence intact. Verify the archive content was
   saved successfully before updating the consolidated spec.
6. Write the prepared consolidated spec and verify its saved content matches the
   intended result. Only after both destination files are verified, remove
   `changes/<id>.md`. Never delete the active file first. Report both final paths.

## Interrupted Archive

Writes across files are not atomic. If an earlier attempt left an active change
plus an archive, compare complete content (allowing only done/archived status)
and the intended consolidated spec before any write. Resume only if the matching
archive is identifiable and the baseline still matches Base, or the spec already
exactly equals the intended result. Reuse that verified archive, finish/verify
the spec, then remove the active file last. Otherwise stop and ask to reconcile;
never treat an arbitrary Base mismatch as successful archival, overwrite history,
or create another archive blindly.