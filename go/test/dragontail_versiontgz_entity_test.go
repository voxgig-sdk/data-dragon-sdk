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

func TestDragontailVersiontgzEntity(t *testing.T) {
	t.Run("instance", func(t *testing.T) {
		testsdk := sdk.TestSDK(nil, nil)
		ent := testsdk.DragontailVersiontgz(nil)
		if ent == nil {
			t.Fatal("expected non-nil DragontailVersiontgzEntity")
		}
	})

	t.Run("basic", func(t *testing.T) {
		setup := dragontail_versiontgzBasicSetup(nil)
		// Per-op sdk-test-control.json skip — basic test exercises a flow
		// with multiple ops; skipping any op skips the whole flow.
		_mode := "unit"
		if setup.live {
			_mode = "live"
		}
		for _, _op := range []string{"load"} {
			if _shouldSkip, _reason := isControlSkipped("entityOp", "dragontail_versiontgz." + _op, _mode); _shouldSkip {
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
			t.Skip("live entity test uses synthetic IDs from fixture — set DATADRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID JSON to run live")
			return
		}
		client := setup.client

		// Bootstrap entity data from existing test data (no create step in flow).
		dragontailVersiontgzRef01DataRaw := vs.Items(core.ToMapAny(vs.GetPath("existing.dragontail_versiontgz", setup.data)))
		var dragontailVersiontgzRef01Data map[string]any
		if len(dragontailVersiontgzRef01DataRaw) > 0 {
			dragontailVersiontgzRef01Data = core.ToMapAny(dragontailVersiontgzRef01DataRaw[0][1])
		}
		// Discard guards against Go's unused-var check when the flow's steps
		// happen not to consume the bootstrap data (e.g. list-only flows).
		_ = dragontailVersiontgzRef01Data

		// LOAD
		dragontailVersiontgzRef01Ent := client.DragontailVersiontgz(nil)
		dragontailVersiontgzRef01MatchDt0 := map[string]any{}
		dragontailVersiontgzRef01DataDt0Loaded, err := dragontailVersiontgzRef01Ent.Load(dragontailVersiontgzRef01MatchDt0, nil)
		if err != nil {
			t.Fatalf("load failed: %v", err)
		}
		if dragontailVersiontgzRef01DataDt0Loaded == nil {
			t.Fatal("expected load result to be non-nil")
		}

	})
}

func dragontail_versiontgzBasicSetup(extra map[string]any) *entityTestSetup {
	loadEnvLocal()

	_, filename, _, _ := runtime.Caller(0)
	dir := filepath.Dir(filename)

	entityDataFile := filepath.Join(dir, "..", "..", ".sdk", "test", "entity", "dragontail_versiontgz", "DragontailVersiontgzTestData.json")

	entityDataSource, err := os.ReadFile(entityDataFile)
	if err != nil {
		panic("failed to read dragontail_versiontgz test data: " + err.Error())
	}

	var entityData map[string]any
	if err := json.Unmarshal(entityDataSource, &entityData); err != nil {
		panic("failed to parse dragontail_versiontgz test data: " + err.Error())
	}

	options := map[string]any{}
	options["entity"] = entityData["existing"]

	client := sdk.TestSDK(options, extra)

	// Generate idmap via transform, matching TS pattern.
	idmap := vs.Transform(
		[]any{"dragontail_versiontgz01", "dragontail_versiontgz02", "dragontail_versiontgz03", "version01"},
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
	entidEnvRaw := os.Getenv("DATADRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID")
	idmapOverridden := entidEnvRaw != "" && strings.HasPrefix(strings.TrimSpace(entidEnvRaw), "{")

	env := envOverride(map[string]any{
		"DATADRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID": idmap,
		"DATADRAGON_TEST_LIVE":      "FALSE",
		"DATADRAGON_TEST_EXPLAIN":   "FALSE",
		"DATADRAGON_APIKEY":         "NONE",
	})

	idmapResolved := core.ToMapAny(env["DATADRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID"])
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
