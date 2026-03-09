# ADR-014: Keep Sample Files Human-Looking

- Status: accepted
- Date: 2026-03-09
- Decision makers: mobile viewer maintainers
- Related issue: fixture realism follow-up

## Context

The app renders local source files as part of the browsing experience.
If the bundled samples look artificial, it becomes harder to judge typography, wrapping, fold gutter behavior, and scrolling density.
This became obvious after the extension list expanded from a few dozen formats to roughly one hundred suffixes.

Several files were technically valid but visually misleading:

- markdown files were long lists of identical bullets
- mermaid files were just chained numbered nodes
- notebook files alternated the same markdown and code pattern
- alias extensions reused the same content with only the filename changed

## Decision

We will treat the sample corpus as UI fixture data, not as disposable placeholders.
Each file should resemble an artifact a developer would plausibly commit.

### Required properties

1. The file must parse or at least look correct for its language family.
2. The file must contain recognizable domain vocabulary.
3. The file must include a realistic mix of short and long lines.
4. The file must stay between 80 and 200 physical lines.
5. Alias suffixes may share themes, but they should not be byte-for-byte clones.

### Preferred sources of structure

- package manifests
- build scripts
- project configuration
- migration notes
- documentation pages
- diagrams and analysis notebooks

## Consequences

### Positive

- Visual regression checks become more trustworthy.
- Syntax highlighting is easier to judge at a glance.
- Search, wrapping, and folding behaviors are exercised by real patterns.
- Demo screenshots stop looking like internal test data.

### Negative

- Fixture maintenance now takes longer.
- Adding a new extension means creating a believable sample, not just a stub.
- Reviewers need to notice when a sample quietly regresses into filler.

## Implementation Notes

Use short rewrite passes instead of giant scripted generation.
On this machine, small targeted writes are more reliable than one oversized command.
For content-heavy formats, it is acceptable to favor readability over strict executable completeness as long as the file still looks authentic.

## Rejected Alternatives

### Keep auto-generated fixtures and hide them in screenshots

Rejected because the problem is not only screenshots.
Developers use the sample corpus during manual checks, and synthetic content biases those checks.

### Use external open-source files verbatim

Rejected because the set would be harder to curate, license provenance would need review, and many upstream files are either too short or too long.

### Minify the files to reduce maintenance cost

Rejected because dense or minified examples are poor fixtures for a reading-oriented UI.

## Rollout Plan

1. Rewrite the most obviously fake formats first.
2. Re-run extension coverage checks after each batch.
3. Keep a simple scan for repeated placeholder patterns.
4. Fix line-count violations before touching the next group.

## Validation

A sample passes review when a teammate can open it cold and infer what kind of repository it belongs to.
If the only visible purpose is "this file was generated to hit 80 lines", it fails.

## Future Work

- Add lightweight linting for a few structured formats.
- Keep a short note in dev docs explaining how sample files are maintained.
- Consider rotating a subset of samples when new language packages are added.