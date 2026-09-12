import { DataDragonEntityBase } from '../DataDragonEntityBase';
import type { DataDragonSDK } from '../DataDragonSDK';
import type { Control } from '../types';
import type { DataChampion, DataChampionLoadMatch } from '../DataDragonTypes';
declare class DataChampionEntity extends DataDragonEntityBase<DataChampion> {
    constructor(client: DataDragonSDK, entopts: any);
    make(this: DataChampionEntity): DataChampionEntity;
    load(this: any, reqmatch?: DataChampionLoadMatch, ctrl?: Control): Promise<DataChampionEntity>;
}
export { DataChampionEntity };
