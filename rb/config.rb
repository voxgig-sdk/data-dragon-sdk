# DataDragon SDK configuration

module DataDragonConfig
  # Return the process-wide config, built once on first use. The SDK reads
  # the config on every request and never writes to it, so one instance is
  # shared by every client rather than rebuilt per client.
  #
  # The returned hash is shared: treat it as read-only. Callers that need to
  # mutate should use make_config, which always returns a fresh copy.
  def self.shared_config
    @shared_config ||= make_config
  end


  # Build a fresh, fully materialised config hash. Every call rebuilds the
  # whole structure, so prefer shared_config unless you need a private copy
  # you intend to mutate.
  def self.make_config
    {
      "main" => {
        "name" => "DataDragon",
        "slug" => "data-dragon",
        "version" => "0.0.1",
        "target" => "rb",
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
              "input" => "data",
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
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                      },
                    ],
                  },
                  "kind" => "http",
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
                },
              ],
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
              "name" => "image",
              "type" => "`$OBJECT`",
            },
            {
              "name" => "key",
              "short" => "Champion ID",
              "type" => "`$STRING`",
            },
            {
              "name" => "name",
              "short" => "Champion name",
              "type" => "`$STRING`",
            },
            {
              "name" => "title",
              "short" => "Champion title",
              "type" => "`$STRING`",
            },
          ],
          "name" => "data_champion",
          "op" => {
            "load" => {
              "input" => "data",
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
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                      },
                    ],
                  },
                  "kind" => "http",
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
                    "res" => "`body.data`",
                  },
                },
              ],
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
              "name" => "description",
              "type" => "`$STRING`",
            },
            {
              "name" => "image",
              "type" => "`$OBJECT`",
            },
            {
              "name" => "name",
              "type" => "`$STRING`",
            },
          ],
          "name" => "data_item",
          "op" => {
            "load" => {
              "input" => "data",
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
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                      },
                    ],
                  },
                  "kind" => "http",
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
                    "res" => "`body.data`",
                  },
                },
              ],
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
              "input" => "data",
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
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                      },
                    ],
                  },
                  "kind" => "http",
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
                },
              ],
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
              "input" => "data",
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
                      },
                    ],
                  },
                  "kind" => "http",
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
                },
              ],
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
              "input" => "data",
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
                      },
                      {
                        "example" => "12.6.1",
                        "kind" => "param",
                        "name" => "version",
                        "orig" => "version",
                        "reqd" => true,
                        "type" => "`$STRING`",
                      },
                    ],
                  },
                  "kind" => "http",
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
                },
              ],
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
              "name" => "champion",
              "type" => "`$STRING`",
            },
            {
              "name" => "item",
              "type" => "`$STRING`",
            },
            {
              "name" => "rune",
              "type" => "`$STRING`",
            },
          ],
          "name" => "region",
          "op" => {
            "load" => {
              "input" => "data",
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
                      },
                    ],
                  },
                  "kind" => "http",
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
                    "res" => "`body.n`",
                  },
                },
              ],
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
              "input" => "data",
              "name" => "list",
              "points" => [
                {
                  "args" => {},
                  "kind" => "http",
                  "method" => "GET",
                  "orig" => "/api/versions.json",
                  "parts" => [
                    "api",
                    "versions.json",
                  ],
                  "select" => {},
                  "transform" => {
                    "req" => "`reqdata`",
                    "res" => "`body`",
                  },
                },
              ],
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
