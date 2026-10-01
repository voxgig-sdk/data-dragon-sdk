"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const node_path_1 = __importDefault(require("node:path"));
const Fs = __importStar(require("node:fs"));
const node_test_1 = require("node:test");
const node_assert_1 = __importDefault(require("node:assert"));
const live_runner_1 = require("../../live-runner");
const live_entity_1 = require("../../live-entity");
const __1 = require("../../..");
const utility_1 = require("../../utility");
(0, utility_1.loadEnvLocal)(__dirname + '/../../../.env.local');
(0, node_test_1.describe)('ChampionEntity', async () => {
    // Per-test live pacing. Delay is read from sdk-test-control.json's
    // `test.live.delayMs`; only sleeps when DATA_DRAGON_TEST_LIVE=TRUE.
    (0, node_test_1.afterEach)((0, utility_1.liveDelay)('DATA_DRAGON_TEST_LIVE'));
    (0, node_test_1.test)('instance', async () => {
        const testsdk = __1.DataDragonSDK.test();
        const ent = testsdk.Champion();
        (0, node_assert_1.default)(null != ent);
    });
    (0, node_test_1.test)('basic', async (t) => {
        const live = 'TRUE' === process.env.DATA_DRAGON_TEST_LIVE;
        for (const op of ['load']) {
            if (!live && (0, utility_1.maybeSkipControl)(t, 'entityOp', 'champion.' + op, live))
                return;
        }
        const setup = basicSetup();
        if (setup.live) {
            return (0, live_entity_1.runLiveEntity)(setup, { "active": true, "alias": { "field": {} }, "fields": { "id": { "a": true, "h": "Id", "n": "id", "r": false, "t": "`$STRING`", "key$": "id", "index$": 0 } }, "id": { "field": "id", "name": "id" }, "name": "champion", "op": { "load": { "input": "data", "name": "load", "points": [{ "a": true, "co": { "id": "GET /cdn/{version}/img/champion/{championImage}", "source": "openapi3", "version": 2 }, "g": { "params": [{ "a": true, "ex": "Ahri.png", "k": "param", "n": "id", "or": "championImage", "r": true, "t": "`$STRING`", "index$": 0 }, { "a": true, "ex": "12.6.1", "k": "param", "n": "version", "or": "version", "r": true, "t": "`$STRING`", "index$": 1 }] }, "k": "http", "m": "GET", "o": "/cdn/{version}/img/champion/{championImage}", "q": { "exist": ["id", "version"] }, "r": { "param": { "championImage": "id" } }, "s": [{ "lit": "cdn" }, { "var": "version" }, { "lit": "img" }, { "lit": "champion" }, { "var": "id" }], "t": { "req": "`reqdata`", "res": "`body`" }, "index$": 0 }], "key$": "load" } }, "relations": { "ancestors": [] }, "key$": "champion", "name__orig": "champion", "Name": "Champion", "name_": "champion", "name-": "champion", "NAME": "CHAMPION", "index$": 0 }, { "active": true, "entity": "champion", "key$": "BasicChampionFlow", "kind": "basic", "name": "BasicChampionFlow", "param": {}, "step": [{ "a": true, "d": {}, "i": { "ref": "champion_ref01", "srcdatavar": "champion_ref01_data", "suffix": "_dt0" }, "m": { "id": "champion01", "version": "version01" }, "o": "load", "s": [], "v": [{ "apply": "TextFieldMark", "def": { "mark": "Mark01-champion_ref01" } }], "index$": 0 }] }, 'Champion', { "GET /cdn/{version}/img/champion/{championImage}": { "protocol": "http", "parameters": [{ "name": "version", "in": "path", "required": true, "description": "Patch version (e.g., 12.6.1)", "schema": { "type": "string" }, "example": "12.6.1", "index$": 0 }, { "name": "championImage", "in": "path", "required": true, "description": "Champion image filename (e.g., Ahri.png)", "schema": { "type": "string" }, "example": "Ahri.png", "index$": 1 }] } });
        }
        const client = setup.client;
        const struct = setup.struct;
        const isempty = struct.isempty;
        const select = struct.select;
        let champion_ref01_data = Object.values(setup.data.existing.champion)[0];
        // LOAD
        const champion_ref01_ent = client.Champion();
        const champion_ref01_match_dt0 = {};
        champion_ref01_match_dt0.id = champion_ref01_data.id;
        const champion_ref01_data_dt0 = (await champion_ref01_ent.load(champion_ref01_match_dt0)).data();
        (0, node_assert_1.default)(champion_ref01_data_dt0.id === champion_ref01_data.id);
    });
});
function basicSetup(extra) {
    // TODO: fix test def options
    const options = {}; // null
    // TODO: needs test utility to resolve path
    const entityDataFile = node_path_1.default.resolve(__dirname, '../../../../.sdk/test/entity/champion/ChampionTestData.json');
    // TODO: file ready util needed?
    const entityDataSource = Fs.readFileSync(entityDataFile).toString('utf8');
    // TODO: need a xlang JSON parse utility in voxgig/struct with better error msgs
    const entityData = JSON.parse(entityDataSource);
    options.entity = entityData.existing;
    let client = __1.DataDragonSDK.test(options, extra);
    const struct = client.utility().struct;
    const merge = struct.merge;
    const transform = struct.transform;
    let idmap = transform(['champion01', 'champion02', 'champion03', 'version01'], {
        '`$PACK`': ['', {
                '`$KEY`': '`$COPY`',
                '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
            }]
    });
    const env = (0, utility_1.envOverride)({
        'DATA_DRAGON_TEST_CHAMPION_ENTID': idmap,
        'DATA_DRAGON_TEST_LIVE': 'FALSE',
        'DATA_DRAGON_TEST_EXPLAIN': 'FALSE',
    });
    idmap = env['DATA_DRAGON_TEST_CHAMPION_ENTID'];
    const live = 'TRUE' === env.DATA_DRAGON_TEST_LIVE;
    const transport = (0, live_runner_1.createLiveTransport)();
    if (live) {
        const rawIds = process.env['DATA_DRAGON_TEST_CHAMPION_ENTID'];
        idmap = rawIds && rawIds.trim() ? JSON.parse(rawIds) : {};
        if (!idmap || Array.isArray(idmap) || typeof idmap !== 'object') {
            throw new Error('Live ENTID must be a JSON object');
        }
        client = new __1.DataDragonSDK(merge([
            // FIRST, so the generated fields below win: sdk-test-control.json's
            // test.client.options adds to the live client, it does not redirect it.
            (0, utility_1.liveClientOptions)(),
            {},
            // 'extra || {}', not a bare 'extra': struct.merge returns UNDEFINED when the
            // last entry is undefined, and basicSetup is normally called with no
            // argument at all - so a bare 'extra' silently discarded the apikey
            // and server values above and handed the SDK undefined. Harmless
            // while there was nothing in that object; not harmless now.
            extra || {},
            { system: { fetch: transport.fetch } }
        ]));
    }
    const setup = {
        idmap,
        env,
        options,
        client,
        struct,
        data: entityData,
        explain: 'TRUE' === env.DATA_DRAGON_TEST_EXPLAIN,
        live,
        transport,
        now: Date.now(),
    };
    return setup;
}
//# sourceMappingURL=ChampionEntity.test.js.map