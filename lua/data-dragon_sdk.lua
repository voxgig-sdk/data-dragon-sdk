-- DataDragon SDK

local vs = require("utility.struct.struct")
local Utility = require("core.utility_type")
local Spec = require("core.spec")
local helpers = require("core.helpers")

-- Load utility registration (populates Utility._registrar)
require("utility.register")

-- Typed-model annotations (LuaLS ---@class); empty at runtime.
require("data-dragon_types")

-- Load features
local BaseFeature = require("feature.base_feature")
local features_factory = require("features")


local DataDragonSDK = {}
DataDragonSDK.__index = DataDragonSDK


local function _make_feature(name)
  local factory = features_factory[name]
  if factory ~= nil then
    return factory()
  end
  return features_factory.base()
end

DataDragonSDK._make_feature = _make_feature


function DataDragonSDK.new(options)
  local self = setmetatable({}, DataDragonSDK)
  self.mode = "live"
  self.features = {}
  self.options = nil

  local utility = Utility.new()
  self._utility = utility

  local config = require("config_shared")()

  self._rootctx = utility.make_context({
    client = self,
    utility = utility,
    config = config,
    options = options or {},
    shared = {},
  }, nil)

  self.options = utility.make_options(self._rootctx)

  if vs.getpath(self.options, "feature.test.active") == true then
    self.mode = "test"
  end

  self._rootctx.options = self.options

  -- Add features in the resolved order (make_options puts an explicit list
  -- order first, else defaults to test-first). Ordering matters: the `test`
  -- feature installs the base mock transport and the transport features
  -- (retry/cache/netsim/proxy/ratelimit) wrap whatever is current, so `test`
  -- must be added before them to sit at the base of the chain.
  local feature_opts = helpers.to_map(vs.getprop(self.options, "feature"))
  if feature_opts ~= nil then
    local featureorder = vs.getpath(self.options, "__derived__.featureorder")
    if type(featureorder) == "table" then
      for _, fname in ipairs(featureorder) do
        local fopts = helpers.to_map(feature_opts[fname])
        if fopts ~= nil and fopts["active"] == true then
          utility.feature_add(self._rootctx, _make_feature(fname))
        end
      end
    end
  end

  -- Add extension features.
  local extend = vs.getprop(self.options, "extend")
  if type(extend) == "table" then
    for _, f in ipairs(extend) do
      if type(f) == "table" and type(f.get_name) == "function" then
        utility.feature_add(self._rootctx, f)
      end
    end
  end

  -- CONSUMED, not kept. `extend` holds feature INSTANCES, and every shipped
  -- feature's init stores `self.client = ctx.client` - so leaving the list
  -- in self.options makes the options map CYCLIC (client.options.extend[1]
  -- .client == client), and options_map()'s vs.clone, which has no cycle
  -- guard, blew the stack on the first prepare_auth of any client built with
  -- an extend feature. The instances live on self.features from here on,
  -- which is the only place anything reads them; the SAME table is
  -- self._rootctx.options, so the root context loses the key too.
  self.options["extend"] = nil

  -- Initialize features.
  for _, f in ipairs(self.features) do
    utility.feature_init(self._rootctx, f)
  end

  utility.feature_hook(self._rootctx, "PostConstruct")

    -- feature: test


  return self
end


function DataDragonSDK:options_map()
  local out = vs.clone(self.options)
  if type(out) == "table" then
    return out
  end
  return {}
end


function DataDragonSDK:get_utility()
  return Utility.copy(self._utility)
end


function DataDragonSDK:get_root_ctx()
  return self._rootctx
end


function DataDragonSDK:prepare(fetchargs)
  local utility = self._utility

  fetchargs = fetchargs or {}

  local ctrl = helpers.to_map(vs.getprop(fetchargs, "ctrl")) or {}

  local ctx = utility.make_context({
    opname = "prepare",
    ctrl = ctrl,
  }, self._rootctx)

  local options = self.options

  local path = vs.getprop(fetchargs, "path") or ""
  if type(path) ~= "string" then path = "" end

  local method = vs.getprop(fetchargs, "method") or "GET"
  if type(method) ~= "string" then method = "GET" end

  local params = helpers.to_map(vs.getprop(fetchargs, "params")) or {}
  local query = helpers.to_map(vs.getprop(fetchargs, "query")) or {}

  local headers = utility.prepare_headers(ctx)

  local base = vs.getprop(options, "base") or ""
  if type(base) ~= "string" then base = "" end
  local prefix = vs.getprop(options, "prefix") or ""
  if type(prefix) ~= "string" then prefix = "" end
  local suffix = vs.getprop(options, "suffix") or ""
  if type(suffix) ~= "string" then suffix = "" end

  ctx.spec = Spec.new({
    base = base,
    prefix = prefix,
    suffix = suffix,
    path = path,
    method = method,
    params = params,
    query = query,
    headers = headers,
    body = vs.getprop(fetchargs, "body"),
    step = "start",
  })

  -- Merge user-provided headers.
  local uh = vs.getprop(fetchargs, "headers")
  if type(uh) == "table" then
    for k, v in pairs(uh) do
      ctx.spec.headers[k] = v
    end
  end

  local _, err = utility.prepare_auth(ctx)
  if err ~= nil then
    return nil, err
  end

  return utility.make_fetch_def(ctx)
