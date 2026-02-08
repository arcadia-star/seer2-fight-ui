/* tslint:disable */
/* eslint-disable */
export type HookDTO =
    "GameStart"
    | "RoundStart"
    | "Moving"
    | "RoundEnd"
    | "GameEnd"
    | "ChangeStat"
    | "ChangeHurt"
    | "ChangeBuff"
    | "SkillPower"
    | "SkillAnger"
    | "SkillType"
    | "SkillCategory"
    | "SkillAccuracy"
    | "SkillCritical"
    | "SkillTimes"
    | "SkillPriority"
    | "BuffRoundDefault"
    | "BuffCountMax"
    | "BuffEndless"
    | "ThisSkillPower"
    | "ThisSkillAnger"
    | "ThisSkillType"
    | "ThisSkillCategory"
    | "ThisSkillAccuracy"
    | "ThisSkillCritical"
    | "ThisSkillTimes"
    | "ThisSkillPriority"
    | "ThisBuffRoundDefault"
    | "ThisBuffCountMax"
    | "ThisBuffEndless";

export interface EffectDTO {
    hook: HookDTO;
    order: number;
    effect: string;
}

export interface MonsterDTO {
    id: number;
    name: string;
    feature: number;
    type: number;
    hp: number;
    atk: number;
    def: number;
    spa: number;
    spd: number;
    spe: number;
    skills: number[];
}

export interface FeatureDTO {
    id: number;
    name: string;
    tips: string;
    effects?: EffectDTO[];
}

export interface CharacterDTO {
    id: number;
    name: string;
    hp: number;
    atk: number;
    def: number;
    spa: number;
    spd: number;
    spe: number;
}

export interface SkillDTO {
    id: number;
    name: string;
    tips: string;
    power: number;
    anger: number;
    type: number;
    category: number;
    accuracy: number;
    critical: number;
    times: number;
    priority: number;
    effects?: EffectDTO[];
}

export interface TypeRateDTO {
    type: number;
    rate: number;
}

export interface TypeDTO {
    id: number;
    name: string;
    rates: TypeRateDTO[];
}

export interface BuffDTO {
    id: number;
    name: string;
    tips: string;
    count_max: number;
    round_default: number;
    endless: number;
    effects?: EffectDTO[];
}

export interface ItemDTO {
    id: number;
    name: string;
    tips: string;
    effects?: EffectDTO[];
}

export interface WeatherDTO {
    id: number;
    name: string;
    tips: string;
    effects?: EffectDTO[];
}

export interface ConfigDTO {
    monsters?: MonsterDTO[];
    features?: FeatureDTO[];
    characters?: CharacterDTO[];
    skills?: SkillDTO[];
    types?: TypeDTO[];
    buffs?: BuffDTO[];
    items?: ItemDTO[];
    weathers?: WeatherDTO[];
}

export interface StatDTO {
    hp: number;
    atk: number;
    def: number;
    spa: number;
    spd: number;
    spe: number;
}

export interface PetItemDTO {
    item: number;
}

export interface PetDTO {
    pet: number;
    monster: number;
    character: number;
    level: number;
    skills: number[];
    iv: StatDTO;
    ev: StatDTO;
    emblem1: number;
    emblem2: number;
    hp: number;
    maxhp: number;
    height: number;
    weight: number;
    items: PetItemDTO[];
}

export interface UserDTO {
    uid: number;
    nick: string;
}

export interface TeamDTO {
    user: UserDTO;
    pets: PetDTO[];
}

export interface ArenaDTO {
    timestamp: number;
    weather: number;
}

export interface DataDTO {
    arena: ArenaDTO;
    left: TeamDTO;
    right: TeamDTO;
}

export type ChangeValueDTO = { $: "Nop" } | { $: "Set"; value: number } | { $: "Add"; value: number } | {
    $: "Sub";
    value: number
} | { $: "Mul"; value: number } | { $: "Div"; value: number } | { $: "AddPct"; value: number } | {
    $: "SubPct";
    value: number
};

export interface AttackDamageDTO {
    pid: number;
    attack: number;
    defence: number;
    power: number;
    times: number;
    category: number;
    rate: number;
    base: number;
    crit: number;
}

export type DamageTypeDTO = { $: "Attack"; ext: AttackDamageDTO } | { $: "Fix" } | { $: "Pct" } | { $: "Real" };

export interface StatResultDTO {
    level: number;
    value: number;
}

export interface ItemResultDTO {
    item: number;
}

export interface SkillResultDTO {
    skill: number;
    power: number;
    anger: number;
    type: number;
    category: number;
    accuracy: number;
    critical: number;
    times: number;
    priority: number;
}

