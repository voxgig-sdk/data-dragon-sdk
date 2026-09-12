import { DataDragonEntityBase } from '../DataDragonEntityBase';
import type { DataDragonSDK } from '../DataDragonSDK';
import type { Control } from '../types';
import type { Version, VersionListMatch } from '../DataDragonTypes';
declare class VersionEntity extends DataDragonEntityBase<Version> {
    constructor(client: DataDragonSDK, entopts: any);
    make(this: VersionEntity): VersionEntity;
    list(this: any, reqmatch?: VersionListMatch, ctrl?: Control): Promise<VersionEntity[]>;
}
export { VersionEntity };
