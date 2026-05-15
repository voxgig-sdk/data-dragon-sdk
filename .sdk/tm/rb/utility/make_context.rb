# DataDragon SDK utility: make_context
require_relative '../core/context'
module DataDragonUtilities
  MakeContext = ->(ctxmap, basectx) {
    DataDragonContext.new(ctxmap, basectx)
  }
end
