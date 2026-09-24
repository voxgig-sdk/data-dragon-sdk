
import { BaseFeature } from './feature/base/BaseFeature'
import { RatelimitFeature } from './feature/ratelimit/RatelimitFeature'
import { RetryFeature } from './feature/retry/RetryFeature'
import { TestFeature } from './feature/test/TestFeature'
import { TimeoutFeature } from './feature/timeout/TimeoutFeature'



const FEATURE_CLASS: Record<string, typeof BaseFeature> = {
   ratelimit: RatelimitFeature,
 retry: RetryFeature,
 test: TestFeature,
 timeout: TimeoutFeature,

}


const FEATURE_PLUGINS: Record<string, any[]> = {
  
}


class Config {

  makeFeature(this: any, fn: string) {
    const fc = FEATURE_CLASS[fn]
    const fi = new fc()
    return fi
  }

  // False for a feature added at runtime via options.extend (station's
  // adopt path) - the constructor uses this to skip makeFeature for names
  // no generated class backs.
  hasFeature(this: any, fn: string) {
    return null != FEATURE_CLASS[fn]
  }


  main = {
    name: 'DataDragon',
        slug: "data-dragon",
    version: "0.0.1",
    target: "ts",

  }


  feature = {
     ratelimit:     {
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
 retry:     {
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
 test:     {
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
 timeout:     {
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

  }


  options = {
    base: "https://ddragon.leagueoflegends.com",

    headers: {
      "content-type": "application/json"
    },

    entity: {
      
        champion: {
        },
  
        data_champion: {
        },
  
        data_item: {
        },
  
        data_rune: {
        },
  
        dragontail_versiontgz: {
        },
  
        item: {
        },
  
        region: {
        },
  
        version: {
        },
  
    }
  }


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
                    "orig": "champion_image",
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
          "name": "image",
          "title": "Image",
          "type": "`$OBJECT`"
        },
        {
          "name": "key",
          "title": "Key",
          "type": "`$STRING`",
          "short": "Champion ID"
        },
        {
          "name": "name",
          "title": "Name",
          "type": "`$STRING`",
          "short": "Champion name"
        },
        {
          "name": "title",
          "title": "Title",
          "type": "`$STRING`",
          "short": "Champion title"
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
                "res": "`body.data`"
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
          "name": "description",
          "title": "Description",
          "type": "`$STRING`"
        },
        {
          "name": "image",
          "title": "Image",
          "type": "`$OBJECT`"
        },
        {
          "name": "name",
          "title": "Name",
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
                "res": "`body.data`"
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
                    "orig": "item_image",
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
          "name": "champion",
          "title": "Champion",
          "type": "`$STRING`"
        },
        {
          "name": "item",
          "title": "Item",
          "type": "`$STRING`"
        },
        {
          "name": "rune",
          "title": "Rune",
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
                "res": "`body.n`"
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
              "select": {}
            }
          ]
        }
      },
      "relations": {
        "ancestors": []
      }
    }
  }
}


const config = new Config()

export {
  config,
  FEATURE_PLUGINS,
}

