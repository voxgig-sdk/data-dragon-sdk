

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


describe('ItemEntity', async () => {

  // Per-test live pacing. Delay is read from sdk-test-control.json's
  // `test.live.delayMs`; only sleeps when DATA_DRAGON_TEST_LIVE=TRUE.
  afterEach(liveDelay('DATA_DRAGON_TEST_LIVE'))

  test('instance', async () => {
    const testsdk = DataDragonSDK.test()
    const ent = testsdk.Item()
    assert(null != ent)
  })


  test('basic', async (t) => {

    const live = 'TRUE' === process.env.DATA_DRAGON_TEST_LIVE
    for (const op of ['load']) {
      if (!live && maybeSkipControl(t, 'entityOp', 'item.' + op, live)) return
    }

    
    const setup = basicSetup()
    if (setup.live) {
      return runLiveEntity(setup, {"active":true,"alias":{"field":{}},"fields":{"id":{"a":true,"h":"Id","n":"id","r":false,"t":"`$STRING`","key$":"id","index$":0}},"id":{"field":"id","name":"id"},"name":"item","op":{"load":{"input":"data","name":"load","points":[{"a":true,"co":{"id":"GET /cdn/{version}/img/item/{itemImage}","source":"openapi3","version":2},"g":{"params":[{"a":true,"ex":"1001.png","k":"param","n":"id","or":"itemImage","r":true,"t":"`$STRING`","index$":0},{"a":true,"ex":"12.6.1","k":"param","n":"version","or":"version","r":true,"t":"`$STRING`","index$":1}]},"k":"http","m":"GET","o":"/cdn/{version}/img/item/{itemImage}","q":{"exist":["id","version"]},"r":{"param":{"itemImage":"id"}},"s":[{"lit":"cdn"},{"var":"version"},{"lit":"img"},{"lit":"item"},{"var":"id"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"load"}},"relations":{"ancestors":[]},"key$":"item","name__orig":"item","Name":"Item","name_":"item","name-":"item","NAME":"ITEM","index$":5}, {"active":true,"entity":"item","key$":"BasicItemFlow","kind":"basic","name":"BasicItemFlow","param":{},"step":[{"a":true,"d":{},"i":{"ref":"item_ref01","srcdatavar":"item_ref01_data","suffix":"_dt0"},"m":{"id":"item01","version":"version01"},"o":"load","s":[],"v":[{"apply":"TextFieldMark","def":{"mark":"Mark01-item_ref01"}}],"index$":0}]}, 'Item', {"GET /cdn/{version}/img/item/{itemImage}":{"protocol":"http","parameters":[{"name":"version","in":"path","required":true,"description":"Patch version (e.g., 12.6.1)","schema":{"type":"string"},"example":"12.6.1","index$":0},{"name":"itemImage","in":"path","required":true,"description":"Item image filename (e.g., 1001.png)","schema":{"type":"string"},"example":"1001.png","index$":1}]}})
    }
    const client = setup.client
    const struct = setup.struct

    const isempty = struct.isempty
    const select = struct.select

    let item_ref01_data = Object.values(setup.data.existing.item)[0] as any

    // LOAD
    const item_ref01_ent = client.Item()
    const item_ref01_match_dt0: any = {}
    item_ref01_match_dt0.id = item_ref01_data.id
    const item_ref01_data_dt0 = (await item_ref01_ent.load(item_ref01_match_dt0)).data()
    assert(item_ref01_data_dt0.id === item_ref01_data.id)


  })
})



function basicSetup(extra?: any) {
  // TODO: fix test def options
  const options: any = {} // null

  // TODO: needs test utility to resolve path
  const entityDataFile =
    Path.resolve(__dirname, 
      '../../../../.sdk/test/entity/item/ItemTestData.json')

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
    ['item01','item02','item03','version01'],
    {
      '`$PACK`': ['', {
        '`$KEY`': '`$COPY`',
        '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
      }]
    })

  const env = envOverride({
    'DATA_DRAGON_TEST_ITEM_ENTID': idmap,
    'DATA_DRAGON_TEST_LIVE': 'FALSE',
    'DATA_DRAGON_TEST_EXPLAIN': 'FALSE',
  })

  idmap = env['DATA_DRAGON_TEST_ITEM_ENTID']

  const live = 'TRUE' === env.DATA_DRAGON_TEST_LIVE

  const transport = createLiveTransport()
  if (live) {
    const rawIds = process.env['DATA_DRAGON_TEST_ITEM_ENTID']
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
  
