# Item entity test

require "minitest/autorun"
require "json"
require_relative "../DataDragon_sdk"
require_relative "runner"

class ItemEntityTest < Minitest::Test
  def test_create_instance
    testsdk = DataDragonSDK.test(nil, nil)
    ent = testsdk.Item(nil)
    assert !ent.nil?
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
    # The basic flow consumes synthetic IDs from the fixture. In live mode
    # without an *_ENTID env override, those IDs hit the live API and 4xx.
    if setup[:synthetic_only]
      skip "live entity test uses synthetic IDs from fixture — set DATADRAGON_TEST_ITEM_ENTID JSON to run live"
      return
    end
    client = setup[:client]

    # Bootstrap entity data from existing test data.
    item_ref01_data_raw = Vs.items(Helpers.to_map(
      Vs.getpath(setup[:data], "existing.item")))
    item_ref01_data = nil
    if item_ref01_data_raw.length > 0
      item_ref01_data = Helpers.to_map(item_ref01_data_raw[0][1])
    end

    # LOAD
    item_ref01_ent = client.Item(nil)
    item_ref01_match_dt0 = {}
    item_ref01_data_dt0_loaded, err = item_ref01_ent.load(item_ref01_match_dt0, nil)
    assert_nil err
    assert !item_ref01_data_dt0_loaded.nil?

  end
end

def item_basic_setup(extra)
  Runner.load_env_local

  entity_data_file = File.join(__dir__, "..", "..", ".sdk", "test", "entity", "item", "ItemTestData.json")
  entity_data_source = File.read(entity_data_file)
  entity_data = JSON.parse(entity_data_source)

  options = {}
  options["entity"] = entity_data["existing"]

  client = DataDragonSDK.test(options, extra)

  # Generate idmap via transform.
  idmap = Vs.transform(
    ["item01", "item02", "item03", "cdn01", "cdn02", "cdn03", "version01"],
    {
      "`$PACK`" => ["", {
        "`$KEY`" => "`$COPY`",
        "`$VAL`" => ["`$FORMAT`", "upper", "`$COPY`"],
      }],
    }
  )

  # Detect ENTID env override before envOverride consumes it. When live
  # mode is on without a real override, the basic test runs against synthetic
  # IDs from the fixture and 4xx's. Surface this so the test can skip.
  entid_env_raw = ENV["DATADRAGON_TEST_ITEM_ENTID"]
  idmap_overridden = !entid_env_raw.nil? && entid_env_raw.strip.start_with?("{")

  env = Runner.env_override({
    "DATADRAGON_TEST_ITEM_ENTID" => idmap,
    "DATADRAGON_TEST_LIVE" => "FALSE",
    "DATADRAGON_TEST_EXPLAIN" => "FALSE",
    "DATADRAGON_APIKEY" => "NONE",
  })

  idmap_resolved = Helpers.to_map(
    env["DATADRAGON_TEST_ITEM_ENTID"])
  if idmap_resolved.nil?
    idmap_resolved = Helpers.to_map(idmap)
  end

  if env["DATADRAGON_TEST_LIVE"] == "TRUE"
    merged_opts = Vs.merge([
      {
        "apikey" => env["DATADRAGON_APIKEY"],
      },
      extra || {},
    ])
    client = DataDragonSDK.new(Helpers.to_map(merged_opts))
  end

  live = env["DATADRAGON_TEST_LIVE"] == "TRUE"
  {
    client: client,
    data: entity_data,
    idmap: idmap_resolved,
    env: env,
    explain: env["DATADRAGON_TEST_EXPLAIN"] == "TRUE",
    live: live,
    synthetic_only: live && !idmap_overridden,
    now: (Time.now.to_f * 1000).to_i,
  }
end
