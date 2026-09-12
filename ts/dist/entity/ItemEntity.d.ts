import { DataDragonEntityBase } from '../DataDragonEntityBase';
import type { DataDragonSDK } from '../DataDragonSDK';
import type { Control } from '../types';
import type { Item, ItemLoadMatch } from '../DataDragonTypes';
declare class ItemEntity extends DataDragonEntityBase<Item> {
    constructor(client: DataDragonSDK, entopts: any);
    make(this: ItemEntity): ItemEntity;
    load(this: any, reqmatch?: ItemLoadMatch, ctrl?: Control): Promise<ItemEntity>;
}
export { ItemEntity };
