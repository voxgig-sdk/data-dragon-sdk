<?php
declare(strict_types=1);

// DataDragon SDK configuration

class DataDragonConfig
{
    /** @var array<string,mixed>|null */
    private static ?array $shared_config = null;

    /**
     * Return the process-wide config, built once on first use. The SDK reads
     * the config on every request and never writes to it, so one instance is
     * shared by every client rather than rebuilt per client.
     *
     * PHP arrays are copy-on-write, so callers that do mutate the result get
     * their own copy and cannot disturb the shared one.
     */
    public static function shared_config(): array
    {
        if (self::$shared_config === null) {
            self::$shared_config = self::make_config();
        }
        return self::$shared_config;
    }

    /**
     * Build a fresh, fully materialised config array. Every call rebuilds the
     * whole structure, so prefer shared_config unless you need a private copy.
     */
    public static function make_config(): array
    {
        return [
            "main" => [
                "name" => "DataDragon",
                "slug" => "data-dragon",
                "version" => "0.0.1",
                "target" => "php",
            ],
            "feature" => [
                "ratelimit" => [
          'options' => [
            'active' => false,
            'burst' => 5,
            'rate' => 5,
          ],
          'optspec' => [
            'now' => '`$FUNCTION`',
            'sleep' => '`$FUNCTION`',
          ],
          'strict' => false,
          'transport' => 'wrap',
        ],
                "retry" => [
          'options' => [
            'active' => false,
            'factor' => 2,
            'maxDelay' => 2000,
            'minDelay' => 50,
            'retries' => 2,
            'statuses' => [
              408,
              425,
              429,
              500,
              502,
              503,
              504,
            ],
          ],
          'optspec' => [
            'jitter' => '`$BOOLEAN`',
            'sleep' => '`$FUNCTION`',
          ],
          'strict' => false,
          'transport' => 'wrap',
        ],
                "test" => [
          'options' => [
            'active' => false,
          ],
          'optspec' => [
            'entity' => '`$MAP`',
            'net' => '`$MAP`',
          ],
          'strict' => false,
          'transport' => 'base',
        ],
                "timeout" => [
          'options' => [
            'active' => false,
            'ms' => 30000,
          ],
          'optspec' => [
            'clearTimer' => '`$FUNCTION`',
            'setTimer' => '`$FUNCTION`',
          ],
          'strict' => false,
          'transport' => 'wrap',
        ],
            ],
            "options" => [
                "base" => "https://ddragon.leagueoflegends.com",
                "headers" => [
          'content-type' => 'application/json',
        ],
                "entity" => [
                    "champion" => [],
                    "data_champion" => [],
                    "data_item" => [],
                    "data_rune" => [],
                    "dragontail_versiontgz" => [],
                    "item" => [],
                    "region" => [],
                    "version" => [],
                ],
            ],
            "entity" => [
        'champion' => [
          'fields' => [
            [
              'name' => 'id',
              'type' => '`$STRING`',
            ],
          ],
          'id' => [
            'field' => 'id',
            'name' => 'id',
          ],
          'name' => 'champion',
          'op' => [
            'load' => [
              'input' => 'data',
              'name' => 'load',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'example' => 'Ahri.png',
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'champion_image',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                      [
                        'example' => '12.6.1',
                        'kind' => 'param',
                        'name' => 'version',
                        'orig' => 'version',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/cdn/{version}/img/champion/{championImage}',
                  'rename' => [
                    'param' => [
                      'championImage' => 'id',
                    ],
                  ],
                  'segments' => [
                    [
                      'lit' => 'cdn',
                    ],
                    [
                      'var' => 'version',
                    ],
                    [
                      'lit' => 'img',
                    ],
                    [
                      'lit' => 'champion',
                    ],
                    [
                      'var' => 'id',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'id',
                      'version',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                  'parts' => [
                    'cdn',
                    '{version}',
                    'img',
                    'champion',
                    '{id}',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [
              [
                'cdn',
              ],
            ],
          ],
        ],
        'data_champion' => [
          'fields' => [
            [
              'name' => 'image',
              'type' => '`$OBJECT`',
            ],
            [
              'name' => 'key',
              'short' => 'Champion ID',
              'type' => '`$STRING`',
            ],
            [
              'name' => 'name',
              'short' => 'Champion name',
              'type' => '`$STRING`',
            ],
            [
              'name' => 'title',
              'short' => 'Champion title',
              'type' => '`$STRING`',
            ],
          ],
          'name' => 'data_champion',
          'op' => [
            'load' => [
              'input' => 'data',
              'name' => 'load',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'example' => 'en_US',
                        'kind' => 'param',
                        'name' => 'language',
                        'orig' => 'language',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                      [
                        'example' => '12.6.1',
                        'kind' => 'param',
                        'name' => 'version',
                        'orig' => 'version',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/cdn/{version}/data/{language}/champion.json',
                  'segments' => [
                    [
                      'lit' => 'cdn',
                    ],
                    [
                      'var' => 'version',
                    ],
                    [
                      'lit' => 'data',
                    ],
                    [
                      'var' => 'language',
                    ],
                    [
                      'lit' => 'champion.json',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'language',
                      'version',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body.data`',
                  ],
                  'parts' => [
                    'cdn',
                    '{version}',
                    'data',
                    '{language}',
                    'champion.json',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [
              [
                'cdn',
                'data',
              ],
            ],
          ],
        ],
        'data_item' => [
          'fields' => [
            [
              'name' => 'description',
              'type' => '`$STRING`',
            ],
            [
              'name' => 'image',
              'type' => '`$OBJECT`',
            ],
            [
              'name' => 'name',
              'type' => '`$STRING`',
            ],
          ],
          'name' => 'data_item',
          'op' => [
            'load' => [
              'input' => 'data',
              'name' => 'load',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'example' => 'en_US',
                        'kind' => 'param',
                        'name' => 'language',
                        'orig' => 'language',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                      [
                        'example' => '12.6.1',
                        'kind' => 'param',
                        'name' => 'version',
                        'orig' => 'version',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/cdn/{version}/data/{language}/item.json',
                  'segments' => [
                    [
                      'lit' => 'cdn',
                    ],
                    [
                      'var' => 'version',
                    ],
                    [
                      'lit' => 'data',
                    ],
                    [
                      'var' => 'language',
                    ],
                    [
                      'lit' => 'item.json',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'language',
                      'version',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body.data`',
                  ],
                  'parts' => [
                    'cdn',
                    '{version}',
                    'data',
                    '{language}',
                    'item.json',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [
              [
                'cdn',
                'data',
              ],
            ],
          ],
        ],
        'data_rune' => [
          'fields' => [],
          'name' => 'data_rune',
          'op' => [
            'load' => [
              'input' => 'data',
              'name' => 'load',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'example' => 'en_US',
                        'kind' => 'param',
                        'name' => 'language',
                        'orig' => 'language',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                      [
                        'example' => '12.6.1',
                        'kind' => 'param',
                        'name' => 'version',
                        'orig' => 'version',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/cdn/{version}/data/{language}/rune.json',
                  'segments' => [
                    [
                      'lit' => 'cdn',
                    ],
                    [
                      'var' => 'version',
                    ],
                    [
                      'lit' => 'data',
                    ],
                    [
                      'var' => 'language',
                    ],
                    [
                      'lit' => 'rune.json',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'language',
                      'version',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                  'parts' => [
                    'cdn',
                    '{version}',
                    'data',
                    '{language}',
                    'rune.json',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [
              [
                'cdn',
                'data',
              ],
            ],
          ],
        ],
        'dragontail_versiontgz' => [
          'fields' => [],
          'name' => 'dragontail_versiontgz',
          'op' => [
            'load' => [
              'input' => 'data',
              'name' => 'load',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'example' => '12.6.1',
                        'kind' => 'param',
                        'name' => 'version',
                        'orig' => 'version',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/cdn/dragontail-{version}.tgz',
                  'segments' => [
                    [
                      'lit' => 'cdn',
                    ],
                    [
                      'lit' => 'dragontail-{version}.tgz',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'version',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                  'parts' => [
                    'cdn',
                    'dragontail-{version}.tgz',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [],
          ],
        ],
        'item' => [
          'fields' => [
            [
              'name' => 'id',
              'type' => '`$STRING`',
            ],
          ],
          'id' => [
            'field' => 'id',
            'name' => 'id',
          ],
          'name' => 'item',
          'op' => [
            'load' => [
              'input' => 'data',
              'name' => 'load',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'example' => '1001.png',
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'item_image',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                      [
                        'example' => '12.6.1',
                        'kind' => 'param',
                        'name' => 'version',
                        'orig' => 'version',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/cdn/{version}/img/item/{itemImage}',
                  'rename' => [
                    'param' => [
                      'itemImage' => 'id',
                    ],
                  ],
                  'segments' => [
                    [
                      'lit' => 'cdn',
                    ],
                    [
                      'var' => 'version',
                    ],
                    [
                      'lit' => 'img',
                    ],
                    [
                      'lit' => 'item',
                    ],
                    [
                      'var' => 'id',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'id',
                      'version',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                  'parts' => [
                    'cdn',
                    '{version}',
                    'img',
                    'item',
                    '{id}',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [
              [
                'cdn',
              ],
            ],
          ],
        ],
        'region' => [
          'fields' => [
            [
              'name' => 'champion',
              'type' => '`$STRING`',
            ],
            [
              'name' => 'item',
              'type' => '`$STRING`',
            ],
            [
              'name' => 'rune',
              'type' => '`$STRING`',
            ],
          ],
          'name' => 'region',
          'op' => [
            'load' => [
              'input' => 'data',
              'name' => 'load',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'example' => 'na',
                        'kind' => 'param',
                        'name' => 'region',
                        'orig' => 'region',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/realms/{region}.json',
                  'segments' => [
                    [
                      'lit' => 'realms',
                    ],
                    [
                      'lit' => '{region}.json',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'region',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body.n`',
                  ],
                  'parts' => [
                    'realms',
                    '{region}.json',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [],
          ],
        ],
        'version' => [
          'fields' => [],
          'name' => 'version',
          'op' => [
            'list' => [
              'input' => 'data',
              'name' => 'list',
              'points' => [
                [
                  'args' => [],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/api/versions.json',
                  'segments' => [
                    [
                      'lit' => 'api',
                    ],
                    [
                      'lit' => 'versions.json',
                    ],
                  ],
                  'select' => [],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                  'parts' => [
                    'api',
                    'versions.json',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [],
          ],
        ],
      ],
        ];
    }


    public static function make_feature(string $name)
    {
        require_once __DIR__ . '/features.php';
        return DataDragonFeatures::make_feature($name);
    }
}
