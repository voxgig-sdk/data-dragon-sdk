import { DataDragonEntityBase } from '../DataDragonEntityBase';
import type { DataDragonSDK } from '../DataDragonSDK';
import type { Control } from '../types';
import type { Champion, ChampionLoadMatch } from '../DataDragonTypes';
declare class ChampionEntity extends DataDragonEntityBase<Champion> {
    constructor(client: DataDragonSDK, entopts: any);
    make(this: ChampionEntity): ChampionEntity;
    load(this: any, reqmatch?: ChampionLoadMatch, ctrl?: Control): Promise<ChampionEntity>;
}
export { ChampionEntity };
