---
name: change
description: "Use when asked to revise an active u-spec proposal, including during implementation. Update the delta, plan and evidence in the same file."
---

# Change

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

## Procedure

1. Select `changes/<change-id>.md` by explicit ID or an unambiguous single
   candidate. Use `propose` for new work. If a matching archive already exists
   for this revision, resolve interrupted archival via `archive` before editing.
2. Read the change and its targeted baselines. Check each `## Targets` entry
   (`- <spec-id>: new` for absence or exact-byte SHA-256 for an existing spec).
   On drift, identify affected requirements and reconcile explicitly. Retain
   unrelated baseline edits. Refresh hashes only after reconciliation.
   Scan spec titles and Scope, then read all global specs and area specs for
   involved areas only. Inspect relevant code when implementation has started.
3. Revise the same file. Keep one `### <spec-id>` block per edited target in
   `## Spec changes`; `#### ADDED Rn` and `#### MODIFIED Rn` hold whole
   requirement bodies, and `#### REMOVED Rn` has no body. Each operation must
   agree with its baseline (unused ID for add, existing ID otherwise). Preserve
   unaffected IDs and avoid recycling retired IDs. For a new spec, require
   `#### METADATA` with `Title:`, `Scope:`, `Goal:` and at least one addition.
   Use the same complete metadata block for an explicit metadata update.
   Scope is `global` or `area:<kebab-case>`. Keep targets without operations
   only when they supply a useful baseline guard. Omit `Spec changes` with
   no operations and both sections with no targets. Keep unchanged
   requirements in their specs.
4. Update Goal, optional Approach, Tasks and Verification consistently.
   Qualify requirement references as `<spec-id>/<R-id>`. Compare checked work
   with actual code. Reopen affected tasks and reset stale evidence while
   preserving unaffected progress. Add `## Questions` while decisions remain.
5. Set `Status: draft` after a material revision. Summarize the delta and request
   approval. Set `ready` after approval and resolution of all questions.
   An explicit `apply` of the complete revision can supply approval.

Revise the workflow document only. Product code, tests, consolidated specs and
archives are outside this skill's write scope.
