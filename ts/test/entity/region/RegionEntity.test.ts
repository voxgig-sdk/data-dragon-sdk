

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
      return runLiveEntity(setup, {"active":true,"alias":{"field":{}},"fields":{"cdn":{"a":true,"h":"Cdn","n":"cdn","r":false,"sh":"CDN base URL","t":"`$STRING`","key$":"cdn","index$":0},"n":{"a":true,"h":"N","n":"n","r":false,"t":"`$OBJECT`","key$":"n","index$":1},"v":{"a":true,"h":"V","n":"v","r":false,"sh":"Current patch version","t":"`$STRING`","key$":"v","index$":2}},"name":"region","op":{"load":{"input":"data","name":"load","points":[{"a":true,"co":{"id":"GET /realms/{region}.json","source":"openapi3","version":2},"g":{"params":[{"a":true,"ex":"na","k":"param","n":"region","or":"region","r":true,"t":"`$STRING`","index$":0}]},"k":"http","m":"GET","o":"/realms/{region}.json","q":{"exist":["region"]},"r":{},"s":[{"lit":"realms"},{"lit":"{region}.json"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"load"}},"relations":{"ancestors":[]},"key$":"region","name__orig":"region","Name":"Region","name_":"region","name-":"region","NAME":"REGION","index$":6}, {"active":true,"entity":"region","key$":"BasicRegionFlow","kind":"basic","name":"BasicRegionFlow","param":{},"step":[{"a":true,"d":{},"i":{"ref":"region_ref01","srcdatavar":"region_ref01_data","suffix":"_dt0"},"m":{"region":"region01"},"o":"load","s":[],"v":[{"apply":"TextFieldMark","def":{"mark":"Mark01-region_ref01"}}],"index$":0}]}, 'Region', {"GET /realms/{region}.json":{"protocol":"http","parameters":[{"name":"region","in":"path","required":true,"description":"Region code (e.g., na, euw, kr)","schema":{"type":"string","enum":["na","euw","eune","kr","br","jp","lan","las","oce","tr","ru"]},"example":"na","index$":0}]}})
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
  
