# DataDragon PHP SDK



The PHP SDK for the DataDragon API — an entity-oriented client using PHP conventions.

The SDK exposes the API as capitalised, semantic **Entities** — for example `$client->Champion()` — with named operations (`list`/`load`) instead of raw URL paths and query strings. Working with resources and verbs keeps call sites self-describing and reduces cognitive load.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
This package is not yet published to Packagist. Install it from the
GitHub release tag (`php/vX.Y.Z`):

- Releases: [https://github.com/voxgig-sdk/data-dragon-sdk/releases](https://github.com/voxgig-sdk/data-dragon-sdk/releases)


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and
loading a specific record.

### 1. Create a client

```php
<?php
require_once 'datadragon_sdk.php';

$client = new DataDragonSDK();
```

### 3. Load a champion

Champion is nested under version, so provide the `version`.

```php
try {
    // load() returns the bare Champion record (throws on error).
    $champion = $client->Champion()->load(["version" => "example_version", "id" => "example_id"]);
    print_r($champion);
} catch (\Throwable $err) {
    echo "Error: " . $err->getMessage();
}
```


## Error handling

Entity operations throw a `\Throwable` on failure, so wrap them in
`try` / `catch`:

```php
try {
    $champion = $client->Champion()->load(["id" => "example_id"]);
} catch (\Throwable $err) {
    echo "Error: " . $err->getMessage();
}
```

`direct()` does **not** throw — it returns the result array. Branch on
`ok`; on failure `status` holds the HTTP status (for error responses) and
`err` holds a transport error, so read both defensively:

```php
$result = $client->direct([
    "path" => "/api/resource/{id}",
    "method" => "GET",
    "params" => ["id" => "example_id"],
]);

if (! $result["ok"]) {
    $err = $result["err"] ?? null;
    echo "request failed: " . ($err ? $err->getMessage() : "HTTP " . $result["status"]);
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```php
// direct() is the raw-HTTP escape hatch: it returns a result array
// (it does not throw). Branch on $result["ok"].
$result = $client->direct([
    "path" => "/api/resource/{id}",
    "method" => "GET",
    "params" => ["id" => "example"],
]);

if ($result["ok"]) {
    echo $result["status"];  // 200
    print_r($result["data"]);  // response body
} else {
    // On an HTTP error status there is no err (only a transport failure sets
    // it), so fall back to the status code.
    $err = $result["err"] ?? null;
    echo "Error: " . ($err ? $err->getMessage() : "HTTP " . $result["status"]);
}
```

### Prepare a request without sending it

```php
// prepare() throws on error and returns the fetch definition.
$fetchdef = $client->prepare([
    "path" => "/api/resource/{id}",
    "method" => "DELETE",
    "params" => ["id" => "example"],
]);

echo $fetchdef["url"];
echo $fetchdef["method"];
print_r($fetchdef["headers"]);
```

### Use test mode

Create a mock client for unit testing — no server required. Seed fixture
data via the `entity` option so offline calls resolve without a live server:

```php
$client = DataDragonSDK::test([
    "entity" => ["champion" => ["test01" => ["id" => "test01"]]],
]);

// Entity ops return the bare mock record (throws on error).
$champion = $client->Champion()->load(["id" => "test01"]);
print_r($champion);
```

### Use a custom fetch function

Replace the HTTP transport with your own function:

```php
$mock_fetch = function ($url, $init) {
    return [
        [
            "status" => 200,
            "statusText" => "OK",
            "headers" => [],
            "json" => function () { return ["id" => "mock01"]; },
        ],
        null,
    ];
};

$client = new DataDragonSDK([
    "base" => "http://localhost:8080",
    "system" => [
        "fetch" => $mock_fetch,
    ],
]);
```

### Run live tests

Create a `.env.local` file at the project root:

```
DATA_DRAGON_TEST_LIVE=TRUE
```

Then run:

```bash
cd php && ./vendor/bin/phpunit test/
```


## Reference

### DataDragonSDK

```php
require_once 'datadragon_sdk.php';
$client = new DataDragonSDK($options);
```

Creates a new SDK client.

| Option | Type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL of the API server. |
| `prefix` | `string` | URL path prefix prepended to all requests. |
| `suffix` | `string` | URL path suffix appended to all requests. |
| `feature` | `array` | Feature activation flags. |
| `extend` | `array` | Additional Feature instances to load. |
| `system` | `array` | System overrides (e.g. custom `fetch` callable). |

### test

```php
$client = DataDragonSDK::test($testopts, $sdkopts);
```

Creates a test-mode client with mock transport. Both arguments may be `null`.

### DataDragonSDK methods

| Method | Signature | Description |
| --- | --- | --- |
| `options_map` | `(): array` | Deep copy of current SDK options. |
| `get_utility` | `(): Utility` | Copy of the SDK utility object. |
| `prepare` | `(array $fetchargs): array` | Build an HTTP request definition without sending. |
| `direct` | `(array $fetchargs): array` | Build and send an HTTP request. |
| `Champion` | `($data): ChampionEntity` | Create a Champion entity instance. |
| `DataChampion` | `($data): DataChampionEntity` | Create a DataChampion entity instance. |
| `DataItem` | `($data): DataItemEntity` | Create a DataItem entity instance. |
| `DataRune` | `($data): DataRuneEntity` | Create a DataRune entity instance. |
| `DragontailVersiontgz` | `($data): DragontailVersiontgzEntity` | Create a DragontailVersiontgz entity instance. |
| `Item` | `($data): ItemEntity` | Create an Item entity instance. |
| `Region` | `($data): RegionEntity` | Create a Region entity instance. |
| `Version` | `($data): VersionEntity` | Create a Version entity instance. |

### Entity interface

All entities share the same interface.

| Method | Signature | Description |
| --- | --- | --- |
| `load` | `($reqmatch, $ctrl): array` | Load a single entity by match criteria. |
| `list` | `(?array $reqmatch = null, $ctrl): array` | List entities matching the criteria (call with no argument to list all). |
| `data_get` | `(): array` | Get entity data. |
| `data_set` | `($data): void` | Set entity data. |
| `match_get` | `(): array` | Get entity match criteria. |
| `match_set` | `($match): void` | Set entity match criteria. |
| `make` | `(): Entity` | Create a new instance with the same options. |
| `get_name` | `(): string` | Return the entity name. |

### Result shape

Entity operations return the bare result data (an `array` for single-entity
ops, a `list` for `list`) and throw on error. Wrap calls in
`try`/`catch` to handle failures.

The `direct()` escape hatch never throws — it returns a result `array`
you branch on via `$result["ok"]`:

| Key | Type | Description |
| --- | --- | --- |
| `ok` | `bool` | `true` if the HTTP status is 2xx. |
| `status` | `int` | HTTP status code. |
| `headers` | `array` | Response headers. |
| `data` | `mixed` | Parsed JSON response body. |

On error, `ok` is `false` and `$err` contains the error value.

### Entities

#### Champion

| Field | Description |
| --- | --- |

Operations: Load.

API path: `/cdn/{version}/img/champion/{championImage}`

#### DataChampion

| Field | Description |
| --- | --- |
| `data` |  |
| `format` |  |
| `type` |  |
| `version` |  |

Operations: Load.

API path: `/cdn/{version}/data/{language}/champion.json`

#### DataItem

| Field | Description |
| --- | --- |
| `data` |  |
| `type` |  |
| `version` |  |

Operations: Load.

API path: `/cdn/{version}/data/{language}/item.json`

#### DataRune

| Field | Description |
| --- | --- |

Operations: Load.

API path: `/cdn/{version}/data/{language}/rune.json`

#### DragontailVersiontgz

| Field | Description |
| --- | --- |

Operations: Load.

API path: `/cdn/dragontail-{version}.tgz`

#### Item

| Field | Description |
| --- | --- |

Operations: Load.

API path: `/cdn/{version}/img/item/{itemImage}`

#### Region

| Field | Description |
| --- | --- |
| `cdn` |  |
| `n` |  |
| `v` |  |

Operations: Load.

API path: `/realms/{region}.json`

#### Version

| Field | Description |
| --- | --- |

Operations: List.

API path: `/api/versions.json`



## Entities


### Champion

Create an instance: `$champion = $client->Champion();`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Example: Load

```php
// load() returns the bare Champion record (throws on error).
$champion = $client->Champion()->load(["id" => "champion_id", "version" => "version"]);
```


### DataChampion

Create an instance: `$data_champion = $client->DataChampion();`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `data` | `array` |  |
| `format` | `string` |  |
| `type` | `string` |  |
| `version` | `string` |  |

#### Example: Load

```php
// load() returns the bare DataChampion record (throws on error).
$data_champion = $client->DataChampion()->load(["language" => "language", "version" => "version"]);
```


### DataItem

Create an instance: `$data_item = $client->DataItem();`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `data` | `array` |  |
| `type` | `string` |  |
| `version` | `string` |  |

#### Example: Load

```php
// load() returns the bare DataItem record (throws on error).
$data_item = $client->DataItem()->load(["language" => "language", "version" => "version"]);
```


### DataRune

Create an instance: `$data_rune = $client->DataRune();`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Example: Load

```php
// load() returns the bare DataRune record (throws on error).
$data_rune = $client->DataRune()->load(["language" => "language", "version" => "version"]);
```


### DragontailVersiontgz

Create an instance: `$dragontail_versiontgz = $client->DragontailVersiontgz();`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Example: Load

```php
// load() returns the bare DragontailVersiontgz record (throws on error).
$dragontail_versiontgz = $client->DragontailVersiontgz()->load(["version" => "version"]);
```


### Item

Create an instance: `$item = $client->Item();`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Example: Load

```php
// load() returns the bare Item record (throws on error).
$item = $client->Item()->load(["id" => "item_id", "version" => "version"]);
```


### Region

Create an instance: `$region = $client->Region();`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `cdn` | `string` |  |
| `n` | `array` |  |
| `v` | `string` |  |

#### Example: Load

```php
// load() returns the bare Region record (throws on error).
$region = $client->Region()->load(["region" => "region"]);
```


### Version

Create an instance: `$version = $client->Version();`

#### Operations

| Method | Description |
| --- | --- |
| `list(match)` | List entities matching the criteria. |

#### Example: List

```php
// list() returns an array of Version records (throws on error).
$versions = $client->Version()->list();
```


## Advanced

> The sections above cover everyday use. The material below explains the
> SDK's internals — useful when extending it with custom features, but not
> needed for normal use.

### The operation pipeline

Every entity operation follows a six-stage pipeline. Each stage fires a
feature hook before executing:

```
PrePoint → PreSpec → PreRequest → PreResponse → PreResult → PreDone
```

- **PrePoint**: Resolves which API endpoint to call based on the
  operation name and entity configuration.
- **PreSpec**: Builds the HTTP spec — URL, method, headers, body —
  from the resolved point and the caller's parameters.
- **PreRequest**: Sends the HTTP request. Features can intercept here
  to replace the transport (as TestFeature does with mocks).
- **PreResponse**: Parses the raw HTTP response.
- **PreResult**: Extracts the business data from the parsed response.
- **PreDone**: Final stage before returning to the caller. Entity
  state (match, data) is updated here.

If any stage errors, the pipeline short-circuits and the error surfaces
to the caller — see [Error handling](#error-handling) for how that looks
in this language.

### Features and hooks

Features are the extension mechanism. A feature is a PHP class
with hook methods named after pipeline stages (e.g. `PrePoint`,
`PreSpec`). Each method receives the context.

The SDK ships with built-in features:

- **TestFeature**: In-memory mock transport for testing without a live server

Features are initialized in order. Hooks fire in the order features
were added, so later features can override earlier ones.

### Data as arrays

The PHP SDK uses plain PHP associative arrays throughout rather than typed
objects. This mirrors the dynamic nature of the API and keeps the
SDK flexible — no code generation is needed when the API schema
changes.

Use `Helpers::to_map()` to safely validate that a value is an array.

### Directory structure

```
php/
├── datadragon_sdk.php          -- Main SDK class
├── config.php                     -- Configuration
├── features.php                   -- Feature factory
├── core/                          -- Core types and context
├── entity/                        -- Entity implementations
├── feature/                       -- Built-in features (Base, Test, Log)
├── utility/                       -- Utility functions and struct library
└── test/                          -- Test suites
```

The main class (`datadragon_sdk.php`) exports the SDK class
and test helper. Import entity or utility modules directly only
when needed.

### Entity state

Entity instances are stateful. After a successful `load`, the entity
stores the returned data and match criteria internally.

```php
$champion = $client->Champion();
$champion->load(["id" => "example_id"]);

// $champion->data_get() now returns the champion data from the last load
// $champion->match_get() returns the last match criteria
```

Call `make()` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for standard CRUD operations.

`direct()` gives full control over the HTTP request. Use it for
non-standard endpoints, bulk operations, or any path not modelled as
an entity. `prepare()` builds the request without sending it — useful
for debugging or custom transport.


## Full Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
