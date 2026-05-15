# DataDragon SDK configuration

module DataDragonConfig
  def self.make_config
    {
      "main" => {
        "name" => "DataDragon",
      },
      "feature" => {
        "test" => {
          "options" => {
            "active" => false,
          },
        },
      },
      "options" => {
        "base" => "https://ddragon.leagueoflegends.com",
        "auth" => {
          "prefix" => "Bearer",
        },
        "headers" => {
          "content-type" => "application/json",
        },
        "entity" => {
          "champion" => {},
          "data_champion" => {},
          "data_item" => {},
          "data_rune" => {},
          "dragontail_versiontgz" => {},
          "item" => {},
          "region" => {},
          "version" => {},
        },
      },
      "entity" => {
        "champion" => {
          "fields" => [],
          "name" => "champion",
          "op" => {
            "load" => {
              "name" => "load",
              "points" => [
                {
                  "args" => {
                    "params" => [
                      {
                        "example" => "Ahri.png",
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "champion_image",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                    ],
                  },
                  "method" => "GET",
                  "orig" => "/cdn/{version}/img/champion/{championImage}",
                  "parts" => [
                    "cdn",
                    "{version}",
                    "img",
                    "champion",
                    "{id}",
                  ],
                  "rename" => {
                    "param" => {
                      "championImage" => "id",
                    },
                  },
                  "select" => {
                    "exist" => [
                      "id",
                      "version",
                    ],
                  },
                  "transform" => {
                    "req" => "`reqdata`",
                    "res" => "`body`",
                  },
                  "active" => true,
                  "index$" => 0,
                },
              ],
              "input" => "data",
              "key$" => "load",
            },
          },
          "relations" => {
            "ancestors" => [
              [
                "cdn",
              ],
            ],
          },
        },
        "data_champion" => {
          "fields" => [
            {
              "name" => "data",
              "req" => false,
              "type" => "`$OBJECT`",
              "active" => true,
              "index$" => 0,
            },
            {
              "name" => "format",
              "req" => false,
              "type" => "`$STRING`",
              "active" => true,
              "index$" => 1,
            },
            {
              "name" => "type",
              "req" => false,
              "type" => "`$STRING`",
              "active" => true,
              "index$" => 2,
            },
            {
              "name" => "version",
              "req" => false,
              "type" => "`$STRING`",
              "active" => true,
              "index$" => 3,
            },
          ],
          "name" => "data_champion",
          "op" => {
            "load" => {
              "name" => "load",
              "points" => [
                {
                  "args" => {
                    "params" => [
                      {
                        "example" => "en_US",
                        "kind" => "param",
                        "name" => "language",
                        "orig" => "language",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                    ],
                  },
                  "method" => "GET",
                  "orig" => "/cdn/{version}/data/{language}/champion.json",
                  "parts" => [
                    "cdn",
                    "{version}",
                    "data",
                    "{language}",
                    "champion.json",
                  ],
                  "select" => {
                    "exist" => [
                      "language",
                      "version",
                    ],
                  },
                  "transform" => {
                    "req" => "`reqdata`",
                    "res" => "`body`",
                  },
                  "active" => true,
                  "index$" => 0,
                },
              ],
              "input" => "data",
              "key$" => "load",
            },
          },
          "relations" => {
            "ancestors" => [
              [
                "cdn",
                "data",
              ],
            ],
          },
        },
        "data_item" => {
          "fields" => [
            {
              "name" => "data",
              "req" => false,
              "type" => "`$OBJECT`",
              "active" => true,
              "index$" => 0,
            },
            {
              "name" => "type",
              "req" => false,
              "type" => "`$STRING`",
              "active" => true,
              "index$" => 1,
            },
            {
              "name" => "version",
              "req" => false,
              "type" => "`$STRING`",
              "active" => true,
              "index$" => 2,
            },
          ],
          "name" => "data_item",
          "op" => {
            "load" => {
              "name" => "load",
              "points" => [
                {
                  "args" => {
                    "params" => [
                      {
                        "example" => "en_US",
                        "kind" => "param",
                        "name" => "language",
                        "orig" => "language",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                    ],
                  },
                  "method" => "GET",
                  "orig" => "/cdn/{version}/data/{language}/item.json",
                  "parts" => [
                    "cdn",
                    "{version}",
                    "data",
                    "{language}",
                    "item.json",
                  ],
                  "select" => {
                    "exist" => [
                      "language",
                      "version",
                    ],
                  },
                  "transform" => {
                    "req" => "`reqdata`",
                    "res" => "`body`",
                  },
                  "active" => true,
                  "index$" => 0,
                },
              ],
              "input" => "data",
              "key$" => "load",
            },
          },
          "relations" => {
            "ancestors" => [
              [
                "cdn",
                "data",
              ],
            ],
          },
        },
        "data_rune" => {
          "fields" => [],
          "name" => "data_rune",
          "op" => {
            "load" => {
              "name" => "load",
              "points" => [
                {
                  "args" => {
                    "params" => [
                      {
                        "example" => "en_US",
                        "kind" => "param",
                        "name" => "language",
                        "orig" => "language",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                    ],
                  },
                  "method" => "GET",
                  "orig" => "/cdn/{version}/data/{language}/rune.json",
                  "parts" => [
                    "cdn",
                    "{version}",
                    "data",
                    "{language}",
                    "rune.json",
                  ],
                  "select" => {
                    "exist" => [
                      "language",
                      "version",
                    ],
                  },
                  "transform" => {
                    "req" => "`reqdata`",
                    "res" => "`body`",
                  },
                  "active" => true,
                  "index$" => 0,
                },
              ],
              "input" => "data",
              "key$" => "load",
            },
          },
          "relations" => {
            "ancestors" => [
              [
                "cdn",
                "data",
              ],
            ],
          },
        },
        "dragontail_versiontgz" => {
          "fields" => [],
          "name" => "dragontail_versiontgz",
          "op" => {
            "load" => {
              "name" => "load",
              "points" => [
                {
                  "args" => {
                    "params" => [
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                    ],
                  },
                  "method" => "GET",
                  "orig" => "/cdn/dragontail-{version}.tgz",
                  "parts" => [
                    "cdn",
                    "dragontail-{version}.tgz",
                  ],
                  "select" => {
                    "exist" => [
                      "version",
                    ],
                  },
                  "transform" => {
                    "req" => "`reqdata`",
                    "res" => "`body`",
                  },
                  "active" => true,
                  "index$" => 0,
                },
              ],
              "input" => "data",
              "key$" => "load",
            },
          },
          "relations" => {
            "ancestors" => [],
          },
        },
        "item" => {
          "fields" => [],
          "name" => "item",
          "op" => {
            "load" => {
              "name" => "load",
              "points" => [
                {
                  "args" => {
                    "params" => [
                      {
                        "example" => "1001.png",
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "item_image",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                    ],
                  },
                  "method" => "GET",
                  "orig" => "/cdn/{version}/img/item/{itemImage}",
                  "parts" => [
                    "cdn",
                    "{version}",
                    "img",
                    "item",
                    "{id}",
                  ],
                  "rename" => {
                    "param" => {
                      "itemImage" => "id",
                    },
                  },
                  "select" => {
                    "exist" => [
                      "id",
                      "version",
                    ],
                  },
                  "transform" => {
                    "req" => "`reqdata`",
                    "res" => "`body`",
                  },
                  "active" => true,
                  "index$" => 0,
                },
              ],
              "input" => "data",
              "key$" => "load",
            },
          },
          "relations" => {
            "ancestors" => [
              [
                "cdn",
              ],
            ],
          },
        },
        "region" => {
          "fields" => [
            {
              "name" => "cdn",
              "req" => false,
              "type" => "`$STRING`",
              "active" => true,
              "index$" => 0,
            },
            {
              "name" => "n",
              "req" => false,
              "type" => "`$OBJECT`",
              "active" => true,
              "index$" => 1,
            },
            {
              "name" => "v",
              "req" => false,
              "type" => "`$STRING`",
              "active" => true,
              "index$" => 2,
            },
          ],
          "name" => "region",
          "op" => {
            "load" => {
              "name" => "load",
              "points" => [
                {
                  "args" => {
                    "params" => [
                      {
                        "example" => "na",
                        "kind" => "param",
                        "name" => "region",
                        "orig" => "region",
                        "reqd" => true,
                        "type" => "`$STRING`",
                        "active" => true,
                      },
                    ],
                  },
                  "method" => "GET",
                  "orig" => "/realms/{region}.json",
                  "parts" => [
                    "realms",
                    "{region}.json",
                  ],
                  "select" => {
                    "exist" => [
                      "region",
                    ],
                  },
                  "transform" => {
                    "req" => "`reqdata`",
                    "res" => "`body`",
                  },
                  "active" => true,
                  "index$" => 0,
                },
              ],
              "input" => "data",
              "key$" => "load",
            },
          },
          "relations" => {
            "ancestors" => [
              [
                "realm",
              ],
            ],
          },
        },
        "version" => {
          "fields" => [],
          "name" => "version",
          "op" => {
            "list" => {
              "name" => "list",
              "points" => [
                {
                  "method" => "GET",
                  "orig" => "/api/versions.json",
                  "parts" => [
                    "api",
                    "versions.json",
                  ],
                  "transform" => {
                    "req" => "`reqdata`",
                    "res" => "`body`",
                  },
                  "active" => true,
                  "args" => {},
                  "select" => {},
                  "index$" => 0,
                },
              ],
              "input" => "data",
              "key$" => "list",
            },
          },
          "relations" => {
            "ancestors" => [],
          },
        },
      },
    }
  end


  def self.make_feature(name)
    require_relative 'features'
    DataDragonFeatures.make_feature(name)
  end
end
