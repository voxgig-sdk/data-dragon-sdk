import { DataDragonEntityBase } from '../DataDragonEntityBase';
import type { DataDragonSDK } from '../DataDragonSDK';
import type { Control } from '../types';
import type { DataRune, DataRuneLoadMatch } from '../DataDragonTypes';
declare class DataRuneEntity extends DataDragonEntityBase<DataRune> {
    constructor(client: DataDragonSDK, entopts: any);
    make(this: DataRuneEntity): DataRuneEntity;
    load(this: any, reqmatch?: DataRuneLoadMatch, ctrl?: Control): Promise<DataRuneEntity>;
}
export { DataRuneEntity };
