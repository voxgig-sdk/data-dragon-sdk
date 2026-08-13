# frozen_string_literal: true

# Typed models for the DataDragon SDK.
#
# GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
# params (op.<name>.points[].args.params[]). Member types come from the
# canonical type sentinels via @voxgig/sdkgen canonToType (source of truth:
# @voxgig/apidef VALID_CANON). Ruby types are unenforced; these YARD
# annotations document the shapes. Do not edit by hand.

# Champion entity data model.
class Champion
end

# Request payload for Champion#load.
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] version
#   @return [String]
ChampionLoadMatch = Struct.new(
  :id,
  :version,
  keyword_init: true
)

# DataChampion entity data model.
#
# @!attribute [rw] image
#   @return [Hash, nil]
#
# @!attribute [rw] key
#   @return [String, nil]
#
# @!attribute [rw] name
#   @return [String, nil]
#
# @!attribute [rw] title
#   @return [String, nil]
DataChampion = Struct.new(
  :image,
  :key,
  :name,
  :title,
  keyword_init: true
)

# Request payload for DataChampion#load.
#
# @!attribute [rw] language
#   @return [String]
#
# @!attribute [rw] version
#   @return [String]
DataChampionLoadMatch = Struct.new(
  :language,
  :version,
  keyword_init: true
)

# DataItem entity data model.
#
# @!attribute [rw] description
#   @return [String, nil]
#
# @!attribute [rw] image
#   @return [Hash, nil]
#
# @!attribute [rw] name
#   @return [String, nil]
DataItem = Struct.new(
  :description,
  :image,
  :name,
  keyword_init: true
)

# Request payload for DataItem#load.
#
# @!attribute [rw] language
#   @return [String]
#
# @!attribute [rw] version
#   @return [String]
DataItemLoadMatch = Struct.new(
  :language,
  :version,
  keyword_init: true
)

# DataRune entity data model.
class DataRune
end

# Request payload for DataRune#load.
#
# @!attribute [rw] language
#   @return [String]
#
# @!attribute [rw] version
#   @return [String]
DataRuneLoadMatch = Struct.new(
  :language,
  :version,
  keyword_init: true
)

# DragontailVersiontgz entity data model.
class DragontailVersiontgz
end

# Request payload for DragontailVersiontgz#load.
#
# @!attribute [rw] version
#   @return [String]
DragontailVersiontgzLoadMatch = Struct.new(
  :version,
  keyword_init: true
)

# Item entity data model.
class Item
end

# Request payload for Item#load.
#
# @!attribute [rw] id
#   @return [String]
#
# @!attribute [rw] version
#   @return [String]
ItemLoadMatch = Struct.new(
  :id,
  :version,
  keyword_init: true
)

# Region entity data model.
#
# @!attribute [rw] champion
#   @return [String, nil]
#
# @!attribute [rw] item
#   @return [String, nil]
#
# @!attribute [rw] rune
#   @return [String, nil]
Region = Struct.new(
  :champion,
  :item,
  :rune,
  keyword_init: true
)

# Request payload for Region#load.
#
# @!attribute [rw] region
#   @return [String]
RegionLoadMatch = Struct.new(
  :region,
  keyword_init: true
)

# Version entity data model.
class Version
end

# Request payload for Version#list.
class VersionListMatch
end

