

import Path from 'node:path'
import * as Fs from 'node:fs'

import { test, describe, afterEach } from 'node:test'
import assert from 'node:assert'
import { createLiveTransport } from '../../live-runner'
import { runLiveEntity } from '../../live-entity'


import { DataDragonSDK, BaseFeature, stdutil } from '../../..'

import {
  envOverride,
  liveClientOptions,
  liveDelay,
  loadEnvLocal,
  makeCtrl,
  makeMatch,
  makeReqdata,
  makeStepData,
  makeValid,
  maybeSkipControl,
} from '../../utility'


// AFTER the imports on purpose: TypeScript hoists `import` above any
// statement in the emitted CommonJS, so a loader placed above them would
// run only after every imported module had already been evaluated - and
// anything reading process.env at module scope would miss these values.
loadEnvLocal(__dirname + '/../../../.env.local')


describe('DataChampionEntity', async () => {

  // Per-test live pacing. Delay is read from sdk-test-control.json's
  // `test.live.delayMs`; only sleeps when DATA_DRAGON_TEST_LIVE=TRUE.
  afterEach(liveDelay('DATA_DRAGON_TEST_LIVE'))

  test('instance', async () => {
    const testsdk = DataDragonSDK.test()
    const ent = testsdk.DataChampion()
    assert(null != ent)
  })


  test('basic', async (t) => {

    const live = 'TRUE' === process.env.DATA_DRAGON_TEST_LIVE
    for (const op of ['load']) {
      if (!live && maybeSkipControl(t, 'entityOp', 'data_champion.' + op, live)) return
    }

    
    const setup = basicSetup()
    if (setup.live) {
      return runLiveEntity(setup, {"active":true,"alias":{"field":{}},"fields":[{"active":true,"name":"image","req":false,"type":"`$OBJECT`","index$":0},{"active":true,"name":"key","req":false,"short":"Champion ID","type":"`$STRING`","index$":1},{"active":true,"name":"name","req":false,"short":"Champion name","type":"`$STRING`","index$":2},{"active":true,"name":"title","req":false,"short":"Champion title","type":"`$STRING`","index$":3}],"name":"data_champion","op":{"load":{"input":"data","name":"load","points":[{"active":true,"args":{"params":[{"active":true,"example":"en_US","kind":"param","name":"language","orig":"language","reqd":true,"type":"`$STRING`","index$":0},{"active":true,"example":"12.6.1","kind":"param","name":"version","orig":"version","reqd":true,"type":"`$STRING`","index$":1}]},"contract":{"id":"GET /cdn/{version}/data/{language}/champion.json","json":"{\"operationId\":\"getChampionData\",\"parameters\":[{\"description\":\"Patch version (e.g., 12.6.1)\",\"example\":\"12.6.1\",\"in\":\"path\",\"name\":\"version\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"description\":\"Language code (e.g., en_US, ko_KR, ja_JP)\",\"example\":\"en_US\",\"in\":\"path\",\"name\":\"language\",\"required\":true,\"schema\":{\"enum\":[\"cs_CZ\",\"el_GR\",\"pl_PL\",\"ro_RO\",\"hu_HU\",\"en_GB\",\"de_DE\",\"es_ES\",\"it_IT\",\"fr_FR\",\"ja_JP\",\"ko_KR\",\"es_MX\",\"es_AR\",\"pt_BR\",\"en_US\",\"en_AU\",\"ru_RU\",\"tr_TR\",\"ms_MY\",\"en_PH\",\"en_SG\",\"th_TH\",\"vn_VN\",\"id_ID\",\"zh_MY\",\"zh_CN\",\"zh_TW\"],\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"data\":{\"additionalProperties\":{\"properties\":{\"image\":{\"properties\":{\"full\":{\"description\":\"Image filename\",\"type\":\"string\"}},\"type\":\"object\"},\"key\":{\"description\":\"Champion ID\",\"type\":\"string\"},\"name\":{\"description\":\"Champion name\",\"type\":\"string\"},\"title\":{\"description\":\"Champion title\",\"type\":\"string\"}},\"type\":\"object\"},\"type\":\"object\"},\"format\":{\"type\":\"string\"},\"type\":{\"type\":\"string\"},\"version\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"Successfully retrieved champion data\",\"headers\":{\"Accept-Charset\":{\"description\":\"Response encoding (UTF-8)\",\"schema\":{\"type\":\"string\"}}}}},\"securitySource\":\"unspecified\"}","source":"openapi3","version":1},"kind":"http","method":"GET","orig":"/cdn/{version}/data/{language}/champion.json","segments":[{"lit":"cdn"},{"var":"version"},{"lit":"data"},{"var":"language"},{"lit":"champion.json"}],"select":{"exist":["language","version"]},"transform":{"req":"`reqdata`","res":"`body.data`"},"index$":0}],"key$":"load"}},"relations":{"ancestors":[["cdn","data"]]},"key$":"data_champion","name__orig":"data_champion","Name":"DataChampion","name_":"data_champion","name-":"data-champion","NAME":"DATA_CHAMPION","index$":1}, {"active":true,"entity":"data_champion","key$":"BasicDataChampionFlow","kind":"basic","name":"BasicDataChampionFlow","param":{},"step":[{"active":true,"data":{},"input":{"ref":"data_champion_ref01","srcdatavar":"data_champion_ref01_data","suffix":"_dt0"},"match":{"id":"data_champion01","version":"version01"},"op":"load","spec":[],"valid":[{"apply":"TextFieldMark","def":{"mark":"Mark01-data_champion_ref01"}}],"index$":0}]}, 'DataChampion')
    }
    const client = setup.client
    const struct = setup.struct

    const isempty = struct.isempty
    const select = struct.select

    let data_champion_ref01_data = Object.values(setup.data.existing.data_champion)[0] as any

    // LOAD: skipped — no entity id field and load requires path params.
    // Entity-var is declared here so later flow steps still compile.
    const data_champion_ref01_ent = client.DataChampion()


  })
})



