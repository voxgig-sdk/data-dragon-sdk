

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


describe('DragontailVersiontgzEntity', async () => {

  // Per-test live pacing. Delay is read from sdk-test-control.json's
  // `test.live.delayMs`; only sleeps when DATA_DRAGON_TEST_LIVE=TRUE.
  afterEach(liveDelay('DATA_DRAGON_TEST_LIVE'))

  test('instance', async () => {
    const testsdk = DataDragonSDK.test()
    const ent = testsdk.DragontailVersiontgz()
    assert(null != ent)
  })


  test('basic', async (t) => {

    const live = 'TRUE' === process.env.DATA_DRAGON_TEST_LIVE
    for (const op of ['load']) {
      if (!live && maybeSkipControl(t, 'entityOp', 'dragontail_versiontgz.' + op, live)) return
    }

    
    const setup = basicSetup()
    if (setup.live) {
      return runLiveEntity(setup, {"active":true,"alias":{"field":{}},"fields":{},"name":"dragontail_versiontgz","op":{"load":{"input":"data","name":"load","points":[{"a":true,"co":{"id":"GET /cdn/dragontail-{version}.tgz","source":"openapi3","version":2},"g":{"params":[{"a":true,"ex":"12.6.1","k":"param","n":"version","or":"version","r":true,"t":"`$STRING`","index$":0}]},"k":"http","m":"GET","o":"/cdn/dragontail-{version}.tgz","q":{"exist":["version"]},"r":{},"s":[{"lit":"cdn"},{"lit":"dragontail-{version}.tgz"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"load"}},"relations":{"ancestors":[]},"key$":"dragontail_versiontgz","name__orig":"dragontail_versiontgz","Name":"DragontailVersiontgz","name_":"dragontail_versiontgz","name-":"dragontail-versiontgz","NAME":"DRAGONTAIL_VERSIONTGZ","index$":4}, {"active":true,"entity":"dragontail_versiontgz","key$":"BasicDragontailVersiontgzFlow","kind":"basic","name":"BasicDragontailVersiontgzFlow","param":{},"step":[{"a":true,"d":{},"i":{"ref":"dragontail_versiontgz_ref01","srcdatavar":"dragontail_versiontgz_ref01_data","suffix":"_dt0"},"m":{"version":"version01"},"o":"load","s":[],"v":[{"apply":"TextFieldMark","def":{"mark":"Mark01-dragontail_versiontgz_ref01"}}],"index$":0}]}, 'DragontailVersiontgz', {"GET /cdn/dragontail-{version}.tgz":{"protocol":"http","parameters":[{"name":"version","in":"path","required":true,"description":"Patch version (e.g., 12.6.1)","schema":{"type":"string"},"example":"12.6.1","index$":0}]}})
    }
    const client = setup.client
    const struct = setup.struct

    const isempty = struct.isempty
    const select = struct.select

    let dragontail_versiontgz_ref01_data = Object.values(setup.data.existing.dragontail_versiontgz)[0] as any

    // LOAD: skipped — no entity id field and load requires path params.
    // Entity-var is declared here so later flow steps still compile.
    const dragontail_versiontgz_ref01_ent = client.DragontailVersiontgz()


  })
})



function basicSetup(extra?: any) {
  // TODO: fix test def options
  const options: any = {} // null

  // TODO: needs test utility to resolve path
  const entityDataFile =
    Path.resolve(__dirname, 
      '../../../../.sdk/test/entity/dragontail_versiontgz/DragontailVersiontgzTestData.json')

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
    ['dragontail_versiontgz01','dragontail_versiontgz02','dragontail_versiontgz03','version01'],
    {
      '`$PACK`': ['', {
        '`$KEY`': '`$COPY`',
        '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
      }]
    })

  const env = envOverride({
    'DATA_DRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID': idmap,
    'DATA_DRAGON_TEST_LIVE': 'FALSE',
    'DATA_DRAGON_TEST_EXPLAIN': 'FALSE',
  })

  idmap = env['DATA_DRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID']

  const live = 'TRUE' === env.DATA_DRAGON_TEST_LIVE

  const transport = createLiveTransport()
  if (live) {
    const rawIds = process.env['DATA_DRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID']
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
  
