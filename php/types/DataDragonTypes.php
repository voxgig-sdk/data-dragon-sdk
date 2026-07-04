<?php
declare(strict_types=1);

// Typed models for the DataDragon SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
// @voxgig/apidef VALID_CANON). Do not edit by hand.
//
// These are documentation-grade value objects (PHP 8 typed properties),
// registered on the composer classmap autoload. The SDK boundary exchanges
// assoc-arrays; these classes name the shapes for tooling and typed callers.

/** Champion entity data model. */
class Champion
{
}

/** Request payload for Champion#load. */
class ChampionLoadMatch
{
    public string $id;
    public string $version;
}

/** DataChampion entity data model. */
class DataChampion
{
    public ?array $data = null;
    public ?string $format = null;
    public ?string $type = null;
    public ?string $version = null;
}

/** Request payload for DataChampion#load. */
class DataChampionLoadMatch
{
    public string $language;
    public string $version;
}

/** DataItem entity data model. */
class DataItem
{
    public ?array $data = null;
    public ?string $type = null;
    public ?string $version = null;
}

/** Request payload for DataItem#load. */
class DataItemLoadMatch
{
    public string $language;
    public string $version;
}

/** DataRune entity data model. */
class DataRune
{
}

/** Request payload for DataRune#load. */
class DataRuneLoadMatch
{
    public string $language;
    public string $version;
}

/** DragontailVersiontgz entity data model. */
class DragontailVersiontgz
{
}

/** Request payload for DragontailVersiontgz#load. */
class DragontailVersiontgzLoadMatch
{
    public string $version;
}

/** Item entity data model. */
class Item
{
}

/** Request payload for Item#load. */
class ItemLoadMatch
{
    public string $id;
    public string $version;
}

/** Region entity data model. */
class Region
{
    public ?string $cdn = null;
    public ?array $n = null;
    public ?string $v = null;
}

/** Request payload for Region#load. */
class RegionLoadMatch
{
    public string $region;
}

/** Version entity data model. */
class Version
{
}

/** Match filter for Version#list (any subset of Version fields). */
class VersionListMatch
{
}

