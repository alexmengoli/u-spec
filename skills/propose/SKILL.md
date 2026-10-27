---
name: propose
description: "Use when asked to propose or plan a u-spec feature, fix, or small project change. Ask persistent clarifying questions and create one compact specification; do not implement."
---

# Propose

Create a small, unambiguous change specification. Respond in the user's language.
Write all workflow Markdown files in English, including saved questions and
evidence. Preserve exact identifiers, paths, commands, UI literals and quotations.

## Boundaries

- Resolve the target project root; ask if ambiguous. Store every workflow artifact
  under `<project-root>/u-spec/`, never relative to the installed skill directory.
- Ensure `changes/`, `specs/`, `archive/` exist there. Each contains only direct
  `.md` files, no subdirectories. Do not create other workflow files or folders.
- Scan current spec titles and Scope metadata; load applicable bodies as below,
   not unrelated specs, archives or other skills. No CLI dependency is required.
- Do not modify application code, tests, dependencies or project configuration.

## Procedure

1. Establish the goal and choose one stable lowercase kebab-case spec ID. Reuse an
   existing ID when changing the same capability. Use filenames to find candidates;
   ask on ambiguity. If `changes/<id>.md` exists, offer to resume it with `change`;
   never overwrite it. Agree on splitting unrelated capabilities before doing so.
2. Set `Scope: global` for project-wide rules (fonts, theme, shared animations,
   constants), or `Scope: area:<id>` for one area's behavior (e.g. `area:login`
   for Login UX/UI). Reuse stable English lowercase kebab-case area IDs; ask if
   uncertain. Scan titles and Scope metadata in `specs/*.md`. Always reread every
   global spec, regardless of the request's area. Read area-specific spec bodies
   only when their Scope matches an area actually involved in the request; read
   every spec for those areas and `specs/<id>.md` if present. A global request does
   not automatically involve every area: with no specific area involved, read
   only global specs. Determine involved areas from the request and nearby code;
   ask if unclear rather than loading other areas speculatively. Clarify
   missing/ambiguous Scope rather than skipping it.
   Resolve conflicts with the user; never silently override existing rules.
   Inspect the nearest owning code/checks and form an evidence-based approach.
3. Keep asking until material uncertainty is resolved: expected behavior, scope,
   exclusions, edge/error cases, compatibility, constraints and acceptance checks.
   Ask a few focused questions per turn, with concrete choices and consequences
   when useful. Investigate facts available in code rather than asking the user.
   Challenge conflicting answers and vague terms. Never silently choose product
   behavior. There is no question-count limit; do not stop just to save tokens.
   Skip already answered or irrelevant questions. If questioning is paused, save
   a `draft` with explicit open questions; never mark it ready or implement it.
4. Create `changes/<id>.md` using the compact format below. `Base` is `new` when
   no baseline exists, otherwise the SHA-256 of the exact bytes of `specs/<id>.md`
   computed with available tools. Do not guess the hash. Preserve all unchanged
   baseline requirements and their IDs: this is the full intended resulting spec.
5. Show a short summary and request approval. Stay `draft` until explicit approval
   of this revision, then set `ready`. A later explicit `apply` request also
   approves the current revision if it has no open questions. Do not run apply.

## Single-File Format

```markdown
# <id>: <short title>
Scope: <global | area:area-id>
Status: draft
Base: <new | SHA-256 of specs/<id>.md>

## Goal
<why and intended outcome; exclusions only when useful>

## Requirements
- R1: <observable behavior and concrete acceptance example, including errors if relevant>

## Approach
<brief decision, affected paths, constraints; omit unnecessary design detail>

## Tasks
- [ ] T1: <small actionable step and its requirement IDs>

## Verification
- R1: <specific check/command and expected outcome> | not run
```

Add `## Questions` only while unresolved questions exist; remove it when resolved.
Keep requirement/task IDs stable, do not recycle deleted IDs. Cover every
requirement with tasks and a check; existing behavior may use a regression check.
No empty sections, duplicated prose, chat transcripts or separate artifacts.