function basicSetup(extra?: any) {
  // TODO: fix test def options
  const options: any = {} // null

  // TODO: needs test utility to resolve path
  const entityDataFile =
    Path.resolve(__dirname, 
      '../../../../.sdk/test/entity/data_champion/DataChampionTestData.json')

  // TODO: file ready util needed?
  const entityDataSource = Fs.readFileSync(entityDataFile).toString('utf8')

  // TODO: need a xlang JSON parse utility in voxgig/struct with better error msgs
  const entityData = JSON.parse(entityDataSource)

  options.entity = entityData.existing

  let client = DataDragonSDK.test(options, extra)
  const struct = client.utility().struct
  const merge = struct.merge
  const transform = struct.transform

  let idmap = transform(
    ['data_champion01','data_champion02','data_champion03','cdn01','cdn02','cdn03','data01','data02','data03'],
    {
      '`$PACK`': ['', {
        '`$KEY`': '`$COPY`',
        '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
      }]
    })

  const env = envOverride({
    'DATA_DRAGON_TEST_DATA_CHAMPION_ENTID': idmap,
    'DATA_DRAGON_TEST_LIVE': 'FALSE',
    'DATA_DRAGON_TEST_EXPLAIN': 'FALSE',
  })

  idmap = env['DATA_DRAGON_TEST_DATA_CHAMPION_ENTID']

  const live = 'TRUE' === env.DATA_DRAGON_TEST_LIVE

  const transport = createLiveTransport()
  if (live) {
    const rawIds = process.env['DATA_DRAGON_TEST_DATA_CHAMPION_ENTID']
    idmap = rawIds && rawIds.trim() ? JSON.parse(rawIds) : {}
    if (!idmap || Array.isArray(idmap) || typeof idmap !== 'object') {
      throw new Error('Live ENTID must be a JSON object')
    }
    client = new DataDragonSDK(merge([
      // FIRST, so the generated fields below win: sdk-test-control.json's
      // test.client.options adds to the live client, it does not redirect it.
      liveClientOptions(),
      {
      },
      // 'extra || {}', not a bare 'extra': struct.merge returns UNDEFINED when the
      // last entry is undefined, and basicSetup is normally called with no
      // argument at all - so a bare 'extra' silently discarded the apikey
      // and server values above and handed the SDK undefined. Harmless
      // while there was nothing in that object; not harmless now.
      extra || {},
      { system: { fetch: transport.fetch } }
    ]))
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
  }

  return setup
}
  
