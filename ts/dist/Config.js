"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FEATURE_PLUGINS = exports.config = void 0;
const RatelimitFeature_1 = require("./feature/ratelimit/RatelimitFeature");
const RetryFeature_1 = require("./feature/retry/RetryFeature");
const TestFeature_1 = require("./feature/test/TestFeature");
const TimeoutFeature_1 = require("./feature/timeout/TimeoutFeature");
const FEATURE_CLASS = {
    ratelimit: RatelimitFeature_1.RatelimitFeature,
    retry: RetryFeature_1.RetryFeature,
    test: TestFeature_1.TestFeature,
    timeout: TimeoutFeature_1.TimeoutFeature,
};
// Per-feature plugin DEFINITIONS (voxgig/plugin `Definition` values), from
// the model's active plugin groups. A feature that takes a `plugins` option
// (secrets over sekreto) reads its own entry; a feature with no plugins has
// none. Named imports above make each definition statically reachable, so
// an SDK carries exactly the plugin modules its model selects — the same
// leanness the old side-effect registry imports bought, without a registry.
const FEATURE_PLUGINS = {};
exports.FEATURE_PLUGINS = FEATURE_PLUGINS;
class Config {
    makeFeature(fn) {
        const fc = FEATURE_CLASS[fn];
        const fi = new fc();
        // TODO: errors etc
        return fi;
    }
    // False for a feature added at runtime via options.extend (station's
    // adopt path) - the constructor uses this to skip makeFeature for names
    // no generated class backs.
    hasFeature(fn) {
        return null != FEATURE_CLASS[fn];
    }
    main = {
        name: 'DataDragon',
        slug: "data-dragon",
        version: "0.0.1",
        target: "ts",
    };
    feature = {
        ratelimit: {
            "options": {
                "active": false,
                "burst": 5,
                "rate": 5
            },
            "optspec": {
                "now": "`$FUNCTION`",
                "sleep": "`$FUNCTION`"
            },
            "strict": false,
            "transport": "wrap"
        },
        retry: {
            "options": {
                "active": false,
                "factor": 2,
                "maxDelay": 2000,
                "minDelay": 50,
                "retries": 2,
                "statuses": [
                    408,
                    425,
                    429,
                    500,
                    502,
                    503,
                    504
                ]
            },
            "optspec": {
                "jitter": "`$BOOLEAN`",
                "sleep": "`$FUNCTION`"
            },
            "strict": false,
            "transport": "wrap"
        },
        test: {
            "options": {
                "active": false
            },
            "optspec": {
                "entity": "`$MAP`",
                "net": "`$MAP`"
            },
            "strict": false,
            "transport": "base"
        },
        timeout: {
            "options": {
                "active": false,
                "ms": 30000
            },
            "optspec": {
                "clearTimer": "`$FUNCTION`",
                "setTimer": "`$FUNCTION`"
            },
            "strict": false,
            "transport": "wrap"
        },
    };
    options = {
        base: "https://ddragon.leagueoflegends.com",
        headers: {
            "content-type": "application/json"
        },
        entity: {
            champion: {},
            data_champion: {},
            data_item: {},
            data_rune: {},
            dragontail_versiontgz: {},
            item: {},
            region: {},
            version: {},
        }
    };
    entity = {
        "champion": {
            "fields": [
                {
                    "name": "id",
                    "type": "`$STRING`"
                }
            ],
            "id": {
                "field": "id",
                "name": "id"
            },
            "name": "champion",
            "op": {
                "load": {
                    "input": "data",
                    "name": "load",
                    "points": [
                        {
                            "args": {
                                "params": [
                                    {
                                        "example": "Ahri.png",
                                        "kind": "param",
                                        "name": "id",
                                        "orig": "champion_image",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    },
                                    {
                                        "example": "12.6.1",
                                        "kind": "param",
                                        "name": "version",
                                        "orig": "version",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    }
                                ]
                            },
                            "kind": "http",
                            "method": "GET",
                            "orig": "/cdn/{version}/img/champion/{championImage}",
                            "rename": {
                                "param": {
                                    "championImage": "id"
                                }
                            },
                            "segments": [
                                {
                                    "lit": "cdn"
                                },
                                {
                                    "var": "version"
                                },
                                {
                                    "lit": "img"
                                },
                                {
                                    "lit": "champion"
                                },
                                {
                                    "var": "id"
                                }
                            ],
                            "select": {
                                "exist": [
                                    "id",
                                    "version"
                                ]
                            },
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "parts": [
                                "cdn",
                                "{version}",
                                "img",
                                "champion",
                                "{id}"
                            ]
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": [
                    [
                        "cdn"
                    ]
                ]
            }
        },
        "data_champion": {
            "fields": [
                {
                    "name": "image",
                    "type": "`$OBJECT`"
                },
                {
                    "name": "key",
                    "short": "Champion ID",
                    "type": "`$STRING`"
                },
                {
                    "name": "name",
                    "short": "Champion name",
                    "type": "`$STRING`"
                },
                {
                    "name": "title",
                    "short": "Champion title",
                    "type": "`$STRING`"
                }
            ],
            "name": "data_champion",
            "op": {
                "load": {
                    "input": "data",
                    "name": "load",
                    "points": [
                        {
                            "args": {
                                "params": [
                                    {
                                        "example": "en_US",
                                        "kind": "param",
                                        "name": "language",
                                        "orig": "language",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    },
                                    {
                                        "example": "12.6.1",
                                        "kind": "param",
                                        "name": "version",
                                        "orig": "version",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    }
                                ]
                            },
                            "kind": "http",
                            "method": "GET",
                            "orig": "/cdn/{version}/data/{language}/champion.json",
                            "segments": [
                                {
                                    "lit": "cdn"
                                },
                                {
                                    "var": "version"
                                },
                                {
                                    "lit": "data"
                                },
                                {
                                    "var": "language"
                                },
                                {
                                    "lit": "champion.json"
                                }
                            ],
                            "select": {
                                "exist": [
                                    "language",
                                    "version"
                                ]
                            },
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body.data`"
                            },
                            "parts": [
                                "cdn",
                                "{version}",
                                "data",
                                "{language}",
                                "champion.json"
                            ]
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": [
                    [
                        "cdn",
                        "data"
                    ]
                ]
            }
        },
        "data_item": {
            "fields": [
                {
                    "name": "description",
                    "type": "`$STRING`"
                },
                {
                    "name": "image",
                    "type": "`$OBJECT`"
                },
                {
                    "name": "name",
                    "type": "`$STRING`"
                }
            ],
            "name": "data_item",
            "op": {
                "load": {
                    "input": "data",
                    "name": "load",
                    "points": [
                        {
                            "args": {
                                "params": [
                                    {
                                        "example": "en_US",
                                        "kind": "param",
                                        "name": "language",
                                        "orig": "language",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    },
                                    {
                                        "example": "12.6.1",
                                        "kind": "param",
                                        "name": "version",
                                        "orig": "version",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    }
                                ]
                            },
                            "kind": "http",
                            "method": "GET",
                            "orig": "/cdn/{version}/data/{language}/item.json",
                            "segments": [
                                {
                                    "lit": "cdn"
                                },
                                {
                                    "var": "version"
                                },
                                {
                                    "lit": "data"
                                },
                                {
                                    "var": "language"
                                },
                                {
                                    "lit": "item.json"
                                }
                            ],
                            "select": {
                                "exist": [
                                    "language",
                                    "version"
                                ]
                            },
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body.data`"
                            },
                            "parts": [
                                "cdn",
                                "{version}",
                                "data",
                                "{language}",
                                "item.json"
                            ]
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": [
                    [
                        "cdn",
                        "data"
                    ]
                ]
            }
        },
        "data_rune": {
            "fields": [],
            "name": "data_rune",
            "op": {
                "load": {
                    "input": "data",
                    "name": "load",
                    "points": [
                        {
                            "args": {
                                "params": [
                                    {
                                        "example": "en_US",
                                        "kind": "param",
                                        "name": "language",
                                        "orig": "language",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    },
                                    {
                                        "example": "12.6.1",
                                        "kind": "param",
                                        "name": "version",
                                        "orig": "version",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    }
                                ]
                            },
                            "kind": "http",
                            "method": "GET",
                            "orig": "/cdn/{version}/data/{language}/rune.json",
                            "segments": [
                                {
                                    "lit": "cdn"
                                },
                                {
                                    "var": "version"
                                },
                                {
                                    "lit": "data"
                                },
                                {
                                    "var": "language"
                                },
                                {
                                    "lit": "rune.json"
                                }
                            ],
                            "select": {
                                "exist": [
                                    "language",
                                    "version"
                                ]
                            },
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "parts": [
                                "cdn",
                                "{version}",
                                "data",
                                "{language}",
                                "rune.json"
                            ]
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": [
                    [
                        "cdn",
                        "data"
                    ]
                ]
            }
        },
        "dragontail_versiontgz": {
            "fields": [],
            "name": "dragontail_versiontgz",
            "op": {
                "load": {
                    "input": "data",
                    "name": "load",
                    "points": [
                        {
                            "args": {
                                "params": [
                                    {
                                        "example": "12.6.1",
                                        "kind": "param",
                                        "name": "version",
                                        "orig": "version",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    }
                                ]
                            },
                            "kind": "http",
                            "method": "GET",
                            "orig": "/cdn/dragontail-{version}.tgz",
                            "segments": [
                                {
                                    "lit": "cdn"
                                },
                                {
                                    "lit": "dragontail-{version}.tgz"
                                }
                            ],
                            "select": {
                                "exist": [
                                    "version"
                                ]
                            },
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "parts": [
                                "cdn",
                                "dragontail-{version}.tgz"
                            ]
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": []
            }
        },
        "item": {
            "fields": [
                {
                    "name": "id",
                    "type": "`$STRING`"
                }
            ],
            "id": {
                "field": "id",
                "name": "id"
            },
            "name": "item",
            "op": {
                "load": {
                    "input": "data",
                    "name": "load",
                    "points": [
                        {
                            "args": {
                                "params": [
                                    {
                                        "example": "1001.png",
                                        "kind": "param",
                                        "name": "id",
                                        "orig": "item_image",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    },
                                    {
                                        "example": "12.6.1",
                                        "kind": "param",
                                        "name": "version",
                                        "orig": "version",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    }
                                ]
                            },
                            "kind": "http",
                            "method": "GET",
                            "orig": "/cdn/{version}/img/item/{itemImage}",
                            "rename": {
                                "param": {
                                    "itemImage": "id"
                                }
                            },
                            "segments": [
                                {
                                    "lit": "cdn"
                                },
                                {
                                    "var": "version"
                                },
                                {
                                    "lit": "img"
                                },
                                {
                                    "lit": "item"
                                },
                                {
                                    "var": "id"
                                }
                            ],
                            "select": {
                                "exist": [
                                    "id",
                                    "version"
                                ]
                            },
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "parts": [
                                "cdn",
                                "{version}",
                                "img",
                                "item",
                                "{id}"
                            ]
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": [
                    [
                        "cdn"
                    ]
                ]
            }
        },
        "region": {
            "fields": [
                {
                    "name": "champion",
                    "type": "`$STRING`"
                },
                {
                    "name": "item",
                    "type": "`$STRING`"
                },
                {
                    "name": "rune",
                    "type": "`$STRING`"
                }
            ],
            "name": "region",
            "op": {
                "load": {
                    "input": "data",
                    "name": "load",
                    "points": [
                        {
                            "args": {
                                "params": [
                                    {
                                        "example": "na",
                                        "kind": "param",
                                        "name": "region",
                                        "orig": "region",
                                        "reqd": true,
                                        "type": "`$STRING`"
                                    }
                                ]
                            },
                            "kind": "http",
                            "method": "GET",
                            "orig": "/realms/{region}.json",
                            "segments": [
                                {
                                    "lit": "realms"
                                },
                                {
                                    "lit": "{region}.json"
                                }
                            ],
                            "select": {
                                "exist": [
                                    "region"
                                ]
                            },
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body.n`"
                            },
                            "parts": [
                                "realms",
                                "{region}.json"
                            ]
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": []
            }
        },
        "version": {
            "fields": [],
            "name": "version",
            "op": {
                "list": {
                    "input": "data",
                    "name": "list",
                    "points": [
                        {
                            "args": {},
                            "kind": "http",
                            "method": "GET",
                            "orig": "/api/versions.json",
                            "segments": [
                                {
                                    "lit": "api"
                                },
                                {
                                    "lit": "versions.json"
                                }
                            ],
                            "select": {},
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "parts": [
                                "api",
                                "versions.json"
                            ]
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": []
            }
        }
    };
}
const config = new Config();
exports.config = config;
//# sourceMappingURL=Config.js.map