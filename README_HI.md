# Git कोड व्यूअर

[English](./README.md) | [简体中文](./README_ZH.md) | [Deutsch](./README_DE.md) | [Español](./README_ES.md) | [Français](./README_FR.md) | हिन्दी | [日本語](./README_JA.md) | [한국어](./README_KO.md) | [Português (Brasil)](./README_PT_BR.md) | [Bahasa Indonesia](./README_ID.md) | [Türkçe](./README_TR.md)

![Feature Graphic](./other/feature-graphic.png)
<a href='https://play.google.com/store/apps/details?id=com.xdnote.codeviewer&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'>
  <img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height="80"/>
</a>

एक उच्च-प्रदर्शन सोर्स कोड रीडिंग टूल है जो आपको कभी भी, कहीं भी कोड देखने में मदद करता है।

## विशेषताएं

1. **ऑफ़लाइन Git:** क्लोन करने के बाद ऑफ़लाइन देखें। branch, log और अन्य Git संचालन के साथ निजी रिपॉज़िटरी का समर्थन करता है।
2. **सिंटैक्स हाइलाइट:** मुख्य भाषाओं का समर्थन करता है (HTML, JS, CSS, Python, TypeScript, Java, C++, PHP, Rust, Go, Ruby, Kotlin, Dart, Bash, SQL, YAML, आदि)।
3. **दस्तावेज़ पढ़ना:** Markdown, Mermaid (.mmd, .mermaid), Jupyter (.ipynb) और अधिक का समर्थन करता है।
4. **थीम:** Light/Dark मोड और VS Code/JetBrains थीम स्टाइल का समर्थन करता है।
5. **GitHub:** लोकप्रिय सार्वजनिक परियोजनाओं को तेज़ी से खोजें और डाउनलोड करें।

## 🚀 लाइव डेमो

📱 **ऐप के अंदर देख रहे हैं?** सिंटैक्स हाइलाइटिंग और रेंडरिंग क्षमताओं का पूर्वावलोकन करने के लिए नीचे दी गई फ़ाइलों पर टैप करें।

> **यह रिपो कैसे प्राप्त करें?**
> ऐप में `GitCodeViewer` खोजें, या **+** -> **क्लोन** पर टैप करें और दर्ज करें:
> `https://github.com/ada87/GitCodeViewer.git`

## लोकप्रिय

- [Python](./backend/repo.py) | [Rust](./backend/sync.rs) | [TypeScript](./frontend/repo.ts) | [Golang](./backend/cache.go) | [Markdown](./document/markdown-code.md) | [Jupyter](./document/jupyter.ipynb)

## कोड

