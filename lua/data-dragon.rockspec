package = "voxgig-sdk-data-dragon"
version = "0.0-1"
source = {
  url = "git://github.com/voxgig-sdk/data-dragon-sdk.git"
}
description = {
  summary = "DataDragon SDK for Lua",
  license = "MIT"
}
dependencies = {
  "lua >= 5.3",
  "dkjson >= 2.5",
  "dkjson >= 2.5",
}
build = {
  type = "builtin",
  modules = {
    ["data-dragon_sdk"] = "data-dragon_sdk.lua",
    ["config"] = "config.lua",
    ["features"] = "features.lua",
  }
}
