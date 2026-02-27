# Markdown Code Highlight

Showcasing all languages supported by highlight.js in this viewer.

## Web

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>GitCode Viewer</title>
</head>
<body>
  <div id="app"></div>
  <script type="module" src="/main.js"></script>
</body>
</html>
```

```css
:root {
  --bg: #1e1e1e;
  --fg: #d4d4d4;
  --accent: #4ea1ff;
}

.repo-card {
  background: var(--bg);
  color: var(--fg);
  border-radius: 8px;
  padding: 16px;
  transition: border-color 0.15s;
}

.repo-card:hover {
  border-color: var(--accent);
}
```

```scss
$accent: #4ea1ff;
$radius: 8px;

@mixin flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}

.repo-card {
  border-radius: $radius;
  &:hover { border-color: $accent; }
  &__name { @include flex-center; }
}
```

```javascript
async function fetchRepos(user) {
  const res = await fetch(`https://api.github.com/users/${user}/repos`)
  if (!res.ok) throw new Error(`HTTP ${res.status}`)
  return res.json()
}

fetchRepos('ada87').then(repos => {
  repos.sort((a, b) => b.stargazers_count - a.stargazers_count)
  console.log(repos.map(r => r.full_name))
})
```

```typescript
interface Repository {
  id: number
  full_name: string
  stargazers_count: number
  language: string | null
}

async function fetchRepos(user: string): Promise<Repository[]> {
  const res = await fetch(`https://api.github.com/users/${user}/repos`)
  if (!res.ok) throw new Error(`HTTP ${res.status}`)
  return res.json() as Promise<Repository[]>
}
```

```json
{
  "name": "GitCodeViewer",
  "version": "1.0.0",
  "dependencies": {
    "react-native": "0.83.0",
    "zustand": "^5.0.0"
  },
  "scripts": {
    "start": "react-native start",
    "android": "react-native run-android"
  }
}
```

## Systems

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char id[64];
    char name[128];
    long size_bytes;
} Repository;

char* format_bytes(long bytes) {
    char* buf = malloc(32);
    if (bytes < 1024)
        snprintf(buf, 32, "%ld B", bytes);
    else if (bytes < 1048576)
        snprintf(buf, 32, "%.1f KB", bytes / 1024.0);
    else
        snprintf(buf, 32, "%.1f MB", bytes / 1048576.0);
    return buf;
}
```

```cpp
#include <string>
#include <vector>
#include <algorithm>

struct Repository {
    std::string id;
    std::string name;
    std::string url;
    long size_bytes = 0;

    std::string display_name() const {
        auto pos = url.rfind('/');
        return pos != std::string::npos ? url.substr(pos + 1) : name;
    }
};

std::string format_bytes(long bytes) {
    if (bytes < 1024) return std::to_string(bytes) + " B";
    if (bytes < 1 << 20) return std::to_string(bytes >> 10) + " KB";
    return std::to_string(bytes >> 20) + " MB";
}
```

```csharp
public record Repository(
    string Id, string Name, string Url,
    string Branch = "main", long SizeBytes = 0
);

public static string FormatBytes(long bytes) => bytes switch {
    < 1024        => $"{bytes} B",
    < 1024 * 1024 => $"{bytes / 1024} KB",
    _             => $"{bytes / (1024.0 * 1024.0):F1} MB",
};
```

```rust
#[derive(Debug, Clone)]
pub struct Repository {
    pub id: String,
    pub name: String,
    pub url: String,
    pub size_bytes: u64,
}

pub fn format_bytes(bytes: u64) -> String {
    match bytes {
        b if b < 1024 => format!("{} B", b),
        b if b < 1024 * 1024 => format!("{} KB", b / 1024),
        b => format!("{:.1} MB", b as f64 / (1024.0 * 1024.0)),
    }
}
```

```go
type Repository struct {
    ID        string    `json:"id"`
    Name      string    `json:"name"`
    URL       string    `json:"url"`
    SizeBytes int64     `json:"size_bytes"`
}

func FormatBytes(bytes int64) string {
    switch {
    case bytes < 1024:
        return fmt.Sprintf("%d B", bytes)
    case bytes < 1024*1024:
        return fmt.Sprintf("%d KB", bytes/1024)
    default:
        return fmt.Sprintf("%.1f MB", float64(bytes)/(1024*1024))
    }
}
```

## JVM / Mobile

```java
public class Repository {
    private final String id;
    private final String name;
    private final long sizeBytes;

    public String formatSize() {
        if (sizeBytes < 1024) return sizeBytes + " B";
        if (sizeBytes < 1024 * 1024) return sizeBytes / 1024 + " KB";
        return String.format("%.1f MB", sizeBytes / (1024.0 * 1024.0));
    }
}
```

```kotlin
data class Repository(
    val id: String,
    val name: String,
    val url: String,
    val sizeBytes: Long = 0,
)

fun Long.formatBytes(): String = when {
    this < 1024        -> "$this B"
    this < 1024 * 1024 -> "${this / 1024} KB"
    else               -> "${"%.1f".format(this / (1024.0 * 1024.0))} MB"
}
```

