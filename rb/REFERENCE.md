# DataDragon Ruby SDK Reference

Complete API reference for the DataDragon Ruby SDK.


## DataDragonSDK

### Constructor

```ruby
require_relative 'data-dragon_sdk'

client = DataDragonSDK.new(options)
```

Create a new SDK client instance.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `options` | `Hash` | SDK configuration options. |
| `options["apikey"]` | `String` | API key for authentication. |
| `options["base"]` | `String` | Base URL for API requests. |
| `options["prefix"]` | `String` | URL prefix appended after base. |
| `options["suffix"]` | `String` | URL suffix appended after path. |
| `options["headers"]` | `Hash` | Custom headers for all requests. |
| `options["feature"]` | `Hash` | Feature configuration. |
| `options["system"]` | `Hash` | System overrides (e.g. custom fetch). |


### Static Methods

#### `DataDragonSDK.test(testopts = nil, sdkopts = nil)`

Create a test client with mock features active. Both arguments may be `nil`.

```ruby
client = DataDragonSDK.test
```


### Instance Methods

#### `Champion(data = nil)`

Create a new `Champion` entity instance. Pass `nil` for no initial data.

#### `DataChampion(data = nil)`

Create a new `DataChampion` entity instance. Pass `nil` for no initial data.

#### `DataItem(data = nil)`

Create a new `DataItem` entity instance. Pass `nil` for no initial data.

#### `DataRune(data = nil)`

Create a new `DataRune` entity instance. Pass `nil` for no initial data.

#### `DragontailVersiontgz(data = nil)`

Create a new `DragontailVersiontgz` entity instance. Pass `nil` for no initial data.

#### `Item(data = nil)`

Create a new `Item` entity instance. Pass `nil` for no initial data.

#### `Region(data = nil)`

Create a new `Region` entity instance. Pass `nil` for no initial data.

#### `Version(data = nil)`

Create a new `Version` entity instance. Pass `nil` for no initial data.

#### `options_map -> Hash`

Return a deep copy of the current SDK options.

#### `get_utility -> Utility`

Return a copy of the SDK utility object.

#### `direct(fetchargs = {}) -> Hash, err`

Make a direct HTTP request to any API endpoint.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `fetchargs["path"]` | `String` | URL path with optional `{param}` placeholders. |
| `fetchargs["method"]` | `String` | HTTP method (default: `"GET"`). |
| `fetchargs["params"]` | `Hash` | Path parameter values for `{param}` substitution. |
| `fetchargs["query"]` | `Hash` | Query string parameters. |
| `fetchargs["headers"]` | `Hash` | Request headers (merged with defaults). |
| `fetchargs["body"]` | `any` | Request body (hashes are JSON-serialized). |
| `fetchargs["ctrl"]` | `Hash` | Control options (e.g. `{ "explain" => true }`). |

**Returns:** `Hash, err`

#### `prepare(fetchargs = {}) -> Hash, err`

Prepare a fetch definition without sending the request. Accepts the
same parameters as `direct()`.

**Returns:** `Hash, err`


---

## ChampionEntity

```ruby
champion = client.Champion
```

### Operations

#### `load(reqmatch, ctrl = nil) -> result, err`

Load a single entity matching the given criteria.

```ruby
result, err = client.Champion.load({ "id" => "champion_id" })
```

### Common Methods

#### `data_get -> Hash`

Get the entity data. Returns a copy of the current data.

#### `data_set(data)`

Set the entity data.

#### `match_get -> Hash`

Get the entity match criteria.

#### `match_set(match)`

Set the entity match criteria.

#### `make -> Entity`

Create a new `ChampionEntity` instance with the same client and
options.

#### `get_name -> String`

Return the entity name.


---

## DataChampionEntity

```ruby
data_champion = client.DataChampion
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `data` | ``$OBJECT`` | No |  |
| `format` | ``$STRING`` | No |  |
| `type` | ``$STRING`` | No |  |
| `version` | ``$STRING`` | No |  |

### Operations

#### `load(reqmatch, ctrl = nil) -> result, err`

Load a single entity matching the given criteria.

```ruby
result, err = client.DataChampion.load({ "id" => "data_champion_id" })
```

### Common Methods

#### `data_get -> Hash`

Get the entity data. Returns a copy of the current data.

#### `data_set(data)`

Set the entity data.

#### `match_get -> Hash`

Get the entity match criteria.

#### `match_set(match)`

Set the entity match criteria.

#### `make -> Entity`

Create a new `DataChampionEntity` instance with the same client and
options.

#### `get_name -> String`

Return the entity name.


---

## DataItemEntity

```ruby
data_item = client.DataItem
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `data` | ``$OBJECT`` | No |  |
| `type` | ``$STRING`` | No |  |
| `version` | ``$STRING`` | No |  |

