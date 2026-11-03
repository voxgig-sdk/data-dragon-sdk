package core

import (
	"sync"
)

// MakeConfig builds a fresh, fully materialised config map. Every call
// rebuilds the whole structure, so prefer SharedConfig unless you need a
// private copy you intend to mutate.
func MakeConfig() map[string]any {
	return map[string]any{
		"main": map[string]any{
			"name": "DataDragon",
			"slug": "data-dragon",
			"version": "0.0.1",
			"target": "go",
		},
		"feature": map[string]any{
			"ratelimit": map[string]any{
				"options": map[string]any{
					"active": false,
					"burst": 5,
					"rate": 5,
				},
				"optspec": map[string]any{
					"now": "`$FUNCTION`",
					"sleep": "`$FUNCTION`",
				},
				"strict": false,
				"transport": "wrap",
			},
			"retry": map[string]any{
				"options": map[string]any{
					"active": false,
					"factor": 2,
					"maxDelay": 2000,
					"minDelay": 50,
					"retries": 2,
					"statuses": []any{
						408,
						425,
						429,
						500,
						502,
						503,
						504,
					},
				},
				"optspec": map[string]any{
					"jitter": "`$BOOLEAN`",
					"sleep": "`$FUNCTION`",
				},
				"strict": false,
				"transport": "wrap",
			},
			"test": map[string]any{
				"options": map[string]any{
					"active": false,
				},
				"optspec": map[string]any{
					"entity": "`$MAP`",
					"net": "`$MAP`",
				},
				"strict": false,
				"transport": "base",
			},
			"timeout": map[string]any{
				"options": map[string]any{
					"active": false,
					"ms": 30000,
				},
				"optspec": map[string]any{
					"clearTimer": "`$FUNCTION`",
					"now": "`$FUNCTION`",
					"setTimer": "`$FUNCTION`",
				},
				"strict": false,
				"transport": "wrap",
			},
		},
		"options": map[string]any{
			"base": "https://ddragon.leagueoflegends.com",
			"headers": map[string]any{
				"content-type": "application/json",
			},
			"entity": map[string]any{
				"champion": map[string]any{},
				"data_champion": map[string]any{},
				"data_item": map[string]any{},
				"data_rune": map[string]any{},
				"dragontail_versiontgz": map[string]any{},
				"item": map[string]any{},
				"region": map[string]any{},
				"version": map[string]any{},
			},
		},
		"entity": map[string]any{
			"champion": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "id",
						"title": "Id",
						"type": "`$STRING`",
					},
				},
				"id": map[string]any{
					"field": "id",
					"name": "id",
				},
				"name": "champion",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/img/champion/{championImage}",
								"segments": []any{
									map[string]any{
										"lit": "cdn",
									},
									map[string]any{
										"var": "version",
									},
									map[string]any{
										"lit": "img",
									},
									map[string]any{
										"lit": "champion",
									},
									map[string]any{
										"var": "id",
									},
								},
								"parts": []any{
									"cdn",
									"{version}",
									"img",
									"champion",
									"{id}",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"championImage": "id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"name": "id",
											"orig": "championImage",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "Ahri.png",
										},
										map[string]any{
											"name": "version",
											"orig": "version",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "12.6.1",
										},
									},
								},
								"select": map[string]any{
									"exist": []any{
										"id",
										"version",
									},
								},
								"response": map[string]any{
									"binary": true,
									"kind": "raw",
									"media": "image/png",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{},
				},
			},
			"data_champion": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "data",
						"title": "Data",
						"type": "`$OBJECT`",
					},
					map[string]any{
						"name": "format",
						"title": "Format",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "type",
						"title": "Type",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "version",
						"title": "Version",
						"type": "`$STRING`",
					},
				},
				"name": "data_champion",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/data/{language}/champion.json",
								"segments": []any{
									map[string]any{
										"lit": "cdn",
									},
									map[string]any{
										"var": "version",
									},
									map[string]any{
										"lit": "data",
									},
									map[string]any{
										"var": "language",
									},
									map[string]any{
										"lit": "champion.json",
									},
								},
								"parts": []any{
									"cdn",
									"{version}",
									"data",
									"{language}",
									"champion.json",
								},
								"rename": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"name": "language",
											"orig": "language",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "en_US",
										},
										map[string]any{
											"name": "version",
											"orig": "version",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "12.6.1",
										},
									},
								},
								"select": map[string]any{
									"exist": []any{
										"language",
										"version",
									},
								},
								"response": map[string]any{
									"kind": "json",
									"media": "application/json",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{},
				},
			},
			"data_item": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "data",
						"title": "Data",
						"type": "`$OBJECT`",
					},
					map[string]any{
						"name": "type",
						"title": "Type",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "version",
						"title": "Version",
						"type": "`$STRING`",
					},
				},
				"name": "data_item",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/data/{language}/item.json",
								"segments": []any{
									map[string]any{
										"lit": "cdn",
									},
									map[string]any{
										"var": "version",
									},
									map[string]any{
										"lit": "data",
									},
									map[string]any{
										"var": "language",
									},
									map[string]any{
										"lit": "item.json",
									},
								},
								"parts": []any{
									"cdn",
									"{version}",
									"data",
									"{language}",
									"item.json",
								},
								"rename": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"name": "language",
											"orig": "language",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "en_US",
										},
										map[string]any{
											"name": "version",
											"orig": "version",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "12.6.1",
										},
									},
								},
								"select": map[string]any{
									"exist": []any{
										"language",
										"version",
									},
								},
								"response": map[string]any{
									"kind": "json",
									"media": "application/json",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{},
				},
			},
			"data_rune": map[string]any{
				"fields": []any{},
				"name": "data_rune",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/data/{language}/rune.json",
								"segments": []any{
									map[string]any{
										"lit": "cdn",
									},
									map[string]any{
										"var": "version",
									},
									map[string]any{
										"lit": "data",
									},
									map[string]any{
										"var": "language",
									},
									map[string]any{
										"lit": "rune.json",
									},
								},
								"parts": []any{
									"cdn",
									"{version}",
									"data",
									"{language}",
									"rune.json",
								},
								"rename": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"name": "language",
											"orig": "language",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "en_US",
										},
										map[string]any{
											"name": "version",
											"orig": "version",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "12.6.1",
										},
									},
								},
								"select": map[string]any{
									"exist": []any{
										"language",
										"version",
									},
								},
								"response": map[string]any{
									"kind": "json",
									"media": "application/json",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{},
				},
			},
			"dragontail_versiontgz": map[string]any{
				"fields": []any{},
				"name": "dragontail_versiontgz",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/dragontail-{version}.tgz",
								"segments": []any{
									map[string]any{
										"lit": "cdn",
									},
									map[string]any{
										"lit": "dragontail-{version}.tgz",
									},
								},
								"parts": []any{
									"cdn",
									"dragontail-{version}.tgz",
								},
								"rename": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"name": "version",
											"orig": "version",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "12.6.1",
										},
									},
								},
								"select": map[string]any{
									"exist": []any{
										"version",
									},
								},
								"response": map[string]any{
									"binary": true,
									"kind": "raw",
									"media": "application/gzip",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{},
				},
			},
			"item": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "id",
						"title": "Id",
						"type": "`$STRING`",
					},
				},
				"id": map[string]any{
					"field": "id",
					"name": "id",
				},
				"name": "item",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/img/item/{itemImage}",
								"segments": []any{
									map[string]any{
										"lit": "cdn",
									},
									map[string]any{
										"var": "version",
									},
									map[string]any{
										"lit": "img",
									},
									map[string]any{
										"lit": "item",
									},
									map[string]any{
										"var": "id",
									},
								},
								"parts": []any{
									"cdn",
									"{version}",
									"img",
									"item",
									"{id}",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"itemImage": "id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"name": "id",
											"orig": "itemImage",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "1001.png",
										},
										map[string]any{
											"name": "version",
											"orig": "version",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "12.6.1",
										},
									},
								},
								"select": map[string]any{
									"exist": []any{
										"id",
										"version",
									},
								},
								"response": map[string]any{
									"binary": true,
									"kind": "raw",
									"media": "image/png",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{},
				},
			},
			"region": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "cdn",
						"title": "Cdn",
						"type": "`$STRING`",
						"short": "CDN base URL",
					},
					map[string]any{
						"name": "n",
						"title": "N",
						"type": "`$OBJECT`",
					},
					map[string]any{
						"name": "v",
						"title": "V",
						"type": "`$STRING`",
						"short": "Current patch version",
					},
				},
				"name": "region",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"kind": "http",
								"method": "GET",
								"orig": "/realms/{region}.json",
								"segments": []any{
									map[string]any{
										"lit": "realms",
									},
									map[string]any{
										"lit": "{region}.json",
									},
								},
								"parts": []any{
									"realms",
									"{region}.json",
								},
								"rename": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"name": "region",
											"orig": "region",
											"type": "`$STRING`",
											"kind": "param",
											"reqd": true,
											"example": "na",
										},
									},
								},
								"select": map[string]any{
									"exist": []any{
										"region",
									},
								},
								"response": map[string]any{
									"kind": "json",
									"media": "application/json",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{},
				},
			},
			"version": map[string]any{
				"fields": []any{},
				"name": "version",
				"op": map[string]any{
					"list": map[string]any{
						"input": "data",
						"name": "list",
						"points": []any{
							map[string]any{
								"kind": "http",
								"method": "GET",
								"orig": "/api/versions.json",
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "versions.json",
									},
								},
								"parts": []any{
									"api",
									"versions.json",
								},
								"rename": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"args": map[string]any{},
								"select": map[string]any{},
								"response": map[string]any{
									"kind": "json",
									"media": "application/json",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{},
				},
			},
		},
	}
}

