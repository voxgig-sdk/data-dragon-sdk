
import { test, describe } from 'node:test'
import { equal } from 'node:assert'


import { DataDragonSDK } from '..'


describe('exists', async () => {

  test('test-mode', () => {
    const testsdk = DataDragonSDK.test()
    equal(testsdk instanceof DataDragonSDK, true,
      'DataDragonSDK.test() must return a client synchronously')
  })

})
