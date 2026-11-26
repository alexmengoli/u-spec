---
name: propose
description: "Use when asked to propose a u-spec change. Define the smallest verified delta across one or more specs and get approval before implementation."
---

# Propose

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

1. Choose a stable lowercase kebab-case change ID for the work. A change may
   affect multiple existing or new spec IDs. Reuse existing capability IDs.
   Pick a fresh ID for new work by checking active changes and archive
   filenames. Never overwrite an active change. Use `change` to revise it.
2. Scan spec titles and Scope metadata. Read target specs, all global specs,
   and other area specs only for areas actually involved. Inspect nearby code,
   tests and authoritative contracts. Resolve conflicts and consequential
   product questions with the user. If questions remain, save them in the
   proposal. Do not implement code, edit specs or create a separate design file.
3. Write `u-spec/changes/<change-id>.md` using the format below. Base hashes
   cover the exact bytes of each targeted spec (SHA-256); use `new` only for an
   absent spec. Additions and replacements contain the complete text of only
   the affected requirement. Keep tasks and checks focused on the delta and
   its real regression risks. Reference authoritative contracts and shared
   rules rather than restating them. Keep durable behavior in requirements,
   implementation detail in Approach, and test evidence in Verification.
4. Summarize intent, affected specs and material changes. Use `Status: draft`
   until the proposal is approved and has no open questions, then `ready`.
   An explicit `apply` of the current complete proposal may supply approval.

## Change format

```markdown
# add-recipe-collections: Add recipe collections
Format: 2
Status: draft

## Goal
Let people organize recipes into named collections.

## Targets
- recipe-library: <64-character SHA-256>
- recipe-collections: new

## Spec changes

### recipe-library

#### MODIFIED R4
The recipe library links to the collections page.

#### REMOVED R9

### recipe-collections

#### METADATA
Title: Recipe collections
Scope: area:recipes
Goal: Let users organize saved recipes.

#### ADDED R1
Users can create a named collection. A new collection starts empty.

## Approach
Reuse the recipe library's existing form controls on the collections page.

## Tasks
- [ ] T1: Link to collections and remove automatic cuisine groups (recipe-library/R4, recipe-library/R9).
- [ ] T2: Add the named collection form (recipe-collections/R1).

## Verification
- recipe-library/R4, recipe-library/R9: The library links to collections and shows no automatic cuisine groups. | not run
- recipe-collections/R1: Creating `Weeknight dinners` shows that name and an empty recipe list. | not run
```

Use optional `## Questions` for unresolved decisions and omit it once resolved.
Each target has one base and at most one `### <spec-id>` block. Each requirement
uses a unique local ID such as `R1`; qualify references as `<spec-id>/<R-id>`.
`ADDED` requires an unused ID. `MODIFIED` and `REMOVED` require an existing ID.
Keep existing IDs and avoid reusing retired ones. `REMOVED` has no body.
An existing target can omit its block when included only as a baseline check.
Omit `Spec changes` when there are no operations.
A new spec requires `METADATA` and at least one `ADDED`. For an existing spec,
include `METADATA` only to change its title, Scope or Goal. Supply all three
fields, using the existing values for unchanged fields. Goal may continue on
indented lines. Scope is `global` or `area:<kebab-case>`. For work entirely
outside the spec corpus, omit both `Targets` and `Spec changes`.
