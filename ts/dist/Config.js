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
const FEATURE_PLUGINS = {};
exports.FEATURE_PLUGINS = FEATURE_PLUGINS;
class Config {
    makeFeature(fn) {
        const fc = FEATURE_CLASS[fn];
        const fi = new fc();
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
                "now": "`$FUNCTION`",
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
                    "title": "Id",
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
                            "kind": "http",
                            "method": "GET",
                            "orig": "/cdn/{version}/img/champion/{championImage}",
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
                            "parts": [
                                "cdn",
                                "{version}",
                                "img",
                                "champion",
                                "{id}"
                            ],
                            "rename": {
                                "param": {
                                    "championImage": "id"
                                }
                            },
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "args": {
                                "params": [
                                    {
                                        "name": "id",
                                        "orig": "championImage",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "Ahri.png"
                                    },
                                    {
                                        "name": "version",
                                        "orig": "version",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "12.6.1"
                                    }
                                ]
                            },
                            "select": {
                                "exist": [
                                    "id",
                                    "version"
                                ]
                            },
                            "response": {
                                "binary": true,
                                "kind": "raw",
                                "media": "image/png"
                            }
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": []
            }
        },
        "data_champion": {
            "fields": [
                {
                    "name": "data",
                    "title": "Data",
                    "type": "`$OBJECT`"
                },
                {
                    "name": "format",
                    "title": "Format",
                    "type": "`$STRING`"
                },
                {
                    "name": "type",
                    "title": "Type",
                    "type": "`$STRING`"
                },
                {
                    "name": "version",
                    "title": "Version",
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
                            "parts": [
                                "cdn",
                                "{version}",
                                "data",
                                "{language}",
                                "champion.json"
                            ],
                            "rename": {},
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "args": {
                                "params": [
                                    {
                                        "name": "language",
                                        "orig": "language",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "en_US"
                                    },
                                    {
                                        "name": "version",
                                        "orig": "version",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "12.6.1"
                                    }
                                ]
                            },
                            "select": {
                                "exist": [
                                    "language",
                                    "version"
                                ]
                            },
                            "response": {
                                "kind": "json",
                                "media": "application/json"
                            }
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": []
            }
        },
        "data_item": {
            "fields": [
                {
                    "name": "data",
                    "title": "Data",
                    "type": "`$OBJECT`"
                },
                {
                    "name": "type",
                    "title": "Type",
                    "type": "`$STRING`"
                },
                {
                    "name": "version",
                    "title": "Version",
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
                            "parts": [
                                "cdn",
                                "{version}",
                                "data",
                                "{language}",
                                "item.json"
                            ],
                            "rename": {},
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "args": {
                                "params": [
                                    {
                                        "name": "language",
                                        "orig": "language",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "en_US"
                                    },
                                    {
                                        "name": "version",
                                        "orig": "version",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "12.6.1"
                                    }
                                ]
                            },
                            "select": {
                                "exist": [
                                    "language",
                                    "version"
                                ]
                            },
                            "response": {
                                "kind": "json",
                                "media": "application/json"
                            }
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": []
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
                            "parts": [
                                "cdn",
                                "{version}",
                                "data",
                                "{language}",
                                "rune.json"
                            ],
                            "rename": {},
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "args": {
                                "params": [
                                    {
                                        "name": "language",
                                        "orig": "language",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "en_US"
                                    },
                                    {
                                        "name": "version",
                                        "orig": "version",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "12.6.1"
                                    }
                                ]
                            },
                            "select": {
                                "exist": [
                                    "language",
                                    "version"
                                ]
                            },
                            "response": {
                                "kind": "json",
                                "media": "application/json"
                            }
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": []
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
                            "parts": [
                                "cdn",
                                "dragontail-{version}.tgz"
                            ],
                            "rename": {},
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "args": {
                                "params": [
                                    {
                                        "name": "version",
                                        "orig": "version",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "12.6.1"
                                    }
                                ]
                            },
                            "select": {
                                "exist": [
                                    "version"
                                ]
                            },
                            "response": {
                                "binary": true,
                                "kind": "raw",
                                "media": "application/gzip"
                            }
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
                    "title": "Id",
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
                            "kind": "http",
                            "method": "GET",
                            "orig": "/cdn/{version}/img/item/{itemImage}",
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
                            "parts": [
                                "cdn",
                                "{version}",
                                "img",
                                "item",
                                "{id}"
                            ],
                            "rename": {
                                "param": {
                                    "itemImage": "id"
                                }
                            },
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "args": {
                                "params": [
                                    {
                                        "name": "id",
                                        "orig": "itemImage",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "1001.png"
                                    },
                                    {
                                        "name": "version",
                                        "orig": "version",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "12.6.1"
                                    }
                                ]
                            },
                            "select": {
                                "exist": [
                                    "id",
                                    "version"
                                ]
                            },
                            "response": {
                                "binary": true,
                                "kind": "raw",
                                "media": "image/png"
                            }
                        }
                    ]
                }
            },
            "relations": {
                "ancestors": []
            }
        },
        "region": {
            "fields": [
                {
                    "name": "cdn",
                    "title": "Cdn",
                    "type": "`$STRING`",
                    "short": "CDN base URL"
                },
                {
                    "name": "n",
                    "title": "N",
                    "type": "`$OBJECT`"
                },
                {
                    "name": "v",
                    "title": "V",
                    "type": "`$STRING`",
                    "short": "Current patch version"
                }
            ],
            "name": "region",
            "op": {
                "load": {
                    "input": "data",
                    "name": "load",
                    "points": [
                        {
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
                            "parts": [
                                "realms",
                                "{region}.json"
                            ],
                            "rename": {},
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "args": {
                                "params": [
                                    {
                                        "name": "region",
                                        "orig": "region",
                                        "type": "`$STRING`",
                                        "kind": "param",
                                        "reqd": true,
                                        "example": "na"
                                    }
                                ]
                            },
                            "select": {
                                "exist": [
                                    "region"
                                ]
                            },
                            "response": {
                                "kind": "json",
                                "media": "application/json"
                            }
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
                            "parts": [
                                "api",
                                "versions.json"
                            ],
                            "rename": {},
                            "transform": {
                                "req": "`reqdata`",
                                "res": "`body`"
                            },
                            "args": {},
                            "select": {},
                            "response": {
                                "kind": "json",
                                "media": "application/json"
                            }
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