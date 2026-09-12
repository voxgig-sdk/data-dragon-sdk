import { ChampionEntity } from './entity/ChampionEntity';
import { DataChampionEntity } from './entity/DataChampionEntity';
import { DataItemEntity } from './entity/DataItemEntity';
import { DataRuneEntity } from './entity/DataRuneEntity';
import { DragontailVersiontgzEntity } from './entity/DragontailVersiontgzEntity';
import { ItemEntity } from './entity/ItemEntity';
import { RegionEntity } from './entity/RegionEntity';
import { VersionEntity } from './entity/VersionEntity';
export type * from './DataDragonTypes';
import { inspect } from 'node:util';
import type { Context, Feature } from './types';
import { config } from './Config';
import { DataDragonEntityBase } from './DataDragonEntityBase';
import { Utility } from './utility/Utility';
import { BaseFeature } from './feature/base/BaseFeature';
declare const stdutil: Utility;
declare class DataDragonSDK {
    _mode: string;
    _options: any;
    _utility: Utility;
    _features: Feature[];
    _rootctx: Context;
    constructor(options?: any);
    options(): any;
    utility(): any;
    prepare(fetchargs?: any): Promise<any>;
    direct(fetchargs?: any): Promise<Error | {
        ok: boolean;
        status: number;
        headers: any;
        data: any;
        err?: undefined;
    } | {
        ok: boolean;
        err: any;
        status?: undefined;
        headers?: undefined;
        data?: undefined;
    }>;
    _rawRequest(fetchargs?: any): Promise<Error | {
        ok: boolean;
        status: number;
        headers: any;
        data: any;
        err?: undefined;
    } | {
        ok: boolean;
        err: any;
        status?: undefined;
        headers?: undefined;
        data?: undefined;
    }>;
    graphql(query: string, variables?: any, ctrl?: any): Promise<any>;
    Champion(entopts?: Record<string, any>): ChampionEntity;
    DataChampion(entopts?: Record<string, any>): DataChampionEntity;
    DataItem(entopts?: Record<string, any>): DataItemEntity;
    DataRune(entopts?: Record<string, any>): DataRuneEntity;
    DragontailVersiontgz(entopts?: Record<string, any>): DragontailVersiontgzEntity;
    Item(entopts?: Record<string, any>): ItemEntity;
    Region(entopts?: Record<string, any>): RegionEntity;
    Version(entopts?: Record<string, any>): VersionEntity;
    static test(testoptsarg?: any, sdkoptsarg?: any): DataDragonSDK;
    tester(testopts?: any, sdkopts?: any): DataDragonSDK;
    toJSON(): {
        name: string;
    };
    toString(): string;
    [inspect.custom](): string;
}
declare const SDK: typeof DataDragonSDK;
export { stdutil, config, BaseFeature, DataDragonEntityBase, DataDragonSDK, SDK, };
