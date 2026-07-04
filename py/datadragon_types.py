# Typed models for the DataDragon SDK.
#
# GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
# params (op.<name>.points[].args.params[]). Field/param types come from the
# canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
# @voxgig/apidef VALID_CANON). Do not edit by hand.

from __future__ import annotations

from dataclasses import dataclass
from typing import Optional, Any


@dataclass
class Champion:
    pass


@dataclass
class ChampionLoadMatch:
    id: str
    version: str


@dataclass
class DataChampion:
    data: Optional[dict] = None
    format: Optional[str] = None
    type: Optional[str] = None
    version: Optional[str] = None


@dataclass
class DataChampionLoadMatch:
    language: str
    version: str


@dataclass
class DataItem:
    data: Optional[dict] = None
    type: Optional[str] = None
    version: Optional[str] = None


@dataclass
class DataItemLoadMatch:
    language: str
    version: str


@dataclass
class DataRune:
    pass


@dataclass
class DataRuneLoadMatch:
    language: str
    version: str


@dataclass
class DragontailVersiontgz:
    pass


@dataclass
class DragontailVersiontgzLoadMatch:
    version: str


@dataclass
class Item:
    pass


@dataclass
class ItemLoadMatch:
    id: str
    version: str


@dataclass
class Region:
    cdn: Optional[str] = None
    n: Optional[dict] = None
    v: Optional[str] = None


@dataclass
class RegionLoadMatch:
    region: str


@dataclass
class Version:
    pass


@dataclass
class VersionListMatch:
    pass

