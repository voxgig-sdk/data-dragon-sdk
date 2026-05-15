# DataDragon TypeScript SDK

The TypeScript SDK for the DataDragon API. Provides a type-safe, entity-oriented interface with full async/await support.


## Install
```bash
npm install data-dragon
```
## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and
loading a specific record.

### 1. Create a client

```ts
import { DataDragonSDK } from 'data-dragon'

const client = new DataDragonSDK({
  apikey: process.env.DATA-DRAGON_APIKEY,
})
```

### 3. Load a champion

```ts
const result = await client.Champion().load({ id: 'example_id' })

if (result.ok) {
  console.log(result.data)
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```ts
const result = await client.direct({
  path: '/api/resource/{id}',
  method: 'GET',
  params: { id: 'example' },
})

if (result.ok) {
  console.log(result.status)  // 200
  console.log(result.data)    // response body
}
```

### Prepare a request without sending it

```ts
const fetchdef = await client.prepare({
  path: '/api/resource/{id}',
  method: 'DELETE',
  params: { id: 'example' },
})

// Inspect before sending
console.log(fetchdef.url)
console.log(fetchdef.method)
console.log(fetchdef.headers)
```

### Use test mode

Create a mock client for unit testing — no server required:

```ts
const client = DataDragonSDK.test()

const result = await client.Planet().load({ id: 'test01' })
// result.ok === true
// result.data contains mock response data
```

You can also use the instance method:

```ts
const client = new DataDragonSDK({ apikey: '...' })
const testClient = client.tester()
```

### Retain entity state across calls

Entity instances remember their last match and data:

```ts
const entity = client.Planet()

// First call sets internal match
await entity.load({ id: 'example' })

// Subsequent calls reuse the stored match
const data = entity.data()
console.log(data.id) // 'example'
```

### Add custom middleware

Pass features via the `extend` option:

```ts
const logger = {
  hooks: {
    PreRequest: (ctx: any) => {
      console.log('Requesting:', ctx.spec.method, ctx.spec.path)
    },
    PreResponse: (ctx: any) => {
      console.log('Status:', ctx.out.request?.status)
    },
  },
}

