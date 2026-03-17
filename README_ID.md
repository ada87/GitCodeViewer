# Penampil Kode Git

[English](./README.md) | [简体中文](./README_ZH.md) | [Deutsch](./README_DE.md) | [Español](./README_ES.md) | [Français](./README_FR.md) | [हिन्दी](./README_HI.md) | [日本語](./README_JA.md) | [한국어](./README_KO.md) | [Português (Brasil)](./README_PT_BR.md) | Bahasa Indonesia | [Türkçe](./README_TR.md)

![Feature Graphic](./other/feature-graphic.png)

<a href='https://play.google.com/store/apps/details?id=com.xdnote.codeviewer&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'>
  <img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height="80"/>
</a>

**Code Viewer** adalah klien Git dan pembaca kode berperforma tinggi untuk Android. Aplikasi ini dibuat untuk developer yang perlu membaca kode, mereview PR, dan mempelajari proyek open source secara offline.

## Fitur

1. **Git Offline:** Clone sekali, baca di mana saja. Mendukung branch, log, dan operasi Git lainnya, termasuk repository privat.
2. **Syntax Highlight:** Mendukung bahasa populer seperti HTML, JS, CSS, Python, TypeScript, Java, C++, PHP, Rust, Go, Ruby, Kotlin, Dart, Bash, SQL, YAML, dan lainnya.
3. **Pembacaan Dokumen:** Mendukung Markdown (`.md`, `.markdown`) dan MDX (`.mdx`, ditampilkan sebagai Markdown untuk dibaca), Mermaid (`.mmd`, `.mermaid`), Jupyter (`.ipynb`), Draw.io, dan format terstruktur lainnya.
4. **Tema:** Mendukung mode terang/gelap serta gaya tema VS Code/JetBrains.
5. **GitHub:** Temukan dan unduh proyek publik populer dengan cepat.

## Demo Langsung

Sedang melihat di aplikasi? Ketuk file di bawah untuk melihat preview syntax highlighting dan rendering.

> Bagaimana cara mendapatkan repo ini?
> Cari `GitCodeViewer` di aplikasi, atau ketuk **+** -> **Clone** lalu masukkan:
> `https://github.com/ada87/GitCodeViewer.git`

## Pustaka Demo

Folder demo sekarang berada di root repository dan dikelompokkan berdasarkan penggunaan, bukan lagi daftar bahasa datar.

Daftar unggulan dikelola di [`./_meta/popular.json`](./_meta/popular.json).

### Popular

- [Python](./backend/repo.py) | [Rust](./backend/sync.rs) | [TypeScript](./frontend/repo.ts) | [Golang](./backend/cache.go) | [Markdown](./document/markdown-code.md) | [Jupyter](./document/jupyter.ipynb)

### File Catalog

