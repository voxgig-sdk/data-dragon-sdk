# DataChampion entity test

import json
import os
import time

import pytest

from utility.voxgig_struct import voxgig_struct as vs
from datadragon_sdk import DataDragonSDK
from core import helpers

_TEST_DIR = os.path.dirname(os.path.abspath(__file__))
from test import runner


class TestDataChampionEntity:

    def test_should_create_instance(self):
        testsdk = DataDragonSDK.test(None, None)
        ent = testsdk.DataChampion(None)
        assert ent is not None

    def test_should_run_basic_flow(self):
        setup = _data_champion_basic_setup(None)
        # Per-op sdk-test-control.json skip — basic test exercises a flow with
        # multiple ops; skipping any one skips the whole flow (steps depend
        # on each other).
        _live = setup.get("live", False)
        for _op in ["load"]:
            _skip, _reason = runner.is_control_skipped("entityOp", "data_champion." + _op, "live" if _live else "unit")
            if _skip:
                pytest.skip(_reason or "skipped via sdk-test-control.json")
                return
        # The basic flow consumes synthetic IDs from the fixture. In live mode
        # without an *_ENTID env override, those IDs hit the live API and 4xx.
        if setup.get("synthetic_only"):
            pytest.skip("live entity test uses synthetic IDs from fixture — "
                        "set DATADRAGON_TEST_DATA_CHAMPION_ENTID JSON to run live")
        client = setup["client"]

        # Bootstrap entity data from existing test data.
        data_champion_ref01_data_raw = vs.items(helpers.to_map(
            vs.getpath(setup["data"], "existing.data_champion")))
        data_champion_ref01_data = None
        if len(data_champion_ref01_data_raw) > 0:
            data_champion_ref01_data = helpers.to_map(data_champion_ref01_data_raw[0][1])

        # LOAD
        data_champion_ref01_ent = client.DataChampion(None)
        data_champion_ref01_match_dt0 = {}
        data_champion_ref01_data_dt0_loaded, err = data_champion_ref01_ent.load(data_champion_ref01_match_dt0, None)
        assert err is None
        assert data_champion_ref01_data_dt0_loaded is not None



def _data_champion_basic_setup(extra):
    runner.load_env_local()

    entity_data_file = os.path.join(_TEST_DIR, "../../.sdk/test/entity/data_champion/DataChampionTestData.json")
    with open(entity_data_file, "r") as f:
        entity_data_source = f.read()

    entity_data = json.loads(entity_data_source)

    options = {}
    options["entity"] = entity_data.get("existing")

    client = DataDragonSDK.test(options, extra)

    # Generate idmap via transform.
    idmap = vs.transform(
        ["data_champion01", "data_champion02", "data_champion03", "cdn01", "cdn02", "cdn03", "data01", "data02", "data03", "version01"],
        {
            "`$PACK`": ["", {
                "`$KEY`": "`$COPY`",
                "`$VAL`": ["`$FORMAT`", "upper", "`$COPY`"],
            }],
        }
    )

    # Detect ENTID env override before envOverride consumes it. When live
    # mode is on without a real override, the basic test runs against synthetic
    # IDs from the fixture and 4xx's. We surface this so the test can skip.
    _entid_env_raw = os.environ.get(
        "DATADRAGON_TEST_DATA_CHAMPION_ENTID")
    _idmap_overridden = _entid_env_raw is not None and _entid_env_raw.strip().startswith("{")

    env = runner.env_override({
        "DATADRAGON_TEST_DATA_CHAMPION_ENTID": idmap,
        "DATADRAGON_TEST_LIVE": "FALSE",
        "DATADRAGON_TEST_EXPLAIN": "FALSE",
        "DATADRAGON_APIKEY": "NONE",
    })

    idmap_resolved = helpers.to_map(
        env.get("DATADRAGON_TEST_DATA_CHAMPION_ENTID"))
    if idmap_resolved is None:
        idmap_resolved = helpers.to_map(idmap)

    if env.get("DATADRAGON_TEST_LIVE") == "TRUE":
        merged_opts = vs.merge([
            {
                "apikey": env.get("DATADRAGON_APIKEY"),
            },
            extra or {},
        ])
        client = DataDragonSDK(helpers.to_map(merged_opts))

    _live = env.get("DATADRAGON_TEST_LIVE") == "TRUE"
    return {
        "client": client,
        "data": entity_data,
        "idmap": idmap_resolved,
        "env": env,
        "explain": env.get("DATADRAGON_TEST_EXPLAIN") == "TRUE",
        "live": _live,
        "synthetic_only": _live and not _idmap_overridden,
        "now": int(time.time() * 1000),
    }
