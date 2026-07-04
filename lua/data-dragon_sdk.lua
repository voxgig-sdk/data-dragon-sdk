-- DataDragon SDK

local vs = require("utility.struct.struct")
local Utility = require("core.utility_type")
local Spec = require("core.spec")
local helpers = require("core.helpers")

-- Load utility registration (populates Utility._registrar)
require("utility.register")

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

  local config = require("config")()

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

  -- Add features from config.
  local feature_opts = helpers.to_map(vs.getprop(self.options, "feature"))
  if feature_opts ~= nil then
    local feature_items = vs.items(feature_opts)
    if feature_items ~= nil then
      for _, item in ipairs(feature_items) do
        local fname = item[1]
        local fopts = helpers.to_map(item[2])
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

  -- Initialize features.
  for _, f in ipairs(self.features) do
    utility.feature_init(self._rootctx, f)
  end

  utility.feature_hook(self._rootctx, "PostConstruct")

  -- #BuildFeatures

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


function DataDragonSDK:direct(fetchargs)
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



-- Idiomatic facade: client:champion():list() / client:champion():load({ id = ... })
function DataDragonSDK:champion(data)
  local EntityMod = require("entity.champion_entity")
  if data == nil then
    if self._champion == nil then
      self._champion = EntityMod.new(self, nil)
    end
    return self._champion
  end
  return EntityMod.new(self, data)
end

-- Deprecated: use client:champion() instead.
function DataDragonSDK:Champion(data)
  local EntityMod = require("entity.champion_entity")
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:data_champion():list() / client:data_champion():load({ id = ... })
function DataDragonSDK:data_champion(data)
  local EntityMod = require("entity.data_champion_entity")
  if data == nil then
    if self._data_champion == nil then
      self._data_champion = EntityMod.new(self, nil)
    end
    return self._data_champion
  end
  return EntityMod.new(self, data)
end

-- Deprecated: use client:data_champion() instead.
function DataDragonSDK:DataChampion(data)
  local EntityMod = require("entity.data_champion_entity")
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:data_item():list() / client:data_item():load({ id = ... })
function DataDragonSDK:data_item(data)
  local EntityMod = require("entity.data_item_entity")
  if data == nil then
    if self._data_item == nil then
      self._data_item = EntityMod.new(self, nil)
    end
    return self._data_item
  end
  return EntityMod.new(self, data)
end

-- Deprecated: use client:data_item() instead.
function DataDragonSDK:DataItem(data)
  local EntityMod = require("entity.data_item_entity")
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:data_rune():list() / client:data_rune():load({ id = ... })
function DataDragonSDK:data_rune(data)
  local EntityMod = require("entity.data_rune_entity")
  if data == nil then
    if self._data_rune == nil then
      self._data_rune = EntityMod.new(self, nil)
    end
    return self._data_rune
  end
  return EntityMod.new(self, data)
end

-- Deprecated: use client:data_rune() instead.
function DataDragonSDK:DataRune(data)
  local EntityMod = require("entity.data_rune_entity")
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:dragontail_versiontgz():list() / client:dragontail_versiontgz():load({ id = ... })
function DataDragonSDK:dragontail_versiontgz(data)
  local EntityMod = require("entity.dragontail_versiontgz_entity")
  if data == nil then
    if self._dragontail_versiontgz == nil then
      self._dragontail_versiontgz = EntityMod.new(self, nil)
    end
    return self._dragontail_versiontgz
  end
  return EntityMod.new(self, data)
end

-- Deprecated: use client:dragontail_versiontgz() instead.
function DataDragonSDK:DragontailVersiontgz(data)
  local EntityMod = require("entity.dragontail_versiontgz_entity")
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:item():list() / client:item():load({ id = ... })
function DataDragonSDK:item(data)
  local EntityMod = require("entity.item_entity")
  if data == nil then
    if self._item == nil then
      self._item = EntityMod.new(self, nil)
    end
    return self._item
  end
  return EntityMod.new(self, data)
end

-- Deprecated: use client:item() instead.
function DataDragonSDK:Item(data)
  local EntityMod = require("entity.item_entity")
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:region():list() / client:region():load({ id = ... })
function DataDragonSDK:region(data)
  local EntityMod = require("entity.region_entity")
  if data == nil then
    if self._region == nil then
      self._region = EntityMod.new(self, nil)
    end
    return self._region
  end
  return EntityMod.new(self, data)
end

-- Deprecated: use client:region() instead.
function DataDragonSDK:Region(data)
  local EntityMod = require("entity.region_entity")
  return EntityMod.new(self, data)
end


-- Idiomatic facade: client:version():list() / client:version():load({ id = ... })
function DataDragonSDK:version(data)
  local EntityMod = require("entity.version_entity")
  if data == nil then
    if self._version == nil then
      self._version = EntityMod.new(self, nil)
    end
    return self._version
  end
  return EntityMod.new(self, data)
end

-- Deprecated: use client:version() instead.
function DataDragonSDK:Version(data)
  local EntityMod = require("entity.version_entity")
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
