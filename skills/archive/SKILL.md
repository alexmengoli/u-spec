---
name: archive
description: "Use when asked to archive a verified u-spec change. Apply requirement deltas to the named specs and save one change record."
---

# Archive

Framework version: v2.0.0

Resolve the consuming project root and respect its instructions. Keep workflow
artifacts as direct Markdown files in `u-spec/{changes,specs,archive}/` plus the
provenance README. Use the user's language in chat and English in workflow files,
preserving exact identifiers, commands and product literals.

## Format and provenance

Active changes and new archives carry `Format: 2`. An unmarked v1 active
change uses full snapshots. Direct the user to `migrate-u-spec-v2` before
operating on it. Existing consolidated specs remain readable. Create workflow
directories as needed.

After confirming the project is new or uses v2, synchronize `u-spec/README.md`
to this managed block using this skill's declared version:

```markdown
<!-- u-spec:provenance -->
# u-spec

Repository: [u-spec](https://github.com/alexmengoli/u-spec)\
Author: Alex Mengoli\
Version: <framework-version>
<!-- /u-spec:provenance -->
```

The Repository and Author lines each end in one literal backslash immediately
before the newline (Markdown hard breaks). Create the README if absent. In an
existing README, require one ordered marker pair with one Repository and Version
line and at most one Author line. Update only managed lines, inserting a missing
Author after Repository. Preserve other content and existing newline style.
Ask about ambiguous content. Verify the saved block and skip identical writes.
A recorded v1 version requires migration before normal v2 operations.

## Preflight

1. Select `changes/<change-id>.md` by explicit ID or an unambiguous single
   candidate. Require `Status: done`, checked tasks, no questions, and passing
   evidence for the delta, regression checks and required project gates. Reuse
   current evidence. If affected code changed since verification, rerun the
   affected checks or return to `apply` if evidence is missing or fails.
2. Read the selected change and only its target specs. Look for an interrupted
   archive as described below before rejecting a hash mismatch. For a fresh
   archive, every `## Targets` entry must match the spec's exact-byte SHA-256,
   or absence for `new`. Stop on drift and use `change` to reconcile. Do not
   scan sibling specs or semantically merge requirements.
3. Validate all target IDs and operations before any target or archive write.
   Require unique lowercase kebab-case target IDs, each with one base. Each
   `## Spec changes` block `### <spec-id>` must name a unique declared target,
   with unique requirement IDs. Reject unknown operations and empty bodies
   for additions or replacements. For each `#### ADDED Rn` append the new
   `- Rn:` requirement. For each `#### MODIFIED Rn` replace only that
   requirement in place. For each `#### REMOVED Rn` delete exactly that
   requirement; the operation must have no body. An add must name an unused
   ID, and a modification or removal must identify exactly one existing
   requirement. Treat continuation lines as part of the same requirement and
   preserve Markdown structure when converting delta content to a list item.
   Use an explicit `#### METADATA` block (Title, Scope, Goal) for metadata
   changes. Scope must be `global` or `area:<kebab-case>`. A new spec
   requires this block and at least one addition. Write
   `# <spec-id>: <Title>`, `Scope:`, `## Goal` and `## Requirements`.
   Existing targets without operations retain their exact bytes. A guard-only
   change has Targets without Spec changes. Reject ambiguous structures.
   A change with no spec targets has neither section.

## Serialize spec results

- Identify operations and requirement boundaries outside fenced code. Remove
  blank lines at the edges of an operation body. Render the first body line
  as the text after the requirement ID. Prefix each remaining nonblank line
  with two spaces, keeping its original indentation and text. Retain interior
  blank lines and do not rewrap. Treat blank lines between existing items as
  separators, not part of the preceding body.
- For existing specs, preserve the original encoding, untouched lines and
  their line endings. Use the file's first line-ending style for generated
  lines. Replace an item's lines in place, leaving intervening separators
  untouched. Remove the item and one adjacent separator if present, preferring
  the following separator. Append additions in delta order with one blank
  line between additions and between the first addition and the last existing
  item, stripping trailing blank lines at that boundary. Keep metadata field
  order and render an explicit new goal by removing its field indentation.
- For new specs, use UTF-8 without BOM and LF. Write the title and Scope on
  successive lines, then a blank line, the Goal heading, the goal body, a
  blank line, the Requirements heading, and the requirement items, with one
  blank line between items and one terminal LF.

## Save

1. Prepare all resulting bytes and compute their SHA-256 hashes. Create a
   single `archive/YYYY-MM-DD-<change-id>.md` using the current date, or the
   next available numeric suffix (`-2`, `-3`, …). Save the complete **delta
   change**, switching `Status: done` to `archived` and appending
   `## Archive results` with one `- <spec-id>: <result SHA-256>` for each
   target (or `No spec targets.`). Verify the archive before writing specs.
2. Before writing each spec, recheck its base. Use atomic file replacement
   when available, then verify the saved hash. Skip writing unchanged bytes.
   Before removing the active change, verify the archive, every result hash
   and that the active
   change still matches the archived source. Delete the active change last.
   Report the archive and any changed specs. Leave code and Git history alone.

## Resume an interrupted archive

Search only archive filenames that could belong to the selected change ID.
A reusable Format 2 archive has the same change body except for Status and
the appended results block, and must record exactly the declared targets.
Use only a unique verified match. If the same change body has conflicting or
invalid records, stop for reconciliation. Classify each target's current bytes against
the result hash and its original base. A target already at its recorded result
needs no write. For every remaining target, require the original base
(including absence for `new`), regenerate its result, and verify it against the
recorded hash before any writes. Stop if any target is in a third state.
Complete the pending writes and use the same final verification and removal
steps. Preserve the original archive path and contents.
