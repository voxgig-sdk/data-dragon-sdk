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
        ["id"] = {
          ["field"] = "id",
          ["name"] = "id",
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
                ["rename"] = {
                  ["param"] = {
                    ["championImage"] = "id",
                  },
                },
                ["segments"] = {
                  {
                    ["lit"] = "cdn",
                  },
                  {
                    ["var"] = "version",
                  },
                  {
                    ["lit"] = "img",
                  },
                  {
                    ["lit"] = "champion",
                  },
                  {
                    ["var"] = "id",
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
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "img",
                  "champion",
                  "{id}",
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
                ["segments"] = {
                  {
                    ["lit"] = "cdn",
                  },
                  {
                    ["var"] = "version",
                  },
                  {
                    ["lit"] = "data",
                  },
                  {
                    ["var"] = "language",
                  },
                  {
                    ["lit"] = "champion.json",
                  },
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
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "champion.json",
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
                ["segments"] = {
                  {
                    ["lit"] = "cdn",
                  },
                  {
                    ["var"] = "version",
                  },
                  {
                    ["lit"] = "data",
                  },
                  {
                    ["var"] = "language",
                  },
                  {
                    ["lit"] = "item.json",
                  },
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
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "item.json",
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
                ["segments"] = {
                  {
                    ["lit"] = "cdn",
                  },
                  {
                    ["var"] = "version",
                  },
                  {
                    ["lit"] = "data",
                  },
                  {
                    ["var"] = "language",
                  },
                  {
                    ["lit"] = "rune.json",
                  },
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
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "data",
                  "{language}",
                  "rune.json",
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
                ["segments"] = {
                  {
                    ["lit"] = "cdn",
                  },
                  {
                    ["lit"] = "dragontail-{version}.tgz",
                  },
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
                ["parts"] = {
                  "cdn",
                  "dragontail-{version}.tgz",
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
        ["id"] = {
          ["field"] = "id",
          ["name"] = "id",
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
                ["rename"] = {
                  ["param"] = {
                    ["itemImage"] = "id",
                  },
                },
                ["segments"] = {
                  {
                    ["lit"] = "cdn",
                  },
                  {
                    ["var"] = "version",
                  },
                  {
                    ["lit"] = "img",
                  },
                  {
                    ["lit"] = "item",
                  },
                  {
                    ["var"] = "id",
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
                ["parts"] = {
                  "cdn",
                  "{version}",
                  "img",
                  "item",
                  "{id}",
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
                ["segments"] = {
                  {
                    ["lit"] = "realms",
                  },
                  {
                    ["lit"] = "{region}.json",
                  },
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
                ["parts"] = {
                  "realms",
                  "{region}.json",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {},
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
                ["segments"] = {
                  {
                    ["lit"] = "api",
                  },
                  {
                    ["lit"] = "versions.json",
                  },
                },
                ["select"] = {},
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
                ["parts"] = {
                  "api",
                  "versions.json",
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
