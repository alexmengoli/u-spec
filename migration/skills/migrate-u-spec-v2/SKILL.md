---
name: migrate-u-spec-v2
description: "Use when asked to migrate a repository from u-spec v1 to v2. Convert active full-spec changes to requirement deltas, preserve baseline specs and history, and switch to the v2 workflow."
---

# Migrate u-spec to v2

Resolve the consuming project and its installed workflow skill locations.
Use the user's language in chat and English in workflow files. Migration changes
workflow artifacts only. Preserve consolidated specs, historical archives,
application files and unrelated skills.

## Preflight

1. Inventory the managed README, active changes, matching specs, and installed
   workflow skills. Use version declarations and artifact formats together.
   An unmarked active v1 document has a stable spec ID, Scope, Status, Base,
   Goal, full Requirements, Tasks and Verification. A v2 active document
   declares `Format: 2`. Recognize an already migrated project and skip
   unchanged files. Stop on unrecognized formats or conflicting installations
   that cannot be resolved from the available files.
2. Locate the trusted v2 copy of all four workflow skills (propose, change,
   apply and archive) from the provided checkout, release bundle or verified
   installed files. Check that all declare the same v2 version. Identify each
   active harness install that must switch to v2 and preserve local
   customizations. If needed, ask for the source or a decision about
   incompatible customizations before writing.
3. For each v1 active change, first check archive filenames for the same
   active revision (allowing the legacy archived status). Complete or
   reconcile an interrupted v1 archive with the old workflow before
   migration, including the case where it already updated the spec.
   Otherwise verify the original Base against the exact-byte SHA-256 of
   its matching spec, or require absence for Base: new. Stop on drift,
   malformed files or duplicate IDs and reconcile explicitly before
   proceeding. Never reset Base merely to make a mismatch disappear.
   Prepare and validate all replacements, including the provenance edit,
   before writing any of them.

## Convert each active change

Keep its filename and change ID. Replace the v1 header metadata with
`Format: 2` and Status. Keep the original Goal as change intent, then use:

```markdown
## Targets
- <spec-id>: <original Base>

## Spec changes

### <spec-id>

#### METADATA
Title: <spec title without the ID>
Scope: <global or area:kebab-case>
Goal: <full spec goal>

#### ADDED R3
<complete requirement body>

#### MODIFIED R1
<complete replacement requirement body>

#### REMOVED R2
```

- Compare full requirements by ID, including continuation lines and examples.
  Use ADDED for IDs only in the change, MODIFIED for differing bodies, and
  REMOVED for IDs only in the baseline. Leave identical bodies out.
  For a new spec, emit all requirements as ADDED. For an existing spec, emit
  METADATA only if Title, Scope or Goal changes. Use the active v1 title,
  Scope and Goal as the intended result. Indent Goal continuation lines.
  Keep the target as a baseline guard even if it has no operations, and omit
  Spec changes when empty. A new spec needs metadata and at least one addition.
- Preserve Approach, Tasks, Verification and Questions, including task IDs,
  approval status, check results and unfinished work. Qualify requirement
  references with the spec ID (for example, `recipe-library/R1`) without
  rewriting literal commands or evidence. Keep existing checks, including
  regression checks. Do not manufacture approval or evidence. If a necessary
  reconciliation changes behavior, return that change to draft and reopen
  affected tasks and checks for review.
- A legacy done change may lack evidence required for some v2 delta operations
  (such as removals) or a project gate. When a real gap exists, retain the
  existing evidence, record the missing check as pending with an unchecked
  task, and set applying so apply can complete verification.
- Apply the prepared delta in memory. Compare the resulting title, Scope,
  Goal and all requirement IDs and bodies to the legacy intended spec. Preserve
  baseline order for retained requirements and append additions in change order.
  If ordering or unsupported structure carries meaning, resolve it before
  writing. The migration is a format conversion, not a spec compaction.

## Write and verify

1. Write and reread converted active changes, then install the verified v2
   skills in the resolved locations. Preserve already converted changes on a
   retry. If interrupted, revalidate any converted change against its Targets
   and continue the remaining conversion and installation. Keep the README
   version switch last.
2. Create or update `u-spec/README.md` with the agreed installed version.
   For an existing README, require exactly one ordered marker pair enclosing
   one Repository line, one Version line and at most one Author line.
   Insert a missing Author after Repository. Preserve other lines and existing
   newline style. The Repository and Author lines each end with one literal
   backslash immediately before the newline, a Markdown hard break.

   ```markdown
   <!-- u-spec:provenance -->
   # u-spec

   Repository: [u-spec](https://github.com/alexmengoli/u-spec)\
   Author: Alex Mengoli\
   Version: <installed v2 version>
   <!-- /u-spec:provenance -->
   ```

3. Verify installed versions, converted changes, the saved README, and that
   baseline and archive bytes match their preflight values. Report converted
   or already converted changes, installation paths and any unresolved items.
