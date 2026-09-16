# Visualiseur de Code Git

[English](./README.md) | [简体中文](./README_ZH.md) | [Deutsch](./README_DE.md) | [Español](./README_ES.md) | Français | [हिन्दी](./README_HI.md) | [日本語](./README_JA.md) | [한국어](./README_KO.md) | [Português (Brasil)](./README_PT_BR.md) | [Bahasa Indonesia](./README_ID.md) | [Türkçe](./README_TR.md)

![Feature Graphic](./other/feature-graphic.png)
<a href='https://play.google.com/store/apps/details?id=com.xdnote.codeviewer&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'>
  <img alt='Get it on Google Play' src='./other/google-play-badge.png'/>
</a>
&nbsp;&nbsp;
<a href='https://apps.apple.com/app/id6800189725'>
  <img alt='Download on the App Store' src='./other/app-store-badge.svg'/>
</a>

GitCode Viewer transpose sur téléphone et tablette le confort de Git et de la lecture de code sur ordinateur : lisez code et documents partout.

Votre dépôt est votre base de connaissances. L'assistant IA intégré vous aide à explorer vos dépôts, repérer les bugs, expliquer le code, résumer la documentation, consulter l'historique des commits, traduire et plus encore.

## Fonctionnalités principales

- 🤖 **Malin :** Prend en charge les principaux fournisseurs de modèles IA, standards ou personnalisés, compatible avec les API aux formats OpenAI et Anthropic.
- 🌿 **Fluide :** Clone / Branch / Log / Diff, aussi agréable que sur ordinateur.
- 🎨 **Code :** Coloration syntaxique de plus de 30 langages (Python / JavaScript / PHP, etc.), avec plan du code et navigation par symboles.
- 📚 **Documents :** Ouvrez instantanément Markdown / Mermaid / Jupyter / Office / PDF.
- 🔎 **Découverte :** Tendances et recherche GitHub intégrées pour explorer vite les projets populaires.
- 📁 **Gestion :** Dépôts privés sur GitHub / GitLab / Bitbucket, entre autres, et serveurs auto-hébergés, accès sécurisé via SSH / PAT.
- 🧩 **Simple :** Lecture hors ligne, sans publicité, prise en main immédiate.

## 🚀 Démo en direct

📱 **Vous regardez dans l'application ?** Appuyez sur les fichiers ci-dessous pour prévisualiser instantanément la coloration syntaxique et le rendu.

> **Comment obtenir ce dépôt ?**
> Recherchez `GitCodeViewer` dans l'application, ou appuyez sur **+** -> **Cloner** et entrez :
> `https://github.com/ada87/GitCodeViewer.git`

## Populaires

- [Python](./backend/repo.py) | [Rust](./backend/sync.rs) | [TypeScript](./frontend/repo.ts) | [Golang](./backend/cache.go) | [Markdown](./document/markdown-code.md) | [Jupyter](./document/jupyter.ipynb)

## Code

