"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const node_test_1 = require("node:test");
const __1 = require("..");
const definition_runner_1 = require("./definition-runner");
const utility_1 = require("./utility");
// Generated from the API definition, not from the model this SDK was built
// from: the route, the declared query parameters, the credential the security
// scheme names, and the definition's own response example.
const PLAN = [
    {
        "entity": "champion",
        "accessor": "Champion",
        "op": "load",
        "method": "GET",
        "path": "/cdn/{version}/img/champion/{championImage}",
        "args": [
            {
                "name": "id",
                "wire": "championImage",
                "value": "Ahri.png"
            },
            {
                "name": "version",
                "wire": "version",
                "value": "12.6.1"
            }
        ],
        "select": {},
        "headers": [],
        "cookies": [],
        "responseMedia": [
            "image/png"
        ],
        "query": [],
        "queryArgs": [],
        "auth": null,
        "status": 200,
        "sample": null,
        "idField": "id"
    },
    {
        "entity": "data_champion",
        "accessor": "DataChampion",
        "op": "load",
        "method": "GET",
        "path": "/cdn/{version}/data/{language}/champion.json",
        "args": [
            {
                "name": "language",
                "wire": "language",
                "value": "en_US"
            },
            {
                "name": "version",
                "wire": "version",
                "value": "12.6.1"
            }
        ],
        "select": {},
        "headers": [],
        "cookies": [],
        "responseMedia": [
            "application/json"
        ],
        "query": [],
        "queryArgs": [],
        "auth": null,
        "status": 200,
        "sample": {
            "type": "x",
            "format": "x",
            "version": "x",
            "data": {}
        },
        "idField": "id"
    },
    {
        "entity": "data_item",
        "accessor": "DataItem",
        "op": "load",
        "method": "GET",
        "path": "/cdn/{version}/data/{language}/item.json",
        "args": [
            {
                "name": "language",
                "wire": "language",
                "value": "en_US"
            },
            {
                "name": "version",
                "wire": "version",
                "value": "12.6.1"
            }
        ],
        "select": {},
        "headers": [],
        "cookies": [],
        "responseMedia": [
            "application/json"
        ],
        "query": [],
        "queryArgs": [],
        "auth": null,
        "status": 200,
        "sample": {
            "type": "x",
            "version": "x",
            "data": {}
        },
        "idField": "id"
    },
    {
        "entity": "data_rune",
        "accessor": "DataRune",
        "op": "load",
        "method": "GET",
        "path": "/cdn/{version}/data/{language}/rune.json",
        "args": [
            {
                "name": "language",
                "wire": "language",
                "value": "en_US"
            },
            {
                "name": "version",
                "wire": "version",
                "value": "12.6.1"
            }
        ],
        "select": {},
        "headers": [],
        "cookies": [],
        "responseMedia": [
            "application/json"
        ],
        "query": [],
        "queryArgs": [],
        "auth": null,
        "status": 200,
        "sample": {},
        "idField": "id"
    },
    {
        "entity": "dragontail_versiontgz",
        "accessor": "DragontailVersiontgz",
        "op": "load",
        "method": "GET",
        "path": "/cdn/dragontail-{version}.tgz",
        "args": [
            {
                "name": "version",
                "wire": "version",
                "value": "12.6.1"
            }
        ],
        "select": {},
        "headers": [],
        "cookies": [],
        "responseMedia": [
            "application/gzip"
        ],
        "query": [],
        "queryArgs": [],
        "auth": null,
        "status": 200,
        "sample": null,
        "idField": "id"
    },
    {
        "entity": "item",
        "accessor": "Item",
        "op": "load",
        "method": "GET",
        "path": "/cdn/{version}/img/item/{itemImage}",
        "args": [
            {
                "name": "id",
                "wire": "itemImage",
                "value": "1001.png"
            },
            {
                "name": "version",
                "wire": "version",
                "value": "12.6.1"
            }
        ],
        "select": {},
        "headers": [],
        "cookies": [],
        "responseMedia": [
            "image/png"
        ],
        "query": [],
        "queryArgs": [],
        "auth": null,
        "status": 200,
        "sample": null,
        "idField": "id"
    },
    {
        "entity": "region",
        "accessor": "Region",
        "op": "load",
        "method": "GET",
        "path": "/realms/{region}.json",
        "args": [
            {
                "name": "region",
                "wire": "region",
                "value": "na"
            }
        ],
        "select": {},
        "headers": [],
        "cookies": [],
        "responseMedia": [
            "application/json"
        ],
        "query": [],
        "queryArgs": [],
        "auth": null,
        "status": 200,
        "sample": {
            "n": {
                "champion": "x",
                "item": "x",
                "rune": "x"
            },
            "v": "x",
            "cdn": "x"
        },
        "idField": "id"
    },
    {
        "entity": "version",
        "accessor": "Version",
        "op": "list",
        "method": "GET",
        "path": "/api/versions.json",
        "args": [],
        "select": {},
        "headers": [],
        "cookies": [],
        "responseMedia": [
            "application/json"
        ],
        "query": [],
        "queryArgs": [],
        "auth": null,
        "status": 200,
        "sample": [
            "12.6.1",
            "12.5.1",
            "12.4.1"
        ],
        "idField": "id"
    }
];
(0, node_test_1.describe)('definition', () => {
    for (const point of PLAN) {
        (0, node_test_1.test)(point.entity + '.' + point.op + ' ' + point.method + ' ' + point.path, async (t) => {
            const control = (0, utility_1.isControlSkipped)('entityOp', point.entity + '.' + point.op, 'definition');
            if (control.skip) {
                t.skip(control.reason || 'skipped via sdk-test-control.json');
                return;
            }
            await (0, definition_runner_1.runDefinitionPoint)(__1.SDK, point);
        });
    }
});
//# sourceMappingURL=definition.test.js.map