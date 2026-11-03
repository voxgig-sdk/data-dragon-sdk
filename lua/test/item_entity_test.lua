-- Item entity test

local json = require("dkjson")
local vs = require("utility.struct.struct")
local sdk = require("data-dragon_sdk")
local helpers = require("core.helpers")
local runner = require("test.runner")

local _test_dir = debug.getinfo(1, "S").source:match("^@(.+/)")  or "./"

-- main.kit.test.live.strict is true (the default is true): a live
-- request that fails, or a live test missing an input it needs,
-- fails the test.
-- An account with no record for a test to read skips it either way.
local LIVE_STRICT = true


describe("ItemEntity", function()
  it("should create instance", function()
    local testsdk = sdk.test(nil, nil)
    local ent = testsdk:Item(nil)
    assert.is_not_nil(ent)
  end)

  it("should refuse an invalid request", function()
    local config = require("config_shared")()
    if type(config.feature) ~= "table" or config.feature.validate == nil then
      pending("feature not present in this SDK: validate")
      return
    end
    local client = sdk.test(nil, { feature = { validate = { active = true } } })
    local _, err = client:Item(nil):load({ ["id"] = 1, ["version"] = "x" }, nil)
    assert.are.equal("validate_failed", type(err) == "table" and err.code or nil)
  end)

  it("should run basic flow", function()
    local setup = item_basic_setup(nil)
    -- Per-op sdk-test-control.json skip.
    local _live = setup.live or false
    for _, _op in ipairs({"load"}) do
      local _should_skip, _reason = runner.is_control_skipped("entityOp", "item." .. _op, _live and "live" or "unit")
      if _should_skip then
        pending(_reason or "skipped via sdk-test-control.json")
        return
      end
    end
    if setup.live then
      for _live_key, _live_ex in pairs({["item01"] = "1001.png", ["version01"] = "12.6.1"}) do
        if setup.synthetic_only or setup.idmap[_live_key] == nil then
          setup.idmap[_live_key] = _live_ex
        end
      end
    end
    local client = setup.client
    if setup.live then
      runner.live_existing(pending, setup, LIVE_STRICT, "item", function()
        return { { id = setup.idmap["item01"] } }
      end)
    end

    -- Bootstrap entity data from existing test data.
    local item_ref01_data_raw = vs.items(helpers.to_map(
      vs.getpath(setup.data, "existing.item")))
    local item_ref01_data = nil
    if #item_ref01_data_raw > 0 then
      item_ref01_data = helpers.to_map(item_ref01_data_raw[1][2])
    end

    -- LOAD
    local item_ref01_ent = client:Item(nil)
    local item_ref01_match_dt0 = {
      id = item_ref01_data["id"],
    }
    item_ref01_match_dt0["version"] = setup.idmap["version"] or setup.idmap["version01"]
    local item_ref01_data_dt0_loaded, err = item_ref01_ent:load(item_ref01_match_dt0, nil)
    assert.is_nil(err)
    local item_ref01_data_dt0_load_result = helpers.to_map(type(item_ref01_data_dt0_loaded) == 'table' and item_ref01_data_dt0_loaded.data_get and item_ref01_data_dt0_loaded:data_get() or item_ref01_data_dt0_loaded)
    assert.is_not_nil(item_ref01_data_dt0_load_result)
    assert.are.equal(item_ref01_data_dt0_load_result["id"], item_ref01_data["id"])

  end)
end)

function item_basic_setup(extra)
  runner.load_env_local()

  local entity_data_file = _test_dir .. "../../.sdk/test/entity/item/ItemTestData.json"
  local f = io.open(entity_data_file, "r")
  if f == nil then
    error("failed to read item test data: " .. entity_data_file)
  end
  local entity_data_source = f:read("*a")
  f:close()

  local entity_data = json.decode(entity_data_source)

  local options = {}
  options["entity"] = entity_data["existing"]

  local client = sdk.test(options, extra)

  -- Generate idmap via transform.
  local idmap = vs.transform(
    { "item01", "item02", "item03", "version01" },
    {
      ["`$PACK`"] = { "", {
        ["`$KEY`"] = "`$COPY`",
        ["`$VAL`"] = { "`$FORMAT`", "upper", "`$COPY`" },
      }},
    }
  )

  -- Whether *_ENTID supplied the idmap, read before env_override consumes
  -- it: without it, the ids a live flow binds are the fixture's synthetic ones.
  local entid_env_raw = os.getenv("DATA_DRAGON_TEST_ITEM_ENTID")
  local idmap_overridden = entid_env_raw ~= nil and entid_env_raw:match("^%s*{") ~= nil

  local env = runner.env_override({
    ["DATA_DRAGON_TEST_ITEM_ENTID"] = idmap,
    ["DATA_DRAGON_TEST_LIVE"] = "FALSE",
    ["DATA_DRAGON_TEST_EXPLAIN"] = "FALSE",
  })

  local idmap_resolved = helpers.to_map(
    env["DATA_DRAGON_TEST_ITEM_ENTID"])
  if idmap_resolved == nil then
    idmap_resolved = helpers.to_map(idmap)
  end

  if env["DATA_DRAGON_TEST_LIVE"] == "TRUE" then
    local merged_opts = vs.merge({
      -- FIRST, so the generated fields below win: sdk-test-control.json's
      -- test.client.options adds to the live client, it does not redirect it.
      runner.live_client_options(),
      {
      },
      extra or {},
    })
    client = sdk.new(helpers.to_map(merged_opts))
  end

  local live = env["DATA_DRAGON_TEST_LIVE"] == "TRUE"
  return {
    client = client,
    data = entity_data,
    idmap = idmap_resolved,
    env = env,
    explain = env["DATA_DRAGON_TEST_EXPLAIN"] == "TRUE",
    live = live,
    synthetic_only = live and not idmap_overridden,
    now = os.time() * 1000,
  }
end