const client = new DataDragonSDK({
  apikey: '...',
  extend: [logger],
})
```

### Run live tests

Create a `.env.local` file at the project root:

```
DATA-DRAGON_TEST_LIVE=TRUE
DATA-DRAGON_APIKEY=<your-key>
```

Then run:

```bash
cd ts && npm test
```


## Reference

### DataDragonSDK

#### Constructor

```ts
new DataDragonSDK(options?: {
  apikey?: string
  base?: string
  prefix?: string
  suffix?: string
  feature?: Record<string, { active: boolean }>
  extend?: Feature[]
})
```

| Option | Type | Description |
| --- | --- | --- |
| `apikey` | `string` | API key for authentication. |
| `base` | `string` | Base URL of the API server. |
| `prefix` | `string` | URL path prefix prepended to all requests. |
| `suffix` | `string` | URL path suffix appended to all requests. |
| `feature` | `object` | Feature activation flags (e.g. `{ test: { active: true } }`). |
| `extend` | `Feature[]` | Additional feature instances to load. |

#### Methods

| Method | Returns | Description |
| --- | --- | --- |
| `options()` | `object` | Deep copy of current SDK options. |
| `utility()` | `Utility` | Deep copy of the SDK utility object. |
| `prepare(fetchargs?)` | `Promise<FetchDef>` | Build an HTTP request definition without sending it. |
| `direct(fetchargs?)` | `Promise<DirectResult>` | Build and send an HTTP request. |
| `Champion(data?)` | `ChampionEntity` | Create a Champion entity instance. |
| `DataChampion(data?)` | `DataChampionEntity` | Create a DataChampion entity instance. |
| `DataItem(data?)` | `DataItemEntity` | Create a DataItem entity instance. |
| `DataRune(data?)` | `DataRuneEntity` | Create a DataRune entity instance. |
| `DragontailVersiontgz(data?)` | `DragontailVersiontgzEntity` | Create a DragontailVersiontgz entity instance. |
| `Item(data?)` | `ItemEntity` | Create a Item entity instance. |
| `Region(data?)` | `RegionEntity` | Create a Region entity instance. |
| `Version(data?)` | `VersionEntity` | Create a Version entity instance. |
| `tester(testopts?, sdkopts?)` | `DataDragonSDK` | Create a test-mode client instance. |

#### Static methods

| Method | Returns | Description |
| --- | --- | --- |
| `DataDragonSDK.test(testopts?, sdkopts?)` | `DataDragonSDK` | Create a test-mode client. |

### Entity interface

All entities share the same interface.

#### Methods

| Method | Signature | Description |
| --- | --- | --- |
| `load` | `load(reqmatch?, ctrl?): Promise<Result>` | Load a single entity by match criteria. |
| `list` | `list(reqmatch?, ctrl?): Promise<Result>` | List entities matching the criteria. |
| `create` | `create(reqdata?, ctrl?): Promise<Result>` | Create a new entity. |
| `update` | `update(reqdata?, ctrl?): Promise<Result>` | Update an existing entity. |
| `remove` | `remove(reqmatch?, ctrl?): Promise<Result>` | Remove an entity. |
| `data` | `data(data?): any` | Get or set entity data. |
| `match` | `match(match?): any` | Get or set entity match criteria. |
| `make` | `make(): Entity` | Create a new instance with the same options. |
| `client` | `client(): DataDragonSDK` | Return the parent SDK client. |
| `entopts` | `entopts(): object` | Return a copy of the entity options. |

#### Result shape

All entity operations return a Result object:

```ts
{
  ok: boolean      // true if the HTTP status is 2xx
  status: number   // HTTP status code
  headers: object  // response headers
  data: any        // parsed JSON response body
}
```

### DirectResult shape

The `direct()` method returns:

```ts
{
  ok: boolean
  status: number
  headers: object
  data: any
}
```

On error, `ok` is `false` and an `err` property contains the error.

### FetchDef shape

The `prepare()` method returns:

```ts
{
  url: string
  method: string
  headers: Record<string, string>
  body?: any
}
```

### Entities

#### Champion

| Field | Description |
| --- | --- |

Operations: load.

API path: `/cdn/{version}/img/champion/{championImage}`

#### DataChampion

| Field | Description |
| --- | --- |
| `data` |  |
| `format` |  |
| `type` |  |
| `version` |  |

Operations: load.

API path: `/cdn/{version}/data/{language}/champion.json`

#### DataItem

| Field | Description |
| --- | --- |
| `data` |  |
| `type` |  |
| `version` |  |

Operations: load.

API path: `/cdn/{version}/data/{language}/item.json`

#### DataRune

| Field | Description |
| --- | --- |

Operations: load.

API path: `/cdn/{version}/data/{language}/rune.json`

#### DragontailVersiontgz

| Field | Description |
| --- | --- |

Operations: load.

API path: `/cdn/dragontail-{version}.tgz`

#### Item

| Field | Description |
| --- | --- |

Operations: load.

API path: `/cdn/{version}/img/item/{itemImage}`

#### Region

| Field | Description |
| --- | --- |
| `cdn` |  |
| `n` |  |
| `v` |  |

Operations: load.

API path: `/realms/{region}.json`

#### Version

| Field | Description |
| --- | --- |

Operations: list.

API path: `/api/versions.json`



## Entities


### Champion

Create an instance: `const champion = client.Champion()`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Example: Load

```ts
const champion = await client.Champion().load({ id: 'champion_id' })
```


### DataChampion

Create an instance: `const data_champion = client.DataChampion()`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `data` | ``$OBJECT`` |  |
| `format` | ``$STRING`` |  |
| `type` | ``$STRING`` |  |
| `version` | ``$STRING`` |  |

#### Example: Load

```ts
const data_champion = await client.DataChampion().load({ id: 'data_champion_id' })
```


### DataItem

Create an instance: `const data_item = client.DataItem()`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `data` | ``$OBJECT`` |  |
| `type` | ``$STRING`` |  |
| `version` | ``$STRING`` |  |

#### Example: Load

```ts
const data_item = await client.DataItem().load({ id: 'data_item_id' })
```


### DataRune

Create an instance: `const data_rune = client.DataRune()`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Example: Load

```ts
const data_rune = await client.DataRune().load({ id: 'data_rune_id' })
```


### DragontailVersiontgz

Create an instance: `const dragontail_versiontgz = client.DragontailVersiontgz()`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Example: Load

```ts
const dragontail_versiontgz = await client.DragontailVersiontgz().load({ id: 'dragontail_versiontgz_id' })
```


### Item

Create an instance: `const item = client.Item()`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Example: Load

```ts
const item = await client.Item().load({ id: 'item_id' })
```


### Region

Create an instance: `const region = client.Region()`

#### Operations

| Method | Description |
| --- | --- |
| `load(match)` | Load a single entity by match criteria. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `cdn` | ``$STRING`` |  |
| `n` | ``$OBJECT`` |  |
| `v` | ``$STRING`` |  |

#### Example: Load

```ts
const region = await client.Region().load({ id: 'region_id' })
```


### Version

Create an instance: `const version = client.Version()`

#### Operations

| Method | Description |
| --- | --- |
| `list(match)` | List entities matching the criteria. |

#### Example: List

```ts
const versions = await client.Version().list()
```


## Explanation

### The operation pipeline

Every entity operation (load, list, create, update, remove) follows a
six-stage pipeline. Each stage fires a feature hook before executing:

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

If any stage returns an error, the pipeline short-circuits and the
error is returned to the caller.

An unexpected exception triggers the `PreUnexpected` hook before
propagating.

### Features and hooks

Features are the extension mechanism. A feature is an object with a
`hooks` map. Each hook key is a pipeline stage name, and the value is
a function that receives the context.

The SDK ships with built-in features:

- **TestFeature**: In-memory mock transport for testing without a live server

Features are initialized in order. Hooks fire in the order features
were added, so later features can override earlier ones.

### Module structure

```
data-dragon/
├── src/
│   ├── DataDragonSDK.ts        # Main SDK class
│   ├── entity/             # Entity implementations
│   ├── feature/            # Built-in features (Base, Test, Log)
│   └── utility/            # Utility functions
├── test/                   # Test suites
└── dist/                   # Compiled output
```

Import the SDK from the package root:

```ts
import { DataDragonSDK } from 'data-dragon'
```

### Entity state

Entity instances are stateful. After a successful `load`, the entity
stores the returned data and match criteria internally. Subsequent
calls on the same instance can rely on this state.

```ts
const moon = client.Moon()
await moon.load({ planet_id: 'earth', id: 'luna' })

// moon.data() now returns the loaded moon data
// moon.match() returns { planet_id: 'earth', id: 'luna' }
```

Call `make()` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for standard CRUD operations.

The `direct` method gives full control over the HTTP request. Use it
for non-standard endpoints, bulk operations, or any path not modelled
as an entity. The `prepare` method is useful for debugging — it
shows exactly what `direct` would send.


## Full Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
