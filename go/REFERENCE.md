# DataDragon Golang SDK Reference

Complete API reference for the DataDragon Golang SDK.


## DataDragonSDK

### Constructor

```go
func NewDataDragonSDK(options map[string]any) *DataDragonSDK
```

Create a new SDK client instance.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `options` | `map[string]any` | SDK configuration options. |
| `options["apikey"]` | `string` | API key for authentication. |
| `options["base"]` | `string` | Base URL for API requests. |
| `options["prefix"]` | `string` | URL prefix appended after base. |
| `options["suffix"]` | `string` | URL suffix appended after path. |
| `options["headers"]` | `map[string]any` | Custom headers for all requests. |
| `options["feature"]` | `map[string]any` | Feature configuration. |
| `options["system"]` | `map[string]any` | System overrides (e.g. custom fetch). |


### Static Methods

#### `TestSDK(testopts, sdkopts map[string]any) *DataDragonSDK`

Create a test client with mock features active. Both arguments may be `nil`.

```go
client := sdk.TestSDK(nil, nil)
```


### Instance Methods

#### `Champion(data map[string]any) DataDragonEntity`

Create a new `Champion` entity instance. Pass `nil` for no initial data.

#### `DataChampion(data map[string]any) DataDragonEntity`

Create a new `DataChampion` entity instance. Pass `nil` for no initial data.

#### `DataItem(data map[string]any) DataDragonEntity`

Create a new `DataItem` entity instance. Pass `nil` for no initial data.

#### `DataRune(data map[string]any) DataDragonEntity`

Create a new `DataRune` entity instance. Pass `nil` for no initial data.

#### `DragontailVersiontgz(data map[string]any) DataDragonEntity`

Create a new `DragontailVersiontgz` entity instance. Pass `nil` for no initial data.

#### `Item(data map[string]any) DataDragonEntity`

Create a new `Item` entity instance. Pass `nil` for no initial data.

#### `Region(data map[string]any) DataDragonEntity`

Create a new `Region` entity instance. Pass `nil` for no initial data.

#### `Version(data map[string]any) DataDragonEntity`

Create a new `Version` entity instance. Pass `nil` for no initial data.

#### `OptionsMap() map[string]any`

Return a deep copy of the current SDK options.

#### `GetUtility() *Utility`

Return a copy of the SDK utility object.

#### `Direct(fetchargs map[string]any) (map[string]any, error)`

Make a direct HTTP request to any API endpoint.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `fetchargs["path"]` | `string` | URL path with optional `{param}` placeholders. |
| `fetchargs["method"]` | `string` | HTTP method (default: `"GET"`). |
| `fetchargs["params"]` | `map[string]any` | Path parameter values for `{param}` substitution. |
| `fetchargs["query"]` | `map[string]any` | Query string parameters. |
| `fetchargs["headers"]` | `map[string]any` | Request headers (merged with defaults). |
| `fetchargs["body"]` | `any` | Request body (maps are JSON-serialized). |
| `fetchargs["ctrl"]` | `map[string]any` | Control options (e.g. `map[string]any{"explain": true}`). |

**Returns:** `(map[string]any, error)`

#### `Prepare(fetchargs map[string]any) (map[string]any, error)`

Prepare a fetch definition without sending the request. Accepts the
same parameters as `Direct()`.

**Returns:** `(map[string]any, error)`


---

## ChampionEntity

```go
champion := client.Champion(nil)
```

### Operations

#### `Load(reqmatch, ctrl map[string]any) (any, error)`

Load a single entity matching the given criteria.

```go
result, err := client.Champion(nil).Load(map[string]any{"id": "champion_id"}, nil)
```

### Common Methods

#### `Data(args ...any) any`

Get or set the entity data. When called with data, sets the entity's
internal data and returns the current data. When called without
arguments, returns a copy of the current data.

#### `Match(args ...any) any`

Get or set the entity match criteria. Works the same as `Data()`.

#### `Make() Entity`

Create a new `ChampionEntity` instance with the same client and
options.

#### `GetName() string`

Return the entity name.


---

## DataChampionEntity

```go
data_champion := client.DataChampion(nil)
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `data` | ``$OBJECT`` | No |  |
| `format` | ``$STRING`` | No |  |
| `type` | ``$STRING`` | No |  |
| `version` | ``$STRING`` | No |  |

### Operations

#### `Load(reqmatch, ctrl map[string]any) (any, error)`

Load a single entity matching the given criteria.

```go
result, err := client.DataChampion(nil).Load(map[string]any{"id": "data_champion_id"}, nil)
```

### Common Methods

#### `Data(args ...any) any`

Get or set the entity data. When called with data, sets the entity's
internal data and returns the current data. When called without
arguments, returns a copy of the current data.

#### `Match(args ...any) any`

Get or set the entity match criteria. Works the same as `Data()`.

#### `Make() Entity`

Create a new `DataChampionEntity` instance with the same client and
options.

#### `GetName() string`

Return the entity name.


---

## DataItemEntity

```go
data_item := client.DataItem(nil)
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `data` | ``$OBJECT`` | No |  |
| `type` | ``$STRING`` | No |  |
| `version` | ``$STRING`` | No |  |

