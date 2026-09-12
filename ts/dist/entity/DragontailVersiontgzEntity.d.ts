import { DataDragonEntityBase } from '../DataDragonEntityBase';
import type { DataDragonSDK } from '../DataDragonSDK';
import type { Control } from '../types';
import type { DragontailVersiontgz, DragontailVersiontgzLoadMatch } from '../DataDragonTypes';
declare class DragontailVersiontgzEntity extends DataDragonEntityBase<DragontailVersiontgz> {
    constructor(client: DataDragonSDK, entopts: any);
    make(this: DragontailVersiontgzEntity): DragontailVersiontgzEntity;
    load(this: any, reqmatch?: DragontailVersiontgzLoadMatch, ctrl?: Control): Promise<DragontailVersiontgzEntity>;
}
export { DragontailVersiontgzEntity };
