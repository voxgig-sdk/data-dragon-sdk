<?php
declare(strict_types=1);

// DataRune entity test

require_once __DIR__ . '/../datadragon_sdk.php';
require_once __DIR__ . '/Runner.php';

use PHPUnit\Framework\TestCase;
use Voxgig\Struct\Struct as Vs;

class DataRuneEntityTest extends TestCase
{
    public function test_create_instance(): void
    {
        $testsdk = DataDragonSDK::test(null, null);
        $ent = $testsdk->DataRune(null);
        $this->assertNotNull($ent);
    }

    public function test_basic_flow(): void
    {
        $setup = data_rune_basic_setup(null);
        // Per-op sdk-test-control.json skip.
        $_live = !empty($setup["live"]);
        foreach (["load"] as $_op) {
            [$_shouldSkip, $_reason] = Runner::is_control_skipped("entityOp", "data_rune." . $_op, $_live ? "live" : "unit");
            if ($_shouldSkip) {
                $this->markTestSkipped($_reason ?? "skipped via sdk-test-control.json");
                return;
            }
        }
        // The basic flow consumes synthetic IDs from the fixture. In live mode
        // without an *_ENTID env override, those IDs hit the live API and 4xx.
        if (!empty($setup["synthetic_only"])) {
            $this->markTestSkipped("live entity test uses synthetic IDs from fixture — set DATADRAGON_TEST_DATA_RUNE_ENTID JSON to run live");
            return;
        }
        $client = $setup["client"];

        // Bootstrap entity data from existing test data.
        $data_rune_ref01_data_raw = Vs::items(Helpers::to_map(
            Vs::getpath($setup["data"], "existing.data_rune")));
        $data_rune_ref01_data = null;
        if (count($data_rune_ref01_data_raw) > 0) {
            $data_rune_ref01_data = Helpers::to_map($data_rune_ref01_data_raw[0][1]);
        }

        // LOAD
        $data_rune_ref01_ent = $client->DataRune(null);
        $data_rune_ref01_match_dt0 = [];
        [$data_rune_ref01_data_dt0_loaded, $err] = $data_rune_ref01_ent->load($data_rune_ref01_match_dt0, null);
        $this->assertNull($err);
        $this->assertNotNull($data_rune_ref01_data_dt0_loaded);

    }
}

function data_rune_basic_setup($extra)
{
    Runner::load_env_local();

    $entity_data_file = __DIR__ . '/../../.sdk/test/entity/data_rune/DataRuneTestData.json';
    $entity_data_source = file_get_contents($entity_data_file);
    $entity_data = json_decode($entity_data_source, true);

    $options = [];
    $options["entity"] = $entity_data["existing"];

    $client = DataDragonSDK::test($options, $extra);

    // Generate idmap.
    $idmap = [];
    foreach (["data_rune01", "data_rune02", "data_rune03", "cdn01", "cdn02", "cdn03", "data01", "data02", "data03", "version01"] as $k) {
        $idmap[$k] = strtoupper($k);
    }

    // Detect ENTID env override before envOverride consumes it. When live
    // mode is on without a real override, the basic test runs against synthetic
    // IDs from the fixture and 4xx's. Surface this so the test can skip.
    $entid_env_raw = getenv("DATADRAGON_TEST_DATA_RUNE_ENTID");
    $idmap_overridden = $entid_env_raw !== false && str_starts_with(trim($entid_env_raw), "{");

    $env = Runner::env_override([
        "DATADRAGON_TEST_DATA_RUNE_ENTID" => $idmap,
        "DATADRAGON_TEST_LIVE" => "FALSE",
        "DATADRAGON_TEST_EXPLAIN" => "FALSE",
        "DATADRAGON_APIKEY" => "NONE",
    ]);

    $idmap_resolved = Helpers::to_map(
        $env["DATADRAGON_TEST_DATA_RUNE_ENTID"]);
    if ($idmap_resolved === null) {
        $idmap_resolved = Helpers::to_map($idmap);
    }

    if ($env["DATADRAGON_TEST_LIVE"] === "TRUE") {
        $merged_opts = Vs::merge([
            [
                "apikey" => $env["DATADRAGON_APIKEY"],
            ],
            $extra ?? [],
        ]);
        $client = new DataDragonSDK(Helpers::to_map($merged_opts));
    }

    $live = $env["DATADRAGON_TEST_LIVE"] === "TRUE";
    return [
        "client" => $client,
        "data" => $entity_data,
        "idmap" => $idmap_resolved,
        "env" => $env,
        "explain" => $env["DATADRAGON_TEST_EXPLAIN"] === "TRUE",
        "live" => $live,
        "synthetic_only" => $live && !$idmap_overridden,
        "now" => (int)(microtime(true) * 1000),
    ];
}
