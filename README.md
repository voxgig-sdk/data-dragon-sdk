# DataDragon SDK

Static CDN of League of Legends champion, item, and rune data plus images, published by Riot Games

> TypeScript, Python, PHP, Golang, Ruby, Lua SDKs, a CLI, an interactive REPL, and an MCP server for AI agents — all generated from one OpenAPI spec by [@voxgig/sdkgen](https://github.com/voxgig/sdkgen).

## About Data Dragon API

Data Dragon (`ddragon`) is the static data CDN run by [Riot Games](https://www.riotgames.com/) for [League of Legends](https://www.leagueoflegends.com/). It exposes the game's reference data — champions, items, runes, summoner spells — together with the matching portraits, icons, and sprite sheets, so third-party tools can translate IDs into human-readable names and images without hitting the rate-limited live Riot API.

What you get from the API:

- Per-version JSON bundles under `/cdn/{version}/data/{language}/{datatype}.json` (e.g. `champion.json`, `item.json`, `runesReforged.json`).
- The full asset tarball `https://ddragon.leagueoflegends.com/cdn/dragontail-{version}.tgz` (~1 GB) containing every data file and image for a patch.
- The list of available patches at `https://ddragon.leagueoflegends.com/api/versions.json`.
- Per-region realm metadata at `https://ddragon.leagueoflegends.com/realms/{region}.json`, useful for discovering which ddragon version a given shard is currently serving.

Data is published per patch and across 27 locales (en_US, en_GB, es_ES, ja_JP, ko_KR, zh_CN, and so on). Regional realms can lag or lead the global patch by a day or two, so production tools typically read `realms/{region}.json` first and then fetch the matching versioned files. No API key is needed and CORS is enabled, but the assets are large — prefer caching individual JSON files over downloading the dragontail tarball for every build.

## Try it

**TypeScript**
```bash
npm install data-dragon
```

**Python**
```bash
pip install data-dragon-sdk
```

**PHP**
```bash
composer require voxgig/data-dragon-sdk
```

**Golang**
```bash
go get github.com/voxgig-sdk/data-dragon-sdk/go
```

**Ruby**
```bash
gem install data-dragon-sdk
```

**Lua**
```bash
luarocks install data-dragon-sdk
```

## 30-second quickstart

### TypeScript

```ts
import { DataDragonSDK } from 'data-dragon'

const client = new DataDragonSDK({})

```

See the [TypeScript README](ts/README.md) for the
full guide, or scroll down for the same example in other languages.

## What's in the box

| Surface | Use it for | Path |
| --- | --- | --- |
| **SDK** (TypeScript, Python, PHP, Golang, Ruby, Lua) | App integration | `ts/` `py/` `php/` `go/` `rb/` `lua/` |
| **CLI** | Scripts, CI, ops, one-off API calls | `go-cli/` |
| **MCP server** | AI agents (Claude, Cursor, Cline) | `go-mcp/` |

## Use it from an AI agent (MCP)

The generated MCP server exposes every operation in this SDK as an
[MCP](https://modelcontextprotocol.io) tool that Claude, Cursor or Cline
can call directly. Build and register it:

```bash
cd go-mcp && go build -o data-dragon-mcp .
```

Then add it to your agent's MCP config (Claude Desktop, Cursor, etc.):

```json
{
  "mcpServers": {
    "data-dragon": {
      "command": "/abs/path/to/data-dragon-mcp"
    }
  }
}
```

## Entities

The API exposes 8 entities:

| Entity | Description | API path |
| --- | --- | --- |
| **Champion** | League of Legends champion records — name, title, tags, stats, spells, and image references — served under `/cdn/{version}/data/{language}/champion.json` and per-champion files. | `/cdn/{version}/img/champion/{championImage}` |
| **DataChampion** | The champion data bundle for a given patch and locale at `/cdn/{version}/data/{language}/champion.json`. | `/cdn/{version}/data/{language}/champion.json` |
| **DataItem** | The item catalogue (stats, gold cost, tags, build paths, icons) for a patch and locale at `/cdn/{version}/data/{language}/item.json`. | `/cdn/{version}/data/{language}/item.json` |
| **DataRune** | Rune / Runes Reforged data (paths, slots, keystones) for a patch and locale at `/cdn/{version}/data/{language}/runesReforged.json`. | `/cdn/{version}/data/{language}/rune.json` |
| **DragontailVersiontgz** | Full per-patch asset tarball containing every data file and image, at `https://ddragon.leagueoflegends.com/cdn/dragontail-{version}.tgz`. | `/cdn/dragontail-{version}.tgz` |
| **Item** | Individual League of Legends items as exposed via the item data bundle, used to resolve item IDs to names, stats, and icons. | `/cdn/{version}/img/item/{itemImage}` |
| **Region** | Per-shard realm metadata at `https://ddragon.leagueoflegends.com/realms/{region}.json`, describing which ddragon and game versions a Riot region is currently serving. | `/realms/{region}.json` |
| **Version** | The list of published Data Dragon patch versions at `https://ddragon.leagueoflegends.com/api/versions.json`, used to pick a `{version}` for the CDN paths. | `/api/versions.json` |

Each entity supports the following operations where available: **load**,
**list**, **create**, **update**, and **remove**.

## Quickstart in other languages

### Python

```python
from datadragon_sdk import DataDragonSDK

client = DataDragonSDK({})


# Load a specific champion
champion, err = client.Champion(None).load(
    {"id": "example_id"}, None
)
```

### PHP

```php
<?php
require_once 'datadragon_sdk.php';

$client = new DataDragonSDK([]);


// Load a specific champion
[$champion, $err] = $client->Champion(null)->load(
    ["id" => "example_id"], null
);
```

### Golang

```go
import sdk "github.com/voxgig-sdk/data-dragon-sdk/go"

client := sdk.NewDataDragonSDK(map[string]any{})

```

### Ruby

```ruby
require_relative "DataDragon_sdk"

client = DataDragonSDK.new({})


# Load a specific champion
champion, err = client.Champion(nil).load(
  { "id" => "example_id" }, nil
)
```

### Lua

```lua
local sdk = require("data-dragon_sdk")

local client = sdk.new({})


-- Load a specific champion
local champion, err = client:Champion(nil):load(
  { id = "example_id" }, nil
)
```

## Unit testing in offline mode

Every SDK ships a test mode that swaps the HTTP transport for an
in-memory mock, so unit tests run offline.

### TypeScript

```ts
const client = DataDragonSDK.test()
const result = await client.Champion().load({ id: 'test01' })
// result.ok === true, result.data contains mock data
```

### Python

```python
client = DataDragonSDK.test(None, None)
result, err = client.Champion(None).load(
    {"id": "test01"}, None
)
```

### PHP

```php
$client = DataDragonSDK::test(null, null);
[$result, $err] = $client->Champion(null)->load(
    ["id" => "test01"], null
);
```

### Golang

```go
client := sdk.TestSDK(nil, nil)
result, err := client.Champion(nil).Load(
    map[string]any{"id": "test01"}, nil,
)
```

### Ruby

```ruby
client = DataDragonSDK.test(nil, nil)
result, err = client.Champion(nil).load(
  { "id" => "test01" }, nil
)
```

### Lua

```lua
local client = sdk.test(nil, nil)
local result, err = client:Champion(nil):load(
  { id = "test01" }, nil
)
```

## How it works

Every SDK call runs the same five-stage pipeline:

1. **Point** — resolve the API endpoint from the operation definition.
2. **Spec** — build the HTTP specification (URL, method, headers, body).
3. **Request** — send the HTTP request.
4. **Response** — receive and parse the response.
5. **Result** — extract the result data for the caller.

A feature hook fires at each stage (e.g. `PrePoint`, `PreSpec`,
`PreRequest`), so features can inspect or modify the pipeline without
forking the SDK.

### Features

| Feature | Purpose |
| --- | --- |
| **TestFeature** | In-memory mock transport for testing without a live server |

Pass custom features via the `extend` option at construction time.

### Direct and Prepare

For endpoints the entity model doesn't cover, use the low-level methods:

- **`direct(fetchargs)`** — build and send an HTTP request in one step.
- **`prepare(fetchargs)`** — build the request without sending it.

Both accept a map with `path`, `method`, `params`, `query`,
`headers`, and `body`. See the [How-to guides](#how-to-guides) below.

## How-to guides

### Make a direct API call

When the entity interface does not cover an endpoint, use `direct`:

**TypeScript:**
```ts
const result = await client.direct({
  path: '/api/resource/{id}',
  method: 'GET',
  params: { id: 'example' },
})
console.log(result.data)
```

**Python:**
```python
result, err = client.direct({
    "path": "/api/resource/{id}",
    "method": "GET",
    "params": {"id": "example"},
})
```

**PHP:**
```php
[$result, $err] = $client->direct([
    "path" => "/api/resource/{id}",
    "method" => "GET",
    "params" => ["id" => "example"],
]);
```

**Go:**
```go
result, err := client.Direct(map[string]any{
    "path":   "/api/resource/{id}",
    "method": "GET",
    "params": map[string]any{"id": "example"},
})
```

**Ruby:**
```ruby
result, err = client.direct({
  "path" => "/api/resource/{id}",
  "method" => "GET",
  "params" => { "id" => "example" },
})
```

**Lua:**
```lua
local result, err = client:direct({
  path = "/api/resource/{id}",
  method = "GET",
  params = { id = "example" },
})
```

## Per-language documentation

- [TypeScript](ts/README.md)
- [Python](py/README.md)
- [PHP](php/README.md)
- [Golang](go/README.md)
- [Ruby](rb/README.md)
- [Lua](lua/README.md)

## Using the Data Dragon API

- Upstream: [https://ddragon.leagueoflegends.com](https://ddragon.leagueoflegends.com)
- API docs: [https://riot-api-libraries.readthedocs.io/en/latest/ddragon.html](https://riot-api-libraries.readthedocs.io/en/latest/ddragon.html)

- Data Dragon does not ship its own licence file; usage is governed by Riot Games' developer terms and legal policies.
- Champion art, item icons, and other assets are Riot Games intellectual property; respect Riot's fan-content and attribution policies.
- No authentication or API key is required for the CDN itself, and CORS is enabled for browser use.
- Versions are pinned per patch, so cache aggressively and pick a known version rather than assuming "latest".

---

Generated from the Data Dragon API OpenAPI spec by [@voxgig/sdkgen](https://github.com/voxgig/sdkgen).