- frontend: [alias.mjs](./frontend/alias.mjs) | [board.htm](./frontend/board.htm) | [card.sass](./frontend/card.sass) | [page.html](./frontend/page.html) | [help.xhtml](./document/help.xhtml) | [panel.jsx](./frontend/panel.jsx) | [panel.less](./frontend/panel.less) | [preview.js](./frontend/preview.js) | [repo.ts](./frontend/repo.ts) | [resolver.mts](./frontend/resolver.mts) | [shell.astro](./frontend/shell.astro) | [state.cljs](./frontend/state.cljs) | [theme.scss](./frontend/theme.scss) | [tokens.css](./frontend/tokens.css) | [tree.tsx](./frontend/tree.tsx) | [viewer.vue](./frontend/viewer.vue)
- backend: [api.http](./backend/api.http) | [api.java](./backend/api.java) | [cache.go](./backend/cache.go) | [data.edn](./backend/data.edn) | [fetch.rb](./backend/fetch.rb) | [graph.sparql](./backend/graph.sparql) | [jobs.kt](./backend/jobs.kt) | [legacy.php5](./backend/legacy.php5) | [mail.php](./backend/mail.php) | [node.cts](./backend/node.cts) | [query.rq](./backend/query.rq) | [query.sql](./backend/query.sql) | [repo.clj](./backend/repo.clj) | [repo.py](./backend/repo.py) | [report.r](./backend/report.r) | [rules.scala](./backend/rules.scala) | [scan.cjs](./backend/scan.cjs) | [schema.ddl](./backend/schema.ddl) | [script.csx](./backend/script.csx) | [seed.dml](./backend/seed.dml) | [shared.cljc](./backend/shared.cljc) | [stats.jl](./backend/stats.jl) | [store.cs](./backend/store.cs) | [sync.rest](./backend/sync.rest) | [sync.rs](./backend/sync.rs) | [types.pyi](./backend/types.pyi)
- system: [cache.cc](./system/cache.cc) | [core.c](./system/core.c) | [core.h](./system/core.h) | [core.wat](./system/core.wat) | [engine.cpp](./system/engine.cpp) | [index.hpp](./system/index.hpp) | [login.bash](./system/login.bash) | [main.c++](./system/main.c++) | [path.h++](./system/path.h++) | [path.inl](./system/path.inl) | [profile.zsh](./system/profile.zsh) | [render.hxx](./system/render.hxx) | [report.cxx](./system/report.cxx) | [ring.ipp](./system/ring.ipp) | [scan.hh](./system/scan.hh) | [shell.ps1](./system/shell.ps1) | [shell.sh](./system/shell.sh) | [stats.tcc](./system/stats.tcc) | [sync.psm1](./system/sync.psm1) | [telemetry.jsm](./system/telemetry.jsm) | [text.wast](./system/text.wast)
- mobile: [bridge.mm](./mobile/bridge.mm) | [panel.m](./mobile/panel.m) | [reader.ets](./mobile/reader.ets) | [repos.dart](./mobile/repos.dart) | [sync.swift](./mobile/sync.swift)
- template: [guide.njk](./template/guide.njk) | [mail.jinja2](./template/mail.jinja2) | [page.jinja](./template/page.jinja) | [panel.j2](./template/panel.j2) | [panel.phtml](./template/panel.phtml) | [theme.liquid](./template/theme.liquid)
- config: [app.json](./config/app.json) | [app.plist](./config/app.plist) | [app.yaml](./config/app.yaml) | [build.kts](./config/build.kts) | [build.targets](./config/build.targets) | [build.yml](./config/build.yml) | [cargo.toml](./config/cargo.toml) | [data.xml](./config/data.xml) | [editor.jsonc](./config/editor.jsonc) | [module.psd1](./config/module.psd1) | [pack.props](./config/pack.props) | [report.xslt](./config/report.xslt) | [schema.xsd](./config/schema.xsd) | [service.wsdl](./config/service.wsdl) | [style.xsl](./config/style.xsl) | [theme.json5](./config/theme.json5) | [tool.csproj](./config/tool.csproj)
- document: [markdown-basic.md](./document/markdown-basic.md) | [markdown-code.md](./document/markdown-code.md) | [guide.markdown](./document/guide.markdown) | [draft.mdx](./document/draft.mdx) | [audit.ipynb](./document/audit.ipynb) | [jupyter.ipynb](./document/jupyter.ipynb)
- diagram: [architecture.mmd](./document/architecture.mmd) | [classdiagram.mmd](./document/classdiagram.mmd) | [complex-architecture.mmd](./document/complex-architecture.mmd) | [erdiagram.mmd](./document/erdiagram.mmd) | [flow.mermaid](./document/flow.mermaid) | [flowchart.mmd](./document/flowchart.mmd) | [gantt.mmd](./document/gantt.mmd) | [gitgraph.mmd](./document/gitgraph.mmd) | [mindmap.mmd](./document/mindmap.mmd) | [pie.mmd](./document/pie.mmd) | [sequence.mermaid](./document/sequence.mermaid) | [timeline.mmd](./document/timeline.mmd) | [trace.mmd](./document/trace.mmd) | [xychart.mmd](./document/xychart.mmd)
