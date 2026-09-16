

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


describe('RegionEntity', async () => {

  // Per-test live pacing. Delay is read from sdk-test-control.json's
  // `test.live.delayMs`; only sleeps when DATA_DRAGON_TEST_LIVE=TRUE.
  afterEach(liveDelay('DATA_DRAGON_TEST_LIVE'))

  test('instance', async () => {
    const testsdk = DataDragonSDK.test()
    const ent = testsdk.Region()
    assert(null != ent)
  })


  test('basic', async (t) => {

    const live = 'TRUE' === process.env.DATA_DRAGON_TEST_LIVE
    for (const op of ['load']) {
      if (!live && maybeSkipControl(t, 'entityOp', 'region.' + op, live)) return
    }

    
    const setup = basicSetup()
    if (setup.live) {
      return runLiveEntity(setup, {"active":true,"alias":{"field":{}},"fields":[{"active":true,"name":"champion","req":false,"type":"`$STRING`","index$":0},{"active":true,"name":"item","req":false,"type":"`$STRING`","index$":1},{"active":true,"name":"rune","req":false,"type":"`$STRING`","index$":2}],"name":"region","op":{"load":{"input":"data","name":"load","points":[{"active":true,"args":{"params":[{"active":true,"example":"na","kind":"param","name":"region","orig":"region","reqd":true,"type":"`$STRING`","index$":0}]},"contract":{"id":"GET /realms/{region}.json","json":"{\"operationId\":\"getRealmData\",\"parameters\":[{\"description\":\"Region code (e.g., na, euw, kr)\",\"example\":\"na\",\"in\":\"path\",\"name\":\"region\",\"required\":true,\"schema\":{\"enum\":[\"na\",\"euw\",\"eune\",\"kr\",\"br\",\"jp\",\"lan\",\"las\",\"oce\",\"tr\",\"ru\"],\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"cdn\":{\"description\":\"CDN base URL\",\"type\":\"string\"},\"n\":{\"properties\":{\"champion\":{\"type\":\"string\"},\"item\":{\"type\":\"string\"},\"rune\":{\"type\":\"string\"}},\"type\":\"object\"},\"v\":{\"description\":\"Current patch version\",\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"Successfully retrieved realm data\"}},\"securitySource\":\"unspecified\"}","source":"openapi3","version":1},"kind":"http","method":"GET","orig":"/realms/{region}.json","segments":[{"lit":"realms"},{"lit":"{region}.json"}],"select":{"exist":["region"]},"transform":{"req":"`reqdata`","res":"`body.n`"},"index$":0}],"key$":"load"}},"relations":{"ancestors":[]},"key$":"region","name__orig":"region","Name":"Region","name_":"region","name-":"region","NAME":"REGION","index$":6}, {"active":true,"entity":"region","key$":"BasicRegionFlow","kind":"basic","name":"BasicRegionFlow","param":{},"step":[{"active":true,"data":{},"input":{"ref":"region_ref01","srcdatavar":"region_ref01_data","suffix":"_dt0"},"match":{"region":"region01"},"op":"load","spec":[],"valid":[{"apply":"TextFieldMark","def":{"mark":"Mark01-region_ref01"}}],"index$":0}]}, 'Region')
    }
    const client = setup.client
    const struct = setup.struct

    const isempty = struct.isempty
    const select = struct.select

    let region_ref01_data = Object.values(setup.data.existing.region)[0] as any

    // LOAD: skipped — no entity id field and load requires path params.
    // Entity-var is declared here so later flow steps still compile.
    const region_ref01_ent = client.Region()


  })
})



function basicSetup(extra?: any) {
  // TODO: fix test def options
  const options: any = {} // null

  // TODO: needs test utility to resolve path
  const entityDataFile =
    Path.resolve(__dirname, 
      '../../../../.sdk/test/entity/region/RegionTestData.json')

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
    ['region01','region02','region03'],
    {
      '`$PACK`': ['', {
        '`$KEY`': '`$COPY`',
        '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
      }]
    })

  const env = envOverride({
    'DATA_DRAGON_TEST_REGION_ENTID': idmap,
    'DATA_DRAGON_TEST_LIVE': 'FALSE',
    'DATA_DRAGON_TEST_EXPLAIN': 'FALSE',
  })

  idmap = env['DATA_DRAGON_TEST_REGION_ENTID']

  const live = 'TRUE' === env.DATA_DRAGON_TEST_LIVE

  const transport = createLiveTransport()
  if (live) {
    const rawIds = process.env['DATA_DRAGON_TEST_REGION_ENTID']
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
  
