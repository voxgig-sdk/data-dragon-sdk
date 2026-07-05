// Typed models for the DataDragon SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
// @voxgig/apidef VALID_CANON). Do not edit by hand.
package entity

import "encoding/json"

// Champion is the typed data model for the champion entity.
type Champion struct {
}

// ChampionLoadMatch is the typed request payload for Champion.LoadTyped.
type ChampionLoadMatch struct {
	Id string `json:"id"`
	Version string `json:"version"`
}

// DataChampion is the typed data model for the data_champion entity.
type DataChampion struct {
	Data *map[string]any `json:"data,omitempty"`
	Format *string `json:"format,omitempty"`
	Type *string `json:"type,omitempty"`
	Version *string `json:"version,omitempty"`
}

// DataChampionLoadMatch is the typed request payload for DataChampion.LoadTyped.
type DataChampionLoadMatch struct {
	Language string `json:"language"`
	Version string `json:"version"`
}

// DataItem is the typed data model for the data_item entity.
type DataItem struct {
	Data *map[string]any `json:"data,omitempty"`
	Type *string `json:"type,omitempty"`
	Version *string `json:"version,omitempty"`
}

// DataItemLoadMatch is the typed request payload for DataItem.LoadTyped.
type DataItemLoadMatch struct {
	Language string `json:"language"`
	Version string `json:"version"`
}

// DataRune is the typed data model for the data_rune entity.
type DataRune struct {
}

// DataRuneLoadMatch is the typed request payload for DataRune.LoadTyped.
type DataRuneLoadMatch struct {
	Language string `json:"language"`
	Version string `json:"version"`
}

// DragontailVersiontgz is the typed data model for the dragontail_versiontgz entity.
type DragontailVersiontgz struct {
}

// DragontailVersiontgzLoadMatch is the typed request payload for DragontailVersiontgz.LoadTyped.
type DragontailVersiontgzLoadMatch struct {
	Version string `json:"version"`
}

// Item is the typed data model for the item entity.
type Item struct {
}

// ItemLoadMatch is the typed request payload for Item.LoadTyped.
type ItemLoadMatch struct {
	Id string `json:"id"`
	Version string `json:"version"`
}

// Region is the typed data model for the region entity.
type Region struct {
	Cdn *string `json:"cdn,omitempty"`
	N *map[string]any `json:"n,omitempty"`
	V *string `json:"v,omitempty"`
}

// RegionLoadMatch is the typed request payload for Region.LoadTyped.
type RegionLoadMatch struct {
	Region string `json:"region"`
}

// Version is the typed data model for the version entity.
type Version struct {
}

// VersionListMatch is the typed request payload for Version.ListTyped.
type VersionListMatch struct {
}

// asMap turns a typed request/data struct into the map[string]any the
// runtime op pipeline consumes, honouring the json tags above.
func asMap(v any) map[string]any {
	out := map[string]any{}
	b, err := json.Marshal(v)
	if err != nil {
		return out
	}
	_ = json.Unmarshal(b, &out)
	return out
}

// typedFrom decodes a runtime value (a map[string]any produced by the op
// pipeline) into a typed model T via a JSON round-trip. On any error it
// returns the zero value of T; the op's own (value, error) tuple carries the
// real error.
func typedFrom[T any](v any) T {
	var out T
	if v == nil {
		return out
	}
	b, err := json.Marshal(v)
	if err != nil {
		return out
	}
	_ = json.Unmarshal(b, &out)
	return out
}

// typedSliceFrom decodes a runtime list value ([]any of maps) into a typed
// slice []T via a JSON round-trip, for list ops.
func typedSliceFrom[T any](v any) []T {
	var out []T
	if v == nil {
		return out
	}
	b, err := json.Marshal(v)
	if err != nil {
		return out
	}
	_ = json.Unmarshal(b, &out)
	return out
}