### Operations

#### `load(reqmatch, ctrl = nil) -> result, err`

Load a single entity matching the given criteria.

```ruby
result, err = client.DataItem.load({ "id" => "data_item_id" })
```

### Common Methods

#### `data_get -> Hash`

Get the entity data. Returns a copy of the current data.

#### `data_set(data)`

Set the entity data.

#### `match_get -> Hash`

Get the entity match criteria.

#### `match_set(match)`

Set the entity match criteria.

#### `make -> Entity`

Create a new `DataItemEntity` instance with the same client and
options.

#### `get_name -> String`

Return the entity name.


---

## DataRuneEntity

```ruby
data_rune = client.DataRune
```

### Operations

#### `load(reqmatch, ctrl = nil) -> result, err`

Load a single entity matching the given criteria.

```ruby
result, err = client.DataRune.load({ "id" => "data_rune_id" })
```

### Common Methods

#### `data_get -> Hash`

Get the entity data. Returns a copy of the current data.

#### `data_set(data)`

Set the entity data.

#### `match_get -> Hash`

Get the entity match criteria.

#### `match_set(match)`

Set the entity match criteria.

#### `make -> Entity`

Create a new `DataRuneEntity` instance with the same client and
options.

#### `get_name -> String`

Return the entity name.


---

## DragontailVersiontgzEntity

```ruby
dragontail_versiontgz = client.DragontailVersiontgz
```

### Operations

#### `load(reqmatch, ctrl = nil) -> result, err`

Load a single entity matching the given criteria.

```ruby
result, err = client.DragontailVersiontgz.load({ "id" => "dragontail_versiontgz_id" })
```

### Common Methods

#### `data_get -> Hash`

Get the entity data. Returns a copy of the current data.

#### `data_set(data)`

Set the entity data.

#### `match_get -> Hash`

Get the entity match criteria.

#### `match_set(match)`

Set the entity match criteria.

#### `make -> Entity`

Create a new `DragontailVersiontgzEntity` instance with the same client and
options.

#### `get_name -> String`

Return the entity name.


---

## ItemEntity

```ruby
item = client.Item
```

### Operations

#### `load(reqmatch, ctrl = nil) -> result, err`

Load a single entity matching the given criteria.

```ruby
result, err = client.Item.load({ "id" => "item_id" })
```

### Common Methods

#### `data_get -> Hash`

Get the entity data. Returns a copy of the current data.

#### `data_set(data)`

Set the entity data.

#### `match_get -> Hash`

Get the entity match criteria.

#### `match_set(match)`

Set the entity match criteria.

#### `make -> Entity`

Create a new `ItemEntity` instance with the same client and
options.

#### `get_name -> String`

Return the entity name.


---

## RegionEntity

```ruby
region = client.Region
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `cdn` | ``$STRING`` | No |  |
| `n` | ``$OBJECT`` | No |  |
| `v` | ``$STRING`` | No |  |

### Operations

#### `load(reqmatch, ctrl = nil) -> result, err`

Load a single entity matching the given criteria.

```ruby
result, err = client.Region.load({ "id" => "region_id" })
```

### Common Methods

#### `data_get -> Hash`

Get the entity data. Returns a copy of the current data.

#### `data_set(data)`

Set the entity data.

#### `match_get -> Hash`

Get the entity match criteria.

#### `match_set(match)`

Set the entity match criteria.

#### `make -> Entity`

Create a new `RegionEntity` instance with the same client and
options.

#### `get_name -> String`

Return the entity name.


---

## VersionEntity

```ruby
version = client.Version
```

### Operations

#### `list(reqmatch, ctrl = nil) -> result, err`

List entities matching the given criteria. Returns an array.

```ruby
results, err = client.Version.list(nil)
```

### Common Methods

#### `data_get -> Hash`

Get the entity data. Returns a copy of the current data.

#### `data_set(data)`

Set the entity data.

#### `match_get -> Hash`

Get the entity match criteria.

#### `match_set(match)`

Set the entity match criteria.

#### `make -> Entity`

Create a new `VersionEntity` instance with the same client and
options.

#### `get_name -> String`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```ruby
client = DataDragonSDK.new({
  "feature" => {
    "test" => { "active" => true },
  },
})
```