- frontend: [alias.mjs](./frontend/alias.mjs) | [board.htm](./frontend/board.htm) | [card.sass](./frontend/card.sass) | [page.html](./frontend/page.html) | [help.xhtml](./document/help.xhtml) | [panel.jsx](./frontend/panel.jsx) | [panel.less](./frontend/panel.less) | [preview.js](./frontend/preview.js) | [repo.ts](./frontend/repo.ts) | [resolver.mts](./frontend/resolver.mts) | [shell.astro](./frontend/shell.astro) | [state.cljs](./frontend/state.cljs) | [theme.scss](./frontend/theme.scss) | [tokens.css](./frontend/tokens.css) | [tree.tsx](./frontend/tree.tsx) | [viewer.vue](./frontend/viewer.vue)
- backend: [api.http](./backend/api.http) | [api.java](./backend/api.java) | [cache.go](./backend/cache.go) | [data.edn](./backend/data.edn) | [fetch.rb](./backend/fetch.rb) | [graph.sparql](./backend/graph.sparql) | [jobs.kt](./backend/jobs.kt) | [legacy.php5](./backend/legacy.php5) | [mail.php](./backend/mail.php) | [node.cts](./backend/node.cts) | [query.rq](./backend/query.rq) | [query.sql](./backend/query.sql) | [repo.clj](./backend/repo.clj) | [repo.py](./backend/repo.py) | [report.r](./backend/report.r) | [rules.scala](./backend/rules.scala) | [scan.cjs](./backend/scan.cjs) | [schema.ddl](./backend/schema.ddl) | [script.csx](./backend/script.csx) | [seed.dml](./backend/seed.dml) | [shared.cljc](./backend/shared.cljc) | [stats.jl](./backend/stats.jl) | [store.cs](./backend/store.cs) | [sync.rest](./backend/sync.rest) | [sync.rs](./backend/sync.rs) | [types.pyi](./backend/types.pyi)
- system: [cache.cc](./system/cache.cc) | [core.c](./system/core.c) | [core.h](./system/core.h) | [core.wat](./system/core.wat) | [engine.cpp](./system/engine.cpp) | [index.hpp](./system/index.hpp) | [login.bash](./system/login.bash) | [main.c++](./system/main.c++) | [path.h++](./system/path.h++) | [path.inl](./system/path.inl) | [profile.zsh](./system/profile.zsh) | [render.hxx](./system/render.hxx) | [report.cxx](./system/report.cxx) | [ring.ipp](./system/ring.ipp) | [scan.hh](./system/scan.hh) | [shell.ps1](./system/shell.ps1) | [shell.sh](./system/shell.sh) | [stats.tcc](./system/stats.tcc) | [sync.psm1](./system/sync.psm1) | [telemetry.jsm](./system/telemetry.jsm) | [text.wast](./system/text.wast)
- mobile: [bridge.mm](./mobile/bridge.mm) | [panel.m](./mobile/panel.m) | [reader.ets](./mobile/reader.ets) | [repos.dart](./mobile/repos.dart) | [sync.swift](./mobile/sync.swift)
- template: [guide.njk](./template/guide.njk) | [mail.jinja2](./template/mail.jinja2) | [page.jinja](./template/page.jinja) | [panel.j2](./template/panel.j2) | [panel.phtml](./template/panel.phtml) | [theme.liquid](./template/theme.liquid)
- config: [app.json](./config/app.json) | [app.plist](./config/app.plist) | [app.yaml](./config/app.yaml) | [build.kts](./config/build.kts) | [build.targets](./config/build.targets) | [build.yml](./config/build.yml) | [cargo.toml](./config/cargo.toml) | [data.xml](./config/data.xml) | [editor.jsonc](./config/editor.jsonc) | [module.psd1](./config/module.psd1) | [pack.props](./config/pack.props) | [report.xslt](./config/report.xslt) | [schema.xsd](./config/schema.xsd) | [service.wsdl](./config/service.wsdl) | [style.xsl](./config/style.xsl) | [theme.json5](./config/theme.json5) | [tool.csproj](./config/tool.csproj)

## दस्तावेज़

- office: [sample-1.docx](./office/sample-1.docx) | [sample-2.xlsx](./office/sample-2.xlsx) | [sample-3.pptx](./office/sample-3.pptx) | [sample-4.pdf](./office/sample-4.pdf) | [sample-5.tsv](./office/sample-5.tsv) | [sample-6.xlsm](./office/sample-6.xlsm) | [sample-7.xlsb](./office/sample-7.xlsb) | [sample-8.csv](./office/sample-8.csv) | [sample-9.rtf](./office/sample-9.rtf)
- document: [markdown-basic.md](./document/markdown-basic.md) | [markdown-code.md](./document/markdown-code.md) | [guide.markdown](./document/guide.markdown) | [draft.mdx](./document/draft.mdx) | [audit.ipynb](./document/audit.ipynb) | [jupyter.ipynb](./document/jupyter.ipynb)
- diagram: [architecture.mmd](./diagram/architecture.mmd) | [classdiagram.mmd](./diagram/classdiagram.mmd) | [complex-architecture.mmd](./diagram/complex-architecture.mmd) | [erdiagram.mmd](./diagram/erdiagram.mmd) | [flow.mermaid](./diagram/flow.mermaid) | [flowchart.mmd](./diagram/flowchart.mmd) | [gantt.mmd](./diagram/gantt.mmd) | [gitgraph.mmd](./diagram/gitgraph.mmd) | [mindmap.mmd](./diagram/mindmap.mmd) | [pie.mmd](./diagram/pie.mmd) | [sequence.mermaid](./diagram/sequence.mermaid) | [timeline.mmd](./diagram/timeline.mmd) | [trace.mmd](./diagram/trace.mmd) | [xychart.mmd](./diagram/xychart.mmd)