- frontend: [alias.mjs](./frontend/alias.mjs) | [board.htm](./frontend/board.htm) | [card.sass](./frontend/card.sass) | [page.html](./frontend/page.html) | [help.xhtml](./document/help.xhtml) | [panel.jsx](./frontend/panel.jsx) | [panel.less](./frontend/panel.less) | [preview.js](./frontend/preview.js) | [repo.ts](./frontend/repo.ts) | [resolver.mts](./frontend/resolver.mts) | [shell.astro](./frontend/shell.astro) | [state.cljs](./frontend/state.cljs) | [theme.scss](./frontend/theme.scss) | [tokens.css](./frontend/tokens.css) | [tree.tsx](./frontend/tree.tsx) | [viewer.vue](./frontend/viewer.vue)
- backend: [api.http](./backend/api.http) | [api.java](./backend/api.java) | [cache.go](./backend/cache.go) | [data.edn](./backend/data.edn) | [fetch.rb](./backend/fetch.rb) | [graph.sparql](./backend/graph.sparql) | [jobs.kt](./backend/jobs.kt) | [legacy.php5](./backend/legacy.php5) | [mail.php](./backend/mail.php) | [node.cts](./backend/node.cts) | [query.rq](./backend/query.rq) | [query.sql](./backend/query.sql) | [repo.clj](./backend/repo.clj) | [repo.py](./backend/repo.py) | [report.r](./backend/report.r) | [rules.scala](./backend/rules.scala) | [scan.cjs](./backend/scan.cjs) | [schema.ddl](./backend/schema.ddl) | [script.csx](./backend/script.csx) | [seed.dml](./backend/seed.dml) | [shared.cljc](./backend/shared.cljc) | [stats.jl](./backend/stats.jl) | [store.cs](./backend/store.cs) | [sync.rest](./backend/sync.rest) | [sync.rs](./backend/sync.rs) | [types.pyi](./backend/types.pyi)
- system: [cache.cc](./system/cache.cc) | [core.c](./system/core.c) | [core.h](./system/core.h) | [core.wat](./system/core.wat) | [engine.cpp](./system/engine.cpp) | [index.hpp](./system/index.hpp) | [login.bash](./system/login.bash) | [main.c++](./system/main.c++) | [path.h++](./system/path.h++) | [path.inl](./system/path.inl) | [profile.zsh](./system/profile.zsh) | [render.hxx](./system/render.hxx) | [report.cxx](./system/report.cxx) | [ring.ipp](./system/ring.ipp) | [scan.hh](./system/scan.hh) | [shell.ps1](./system/shell.ps1) | [shell.sh](./system/shell.sh) | [stats.tcc](./system/stats.tcc) | [sync.psm1](./system/sync.psm1) | [telemetry.jsm](./system/telemetry.jsm) | [text.wast](./system/text.wast)
- mobile: [bridge.mm](./mobile/bridge.mm) | [panel.m](./mobile/panel.m) | [reader.ets](./mobile/reader.ets) | [repos.dart](./mobile/repos.dart) | [sync.swift](./mobile/sync.swift)
- template: [guide.njk](./template/guide.njk) | [mail.jinja2](./template/mail.jinja2) | [page.jinja](./template/page.jinja) | [panel.j2](./template/panel.j2) | [panel.phtml](./template/panel.phtml) | [theme.liquid](./template/theme.liquid)
- config: [app.json](./config/app.json) | [app.plist](./config/app.plist) | [app.yaml](./config/app.yaml) | [build.kts](./config/build.kts) | [build.targets](./config/build.targets) | [build.yml](./config/build.yml) | [cargo.toml](./config/cargo.toml) | [data.xml](./config/data.xml) | [editor.jsonc](./config/editor.jsonc) | [module.psd1](./config/module.psd1) | [pack.props](./config/pack.props) | [report.xslt](./config/report.xslt) | [schema.xsd](./config/schema.xsd) | [service.wsdl](./config/service.wsdl) | [style.xsl](./config/style.xsl) | [theme.json5](./config/theme.json5) | [tool.csproj](./config/tool.csproj)

## Documents

- office: [sample-1.docx](./office/sample-1.docx) | [sample-2.xlsx](./office/sample-2.xlsx) | [sample-3.pptx](./office/sample-3.pptx) | [sample-4.pdf](./office/sample-4.pdf) | [sample-5.tsv](./office/sample-5.tsv) | [sample-6.xlsm](./office/sample-6.xlsm) | [sample-7.xlsb](./office/sample-7.xlsb) | [sample-8.csv](./office/sample-8.csv) | [sample-9.rtf](./office/sample-9.rtf)
- document: [markdown-basic.md](./document/markdown-basic.md) | [markdown-code.md](./document/markdown-code.md) | [guide.markdown](./document/guide.markdown) | [draft.mdx](./document/draft.mdx) | [audit.ipynb](./document/audit.ipynb) | [jupyter.ipynb](./document/jupyter.ipynb)
- diagram: [architecture.mmd](./diagram/architecture.mmd) | [classdiagram.mmd](./diagram/classdiagram.mmd) | [complex-architecture.mmd](./diagram/complex-architecture.mmd) | [erdiagram.mmd](./diagram/erdiagram.mmd) | [flow.mermaid](./diagram/flow.mermaid) | [flowchart.mmd](./diagram/flowchart.mmd) | [gantt.mmd](./diagram/gantt.mmd) | [gitgraph.mmd](./diagram/gitgraph.mmd) | [mindmap.mmd](./diagram/mindmap.mmd) | [pie.mmd](./diagram/pie.mmd) | [sequence.mermaid](./diagram/sequence.mermaid) | [timeline.mmd](./diagram/timeline.mmd) | [trace.mmd](./diagram/trace.mmd) | [xychart.mmd](./diagram/xychart.mmd)
