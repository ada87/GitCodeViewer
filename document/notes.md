# Syntax Coverage Rollout Notes

This document tracks the sample corpus used by the mobile code viewer during local preview and screenshot runs.

## Goal

The sample directory is not a benchmark suite.
It exists to answer three practical questions:

1. Does the file extension resolve to the expected language mode?
2. Does the editor render a believable file instead of placeholder noise?
3. Does the fold gutter stay hidden when a mode cannot provide folding support?

## Current Expectations

- Every sample file should look like a file copied from a real repository.
- Every sample file should stay between 80 and 200 lines.
- Alias extensions should not all share the exact same filler content.
- Config files should include comments, nested structures, and realistic keys.
- Diagram and notebook files should open without obviously fake numbering.

## Review Checklist

- Open the workspace list on a phone-sized screen.
- Scroll through at least twenty files with different suffixes.
- Confirm that the title remains centered in the mobile header.
- Tap the project name and verify the click affordance is visible only on mobile.
- Open one legacy mode sample and verify the fold gutter does not reserve space.
- Open one modern mode sample and verify folding still works.

## Command Log

```bash
pnpm install
pnpm --dir web dev
pnpm --dir web exec tsc --noEmit
pnpm -s web:build
```

## Notes From The Last Pass

### What improved

- `json5` now looks like a workspace manifest instead of a counting list.
- `jsonc` now looks like editor settings with comments and grouped options.
- `toml` now looks like an actual Cargo manifest with feature flags.
- `yml` now looks like a CI workflow instead of a synthetic dictionary.

### What still needs attention

- A few alias files still read like generated fixtures.
- Notebook content should tell a coherent story from markdown to code to output.
- XML-based project files should reflect their real ecosystem conventions.
- Some legacy language samples still contain leftover counter-style placeholder tails.

## Realism Heuristics

When rewriting a sample, prefer one of these shapes:

- a package manifest with dependency and script sections
- a build file with targets, properties, or conditional branches
- a service module with a small but coherent data flow
- a migration or seed script with varied statements
- a documentation page with headings, tables, and action items

Avoid these patterns:

- one hundred nearly identical comment lines
- one variable per line with sequential numeric suffixes
- fake metrics that only prove the file has enough lines
- placeholder names that never appear in real projects

## Example Acceptance Criteria

| Area | Accept | Reject |
| --- | --- | --- |
| Markdown | README, ADR, release note, runbook | numbered filler bullets |
| XML | csproj, props, plist, draw.io, xsd | repeated `<item>` nodes |
| Notebook | mixed markdown and executable analysis | ten identical print cells |
| Mermaid | system diagram, flow, sequence | node 1 to node 80 |

## Follow-up

If a sample is still borderline, rewrite it around a concrete scenario.
The easiest source material is usually a build step, a release checklist, or a feature design note.
Those files naturally contain structure, naming, and repetition that look normal.

## Status

- Owner: local dev fixtures
- Last updated: 2026-03-09
- Pending batch: markdown aliases, mermaid, notebook, xml project files
- Blocking issue: none