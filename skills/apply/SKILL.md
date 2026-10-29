---
name: apply
description: "Use when asked to apply, implement, or resume a u-spec change. Execute the approved tasks from one specification, verify behavior, and update progress in the same file."
---

# Apply

Framework version: v1.2.0

Implement one approved change. Use the user's language.
Write all workflow Markdown files in English, including saved questions and
evidence. Preserve exact identifiers, paths, commands, UI literals and quotations.

## Boundaries

- Resolve the target project root; ask if ambiguous. Workflow artifacts belong
  only in `<project-root>/u-spec/{changes,specs,archive}/`, as direct `.md` files
   without subdirectories or auxiliary artifacts, plus the provenance
   `<project-root>/u-spec/README.md` below. Code and tests belong in the
  project's normal locations; project-required build/test outputs are not specs.
- Respect repository instructions and existing user edits. No unrelated cleanup,
  automatic commits, extra workflow documents or automatic archiving.
- Read the chosen change, baseline, applicable specs as below and needed code/checks.

## Framework Provenance

At every invocation, after resolving the target project root and before the
procedure, synchronize `<project-root>/u-spec/README.md`. Create its parent if
needed, never write relative to the installed skill directory. If absent, create
this English Markdown, substituting this skill's Framework version:

```markdown
<!-- u-spec:provenance -->
# u-spec

Repository: [u-spec](https://github.com/alexmengoli/u-spec)
Author: Alex Mengoli
Version: <framework-version>
<!-- /u-spec:provenance -->
```

For an existing file, require exactly one ordered pair of these markers containing
one Repository line, one Version line and at most one Author line. Update only
these managed lines inside the block. If Author is missing, insert
`Author: Alex Mengoli` immediately after Repository; otherwise set it to that
value. Preserve all other content. If already correct, do not rewrite the file.
If the file is unrecognized or ambiguous, ask before changing it; never overwrite
user content. Use only this skill's declared version, not GitHub, the host project's
version or another skill. It records the last-used skill version, even if older
than the previous value. Verify the saved link, author and version. This metadata update
does not bypass any workflow prerequisite or authorize application changes.

## Procedure

1. Select `changes/<id>.md` using an explicit ID or the single unambiguous candidate;
   otherwise ask, listing filenames. If absent, ask for a proposal via `propose`.
2. Read the full change: `Scope`, `Status`, `Base`, `Goal`, `Requirements`, `Approach`,
   `Tasks`, `Verification`, optional `Questions`. `Base: new` requires no existing
   `specs/<id>.md`; otherwise compute its exact-byte SHA-256 and compare with Base.
   If missing/mismatched, stop for reconciliation via `change`; do not reset Base.
   Require `Scope: global` (project-wide rules) or `Scope: area:<id>` (one area,
   e.g. `area:login`), with stable English lowercase kebab-case area IDs. Clarify
   missing/ambiguous Scope via `change`. Scan current spec titles/Scope. Always
   reread every global spec, regardless of the request's area. Read area-specific
   spec bodies only when their Scope matches an area actually involved in the
   approved request; read every spec for those areas. A global request does not
   automatically involve every area: with no specific area involved, read only
   global specs. Determine involved areas from the request and nearby code; ask
   if unclear rather than loading other areas speculatively. Preserve Scope
   immediately below the title. Conflicts require `change` and approval, not
   silent overrides.
3. Block on unresolved questions, conflicting requirements, missing acceptance
   checks or an ambiguous scope. Ask focused questions; use `change` to record
   material revisions and obtain approval before implementation. Never invent
   requirements. Explicit user invocation of apply approves the current complete
   draft; otherwise require recorded approval (`ready`, `applying` or `done`).
4. Find the next unchecked task and inspect its owning code and nearest test.
   Confirm any previously checked tasks still match the working tree when
   resuming; reopen stale tasks/evidence. Set `Status: applying` before editing.
5. Implement the smallest scoped task using project conventions. Run the cheapest
   behavior-focused check immediately after the first substantive code edit,
   before expanding scope. Fix local failures and rerun. Mark a task `[x]` only
   after its work and relevant checks succeed; update the same Markdown file.
6. Repeat for remaining tasks. Record concise verification evidence against every
   requirement: command or manual steps, actual outcome and relevant limitation.
   Do not paste full logs. Use project-required validation gates as well as focused
   checks; record unrelated existing failures honestly, never fix them by default.
7. If blocked, record the blocker in `Verification`, keep unfinished tasks unchecked
   and status `applying`, report what needs resolution, and stop. Unavailable,
   failed or skipped required checks are not passes. Do not silently weaken checks.
8. Set `Status: done` only when all tasks are checked and every acceptance check
   and required gate has passed with evidence. Otherwise leave `applying` and
   report remaining work. Summarize changes and verification; offer `archive` next,
   but do not update specs or move the file automatically.

Keep requirement/task IDs stable. Update progress and evidence in place rather
than appending a session diary. New product decisions require `change` and fresh
approval; ordinary implementation details within the approved approach do not.