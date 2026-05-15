package sdktest

import (
	"encoding/json"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
	"time"

	sdk "github.com/voxgig-sdk/data-dragon-sdk"
	"github.com/voxgig-sdk/data-dragon-sdk/core"

	vs "github.com/voxgig/struct"
)

func TestDataChampionEntity(t *testing.T) {
	t.Run("instance", func(t *testing.T) {
		testsdk := sdk.TestSDK(nil, nil)
		ent := testsdk.DataChampion(nil)
		if ent == nil {
			t.Fatal("expected non-nil DataChampionEntity")
		}
	})

	t.Run("basic", func(t *testing.T) {
		setup := data_championBasicSetup(nil)
		// Per-op sdk-test-control.json skip — basic test exercises a flow
		// with multiple ops; skipping any op skips the whole flow.
		_mode := "unit"
		if setup.live {
			_mode = "live"
		}
		for _, _op := range []string{"load"} {
			if _shouldSkip, _reason := isControlSkipped("entityOp", "data_champion." + _op, _mode); _shouldSkip {
				if _reason == "" {
					_reason = "skipped via sdk-test-control.json"
				}
				t.Skip(_reason)
				return
			}
		}
		// The basic flow consumes synthetic IDs from the fixture. In live mode
		// without an *_ENTID env override, those IDs hit the live API and 4xx.
		if setup.syntheticOnly {
			t.Skip("live entity test uses synthetic IDs from fixture — set DATADRAGON_TEST_DATA_CHAMPION_ENTID JSON to run live")
			return
		}
		client := setup.client

		// Bootstrap entity data from existing test data (no create step in flow).
		dataChampionRef01DataRaw := vs.Items(core.ToMapAny(vs.GetPath("existing.data_champion", setup.data)))
		var dataChampionRef01Data map[string]any
		if len(dataChampionRef01DataRaw) > 0 {
			dataChampionRef01Data = core.ToMapAny(dataChampionRef01DataRaw[0][1])
		}
		// Discard guards against Go's unused-var check when the flow's steps
		// happen not to consume the bootstrap data (e.g. list-only flows).
		_ = dataChampionRef01Data

		// LOAD
		dataChampionRef01Ent := client.DataChampion(nil)
		dataChampionRef01MatchDt0 := map[string]any{}
		dataChampionRef01DataDt0Loaded, err := dataChampionRef01Ent.Load(dataChampionRef01MatchDt0, nil)
		if err != nil {
			t.Fatalf("load failed: %v", err)
		}
		if dataChampionRef01DataDt0Loaded == nil {
			t.Fatal("expected load result to be non-nil")
		}

	})
}

func data_championBasicSetup(extra map[string]any) *entityTestSetup {
	loadEnvLocal()

	_, filename, _, _ := runtime.Caller(0)
	dir := filepath.Dir(filename)

	entityDataFile := filepath.Join(dir, "..", "..", ".sdk", "test", "entity", "data_champion", "DataChampionTestData.json")

	entityDataSource, err := os.ReadFile(entityDataFile)
	if err != nil {
		panic("failed to read data_champion test data: " + err.Error())
	}

	var entityData map[string]any
	if err := json.Unmarshal(entityDataSource, &entityData); err != nil {
		panic("failed to parse data_champion test data: " + err.Error())
	}

	options := map[string]any{}
	options["entity"] = entityData["existing"]

	client := sdk.TestSDK(options, extra)

	// Generate idmap via transform, matching TS pattern.
	idmap := vs.Transform(
		[]any{"data_champion01", "data_champion02", "data_champion03", "cdn01", "cdn02", "cdn03", "data01", "data02", "data03", "version01"},
		map[string]any{
			"`$PACK`": []any{"", map[string]any{
				"`$KEY`": "`$COPY`",
				"`$VAL`": []any{"`$FORMAT`", "upper", "`$COPY`"},
			}},
		},
	)

	// Detect ENTID env override before envOverride consumes it. When live
	// mode is on without a real override, the basic test runs against synthetic
	// IDs from the fixture and 4xx's. Surface this so the test can skip.
	entidEnvRaw := os.Getenv("DATADRAGON_TEST_DATA_CHAMPION_ENTID")
	idmapOverridden := entidEnvRaw != "" && strings.HasPrefix(strings.TrimSpace(entidEnvRaw), "{")

	env := envOverride(map[string]any{
		"DATADRAGON_TEST_DATA_CHAMPION_ENTID": idmap,
		"DATADRAGON_TEST_LIVE":      "FALSE",
		"DATADRAGON_TEST_EXPLAIN":   "FALSE",
		"DATADRAGON_APIKEY":         "NONE",
	})

	idmapResolved := core.ToMapAny(env["DATADRAGON_TEST_DATA_CHAMPION_ENTID"])
	if idmapResolved == nil {
		idmapResolved = core.ToMapAny(idmap)
	}

	if env["DATADRAGON_TEST_LIVE"] == "TRUE" {
		mergedOpts := vs.Merge([]any{
			map[string]any{
				"apikey": env["DATADRAGON_APIKEY"],
			},
			extra,
		})
		client = sdk.NewDataDragonSDK(core.ToMapAny(mergedOpts))
	}

	live := env["DATADRAGON_TEST_LIVE"] == "TRUE"
	return &entityTestSetup{
		client:        client,
		data:          entityData,
		idmap:         idmapResolved,
		env:           env,
		explain:       env["DATADRAGON_TEST_EXPLAIN"] == "TRUE",
		live:          live,
		syntheticOnly: live && !idmapOverridden,
		now:           time.Now().UnixMilli(),
	}
}
