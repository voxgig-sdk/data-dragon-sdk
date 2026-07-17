-- DataDragon SDK configuration

local function make_config()
  return {
    main = {
      name = "DataDragon",
    },
    feature = {
      ["test"] = {
        ["options"] = {
          ["active"] = false,
        },
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
        ["fields"] = {},
        ["name"] = "champion",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["active"] = true,
                ["args"] = {
                  ["params"] = {
                    {
                      ["active"] = true,
                      ["example"] = "Ahri.png",
                      ["kind"] = "param",
                      ["name"] = "id",
                      ["orig"] = "champion_image",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 0,
                    },
                    {
                      ["active"] = true,
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 1,
                    },
                  },
                },
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
                ["index$"] = 0,
              },
            },
            ["key$"] = "load",
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
            ["active"] = true,
            ["name"] = "data",
            ["req"] = false,
            ["type"] = "`$OBJECT`",
            ["index$"] = 0,
          },
          {
            ["active"] = true,
            ["name"] = "format",
            ["req"] = false,
            ["type"] = "`$STRING`",
            ["index$"] = 1,
          },
          {
            ["active"] = true,
            ["name"] = "type",
            ["req"] = false,
            ["type"] = "`$STRING`",
            ["index$"] = 2,
          },
          {
            ["active"] = true,
            ["name"] = "version",
            ["req"] = false,
            ["type"] = "`$STRING`",
            ["index$"] = 3,
          },
        },
        ["name"] = "data_champion",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["active"] = true,
                ["args"] = {
                  ["params"] = {
                    {
                      ["active"] = true,
                      ["example"] = "en_US",
                      ["kind"] = "param",
                      ["name"] = "language",
                      ["orig"] = "language",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 0,
                    },
                    {
                      ["active"] = true,
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 1,
                    },
                  },
                },
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
                  ["res"] = "`body`",
                },
                ["index$"] = 0,
              },
            },
            ["key$"] = "load",
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
            ["active"] = true,
            ["name"] = "data",
            ["req"] = false,
            ["type"] = "`$OBJECT`",
            ["index$"] = 0,
          },
          {
            ["active"] = true,
            ["name"] = "type",
            ["req"] = false,
            ["type"] = "`$STRING`",
            ["index$"] = 1,
          },
          {
            ["active"] = true,
            ["name"] = "version",
            ["req"] = false,
            ["type"] = "`$STRING`",
            ["index$"] = 2,
          },
        },
        ["name"] = "data_item",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["active"] = true,
                ["args"] = {
                  ["params"] = {
                    {
                      ["active"] = true,
                      ["example"] = "en_US",
                      ["kind"] = "param",
                      ["name"] = "language",
                      ["orig"] = "language",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 0,
                    },
                    {
                      ["active"] = true,
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 1,
                    },
                  },
                },
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
                  ["res"] = "`body`",
                },
                ["index$"] = 0,
              },
            },
            ["key$"] = "load",
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
                ["active"] = true,
                ["args"] = {
                  ["params"] = {
                    {
                      ["active"] = true,
                      ["example"] = "en_US",
                      ["kind"] = "param",
                      ["name"] = "language",
                      ["orig"] = "language",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 0,
                    },
                    {
                      ["active"] = true,
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 1,
                    },
                  },
                },
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
                ["index$"] = 0,
              },
            },
            ["key$"] = "load",
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
                ["active"] = true,
                ["args"] = {
                  ["params"] = {
                    {
                      ["active"] = true,
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 0,
                    },
                  },
                },
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
                ["index$"] = 0,
              },
            },
            ["key$"] = "load",
          },
        },
        ["relations"] = {
          ["ancestors"] = {},
        },
      },
      ["item"] = {
        ["fields"] = {},
        ["name"] = "item",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["active"] = true,
                ["args"] = {
                  ["params"] = {
                    {
                      ["active"] = true,
                      ["example"] = "1001.png",
                      ["kind"] = "param",
                      ["name"] = "id",
                      ["orig"] = "item_image",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 0,
                    },
                    {
                      ["active"] = true,
                      ["example"] = "12.6.1",
                      ["kind"] = "param",
                      ["name"] = "version",
                      ["orig"] = "version",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 1,
                    },
                  },
                },
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
                ["index$"] = 0,
              },
            },
            ["key$"] = "load",
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
            ["active"] = true,
            ["name"] = "cdn",
            ["req"] = false,
            ["type"] = "`$STRING`",
            ["index$"] = 0,
          },
          {
            ["active"] = true,
            ["name"] = "n",
            ["req"] = false,
            ["type"] = "`$OBJECT`",
            ["index$"] = 1,
          },
          {
            ["active"] = true,
            ["name"] = "v",
            ["req"] = false,
            ["type"] = "`$STRING`",
            ["index$"] = 2,
          },
        },
        ["name"] = "region",
        ["op"] = {
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["active"] = true,
                ["args"] = {
                  ["params"] = {
                    {
                      ["active"] = true,
                      ["example"] = "na",
                      ["kind"] = "param",
                      ["name"] = "region",
                      ["orig"] = "region",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                      ["index$"] = 0,
                    },
                  },
                },
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
                  ["res"] = "`body`",
                },
                ["index$"] = 0,
              },
            },
            ["key$"] = "load",
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
                ["active"] = true,
                ["args"] = {},
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
                ["index$"] = 0,
              },
            },
            ["key$"] = "list",
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