```swift
struct Repository {
    let id: String
    let name: String
    let url: String
    var sizeBytes: Int64 = 0

    var formattedSize: String {
        switch sizeBytes {
        case ..<1024: return "\(sizeBytes) B"
        case ..<(1024*1024): return "\(sizeBytes / 1024) KB"
        default: return String(format: "%.1f MB", Double(sizeBytes) / (1024 * 1024))
        }
    }
}
```

```dart
class Repository {
  final String id;
  final String name;
  final String url;
  final int sizeBytes;

  const Repository({
    required this.id,
    required this.name,
    required this.url,
    this.sizeBytes = 0,
  });

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${sizeBytes ~/ 1024} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
```

```php
<?php

class Repository {
    public function __construct(
        public readonly string $id,
        public readonly string $name,
        public readonly string $url,
        public readonly int $sizeBytes = 0,
    ) {}

    public function formatSize(): string {
        return match(true) {
            $this->sizeBytes < 1024        => "{$this->sizeBytes} B",
            $this->sizeBytes < 1048576     => round($this->sizeBytes / 1024, 1) . " KB",
            default                        => round($this->sizeBytes / 1048576, 1) . " MB",
        };
    }
}
```

## Scripting

```python
from dataclasses import dataclass, field
from typing import Optional
import datetime

@dataclass
class Repository:
    id: str
    name: str
    url: str
    branch: str = "main"
    last_synced: Optional[datetime.datetime] = None
    size_bytes: int = 0

    def format_size(self) -> str:
        if self.size_bytes < 1024:
            return f"{self.size_bytes} B"
        if self.size_bytes < 1024 ** 2:
            return f"{self.size_bytes / 1024:.1f} KB"
        return f"{self.size_bytes / 1024 ** 2:.1f} MB"

    @property
    def display_name(self) -> str:
        return self.url.rstrip("/").split("/")[-1].removesuffix(".git") or self.name
```

```ruby
class Repository
  attr_reader :id, :name, :url, :size_bytes

  def initialize(id:, name:, url:, size_bytes: 0)
    @id = id
    @name = name
    @url = url
    @size_bytes = size_bytes
  end

  def format_size
    case size_bytes
    when 0...1024        then "#{size_bytes} B"
    when 0...1_048_576   then "#{size_bytes / 1024} KB"
    else                      "#{"%.1f" % (size_bytes / 1_048_576.0)} MB"
    end
  end

  def display_name
    url.split("/").last&.delete_suffix(".git") || name
  end
end
```

```bash
#!/usr/bin/env bash
set -euo pipefail

format_bytes() {
  local bytes=$1
  if   (( bytes < 1024 ));        then echo "${bytes} B"
  elif (( bytes < 1048576 ));     then echo "$(( bytes / 1024 )) KB"
  else                                 echo "$(( bytes / 1048576 )) MB"
  fi
}

sync_repo() {
  local url=$1
  local dest=$2
  if [ -d "$dest/.git" ]; then
    echo "Pulling $url..."
    git -C "$dest" pull --ff-only
  else
    echo "Cloning $url..."
    git clone --depth=1 "$url" "$dest"
  fi
}
```

## Data / Config

```sql
CREATE TABLE repositories (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    url         TEXT NOT NULL UNIQUE,
    branch      TEXT NOT NULL DEFAULT 'main',
    last_synced DATETIME,
    size_bytes  INTEGER NOT NULL DEFAULT 0,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_repos_last_synced ON repositories(last_synced DESC);

SELECT
    name,
    CASE
        WHEN size_bytes < 1024        THEN size_bytes || ' B'
        WHEN size_bytes < 1048576     THEN (size_bytes / 1024) || ' KB'
        ELSE round(size_bytes / 1048576.0, 1) || ' MB'
    END AS size_label,
    strftime('%Y-%m-%d', last_synced) AS synced_date
FROM repositories
ORDER BY last_synced DESC
LIMIT 20;
```

```yaml
app:
  name: GitCodeViewer
  version: "1.0.0"

sync:
  max_concurrent: 3
  timeout_seconds: 30
  retry_count: 2
  shallow_clone: true

viewer:
  theme: vscode-dark
  font_size: 14
  line_numbers: true
  code_wrap: false
  toc_position: float

languages:
  - javascript
  - typescript
  - python
  - rust
  - go
  - kotlin
  - swift
```

```diff
--- a/src/sync/SyncService.ts
+++ b/src/sync/SyncService.ts
@@ -12,7 +12,7 @@ export class SyncService {
-  private maxConcurrent = 2
+  private maxConcurrent = 3

   async syncAll(): Promise<SyncResult[]> {
-    const repos = await this.store.getAll()
+    const repos = (await this.store.getAll()).filter(r => r.enabled)
     return Promise.all(repos.map(r => this.syncOne(r)))
   }
```
