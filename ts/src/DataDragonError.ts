
import { Context } from './Context'


class DataDragonError extends Error {

  isDataDragonError = true

  sdk = 'DataDragon'

  code: string
  ctx: Context

  constructor(code: string, msg: string, ctx: Context) {
    super(msg)
    this.code = code
    this.ctx = ctx
  }

}

export {
  DataDragonError
}

