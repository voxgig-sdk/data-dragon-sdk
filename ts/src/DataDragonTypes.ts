// Typed models for the DataDragon SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
// @voxgig/apidef VALID_CANON). Do not edit by hand.

export interface Champion {
}

export interface ChampionLoadMatch {
  id: string
  version: string
}

export interface DataChampion {
  data?: Record<string, any>
  format?: string
  type?: string
  version?: string
}

export interface DataChampionLoadMatch {
  language: string
  version: string
}

export interface DataItem {
  data?: Record<string, any>
  type?: string
  version?: string
}

export interface DataItemLoadMatch {
  language: string
  version: string
}

export interface DataRune {
}

export interface DataRuneLoadMatch {
  language: string
  version: string
}

export interface DragontailVersiontgz {
}

export interface DragontailVersiontgzLoadMatch {
  version: string
}

export interface Item {
}

export interface ItemLoadMatch {
  id: string
  version: string
}

export interface Region {
  cdn?: string
  n?: Record<string, any>
  v?: string
}

export interface RegionLoadMatch {
  region: string
}

export interface Version {
}

export type VersionListMatch = Partial<Version>