// The plugin definitions the model selected per feature, as []any so a
// feature package can consume them without core naming its types. Empty
// when no active feature declares active plugin groups for this target.
var featurePlugins = map[string][]any{
}

// FeaturePlugins is the definitions list for one feature's chain.
func FeaturePlugins(name string) []any {
	return featurePlugins[name]
}

var (
	sharedConfigOnce sync.Once
	sharedConfigVal  map[string]any
)

// SharedConfig returns the process-wide config, built once on first use.
// The SDK reads the config on every request and never writes to it, so one
// instance is shared by every client rather than rebuilt per client.
//
// The returned map is shared: treat it as read-only. Callers that need to
// mutate should use MakeConfig, which always returns a fresh copy.
func SharedConfig() map[string]any {
	sharedConfigOnce.Do(func() {
		sharedConfigVal = MakeConfig()
	})
	return sharedConfigVal
}

func makeFeature(name string) Feature {
	switch name {
	case "ratelimit":
		if NewRatelimitFeatureFunc != nil {
			return NewRatelimitFeatureFunc()
		}
	case "retry":
		if NewRetryFeatureFunc != nil {
			return NewRetryFeatureFunc()
		}
	case "test":
		if NewTestFeatureFunc != nil {
			return NewTestFeatureFunc()
		}
	case "timeout":
		if NewTimeoutFeatureFunc != nil {
			return NewTimeoutFeatureFunc()
		}
	default:
		if NewBaseFeatureFunc != nil {
			return NewBaseFeatureFunc()
		}
	}
	return nil
}
