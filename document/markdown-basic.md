# Reader Feature Overview

This file is meant to exercise the Markdown viewer as a reader, not as a blog post.
When you open it, check spacing, typography, tables, math, code blocks, and small interactive HTML elements.

## What to verify

- headings keep a clear visual hierarchy
- inline code stays readable in both themes
- task lists and nested bullets align cleanly
- tables keep borders and spacing on narrow screens
- block quotes do not collapse into the page background
- code fences show language labels and copy affordances
- footnotes render at the end instead of leaking raw syntax

> Tip: switch between light and dark themes while this file is open.
> The goal is not perfect publishing output. The goal is calm, readable technical notes.

## Reading checklist

- [x] Bold, italic, strike, and `inline code`
- [x] Ordered lists and nested bullets
- [x] Table layout
- [x] Footnotes
- [x] KaTeX inline math such as $E = mc^2$
- [x] KaTeX block math
- [x] HTML details block
- [x] Relative document links

## Quick links

- [Longer renderer notes](./guide.markdown)
- [MDX treated as Markdown](./draft.mdx)
- [Mermaid source sample](../diagram/flow.mermaid)

## Feature matrix

| Area | What this sample checks | Why it matters |
| --- | --- | --- |
| Typography | heading rhythm, paragraph width, quote contrast | long docs must stay comfortable to scan |
| Structure | lists, tables, horizontal rules | README and ADR files lean on these heavily |
| Technical content | math, code, inline tokens | developer docs mix prose with symbols |
| Navigation | relative links and footnotes | repo docs should stay connected |

## Math block

$$
latency\_budget = dns + tls + api + render
$$

$$
\text{score} = 0.4 \cdot \text{readability} + 0.35 \cdot \text{contrast} + 0.25 \cdot \text{density}
$$

## Short code example

```ts
export function summarizeDocument(name: string, sections: number) {
  return `${name} contains ${sections} sections and is ready for review.`
}
```

## Expandable note

<details>
<summary>Why keep this file small?</summary>
A feature demo should be easy to skim. Once the viewer behavior feels right, larger docs such as release notes and runbooks cover the long-form reading case.
</details>

## Footnotes

A realistic reader demo should not feel synthetic.[^demo]
Relative links are more useful than filler paragraphs.[^links]

[^demo]: The file exists to exercise common Markdown features without looking like generated noise.
[^links]: The linked documents in this folder help test cross-file navigation in the same repo.
