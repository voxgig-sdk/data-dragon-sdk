# DataDragon SDK configuration


def make_config():
    return {
        "main": {
            "name": "DataDragon",
        },
        "feature": {
            "test": {
        "options": {
          "active": False,
        },
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
        "fields": [],
        "name": "champion",
        "op": {
          "load": {
            "input": "data",
            "name": "load",
            "points": [
              {
                "active": True,
                "args": {
                  "params": [
                    {
                      "active": True,
                      "example": "Ahri.png",
                      "kind": "param",
                      "name": "id",
                      "orig": "champion_image",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 0,
                    },
                    {
                      "active": True,
                      "example": "12.6.1",
                      "kind": "param",
                      "name": "version",
                      "orig": "version",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 1,
                    },
                  ],
                },
                "method": "GET",
                "orig": "/cdn/{version}/img/champion/{championImage}",
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
                "select": {
                  "exist": [
                    "id",
                    "version",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "index$": 0,
              },
            ],
            "key$": "load",
          },
        },
        "relations": {
          "ancestors": [
            [
              "cdn",
            ],
          ],
        },
      },
      "data_champion": {
        "fields": [
          {
            "active": True,
            "name": "data",
            "req": False,
            "type": "`$OBJECT`",
            "index$": 0,
          },
          {
            "active": True,
            "name": "format",
            "req": False,
            "type": "`$STRING`",
            "index$": 1,
          },
          {
            "active": True,
            "name": "type",
            "req": False,
            "type": "`$STRING`",
            "index$": 2,
          },
          {
            "active": True,
            "name": "version",
            "req": False,
            "type": "`$STRING`",
            "index$": 3,
          },
        ],
        "name": "data_champion",
        "op": {
          "load": {
            "input": "data",
            "name": "load",
            "points": [
              {
                "active": True,
                "args": {
                  "params": [
                    {
                      "active": True,
                      "example": "en_US",
                      "kind": "param",
                      "name": "language",
                      "orig": "language",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 0,
                    },
                    {
                      "active": True,
                      "example": "12.6.1",
                      "kind": "param",
                      "name": "version",
                      "orig": "version",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 1,
                    },
                  ],
                },
                "method": "GET",
                "orig": "/cdn/{version}/data/{language}/champion.json",
                "parts": [
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "champion.json",
                ],
                "select": {
                  "exist": [
                    "language",
                    "version",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "index$": 0,
              },
            ],
            "key$": "load",
          },
        },
        "relations": {
          "ancestors": [
            [
              "cdn",
              "data",
            ],
          ],
        },
      },
      "data_item": {
        "fields": [
          {
            "active": True,
            "name": "data",
            "req": False,
            "type": "`$OBJECT`",
            "index$": 0,
          },
          {
            "active": True,
            "name": "type",
            "req": False,
            "type": "`$STRING`",
            "index$": 1,
          },
          {
            "active": True,
            "name": "version",
            "req": False,
            "type": "`$STRING`",
            "index$": 2,
          },
        ],
        "name": "data_item",
        "op": {
          "load": {
            "input": "data",
            "name": "load",
            "points": [
              {
                "active": True,
                "args": {
                  "params": [
                    {
                      "active": True,
                      "example": "en_US",
                      "kind": "param",
                      "name": "language",
                      "orig": "language",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 0,
                    },
                    {
                      "active": True,
                      "example": "12.6.1",
                      "kind": "param",
                      "name": "version",
                      "orig": "version",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 1,
                    },
                  ],
                },
                "method": "GET",
                "orig": "/cdn/{version}/data/{language}/item.json",
                "parts": [
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "item.json",
                ],
                "select": {
                  "exist": [
                    "language",
                    "version",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "index$": 0,
              },
            ],
            "key$": "load",
          },
        },
        "relations": {
          "ancestors": [
            [
              "cdn",
              "data",
            ],
          ],
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
                "active": True,
                "args": {
                  "params": [
                    {
                      "active": True,
                      "example": "en_US",
                      "kind": "param",
                      "name": "language",
                      "orig": "language",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 0,
                    },
                    {
                      "active": True,
                      "example": "12.6.1",
                      "kind": "param",
                      "name": "version",
                      "orig": "version",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 1,
                    },
                  ],
                },
                "method": "GET",
                "orig": "/cdn/{version}/data/{language}/rune.json",
                "parts": [
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "rune.json",
                ],
                "select": {
                  "exist": [
                    "language",
                    "version",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "index$": 0,
              },
            ],
            "key$": "load",
          },
        },
        "relations": {
          "ancestors": [
            [
              "cdn",
              "data",
            ],
          ],
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
                "active": True,
                "args": {
                  "params": [
                    {
                      "active": True,
                      "example": "12.6.1",
                      "kind": "param",
                      "name": "version",
                      "orig": "version",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 0,
                    },
                  ],
                },
                "method": "GET",
                "orig": "/cdn/dragontail-{version}.tgz",
                "parts": [
                  "cdn",
                  "dragontail-{version}.tgz",
                ],
                "select": {
                  "exist": [
                    "version",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "index$": 0,
              },
            ],
            "key$": "load",
          },
        },
        "relations": {
          "ancestors": [],
        },
      },
      "item": {
        "fields": [],
        "name": "item",
        "op": {
          "load": {
            "input": "data",
            "name": "load",
            "points": [
              {
                "active": True,
                "args": {
                  "params": [
                    {
                      "active": True,
                      "example": "1001.png",
                      "kind": "param",
                      "name": "id",
                      "orig": "item_image",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 0,
                    },
                    {
                      "active": True,
                      "example": "12.6.1",
                      "kind": "param",
                      "name": "version",
                      "orig": "version",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 1,
                    },
                  ],
                },
                "method": "GET",
                "orig": "/cdn/{version}/img/item/{itemImage}",
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
                "select": {
                  "exist": [
                    "id",
                    "version",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "index$": 0,
              },
            ],
            "key$": "load",
          },
        },
        "relations": {
          "ancestors": [
            [
              "cdn",
            ],
          ],
        },
      },
      "region": {
        "fields": [
          {
            "active": True,
            "name": "cdn",
            "req": False,
            "type": "`$STRING`",
            "index$": 0,
          },
          {
            "active": True,
            "name": "n",
            "req": False,
            "type": "`$OBJECT`",
            "index$": 1,
          },
          {
            "active": True,
            "name": "v",
            "req": False,
            "type": "`$STRING`",
            "index$": 2,
          },
        ],
        "name": "region",
        "op": {
          "load": {
            "input": "data",
            "name": "load",
            "points": [
              {
                "active": True,
                "args": {
                  "params": [
                    {
                      "active": True,
                      "example": "na",
                      "kind": "param",
                      "name": "region",
                      "orig": "region",
                      "reqd": True,
                      "type": "`$STRING`",
                      "index$": 0,
                    },
                  ],
                },
                "method": "GET",
                "orig": "/realms/{region}.json",
                "parts": [
                  "realms",
                  "{region}.json",
                ],
                "select": {
                  "exist": [
                    "region",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "index$": 0,
              },
            ],
            "key$": "load",
          },
        },
        "relations": {
          "ancestors": [
            [
              "realm",
            ],
          ],
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
                "active": True,
                "args": {},
                "method": "GET",
                "orig": "/api/versions.json",
                "parts": [
                  "api",
                  "versions.json",
                ],
                "select": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "index$": 0,
              },
            ],
            "key$": "list",
          },
        },
        "relations": {
          "ancestors": [],
        },
      },
    },
    }