end


-- Raw endpoint access is operator-controllable, like every entity op.
-- Blocking it means denying BOTH the 'direct' and 'graphql' tokens, since
-- either one reaches the same endpoint.
function DataDragonSDK:direct(fetchargs)
  if not self:_op_allowed("direct") then
    return self:_op_denied("direct"), nil
  end

  return self:_raw_request(fetchargs)
end


-- Is this raw-access op permitted by the SDK's allow.op option?
function DataDragonSDK:_op_allowed(op)
  local allow = vs.getpath(self.options, "allow.op")
  return type(allow) == "string" and allow:find(op, 1, true) ~= nil
end


function DataDragonSDK:_op_denied(op)
  local allow = vs.getpath(self.options, "allow.op")
  if type(allow) ~= "string" then allow = "" end
  return {
    ok = false,
    err = "DataDragonSDK: " .. op .. ": operation not allowed by" ..
      " SDK option allow.op value: \"" .. allow .. "\"",
  }
end


-- Ungated request path shared by direct and graphql, each of which checks its
-- own allow.op token first. Private, rather than a flag on fetchargs: a
-- caller-supplied marker would let anyone opt straight back out of the gate
-- by passing it.
function DataDragonSDK:_raw_request(fetchargs)
  local utility = self._utility

  local fetchdef, err = self:prepare(fetchargs)
  if err ~= nil then
    return { ok = false, err = err }, nil
  end

  fetchargs = fetchargs or {}
  local ctrl = helpers.to_map(vs.getprop(fetchargs, "ctrl")) or {}

  local ctx = utility.make_context({
    opname = "direct",
    ctrl = ctrl,
  }, self._rootctx)

  local url = fetchdef["url"] or ""
  local fetched, fetch_err = utility.fetcher(ctx, url, fetchdef)

  if fetch_err ~= nil then
    return { ok = false, err = fetch_err }, nil
  end

  if fetched == nil then
    return {
      ok = false,
      err = ctx:make_error("direct_no_response", "response: undefined"),
    }, nil
  end

  if type(fetched) == "table" then
    local status = helpers.to_int(vs.getprop(fetched, "status"))
    local headers = vs.getprop(fetched, "headers") or {}

    -- No-body responses (204, 304) and explicit zero content-length
    -- must skip JSON parsing — calling json() on an empty body errors.
    local content_length = nil
    if type(headers) == "table" then
      content_length = headers["content-length"]
    end
    local no_body = status == 204 or status == 304 or tostring(content_length) == "0"

    local json_data = nil
    if not no_body then
      local jf = vs.getprop(fetched, "json")
      if type(jf) == "function" then
        local ok, result = pcall(jf)
        if ok then
          json_data = result
        end
        -- Non-JSON body: json_data stays nil, status/headers preserved.
      end
    end

    return {
      ok = status >= 200 and status < 300,
      status = status,
      headers = headers,
      data = json_data,
    }, nil
  end

  return {
    ok = false,
    err = ctx:make_error("direct_invalid", "invalid response type"),
  }, nil
end


