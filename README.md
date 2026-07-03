# DataDragon SDK

Data Dragon API client, generated from the OpenAPI spec.

> TypeScript, Python, PHP, Golang, Ruby, Lua SDKs, a CLI, an interactive REPL, and an MCP server for AI agents — all generated from one OpenAPI spec by [@voxgig/sdkgen](https://github.com/voxgig/sdkgen).

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

## Quickstart

### TypeScript

```ts
import { DataDragonSDK } from 'data-dragon'

const client = new DataDragonSDK({
  apikey: process.env.DATA-DRAGON_APIKEY,
})

// Load champion data
const champion = await client.Champion().load({})
console.log(champion.data)
```

See the [TypeScript README](ts/README.md) for the full guide.

## Surfaces

| Surface | Path |
| --- | --- |
| **SDK** (TypeScript, Python, PHP, Golang, Ruby, Lua) | `ts/` `py/` `php/` `go/` `rb/` `lua/` |
| **CLI** | `go-cli/` |
| **MCP server** | `go-mcp/` |

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
| **Champion** |  | `/cdn/{version}/img/champion/{championImage}` |
| **DataChampion** |  | `/cdn/{version}/data/{language}/champion.json` |
| **DataItem** |  | `/cdn/{version}/data/{language}/item.json` |
| **DataRune** |  | `/cdn/{version}/data/{language}/rune.json` |
| **DragontailVersiontgz** |  | `/cdn/dragontail-{version}.tgz` |
| **Item** |  | `/cdn/{version}/img/item/{itemImage}` |
| **Region** |  | `/realms/{region}.json` |
| **Version** |  | `/api/versions.json` |

Each entity supports the following operations where available: **load**,
**list**, **create**, **update**, and **remove**.

## Quickstart in other languages

### Python

```python
import os
from datadragon_sdk import DataDragonSDK

client = DataDragonSDK({
    "apikey": os.environ.get("DATA-DRAGON_APIKEY"),
})


# Load a specific champion
champion, err = client.Champion().load({"id": "example_id"})
print(champion)
```

### PHP

```php
<?php
require_once 'datadragon_sdk.php';

$client = new DataDragonSDK([
    "apikey" => getenv("DATA-DRAGON_APIKEY"),
]);


// Load a specific champion
[$champion, $err] = $client->Champion()->load(["id" => "example_id"]);
print_r($champion);
```

### Golang

```go
import sdk "github.com/voxgig-sdk/data-dragon-sdk/go"

client := sdk.NewDataDragonSDK(map[string]any{
    "apikey": os.Getenv("DATA-DRAGON_APIKEY"),
})

// Load champion data
champion, err := client.Champion(nil).Load(map[string]any{}, nil)
fmt.Println(champion)
```

### Ruby

```ruby
require_relative "DataDragon_sdk"

client = DataDragonSDK.new({
  "apikey" => ENV["DATA-DRAGON_APIKEY"],
})


# Load a specific champion
champion, err = client.Champion().load({ "id" => "example_id" })
puts champion
```

### Lua

```lua
local sdk = require("data-dragon_sdk")

local client = sdk.new({
  apikey = os.getenv("DATA-DRAGON_APIKEY"),
})


-- Load a specific champion
local champion, err = client:Champion():load({ id = "example_id" })
print(champion)
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
client = DataDragonSDK.test()
result, err = client.Champion().load({"id": "test01"})
```

### PHP

```php
$client = DataDragonSDK::test();
[$result, $err] = $client->Champion()->load(["id" => "test01"]);
```

### Golang

```go
client := sdk.Test()
result, err := client.Champion(nil).Load(
    map[string]any{"id": "test01"}, nil,
)
```

### Ruby

```ruby
client = DataDragonSDK.test
result, err = client.Champion().load({ "id" => "test01" })
```

### Lua

```lua
local client = sdk.test()
local result, err = client:Champion():load({ id = "test01" })
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

---

Generated from the Data Dragon API OpenAPI spec by [@voxgig/sdkgen](https://github.com/voxgig/sdkgen).
