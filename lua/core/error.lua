-- DataDragon SDK error

local DataDragonError = {}
DataDragonError.__index = DataDragonError


function DataDragonError.new(code, msg, ctx)
  local self = setmetatable({}, DataDragonError)
  self.is_sdk_error = true
  self.sdk = "DataDragon"
  self.code = code or ""
  self.msg = msg or ""
  self.ctx = ctx
  self.result = nil
  self.spec = nil
  return self
end


function DataDragonError:error()
  return self.msg
end


function DataDragonError:__tostring()
  return self.msg
end


return DataDragonError
