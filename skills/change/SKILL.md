---
name: change
description: "Use when asked to change, revise, or clarify an existing u-spec proposal, requirements, approach, or tasks, including during implementation. Edit the same Markdown file, not application code."
---

# Change

Framework version: v1.2.0

Revise an active specification, not its implementation. Use the user's language.
Write all workflow Markdown files in English, including saved questions and
evidence. Preserve exact identifiers, paths, commands, UI literals and quotations.

## Boundaries

- Resolve the target project root; ask if ambiguous. All workflow artifacts stay
   in `<project-root>/u-spec/{changes,specs,archive}/`, except the provenance
   `<project-root>/u-spec/README.md` below. These three directories
  contain only direct `.md` files, no subdirectories or auxiliary artifacts.
- Do not modify application code, tests, dependencies or project configuration.
  Do not edit consolidated specs or archives. Do not load unrelated specs/history.

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

1. Select `changes/<id>.md` from the supplied ID or an unambiguous single candidate;
   otherwise show filenames and ask. If absent, direct the user to `propose` to
   create a change, reusing an existing spec ID when appropriate. Never edit an
   archive in place or silently create a replacement change.
2. Read the selected file and matching `specs/<id>.md` if present. The format is
   title `# <id>: <title>`, metadata `Scope`, `Status`, `Base`, then `Goal`, `Requirements`,
   `Approach`, `Tasks`, `Verification`, and optional unresolved `Questions`.
   `Base` is `new` or the original baseline's exact-byte SHA-256. If the baseline
   no longer matches, explain the conflicting requirements and ask how to
   reconcile; update `Base` only after reconciliation, never just to bypass it.
   Require `Scope: global` for project-wide rules (fonts/theme/animations/constants)
   or `Scope: area:<id>` for an area's behavior (e.g. `area:login` for Login UX/UI).
   Area IDs are stable English lowercase kebab-case. Clarify missing/ambiguous
   Scope. Scan current spec titles/Scope. Always reread every global spec,
   regardless of the request's area. Read area-specific spec bodies only when
   their Scope matches an area actually involved in the revision; read every
   spec for those areas. A global request does not automatically involve every
   area: with no specific area involved, read only global specs. Determine involved
   areas from the request and nearby code, considering impact of a Scope change;
   ask if unclear rather than loading other areas speculatively. Resolve conflicts
   with the user; never silently override existing rules.
3. Inspect only code/checks needed to understand the revision and any work already
   completed. Ask focused questions in small batches until consequential doubts
   and conflicting requirements are resolved. No arbitrary question limit or
   invented product decisions. Save unresolved questions if the user pauses.
4. Revise this same file, preserving the stable spec ID and unaffected requirement
   and task IDs. Keep the full resulting behavior, including unchanged baseline
   requirements. Remove explicitly superseded requirements; do not recycle IDs.
   Keep intent, approach, tasks and verification consistent. No duplicate documents.
   Preserve Scope immediately below the title unless explicitly revising it.
5. If implementation has started, compare affected completed tasks with real code.
   Reopen invalidated tasks, add necessary correction/removal work, and reset
   stale verification evidence. Preserve unaffected work and valid evidence.
   Never claim code was rolled back or fixed by merely editing the specification.
6. Set `Status: draft`: prior approval does not authorize the revised scope.
   Summarize only the meaningful differences and implementation impact; request
   approval. Set `ready` only after explicit approval and resolution of questions.
   A subsequent explicit `apply` request may supply that approval. Do not implement.

Use concise `R1` requirement bullets, `- [ ] T1: ... (R1)` task checkboxes, and
verification entries recording requirement IDs, checks, expected outcomes and
`not run`/actual results. Every requirement needs a task and check. Remove the
`Questions` section when resolved. Keep all decisions in this file, not chat alone.