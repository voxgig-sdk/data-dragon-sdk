export interface Champion {
    id?: string;
}
export interface ChampionLoadMatch {
    id: string;
    version: string;
}
export interface DataChampion {
    image?: Record<string, any>;
    key?: string;
    name?: string;
    title?: string;
}
export interface DataChampionLoadMatch {
    language: string;
    version: string;
}
export interface DataItem {
    description?: string;
    image?: Record<string, any>;
    name?: string;
}
export interface DataItemLoadMatch {
    language: string;
    version: string;
}
export interface DataRune {
}
export interface DataRuneLoadMatch {
    language: string;
    version: string;
}
export interface DragontailVersiontgz {
}
export interface DragontailVersiontgzLoadMatch {
    version: string;
}
export interface Item {
    id?: string;
}
export interface ItemLoadMatch {
    id: string;
    version: string;
}
export interface Region {
    champion?: string;
    item?: string;
    rune?: string;
}
export interface RegionLoadMatch {
    region: string;
}
export interface Version {
}
export interface VersionListMatch {
}
