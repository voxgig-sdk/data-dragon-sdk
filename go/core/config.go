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
		},
		"feature": map[string]any{
			"test": map[string]any{
				"options": map[string]any{
					"active": false,
				},
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
				"fields": []any{},
				"name": "champion",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"example": "Ahri.png",
											"kind": "param",
											"name": "id",
											"orig": "champion_image",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"example": "12.6.1",
											"kind": "param",
											"name": "version",
											"orig": "version",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/img/champion/{championImage}",
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
								"select": map[string]any{
									"exist": []any{
										"id",
										"version",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{
						[]any{
							"cdn",
						},
					},
				},
			},
			"data_champion": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "image",
						"type": "`$OBJECT`",
					},
					map[string]any{
						"name": "key",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "name",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "title",
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
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"example": "en_US",
											"kind": "param",
											"name": "language",
											"orig": "language",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"example": "12.6.1",
											"kind": "param",
											"name": "version",
											"orig": "version",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/data/{language}/champion.json",
								"parts": []any{
									"cdn",
									"{version}",
									"data",
									"{language}",
									"champion.json",
								},
								"select": map[string]any{
									"exist": []any{
										"language",
										"version",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body.data`",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{
						[]any{
							"cdn",
							"data",
						},
					},
				},
			},
			"data_item": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "description",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "image",
						"type": "`$OBJECT`",
					},
					map[string]any{
						"name": "name",
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
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"example": "en_US",
											"kind": "param",
											"name": "language",
											"orig": "language",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"example": "12.6.1",
											"kind": "param",
											"name": "version",
											"orig": "version",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/data/{language}/item.json",
								"parts": []any{
									"cdn",
									"{version}",
									"data",
									"{language}",
									"item.json",
								},
								"select": map[string]any{
									"exist": []any{
										"language",
										"version",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body.data`",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{
						[]any{
							"cdn",
							"data",
						},
					},
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
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"example": "en_US",
											"kind": "param",
											"name": "language",
											"orig": "language",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"example": "12.6.1",
											"kind": "param",
											"name": "version",
											"orig": "version",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/data/{language}/rune.json",
								"parts": []any{
									"cdn",
									"{version}",
									"data",
									"{language}",
									"rune.json",
								},
								"select": map[string]any{
									"exist": []any{
										"language",
										"version",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{
						[]any{
							"cdn",
							"data",
						},
					},
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
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"example": "12.6.1",
											"kind": "param",
											"name": "version",
											"orig": "version",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/dragontail-{version}.tgz",
								"parts": []any{
									"cdn",
									"dragontail-{version}.tgz",
								},
								"select": map[string]any{
									"exist": []any{
										"version",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
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
				"fields": []any{},
				"name": "item",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"example": "1001.png",
											"kind": "param",
											"name": "id",
											"orig": "item_image",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"example": "12.6.1",
											"kind": "param",
											"name": "version",
											"orig": "version",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/cdn/{version}/img/item/{itemImage}",
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
								"select": map[string]any{
									"exist": []any{
										"id",
										"version",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{
						[]any{
							"cdn",
						},
					},
				},
			},
			"region": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "champion",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "item",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "rune",
						"type": "`$STRING`",
					},
				},
				"name": "region",
				"op": map[string]any{
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"example": "na",
											"kind": "param",
											"name": "region",
											"orig": "region",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/realms/{region}.json",
								"parts": []any{
									"realms",
									"{region}.json",
								},
								"select": map[string]any{
									"exist": []any{
										"region",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body.n`",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{
						[]any{
							"realm",
						},
					},
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
								"args": map[string]any{},
								"kind": "http",
								"method": "GET",
								"orig": "/api/versions.json",
								"parts": []any{
									"api",
									"versions.json",
								},
								"select": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
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
	case "test":
		if NewTestFeatureFunc != nil {
			return NewTestFeatureFunc()
		}
	default:
		if NewBaseFeatureFunc != nil {
			return NewBaseFeatureFunc()
		}
	}
	return nil
}