-- Raw GraphQL access: the pressure valve that makes the generated surface's
-- deliberate omissions (per-call selection sets, typed filter builders,
-- batching, subscriptions) livable — the whole schema stays reachable.
--
-- Thin wrapper over the same prepare/fetch path direct uses, with the one
-- thing raw direct cannot do for GraphQL: a GraphQL failure rides HTTP 200 as
-- a top-level `errors` array, so status alone would report a failed query as
-- ok.
--
-- NOTE: like direct, this bypasses the feature pipeline — no retry, ratelimit
-- or paging features apply.
function DataDragonSDK:graphql(query, variables, ctrl)
  if not self:_op_allowed("graphql") then
    return self:_op_denied("graphql"), nil
  end

  local res, err = self:_raw_request({
    method = "POST",
    headers = { ["content-type"] = "application/json" },
    body = {
      query = query,
      variables = type(variables) == "table" and variables or {},
    },
    ctrl = type(ctrl) == "table" and ctrl or {},
  })

  if err ~= nil or type(res) ~= "table" then
    return res, err
  end

  -- Errors are read BEFORE any status check: a GraphQL parse or validation
  -- failure comes back as HTTP 400 carrying the standard { errors = {...} }
  -- body, and the raw path represents a non-2xx as ok=false with no err — so
  -- returning early on status would discard the server's own diagnostics,
  -- which are the only useful part of that response.
  local errors = vs.getpath(res, "data.errors")

  if type(errors) == "table" and 0 < #errors then
    local msg = vs.getprop(errors[1], "message")
    if type(msg) ~= "string" or msg == "" then
      msg = "graphql error"
    end
    res.ok = false
    res.err = "DataDragonSDK: graphql: " .. msg
    res.graphql = errors
  end

  return res, nil
end



-- Idiomatic facade: client:Champion():list() / client:Champion():load({ id = ... })
-- Entity access is capitalised (PascalCase) for parity with the other SDKs.
function DataDragonSDK:Champion(data)
  local EntityMod = require("entity.champion_entity")
  if data == nil then
    if self._champion == nil then
      self._champion = EntityMod.new(self, nil)
    end
    return self._champion
  end
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:DataChampion():list() / client:DataChampion():load({ id = ... })
-- Entity access is capitalised (PascalCase) for parity with the other SDKs.
function DataDragonSDK:DataChampion(data)
  local EntityMod = require("entity.data_champion_entity")
  if data == nil then
    if self._data_champion == nil then
      self._data_champion = EntityMod.new(self, nil)
    end
    return self._data_champion
  end
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:DataItem():list() / client:DataItem():load({ id = ... })
-- Entity access is capitalised (PascalCase) for parity with the other SDKs.
function DataDragonSDK:DataItem(data)
  local EntityMod = require("entity.data_item_entity")
  if data == nil then
    if self._data_item == nil then
      self._data_item = EntityMod.new(self, nil)
    end
    return self._data_item
  end
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:DataRune():list() / client:DataRune():load({ id = ... })
-- Entity access is capitalised (PascalCase) for parity with the other SDKs.
function DataDragonSDK:DataRune(data)
  local EntityMod = require("entity.data_rune_entity")
  if data == nil then
    if self._data_rune == nil then
      self._data_rune = EntityMod.new(self, nil)
    end
    return self._data_rune
  end
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:DragontailVersiontgz():list() / client:DragontailVersiontgz():load({ id = ... })
-- Entity access is capitalised (PascalCase) for parity with the other SDKs.
function DataDragonSDK:DragontailVersiontgz(data)
  local EntityMod = require("entity.dragontail_versiontgz_entity")
  if data == nil then
    if self._dragontail_versiontgz == nil then
      self._dragontail_versiontgz = EntityMod.new(self, nil)
    end
    return self._dragontail_versiontgz
  end
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:Item():list() / client:Item():load({ id = ... })
-- Entity access is capitalised (PascalCase) for parity with the other SDKs.
function DataDragonSDK:Item(data)
  local EntityMod = require("entity.item_entity")
  if data == nil then
    if self._item == nil then
      self._item = EntityMod.new(self, nil)
    end
    return self._item
  end
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:Region():list() / client:Region():load({ id = ... })
-- Entity access is capitalised (PascalCase) for parity with the other SDKs.
function DataDragonSDK:Region(data)
  local EntityMod = require("entity.region_entity")
  if data == nil then
    if self._region == nil then
      self._region = EntityMod.new(self, nil)
    end
    return self._region
  end
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:Version():list() / client:Version():load({ id = ... })
-- Entity access is capitalised (PascalCase) for parity with the other SDKs.
function DataDragonSDK:Version(data)
  local EntityMod = require("entity.version_entity")
  if data == nil then
    if self._version == nil then
      self._version = EntityMod.new(self, nil)
    end
    return self._version
  end
  return EntityMod.new(self, data)
end




function DataDragonSDK.test(testopts, sdkopts)
  sdkopts = sdkopts or {}
  sdkopts = vs.clone(sdkopts)
  if type(sdkopts) ~= "table" then
    sdkopts = {}
  end

  testopts = testopts or {}
  testopts = vs.clone(testopts)
  if type(testopts) ~= "table" then
    testopts = {}
  end
  testopts["active"] = true

  vs.setpath(sdkopts, "feature.test", testopts)

  local sdk = DataDragonSDK.new(sdkopts)
  sdk.mode = "test"

  return sdk
end


return DataDragonSDK
