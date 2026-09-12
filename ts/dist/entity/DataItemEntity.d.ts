import { DataDragonEntityBase } from '../DataDragonEntityBase';
import type { DataDragonSDK } from '../DataDragonSDK';
import type { Control } from '../types';
import type { DataItem, DataItemLoadMatch } from '../DataDragonTypes';
declare class DataItemEntity extends DataDragonEntityBase<DataItem> {
    constructor(client: DataDragonSDK, entopts: any);
    make(this: DataItemEntity): DataItemEntity;
    load(this: any, reqmatch?: DataItemLoadMatch, ctrl?: Control): Promise<DataItemEntity>;
}
export { DataItemEntity };