### Operations

#### `Load(reqmatch, ctrl map[string]any) (any, error)`

Load a single entity matching the given criteria.

```go
result, err := client.DataItem(nil).Load(map[string]any{"id": "data_item_id"}, nil)
```

### Common Methods

#### `Data(args ...any) any`

Get or set the entity data. When called with data, sets the entity's
internal data and returns the current data. When called without
arguments, returns a copy of the current data.

#### `Match(args ...any) any`

Get or set the entity match criteria. Works the same as `Data()`.

#### `Make() Entity`

Create a new `DataItemEntity` instance with the same client and
options.

#### `GetName() string`

Return the entity name.


---

## DataRuneEntity

```go
data_rune := client.DataRune(nil)
```

### Operations

#### `Load(reqmatch, ctrl map[string]any) (any, error)`

Load a single entity matching the given criteria.

```go
result, err := client.DataRune(nil).Load(map[string]any{"id": "data_rune_id"}, nil)
```

### Common Methods

#### `Data(args ...any) any`

Get or set the entity data. When called with data, sets the entity's
internal data and returns the current data. When called without
arguments, returns a copy of the current data.

#### `Match(args ...any) any`

Get or set the entity match criteria. Works the same as `Data()`.

#### `Make() Entity`

Create a new `DataRuneEntity` instance with the same client and
options.

#### `GetName() string`

Return the entity name.


---

## DragontailVersiontgzEntity

```go
dragontail_versiontgz := client.DragontailVersiontgz(nil)
```

### Operations

#### `Load(reqmatch, ctrl map[string]any) (any, error)`

Load a single entity matching the given criteria.

```go
result, err := client.DragontailVersiontgz(nil).Load(map[string]any{"id": "dragontail_versiontgz_id"}, nil)
```

### Common Methods

#### `Data(args ...any) any`

Get or set the entity data. When called with data, sets the entity's
internal data and returns the current data. When called without
arguments, returns a copy of the current data.

#### `Match(args ...any) any`

Get or set the entity match criteria. Works the same as `Data()`.

#### `Make() Entity`

Create a new `DragontailVersiontgzEntity` instance with the same client and
options.

#### `GetName() string`

Return the entity name.


---

## ItemEntity

```go
item := client.Item(nil)
```

### Operations

#### `Load(reqmatch, ctrl map[string]any) (any, error)`

Load a single entity matching the given criteria.

```go
result, err := client.Item(nil).Load(map[string]any{"id": "item_id"}, nil)
```

### Common Methods

#### `Data(args ...any) any`

Get or set the entity data. When called with data, sets the entity's
internal data and returns the current data. When called without
arguments, returns a copy of the current data.

#### `Match(args ...any) any`

Get or set the entity match criteria. Works the same as `Data()`.

#### `Make() Entity`

Create a new `ItemEntity` instance with the same client and
options.

#### `GetName() string`

Return the entity name.


---

## RegionEntity

```go
region := client.Region(nil)
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `cdn` | ``$STRING`` | No |  |
| `n` | ``$OBJECT`` | No |  |
| `v` | ``$STRING`` | No |  |

### Operations

#### `Load(reqmatch, ctrl map[string]any) (any, error)`

Load a single entity matching the given criteria.

```go
result, err := client.Region(nil).Load(map[string]any{"id": "region_id"}, nil)
```

### Common Methods

#### `Data(args ...any) any`

Get or set the entity data. When called with data, sets the entity's
internal data and returns the current data. When called without
arguments, returns a copy of the current data.

#### `Match(args ...any) any`

Get or set the entity match criteria. Works the same as `Data()`.

#### `Make() Entity`

Create a new `RegionEntity` instance with the same client and
options.

#### `GetName() string`

Return the entity name.


---

## VersionEntity

```go
version := client.Version(nil)
```

### Operations

#### `List(reqmatch, ctrl map[string]any) (any, error)`

List entities matching the given criteria. Returns an array.

```go
results, err := client.Version(nil).List(nil, nil)
```

### Common Methods

#### `Data(args ...any) any`

Get or set the entity data. When called with data, sets the entity's
internal data and returns the current data. When called without
arguments, returns a copy of the current data.

#### `Match(args ...any) any`

Get or set the entity match criteria. Works the same as `Data()`.

#### `Make() Entity`

Create a new `VersionEntity` instance with the same client and
options.

#### `GetName() string`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```go
client := sdk.NewDataDragonSDK(map[string]any{
    "feature": map[string]any{
        "test": map[string]any{"active": true},
    },
})
```

