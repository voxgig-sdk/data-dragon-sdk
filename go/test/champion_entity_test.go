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
const championEntityLiveStrict = true


func TestChampionEntity(t *testing.T) {
	t.Run("instance", func(t *testing.T) {
		testsdk := sdk.TestSDK(nil, nil)
		ent := testsdk.Champion(nil)
		if ent == nil {
			t.Fatal("expected non-nil ChampionEntity")
		}
	})

	t.Run("validate", func(t *testing.T) {
		if !fhHasFeature("validate") {
			t.Skip("feature not present in this SDK: validate")
		}
		client := sdk.TestSDK(nil, map[string]any{
			"feature": map[string]any{"validate": map[string]any{"active": true}},
		})
		_, err := client.Champion(nil).Load(map[string]any{"id": 1, "version": "x"}, nil)
		if sdkerr, ok := err.(*core.DataDragonError); !ok || "validate_failed" != sdkerr.Code {
			t.Fatalf("expected validate_failed, got %v", err)
		}
	})

	t.Run("basic", func(tt *testing.T) {
		var t testing.TB = tt
		setup := championBasicSetup(nil)
		// Per-op sdk-test-control.json skip — basic test exercises a flow
		// with multiple ops; skipping any op skips the whole flow.
		_mode := "unit"
		if setup.live {
			_mode = "live"
		}
		for _, _op := range []string{"load"} {
			if _shouldSkip, _reason := isControlSkipped("entityOp", "champion." + _op, _mode); _shouldSkip {
				if _reason == "" {
					_reason = "skipped via sdk-test-control.json"
				}
				t.Skip(_reason)
				return
			}
		}
		if setup.live {
			for _liveKey, _liveEx := range map[string]any{"champion01": "Ahri.png", "version01": "12.6.1"} {
				if setup.syntheticOnly || setup.idmap[_liveKey] == nil {
					setup.idmap[_liveKey] = _liveEx
				}
			}
		}
		client := setup.client
		_ = client
		if setup.live {
			liveExisting(t, championEntityLiveStrict, setup.data, "champion", func() (any, error) {
				return []any{map[string]any{"id": setup.idmap["champion01"]}}, nil
			})
		}

		// Bootstrap entity data from existing test data (no create step in flow).
		championRef01DataRaw := vs.Items(core.ToMapAny(vs.GetPath(setup.data, "existing.champion")))
		var championRef01Data map[string]any
		if len(championRef01DataRaw) > 0 {
			championRef01Data = core.ToMapAny(championRef01DataRaw[0][1])
		}
		// Discard guards against Go's unused-var check when the flow's steps
		// happen not to consume the bootstrap data (e.g. list-only flows).
		_ = championRef01Data

		// LOAD
		championRef01Ent := client.Champion(nil)
		championRef01MatchDt0 := map[string]any{
			"id": championRef01Data["id"],
		}
		if v := setup.idmap["version"]; v != nil {
			championRef01MatchDt0["version"] = v
		} else {
			championRef01MatchDt0["version"] = setup.idmap["version01"]
		}
		championRef01DataDt0Loaded, err := championRef01Ent.Load(championRef01MatchDt0, nil)
		if err != nil {
			t.Fatalf("load failed: %v", err)
		}
		championRef01DataDt0LoadResult := core.ToMapAny(entityData(championRef01DataDt0Loaded))
		if championRef01DataDt0LoadResult == nil {
			t.Fatal("expected load result to be a map")
		}
		if championRef01DataDt0LoadResult["id"] != championRef01Data["id"] {
			t.Fatal("expected load result id to match")
		}

	})
}

func championBasicSetup(extra map[string]any) *entityTestSetup {
	loadEnvLocal()

	_, filename, _, _ := runtime.Caller(0)
	dir := filepath.Dir(filename)

	entityDataFile := filepath.Join(dir, "..", "..", ".sdk", "test", "entity", "champion", "ChampionTestData.json")

	entityDataSource, err := os.ReadFile(entityDataFile)
	if err != nil {
		panic("failed to read champion test data: " + err.Error())
	}

	var entityData map[string]any
	if err := json.Unmarshal(entityDataSource, &entityData); err != nil {
		panic("failed to parse champion test data: " + err.Error())
	}

	options := map[string]any{}
	options["entity"] = entityData["existing"]

	client := sdk.TestSDK(options, extra)

	// Generate idmap via transform, matching TS pattern.
	idmap, _ := vs.Transform(
		[]any{"champion01", "champion02", "champion03", "version01"},
		map[string]any{
			"`$PACK`": []any{"", map[string]any{
				"`$KEY`": "`$COPY`",
				"`$VAL`": []any{"`$FORMAT`", "upper", "`$COPY`"},
			}},
		},
	)

	// Whether *_ENTID supplied the idmap, read before envOverride consumes it:
	// without it, the ids a live flow binds are the fixture's synthetic ones.
	entidEnvRaw := os.Getenv("DATA_DRAGON_TEST_CHAMPION_ENTID")
	idmapOverridden := entidEnvRaw != "" && strings.HasPrefix(strings.TrimSpace(entidEnvRaw), "{")

	env := envOverride(map[string]any{
		"DATA_DRAGON_TEST_CHAMPION_ENTID": idmap,
		"DATA_DRAGON_TEST_LIVE":      "FALSE",
		"DATA_DRAGON_TEST_EXPLAIN":   "FALSE",
	})

	idmapResolved := core.ToMapAny(env["DATA_DRAGON_TEST_CHAMPION_ENTID"])
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
