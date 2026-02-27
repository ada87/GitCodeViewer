# Markdown Basic

## 1. Text Formatting

**Bold Text**, *Italic Text*, ~~Strikethrough~~, `Inline Code`.

> **Note**: This is a blockquote.
>
> It can span multiple lines and contain **formatted** text.

---

## 2. Lists

- [x] Task 1 (Done)
- [ ] Task 2 (Todo)
- [ ] Task 3
  - Nested Item A
  - Nested Item B
    - Deep Nested

1. Ordered List 1
2. Ordered List 2
3. Ordered List 3

## 3. Tables

| Feature | Support | Rating |
| :--- | :---: | ---: |
| Syntax Highlighting | ✅ | 5/5 |
| Offline Access | ✅ | 5/5 |
| Diagrams | ✅ | 4/5 |
| Math (KaTeX) | ✅ | 4/5 |
| TOC | ✅ | 4/5 |

## 4. Math (KaTeX)

Block math:

$$
f(x) = \int_{-\infty}^\infty \hat f(\xi)\,e^{2\pi i \xi x} \,d\xi
$$

$$
\begin{pmatrix} a & b \\ c & d \end{pmatrix} \cdot \begin{pmatrix} x \\ y \end{pmatrix} = \begin{pmatrix} ax+by \\ cx+dy \end{pmatrix}
$$

Inline math: $E = mc^2$, $\sum_{i=1}^{n} i = \frac{n(n+1)}{2}$

## 5. Links & Images

[Visit our GitHub Repo](https://github.com/ada87/GitCodeViewer)

![Placeholder Image](https://via.placeholder.com/300x100?text=Code+Viewer+Demo)

## 6. HTML Embedding

<details>
<summary>Click to expand hidden content</summary>
This content is hidden by default. Useful for FAQs and collapsible sections.
</details>

## 7. Footnotes

Here is a footnote reference[^1], and another[^2].

[^1]: This is the first footnote.
[^2]: This is the second footnote with **bold** text.
