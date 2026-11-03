# DataDragon SDK utility: prepare_body
require_relative 'media'
module DataDragonUtilities
  PrepareBody = ->(ctx) {
    return nil unless ctx.op.input == "data"
    return DataDragonUtilities.raw_body(ctx.reqdata) if DataDragonUtilities.raw_request?(ctx.point)
    ctx.utility.transform_request.call(ctx)
  }
end
