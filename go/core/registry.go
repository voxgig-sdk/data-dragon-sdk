package core

var UtilityRegistrar func(u *Utility)

var NewBaseFeatureFunc func() Feature

var NewTestFeatureFunc func() Feature

var NewChampionEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntity

var NewDataChampionEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntity

var NewDataItemEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntity

var NewDataRuneEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntity

var NewDragontailVersiontgzEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntity

var NewItemEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntity

var NewRegionEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntity

var NewVersionEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntity

