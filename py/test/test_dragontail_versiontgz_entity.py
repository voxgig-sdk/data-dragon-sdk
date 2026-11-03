# DragontailVersiontgz entity test

import json
import os
import time

import pytest

from datadragon_sdk.utility.voxgig_struct import voxgig_struct as vs
from datadragon_sdk import DataDragonSDK
from datadragon_sdk.core import helpers
from datadragon_sdk.config import shared_config
from datadragon_sdk.feature.base_feature import DataDragonBaseFeature

_TEST_DIR = os.path.dirname(os.path.abspath(__file__))
from test import runner



# main.kit.test.live.strict is true (the default is true): a live
# request that fails, or a live test missing an input it needs,
# fails the test.
# An account with no record for a test to read skips it either way.
LIVE_STRICT = True


class TestDragontailVersiontgzEntity:

    def test_should_create_instance(self):
        testsdk = DataDragonSDK.test(None, None)
        ent = testsdk.DragontailVersiontgz(None)
        assert ent is not None

    def test_should_refuse_an_invalid_request(self):
        if "validate" not in (shared_config().get("feature") or {}):
            pytest.skip("feature not present in this SDK: validate")
        client = DataDragonSDK.test(
            None, {"feature": {"validate": {"active": True}}})
        with pytest.raises(Exception) as err:
            client.DragontailVersiontgz(None).load({"version": 1}, None)
        assert "validate_failed" == getattr(err.value, "code", None)

    def test_should_run_basic_flow(self):
        setup = _dragontail_versiontgz_basic_setup(None)
        # Per-op sdk-test-control.json skip — basic test exercises a flow with
        # multiple ops; skipping any one skips the whole flow (steps depend
        # on each other).
        _live = setup.get("live", False)
        for _op in ["load"]:
            _skip, _reason = runner.is_control_skipped("entityOp", "dragontail_versiontgz." + _op, "live" if _live else "unit")
            if _skip:
                pytest.skip(_reason or "skipped via sdk-test-control.json")
                return
        if setup["live"]:
            for _live_key, _live_ex in {"version01": "12.6.1"}.items():
                if setup.get("synthetic_only") or setup["idmap"].get(_live_key) is None:
                    setup["idmap"][_live_key] = _live_ex
        client = setup["client"]

        # Bootstrap entity data from existing test data.
        dragontail_versiontgz_ref01_data_raw = vs.items(helpers.to_map(
            vs.getpath(setup["data"], "existing.dragontail_versiontgz")))
        dragontail_versiontgz_ref01_data = None
        if len(dragontail_versiontgz_ref01_data_raw) > 0:
            dragontail_versiontgz_ref01_data = helpers.to_map(dragontail_versiontgz_ref01_data_raw[0][1])

        # LOAD
        dragontail_versiontgz_ref01_ent = client.DragontailVersiontgz(None)
        dragontail_versiontgz_ref01_match_dt0 = {}
        dragontail_versiontgz_ref01_match_dt0["version"] = setup["idmap"].get("version") or setup["idmap"].get("version01")
        dragontail_versiontgz_ref01_data_dt0_loaded = dragontail_versiontgz_ref01_ent.load(dragontail_versiontgz_ref01_match_dt0, None)
        assert dragontail_versiontgz_ref01_data_dt0_loaded is not None



def _dragontail_versiontgz_basic_setup(extra):
    runner.load_env_local()

    entity_data_file = os.path.join(_TEST_DIR, "../../.sdk/test/entity/dragontail_versiontgz/DragontailVersiontgzTestData.json")
    with open(entity_data_file, "r", encoding="utf-8") as f:
        entity_data_source = f.read()

    entity_data = json.loads(entity_data_source)

    options = {}
    options["entity"] = entity_data.get("existing")

    client = DataDragonSDK.test(options, extra)

    # Generate idmap via transform.
    idmap = vs.transform(
        ["dragontail_versiontgz01", "dragontail_versiontgz02", "dragontail_versiontgz03", "version01"],
        {
            "`$PACK`": ["", {
                "`$KEY`": "`$COPY`",
                "`$VAL`": ["`$FORMAT`", "upper", "`$COPY`"],
            }],
        }
    )

    # Whether *_ENTID supplied the idmap, read before env_override consumes
    # it: without it, the ids a live flow binds are the fixture's synthetic ones.
    _entid_env_raw = os.environ.get(
        "DATA_DRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID")
    _idmap_overridden = _entid_env_raw is not None and _entid_env_raw.strip().startswith("{")

    env = runner.env_override({
        "DATA_DRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID": idmap,
        "DATA_DRAGON_TEST_LIVE": "FALSE",
        "DATA_DRAGON_TEST_EXPLAIN": "FALSE",
    })

    idmap_resolved = helpers.to_map(
        env.get("DATA_DRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID"))
    if idmap_resolved is None:
        idmap_resolved = helpers.to_map(idmap)

    if env.get("DATA_DRAGON_TEST_LIVE") == "TRUE":
        merged_opts = vs.merge([
            # FIRST, so the generated fields below win: sdk-test-control.json's
            # test.client.options adds to the live client, it does not
            # redirect it.
            runner.live_client_options(),
            {
            },
            extra or {},
        ])
        client = DataDragonSDK(helpers.to_map(merged_opts))

    _live = env.get("DATA_DRAGON_TEST_LIVE") == "TRUE"
    return {
        "client": client,
        "data": entity_data,
        "idmap": idmap_resolved,
        "env": env,
        "explain": env.get("DATA_DRAGON_TEST_EXPLAIN") == "TRUE",
        "live": _live,
        "synthetic_only": _live and not _idmap_overridden,
        "now": int(time.time() * 1000),
    }
