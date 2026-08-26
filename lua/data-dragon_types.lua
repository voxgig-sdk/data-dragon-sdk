-- Typed models for the DataDragon SDK (LuaLS annotations).
--
-- GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
-- params (op.<name>.points[].args.params[]). Field/param types come from the
-- canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
-- @voxgig/apidef VALID_CANON). Annotations only — no runtime effect. Do not
-- edit by hand.

---@class Champion
---@field id? string

---@class ChampionLoadMatch
---@field id string
---@field version string

---@class DataChampion
---@field image? table
---@field key? string
---@field name? string
---@field title? string

---@class DataChampionLoadMatch
---@field language string
---@field version string

---@class DataItem
---@field description? string
---@field image? table
---@field name? string

---@class DataItemLoadMatch
---@field language string
---@field version string

---@class DataRune

---@class DataRuneLoadMatch
---@field language string
---@field version string

---@class DragontailVersiontgz

---@class DragontailVersiontgzLoadMatch
---@field version string

---@class Item
---@field id? string

---@class ItemLoadMatch
---@field id string
---@field version string

---@class Region
---@field champion? string
---@field item? string
---@field rune? string

---@class RegionLoadMatch
---@field region string

---@class Version

---@class VersionListMatch

local M = {}

return M
