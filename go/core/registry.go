package core

var UtilityRegistrar func(u *Utility)

var NewBaseFeatureFunc func() Feature

var NewRatelimitFeatureFunc func() Feature

var NewRetryFeatureFunc func() Feature

var NewTestFeatureFunc func() Feature

var NewTimeoutFeatureFunc func() Feature

var NewChampionEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntityBase

var NewDataChampionEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntityBase

var NewDataItemEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntityBase

var NewDataRuneEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntityBase

var NewDragontailVersiontgzEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntityBase

var NewItemEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntityBase

var NewRegionEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntityBase

var NewVersionEntityFunc func(client *DataDragonSDK, entopts map[string]any) DataDragonEntityBase

