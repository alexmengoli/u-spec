---
name: apply
description: "Use when asked to implement or resume a u-spec change. Validate the approved delta, implement its tasks and record current verification evidence."
---

# Apply

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
   candidate. Read its Goal, optional Approach, Tasks, Verification, and any
   Questions. Check each `## Targets` entry against the exact-byte SHA-256
   of its current spec or the absence declared by `new`.
2. Validate the delta before implementation. Each edited target has a unique
   `### <spec-id>` block in `## Spec changes`. Each `#### ADDED Rn` uses an
   unused ID, `#### MODIFIED Rn` replaces an existing requirement, and
   `#### REMOVED Rn` names an existing ID with no body. A new target has
   `#### METADATA` with Title, Scope and Goal and at least one addition.
   Existing targets may explicitly replace those metadata fields together or
   serve as baseline guards without operations. A guard-only change has
   Targets without Spec changes. A change with no spec targets omits both
   sections. Preserve unaffected requirements. Never edit specs during apply.
3. Scan spec metadata. Read all global specs and all area specs for areas
   actually involved, plus targets. Inspect relevant code and tests. Baseline
   drift, invalid deltas, open product questions, conflicting requirements and
   missing acceptance checks require resolution via `change`. Explicitly
   invoking apply approves a complete draft. Otherwise require `ready`,
   `applying` or `done`. An interrupted archive belongs to `archive`.
4. Verify previously checked tasks against the working tree; reopen stale
   tasks and evidence. Set `Status: applying` before substantive edits.
   Implement the approved tasks using project conventions. Run the cheapest
   relevant behavior check after the first substantive edit. Check each task
   only after its work and relevant checks pass.
5. Record concise outcomes in `## Verification`, using qualified references
   such as `recipe-library/R4`. Cover additions, replacements, removals and
   meaningful metadata changes plus relevant regressions and required project
   gates. For a blocker, record the limitation and leave the change in
   `applying` with affected tasks unchecked. Material scope changes go through
   `change` and renewed approval.
6. Set `Status: done` only after all tasks and checks pass with current evidence.
   Report the result. Archival requires a separate request.

Update the active change in place. Keep application edits scoped to approved
work and follow the project's normal check and build conventions.
