-- DataDragon SDK configuration

-- Build a fresh, fully materialised config table. Every call rebuilds the
-- whole structure, so prefer require("config_shared") unless you need a
-- private copy you intend to mutate.
local function make_config()
  return {
    main = {
      name = "DataDragon",
      slug = "data-dragon",
      version = "0.0.1",
      target = "lua",
    },
    feature = {
      ["test"] = {
        ["options"] = {
          ["active"] = false,
        },
        ["transport"] = "base",
      },
    },
    options = {
      base = "https://ddragon.leagueoflegends.com",
      headers = {
        ["content-type"] = "application/json",
      },
      entity = {
        ["champion"] = {},
        ["data_champion"] = {},
        ["data_item"] = {},
        ["data_rune"] = {},
        ["dragontail_versiontgz"] = {},
        ["item"] = {},
        ["region"] = {},
        ["version"] = {},
      },
    },
    entity = {
      ["champion"] = {
        ["fields"] = {
          {
            ["name"] = "id",
            ["type"] = "`$STRING`",
          },
        },
        ["name"] = "champion",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["example"] = "Ahri.png",
                      ["kind"] = "param",
                      ["name"] = "id",
                      ["orig"] = "champion_image",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                    {
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                  },
                },
                ["kind"] = "http",
                ["method"] = "GET",
                ["orig"] = "/cdn/{version}/img/champion/{championImage}",
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "img",
                  "champion",
                  "{id}",
                },
                ["rename"] = {
                  ["param"] = {
                    ["championImage"] = "id",
                  },
                },
                ["select"] = {
                  ["exist"] = {
                    "id",
                    "version",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {
            {
              "cdn",
            },
          },
        },
      },
      ["data_champion"] = {
        ["fields"] = {
          {
            ["name"] = "image",
            ["type"] = "`$OBJECT`",
          },
          {
            ["name"] = "key",
            ["short"] = "Champion ID",
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "name",
            ["short"] = "Champion name",
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "title",
            ["short"] = "Champion title",
            ["type"] = "`$STRING`",
          },
        },
        ["name"] = "data_champion",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["example"] = "en_US",
                      ["kind"] = "param",
                      ["name"] = "language",
                      ["orig"] = "language",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                    {
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                  },
                },
                ["kind"] = "http",
                ["method"] = "GET",
                ["orig"] = "/cdn/{version}/data/{language}/champion.json",
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "champion.json",
                },
                ["select"] = {
                  ["exist"] = {
                    "language",
                    "version",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body.data`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {
            {
              "cdn",
              "data",
            },
          },
        },
      },
      ["data_item"] = {
        ["fields"] = {
          {
            ["name"] = "description",
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "image",
            ["type"] = "`$OBJECT`",
          },
          {
            ["name"] = "name",
            ["type"] = "`$STRING`",
          },
        },
        ["name"] = "data_item",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["example"] = "en_US",
                      ["kind"] = "param",
                      ["name"] = "language",
                      ["orig"] = "language",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                    {
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                  },
                },
                ["kind"] = "http",
                ["method"] = "GET",
                ["orig"] = "/cdn/{version}/data/{language}/item.json",
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "item.json",
                },
                ["select"] = {
                  ["exist"] = {
                    "language",
                    "version",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body.data`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {
            {
              "cdn",
              "data",
            },
          },
        },
      },
      ["data_rune"] = {
        ["fields"] = {},
        ["name"] = "data_rune",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["example"] = "en_US",
                      ["kind"] = "param",
                      ["name"] = "language",
                      ["orig"] = "language",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                    {
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                  },
                },
                ["kind"] = "http",
                ["method"] = "GET",
                ["orig"] = "/cdn/{version}/data/{language}/rune.json",
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "rune.json",
                },
                ["select"] = {
                  ["exist"] = {
                    "language",
                    "version",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {
            {
              "cdn",
              "data",
            },
          },
        },
      },
      ["dragontail_versiontgz"] = {
        ["fields"] = {},
        ["name"] = "dragontail_versiontgz",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                  },
                },
                ["kind"] = "http",
                ["method"] = "GET",
                ["orig"] = "/cdn/dragontail-{version}.tgz",
                ["parts"] = {
                  "cdn",
                  "dragontail-{version}.tgz",
                },
                ["select"] = {
                  ["exist"] = {
                    "version",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {},
        },
      },
      ["item"] = {
        ["fields"] = {
          {
            ["name"] = "id",
            ["type"] = "`$STRING`",
          },
        },
        ["name"] = "item",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["example"] = "1001.png",
                      ["kind"] = "param",
                      ["name"] = "id",
                      ["orig"] = "item_image",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                    {
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                  },
                },
                ["kind"] = "http",
                ["method"] = "GET",
                ["orig"] = "/cdn/{version}/img/item/{itemImage}",
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "img",
                  "item",
                  "{id}",
                },
                ["rename"] = {
                  ["param"] = {
                    ["itemImage"] = "id",
                  },
                },
                ["select"] = {
                  ["exist"] = {
                    "id",
                    "version",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {
            {
              "cdn",
            },
          },
        },
      },
      ["region"] = {
        ["fields"] = {
          {
            ["name"] = "champion",
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "item",
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "rune",
            ["type"] = "`$STRING`",
          },
        },
        ["name"] = "region",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["example"] = "na",
                      ["kind"] = "param",
                      ["name"] = "region",
                      ["orig"] = "region",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
                  },
                },
                ["kind"] = "http",
                ["method"] = "GET",
                ["orig"] = "/realms/{region}.json",
                ["parts"] = {
                  "realms",
                  "{region}.json",
                },
                ["select"] = {
                  ["exist"] = {
                    "region",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body.n`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {
            {
              "realm",
            },
          },
        },
      },
      ["version"] = {
        ["fields"] = {},
        ["name"] = "version",
        ["op"] = {
          ["list"] = {
            ["input"] = "data",
            ["name"] = "list",
            ["points"] = {
              {
                ["args"] = {},
                ["kind"] = "http",
                ["method"] = "GET",
                ["orig"] = "/api/versions.json",
                ["parts"] = {
                  "api",
                  "versions.json",
                },
                ["select"] = {},
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {},
        },
      },
    },
  }
end


local function make_feature(name)
  local features = require("features")
  local factory = features[name]
  if factory ~= nil then
    return factory()
  end
  return features.base()
end


-- Attach make_feature to the SDK class
local function setup_sdk(SDK)
  SDK._make_feature = make_feature
end


return make_config
