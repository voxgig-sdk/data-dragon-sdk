# Item entity test

require "minitest/autorun"
require "json"
require_relative "../DataDragon_sdk"
require_relative "runner"

class ItemEntityTest < Minitest::Test
  # main.kit.test.live.strict is true (the default is true): a live
  # request that fails, or a live test missing an input it needs,
  # fails the test.
  # An account with no record for a test to read skips it either way.
  LIVE_STRICT = true

  def test_create_instance
    testsdk = DataDragonSDK.test(nil, nil)
    ent = testsdk.Item(nil)
    assert !ent.nil?
  end

  def test_validate
    cfg = DataDragonConfig.shared_config
    unless cfg["feature"].is_a?(Hash) && cfg["feature"].key?("validate")
      skip("feature not present in this SDK: validate")
    end
    client = DataDragonSDK.test(nil, { "feature" => { "validate" => { "active" => true } } })
    err = assert_raises(StandardError) do
      client.Item(nil).load({ "id" => 1, "version" => "x" }, nil)
    end
    assert_equal "validate_failed", err.code
  end

  def test_basic_flow
    setup = item_basic_setup(nil)
    # Per-op sdk-test-control.json skip.
    _live = setup[:live] || false
    ["load"].each do |_op|
      _should_skip, _reason = Runner.is_control_skipped("entityOp", "item." + _op, _live ? "live" : "unit")
      if _should_skip
        skip(_reason || "skipped via sdk-test-control.json")
        return
      end
    end
    if setup[:live]
      { "item01" => "1001.png", "version01" => "12.6.1" }.each do |_live_key, _live_ex|
        if setup[:synthetic_only] || setup[:idmap][_live_key].nil?
          setup[:idmap][_live_key] = _live_ex
        end
      end
    end
    client = setup[:client]
    if setup[:live]
      Runner.live_existing(setup, LIVE_STRICT, "item") do
        [{ "id" => setup[:idmap]["item01"] }]
      end
    end

    # Bootstrap entity data from existing test data.
    item_ref01_data_raw = Vs.items(Helpers.to_map(
      Vs.getpath(setup[:data], "existing.item")))
    item_ref01_data = nil
    if item_ref01_data_raw.length > 0
      item_ref01_data = Helpers.to_map(item_ref01_data_raw[0][1])
    end

    # LOAD
    item_ref01_ent = client.Item(nil)
    item_ref01_match_dt0 = {
      "id" => item_ref01_data["id"],
    }
    item_ref01_match_dt0["version"] = setup[:idmap]["version"] || setup[:idmap]["version01"]
    item_ref01_data_dt0_loaded = item_ref01_ent.load(item_ref01_match_dt0, nil)
    item_ref01_data_dt0_load_result = Helpers.to_map(item_ref01_data_dt0_loaded.respond_to?(:data_get) ? item_ref01_data_dt0_loaded.data_get : item_ref01_data_dt0_loaded)
    assert !item_ref01_data_dt0_load_result.nil?
    assert_equal item_ref01_data_dt0_load_result["id"], item_ref01_data["id"]

  end
end

def item_basic_setup(extra)
  Runner.load_env_local

  entity_data_file = File.join(__dir__, "..", "..", ".sdk", "test", "entity", "item", "ItemTestData.json")
  entity_data_source = File.read(entity_data_file, encoding: "UTF-8")
  entity_data = JSON.parse(entity_data_source)

  options = {}
  options["entity"] = entity_data["existing"]

  client = DataDragonSDK.test(options, extra)

  # Generate idmap via transform.
  idmap = Vs.transform(
    ["item01", "item02", "item03", "version01"],
    {
      "`$PACK`" => ["", {
        "`$KEY`" => "`$COPY`",
        "`$VAL`" => ["`$FORMAT`", "upper", "`$COPY`"],
      }],
    }
  )

  # Whether *_ENTID supplied the idmap, read before env_override consumes
  # it: without it, the ids a live flow binds are the fixture's synthetic ones.
  entid_env_raw = ENV["DATA_DRAGON_TEST_ITEM_ENTID"]
  idmap_overridden = !entid_env_raw.nil? && entid_env_raw.strip.start_with?("{")

  env = Runner.env_override({
    "DATA_DRAGON_TEST_ITEM_ENTID" => idmap,
    "DATA_DRAGON_TEST_LIVE" => "FALSE",
    "DATA_DRAGON_TEST_EXPLAIN" => "FALSE",
  })

  idmap_resolved = Helpers.to_map(
    env["DATA_DRAGON_TEST_ITEM_ENTID"])
  if idmap_resolved.nil?
    idmap_resolved = Helpers.to_map(idmap)
  end

  if env["DATA_DRAGON_TEST_LIVE"] == "TRUE"
    merged_opts = Vs.merge([
      # FIRST, so the generated fields below win: sdk-test-control.json's
      # test.client.options adds to the live client, it does not redirect it.
      Runner.live_client_options,
      {
      },
      extra || {},
    ])
    client = DataDragonSDK.new(Helpers.to_map(merged_opts))
  end

  live = env["DATA_DRAGON_TEST_LIVE"] == "TRUE"
  {
    client: client,
    data: entity_data,
    idmap: idmap_resolved,
    env: env,
    explain: env["DATA_DRAGON_TEST_EXPLAIN"] == "TRUE",
    live: live,
    synthetic_only: live && !idmap_overridden,
    now: (Time.now.to_f * 1000).to_i,
  }
end