export interface BuffResultDTO {
    buff: number;
    round: number;
    count: number;
    endless: number;
}

export interface PetResultDTO {
    pid: number;
    alive: number;
    hp: number;
    hpMax: number;
    anger: number;
    monster: number;
    feature: number;
    level: number;
    type: number;
    atk: StatResultDTO;
    def: StatResultDTO;
    spa: StatResultDTO;
    spd: StatResultDTO;
    spe: StatResultDTO;
    items: ItemResultDTO[];
    skills: SkillResultDTO[];
    buffs: BuffResultDTO[];
}

export interface TeamResultDTO {
    master: PetResultDTO;
}

export interface ArenaResultDTO {
    round: number;
    turn: number;
    sequence: number;
    weather: number;
    left: TeamResultDTO;
    right: TeamResultDTO;
}

export type FrameTypeResultDTO = "Init" | "RoundStart" | "MoveStart" | "MoveEnd";

export type EventResultDTO = { $: "Move"; pid: number; enemy: number; skill: number; category: number } | {
    $: "Alive";
    pid: number;
    change: ChangeValueDTO
} | { $: "Hp"; pid: number; change: ChangeValueDTO } | { $: "Anger"; pid: number; change: ChangeValueDTO } | {
    $: "Hurt";
    pid: number;
    damage: number;
    type: DamageTypeDTO
} | { $: "Weather"; change: ChangeValueDTO };

export interface EventWithSourceResultDTO {
    event: EventResultDTO;
    source: EffectSourceDTO;
}

export interface FrameResultDTO {
    type: FrameTypeResultDTO;
    arena: ArenaResultDTO;
    events: EventWithSourceResultDTO[];
    logs: string[];
}

export interface FightResultDTO {
    frames: FrameResultDTO[];
}

export type EffectTypeDTO = { $: "Feature"; value: number } | { $: "Emblem1"; value: number } | {
    $: "Emblem2";
    value: number
} | { $: "Skill"; value: number } | { $: "Buff"; value: number } | { $: "Item"; value: number } | {
    $: "Weather";
    value: number
} | { $: "System"; value: number };

export interface EffectSourceDTO {
    type: EffectTypeDTO;
    pid: number | undefined;
}

export interface MetaDTO {
    values: [string, string][];
}


export class ArenaProxy {
    free(): void;

    [Symbol.dispose](): void;

    ready(): FightResultDTO;

    fight(): FightResultDTO;

    user_select_skill(pid: number, skill: number, enemy: number): void;

    static meta(): MetaDTO;

    constructor(data: DataDTO, config: ConfigDTO);
}

export function greet(name: string): void;

export type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

export interface InitOutput {
    readonly memory: WebAssembly.Memory;
    readonly greet: (a: number, b: number) => void;
    readonly arenaproxy_ready: (a: number) => any;
    readonly arenaproxy_fight: (a: number) => any;
    readonly arenaproxy_user_select_skill: (a: number, b: number, c: number, d: number) => void;
    readonly arenaproxy_meta: () => any;
    readonly __wbg_arenaproxy_free: (a: number, b: number) => void;
    readonly arenaproxy_new_from: (a: any, b: any) => number;
    readonly __wbindgen_malloc: (a: number, b: number) => number;
    readonly __wbindgen_realloc: (a: number, b: number, c: number, d: number) => number;
    readonly __wbindgen_exn_store: (a: number) => void;
    readonly __externref_table_alloc: () => number;
    readonly __wbindgen_externrefs: WebAssembly.Table;
    readonly __wbindgen_start: () => void;
}

export type SyncInitInput = BufferSource | WebAssembly.Module;

/**
 * Instantiates the given `module`, which can either be bytes or
 * a precompiled `WebAssembly.Module`.
 *
 * @param {{ module: SyncInitInput }} module - Passing `SyncInitInput` directly is deprecated.
 *
 * @returns {InitOutput}
 */
export function initSync(module: { module: SyncInitInput } | SyncInitInput): InitOutput;

/**
 * If `module_or_path` is {RequestInfo} or {URL}, makes a request and
 * for everything else, calls `WebAssembly.instantiate` directly.
 *
 * @param {{ module_or_path: InitInput | Promise<InitInput> }} module_or_path - Passing `InitInput` directly is deprecated.
 *
 * @returns {Promise<InitOutput>}
 */
export default function __wbg_init(module_or_path?: {
    module_or_path: InitInput | Promise<InitInput>
} | InitInput | Promise<InitInput>): Promise<InitOutput>;
