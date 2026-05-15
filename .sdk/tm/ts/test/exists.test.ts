
import { test, describe } from 'node:test'
import { equal } from 'node:assert'


import { DataDragonSDK } from '..'


describe('exists', async () => {

  test('test-mode', async () => {
    const testsdk = await DataDragonSDK.test()
    equal(null !== testsdk, true)
  })

})
