import { DataDragonEntityBase } from '../DataDragonEntityBase';
import type { DataDragonSDK } from '../DataDragonSDK';
import type { Control } from '../types';
import type { Region, RegionLoadMatch } from '../DataDragonTypes';
declare class RegionEntity extends DataDragonEntityBase<Region> {
    constructor(client: DataDragonSDK, entopts: any);
    make(this: RegionEntity): RegionEntity;
    load(this: any, reqmatch?: RegionLoadMatch, ctrl?: Control): Promise<RegionEntity>;
}
export { RegionEntity };
