# Typed models for the DataDragon SDK.
#
# GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
# params (op.<name>.points[].args.params[]). Field/param types come from the
# canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
# @voxgig/apidef VALID_CANON). Do not edit by hand.
#
# These are TypedDicts, not dataclasses: the SDK ops return/accept plain dicts
# at runtime, and a TypedDict IS a dict shape, so the types match the runtime.
# Optional (req:false) keys are modelled as TypedDict key-optionality
# (total=False), split into a required base + total=False subclass when a type
# has both required and optional keys.

from __future__ import annotations

from typing import TypedDict, Any


class Champion(TypedDict):
    pass


class ChampionLoadMatch(TypedDict):
    id: str
    version: str


class DataChampion(TypedDict, total=False):
    data: dict
    format: str
    type: str
    version: str


class DataChampionLoadMatch(TypedDict):
    language: str
    version: str


class DataItem(TypedDict, total=False):
    data: dict
    type: str
    version: str


class DataItemLoadMatch(TypedDict):
    language: str
    version: str


class DataRune(TypedDict):
    pass


class DataRuneLoadMatch(TypedDict):
    language: str
    version: str


class DragontailVersiontgz(TypedDict):
    pass


class DragontailVersiontgzLoadMatch(TypedDict):
    version: str


class Item(TypedDict):
    pass


class ItemLoadMatch(TypedDict):
    id: str
    version: str


class Region(TypedDict, total=False):
    cdn: str
    n: dict
    v: str


class RegionLoadMatch(TypedDict):
    region: str


class Version(TypedDict):
    pass


class VersionListMatch(TypedDict):
    pass
