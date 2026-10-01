# DataDragon SDK configuration


# The sekreto plugin DEFINITIONS the model selected per feature, imported
# above by name from the modules the catalogue's active `plugin.def`
# entries declare. Handed to each feature (secrets builds its Sekreto
# with them): a provider kind not listed here is unknown to that SDK.
FEATURE_PLUGINS = {
}


_shared_config = None


def shared_config():
    """Return the process-wide config, built once on first use.

    The SDK reads the config on every request and never writes to it, so one
    instance is shared by every client rather than rebuilt per client.

    The returned dict is shared: treat it as read-only. Callers that need to
    mutate should use make_config, which always returns a fresh copy.
    """
    global _shared_config
    if _shared_config is None:
        _shared_config = make_config()
    return _shared_config


def make_config():
    """Build a fresh, fully materialised config dict.

    Every call rebuilds the whole structure, so prefer shared_config unless
    you need a private copy you intend to mutate.
    """
    return {
        "main": {
            "name": "DataDragon",
            "slug": "data-dragon",
            "version": "0.0.1",
            "target": "py",
        },
        "feature": {
            "ratelimit": {
        "options": {
          "active": False,
          "burst": 5,
          "rate": 5,
        },
        "optspec": {
          "now": "`$FUNCTION`",
          "sleep": "`$FUNCTION`",
        },
        "strict": False,
        "transport": "wrap",
      },
            "retry": {
        "options": {
          "active": False,
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
            504,
          ],
        },
        "optspec": {
          "jitter": "`$BOOLEAN`",
          "sleep": "`$FUNCTION`",
        },
        "strict": False,
        "transport": "wrap",
      },
            "test": {
        "options": {
          "active": False,
        },
        "optspec": {
          "entity": "`$MAP`",
          "net": "`$MAP`",
        },
        "strict": False,
        "transport": "base",
      },
            "timeout": {
        "options": {
          "active": False,
          "ms": 30000,
        },
        "optspec": {
          "clearTimer": "`$FUNCTION`",
          "setTimer": "`$FUNCTION`",
        },
        "strict": False,
        "transport": "wrap",
      },
        },
        "options": {
            "base": "https://ddragon.leagueoflegends.com",
            "headers": {
        "content-type": "application/json",
      },
            "entity": {
                "champion": {},
                "data_champion": {},
                "data_item": {},
                "data_rune": {},
                "dragontail_versiontgz": {},
                "item": {},
                "region": {},
                "version": {},
            },
        },
        "entity": {
      "champion": {
        "fields": [
          {
            "name": "id",
            "title": "Id",
            "type": "`$STRING`",
          },
        ],
        "id": {
          "field": "id",
          "name": "id",
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
                    "lit": "cdn",
                  },
                  {
                    "var": "version",
                  },
                  {
                    "lit": "img",
                  },
                  {
                    "lit": "champion",
                  },
                  {
                    "var": "id",
                  },
                ],
                "parts": [
                  "cdn",
                  "{version}",
                  "img",
                  "champion",
                  "{id}",
                ],
                "rename": {
                  "param": {
                    "championImage": "id",
                  },
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "championImage",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "Ahri.png",
                    },
                    {
                      "name": "version",
                      "orig": "version",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "12.6.1",
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "id",
                    "version",
                  ],
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [],
        },
      },
      "data_champion": {
        "fields": [
          {
            "name": "data",
            "title": "Data",
            "type": "`$OBJECT`",
          },
          {
            "name": "format",
            "title": "Format",
            "type": "`$STRING`",
          },
          {
            "name": "type",
            "title": "Type",
            "type": "`$STRING`",
          },
          {
            "name": "version",
            "title": "Version",
            "type": "`$STRING`",
          },
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
                    "lit": "cdn",
                  },
                  {
                    "var": "version",
                  },
                  {
                    "lit": "data",
                  },
                  {
                    "var": "language",
                  },
                  {
                    "lit": "champion.json",
                  },
                ],
                "parts": [
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "champion.json",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "language",
                      "orig": "language",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "en_US",
                    },
                    {
                      "name": "version",
                      "orig": "version",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "12.6.1",
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "language",
                    "version",
                  ],
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [],
        },
      },
      "data_item": {
        "fields": [
          {
            "name": "data",
            "title": "Data",
            "type": "`$OBJECT`",
          },
          {
            "name": "type",
            "title": "Type",
            "type": "`$STRING`",
          },
          {
            "name": "version",
            "title": "Version",
            "type": "`$STRING`",
          },
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
                    "lit": "cdn",
                  },
                  {
                    "var": "version",
                  },
                  {
                    "lit": "data",
                  },
                  {
                    "var": "language",
                  },
                  {
                    "lit": "item.json",
                  },
                ],
                "parts": [
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "item.json",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "language",
                      "orig": "language",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "en_US",
                    },
                    {
                      "name": "version",
                      "orig": "version",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "12.6.1",
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "language",
                    "version",
                  ],
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [],
        },
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
                    "lit": "cdn",
                  },
                  {
                    "var": "version",
                  },
                  {
                    "lit": "data",
                  },
                  {
                    "var": "language",
                  },
                  {
                    "lit": "rune.json",
                  },
                ],
                "parts": [
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "rune.json",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "language",
                      "orig": "language",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "en_US",
                    },
                    {
                      "name": "version",
                      "orig": "version",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "12.6.1",
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "language",
                    "version",
                  ],
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [],
        },
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
                    "lit": "cdn",
                  },
                  {
                    "lit": "dragontail-{version}.tgz",
                  },
                ],
                "parts": [
                  "cdn",
                  "dragontail-{version}.tgz",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "version",
                      "orig": "version",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "12.6.1",
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "version",
                  ],
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [],
        },
      },
      "item": {
        "fields": [
          {
            "name": "id",
            "title": "Id",
            "type": "`$STRING`",
          },
        ],
        "id": {
          "field": "id",
          "name": "id",
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
                    "lit": "cdn",
                  },
                  {
                    "var": "version",
                  },
                  {
                    "lit": "img",
                  },
                  {
                    "lit": "item",
                  },
                  {
                    "var": "id",
                  },
                ],
                "parts": [
                  "cdn",
                  "{version}",
                  "img",
                  "item",
                  "{id}",
                ],
                "rename": {
                  "param": {
                    "itemImage": "id",
                  },
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "itemImage",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "1001.png",
                    },
                    {
                      "name": "version",
                      "orig": "version",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "12.6.1",
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "id",
                    "version",
                  ],
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [],
        },
      },
      "region": {
        "fields": [
          {
            "name": "cdn",
            "title": "Cdn",
            "type": "`$STRING`",
            "short": "CDN base URL",
          },
          {
            "name": "n",
            "title": "N",
            "type": "`$OBJECT`",
          },
          {
            "name": "v",
            "title": "V",
            "type": "`$STRING`",
            "short": "Current patch version",
          },
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
                    "lit": "realms",
                  },
                  {
                    "lit": "{region}.json",
                  },
                ],
                "parts": [
                  "realms",
                  "{region}.json",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "region",
                      "orig": "region",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                      "example": "na",
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "region",
                  ],
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [],
        },
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
                    "lit": "api",
                  },
                  {
                    "lit": "versions.json",
                  },
                ],
                "parts": [
                  "api",
                  "versions.json",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {},
                "select": {},
              },
            ],
          },
        },
        "relations": {
          "ancestors": [],
        },
      },
    },
    }
