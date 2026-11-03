package sdktest

import (
	"encoding/json"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
	"time"

	sdk "github.com/voxgig-sdk/data-dragon-sdk/go"
	"github.com/voxgig-sdk/data-dragon-sdk/go/core"

	vs "github.com/voxgig-sdk/data-dragon-sdk/go/utility/struct"
)

// main.kit.test.live.strict is true (the default is true): a live
// request that fails, or a live test missing an input it needs,
// fails the test.
// An account with no record for a test to read skips it either way.
const dragontail_versiontgzEntityLiveStrict = true


func TestDragontailVersiontgzEntity(t *testing.T) {
	t.Run("instance", func(t *testing.T) {
		testsdk := sdk.TestSDK(nil, nil)
		ent := testsdk.DragontailVersiontgz(nil)
		if ent == nil {
			t.Fatal("expected non-nil DragontailVersiontgzEntity")
		}
	})

	t.Run("validate", func(t *testing.T) {
		if !fhHasFeature("validate") {
			t.Skip("feature not present in this SDK: validate")
		}
		client := sdk.TestSDK(nil, map[string]any{
			"feature": map[string]any{"validate": map[string]any{"active": true}},
		})
		_, err := client.DragontailVersiontgz(nil).Load(map[string]any{"version": 1}, nil)
		if sdkerr, ok := err.(*core.DataDragonError); !ok || "validate_failed" != sdkerr.Code {
			t.Fatalf("expected validate_failed, got %v", err)
		}
	})

	t.Run("basic", func(tt *testing.T) {
		var t testing.TB = tt
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
		if setup.live {
			for _liveKey, _liveEx := range map[string]any{"version01": "12.6.1"} {
				if setup.syntheticOnly || setup.idmap[_liveKey] == nil {
					setup.idmap[_liveKey] = _liveEx
				}
			}
		}
		client := setup.client
		_ = client

		// Bootstrap entity data from existing test data (no create step in flow).
		dragontailVersiontgzRef01DataRaw := vs.Items(core.ToMapAny(vs.GetPath(setup.data, "existing.dragontail_versiontgz")))
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
		if v := setup.idmap["version"]; v != nil {
			dragontailVersiontgzRef01MatchDt0["version"] = v
		} else {
			dragontailVersiontgzRef01MatchDt0["version"] = setup.idmap["version01"]
		}
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
	idmap, _ := vs.Transform(
		[]any{"dragontail_versiontgz01", "dragontail_versiontgz02", "dragontail_versiontgz03", "version01"},
		map[string]any{
			"`$PACK`": []any{"", map[string]any{
				"`$KEY`": "`$COPY`",
				"`$VAL`": []any{"`$FORMAT`", "upper", "`$COPY`"},
			}},
		},
	)

	// Whether *_ENTID supplied the idmap, read before envOverride consumes it:
	// without it, the ids a live flow binds are the fixture's synthetic ones.
	entidEnvRaw := os.Getenv("DATA_DRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID")
	idmapOverridden := entidEnvRaw != "" && strings.HasPrefix(strings.TrimSpace(entidEnvRaw), "{")

	env := envOverride(map[string]any{
		"DATA_DRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID": idmap,
		"DATA_DRAGON_TEST_LIVE":      "FALSE",
		"DATA_DRAGON_TEST_EXPLAIN":   "FALSE",
	})

	idmapResolved := core.ToMapAny(env["DATA_DRAGON_TEST_DRAGONTAIL_VERSIONTGZ_ENTID"])
	if idmapResolved == nil {
		idmapResolved = core.ToMapAny(idmap)
	}

	if env["DATA_DRAGON_TEST_LIVE"] == "TRUE" {
		// An empty map, not a nil one: Merge returns nil when its last entry
		// is nil, and BasicSetup is normally called with no extras - so a
		// bare nil silently discarded the apikey and server values below.
		extraOpts := extra
		if extraOpts == nil {
			extraOpts = map[string]any{}
		}

		mergedOpts := vs.Merge([]any{
			// liveClientOptions() FIRST, so the generated fields below win:
			// sdk-test-control.json's test.client.options adds to the live
			// client, it does not redirect it.
			liveClientOptions(),
			map[string]any{
			},
			extraOpts,
		})
		client = sdk.NewDataDragonSDK(core.ToMapAny(mergedOpts))
	}

	live := env["DATA_DRAGON_TEST_LIVE"] == "TRUE"
	return &entityTestSetup{
		client:        client,
		data:          entityData,
		idmap:         idmapResolved,
		env:           env,
		explain:       env["DATA_DRAGON_TEST_EXPLAIN"] == "TRUE",
		live:          live,
		syntheticOnly: live && !idmapOverridden,
		now:           time.Now().UnixMilli(),
	}
}
