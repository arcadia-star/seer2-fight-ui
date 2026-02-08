export type int = number;
export type String = string;
export type Boolean = boolean;

//eg: <url, item swf>
//eg: ext-img://<url, image>
export type IconUrl = String;

//eg: <url, seer2 pet fight swf>
//eg: ext-s1://<url, seer pet fight swf>
//eg: ext-img://<url, image>
export type PetSwfUrl = String;

export const enum Side {
    Left = 1,
    Right = 2,
}

export const enum ChangeType {
    Replace = 1,
    Morph = 2,
}

export const enum Position {
    Default = 0,
    Master = 1,
}

export const enum MoveCategory {
    Physical = '物理',
    Typical = '属性',
    Special = '特殊',
    Final = '必杀',
    Fusion = '合体',
}

export type Frames = {
    globalVolume: int;
    mapVolume: int;
    frames?: Frame[];
}
export type BaseFrame = { logs?: String[]; _name?: String; }
export type SleepFrame = BaseFrame & { sleep: int; }
export type DataFrame = BaseFrame & { data: Arena; }
export type StartFrame = DataFrame & { start: Start; }
export type EndFrame = DataFrame & { end: End; }
export type MoveFrame = DataFrame & { move: Move; }
export type EventFrame = DataFrame & { event: Event; }
export type ChangeFrame = DataFrame & { change: Change; }
export type Frame = SleepFrame | StartFrame | EndFrame | MoveFrame | EventFrame | ChangeFrame | DataFrame

export type Arena = {
    left: Team;
    right: Team;
    round: int;
    mapSwf: String;
    mapSound: String;
    weatherIcon: IconUrl;
    weatherTips: String;
}
export type Team = {
    pets: Pet[];
    items?: Item[];
    capsules?: Item[];
}
export type Pet = {
    pid: int;
    petIcon: IconUrl;
    petSwf: PetSwfUrl;
    petSound: String;
    name: String;
    level: int;
    typeIcon: IconUrl;
    position: Position;
    alive: int;
    anger: int;
    maxAnger: int;
    hp: int;
    maxHp: int;
    rate: int;
    atk: int;
    def: int;
    spa: int;
    spd: int;
    spe: int;
    skills?: Skill[];
    buffs?: Buff[];
}
export type Skill = {
    id: int;
    name: String;
    power: int;
    anger: int;
    category: String;
    typeIcon: IconUrl;
    tips: String;
    enable: Boolean;
}
export type Buff = {
    id: int;
    name: String;
    count: int;
    icon: IconUrl;
    tips: String;
}
export type Item = {
    id: int;
    name: String;
    count: int;
    icon: IconUrl;
    tips: String;
}
export type Move = {
    side: Side;
    skill: String;
    category: MoveCategory;
    damage: int;
    critical: int;
    miss: int;
    rate: int;
    soundUrl: String;
    effectUrl: String;
}
export type Change = {
    left?: ChangeType;
    right?: ChangeType;
}

export const enum EventType {
    HP_INCREASE = 1,
    HP_DECREASE = 2,
    ITEM_HP = 3,
    ITEM_ANGER = 4,
    CATCH_FAILED = 5,
    CATCH_SUCCESS = 6,
}

export type BaseEvent = { side: Side; delay: int };
export type ChangeEvent = BaseEvent & {
    type: EventType.HP_INCREASE | EventType.HP_DECREASE | EventType.ITEM_HP | EventType.ITEM_ANGER;
    change: int;
};
export type CatchEvent = BaseEvent & { type: EventType.CATCH_FAILED | EventType.CATCH_SUCCESS };
export type Event = ChangeEvent | CatchEvent;

export type Start = {
    urls?: String[];
    tips?: String[];
}
export type End = {
    winner: int;
}