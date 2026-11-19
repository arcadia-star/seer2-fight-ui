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

export const enum FightSide {
    Left = 1,
    Right = 2,
}

export const enum ChangeType {
    Replace = 1,
    Morph = 2,
}

export const enum FightPosition {
    Inactive = 0,
    Main = 1,
    Sub = 2,
}

export const enum MoveCategory {
    Physical = '物理',
    Typical = '属性',
    Special = '特殊',
    Final = '必杀',
    Fusion = '合体',
}

export const enum UiStyle {
    Classic = 0,
    Spt = 1,
    Double2v2 = 2,
    Double2v1 = 3,
}

export type Frames = {
    uiStyle: UiStyle;
    globalVolume: int;
    mapVolume: int;
    frames?: Frame[];
};
export type BaseFrame = {
    logs?: String[];
    _name?: String;
    smooth?: 1 | 2;
    angerPayment?: { side: FightSide; before: number; after: number };
    hpChanges?: { side: FightSide; kind: 'Damage' | 'Heal' | 'LoseHp' | 'SetHp'; change: number }[];
};
export type SleepFrame = BaseFrame & { sleep: int };
export type DataFrame = BaseFrame & { data: Arena };
export type StartFrame = DataFrame & { start: Start };
export type EndFrame = DataFrame & { end: End };
export type MoveFrame = DataFrame & { move: Move };
export type EventFrame = DataFrame & { event: Event };
export type ChangeFrame = DataFrame & { change: Change };
export type Frame = SleepFrame | StartFrame | EndFrame | MoveFrame | EventFrame | ChangeFrame | DataFrame;

export type Arena = {
    left: Team;
    right: Team;
    round: int;
    mapSwf: String;
    mapSound: String;
    weatherIcon: IconUrl;
    weatherTips: String;
};
export type Team = {
    pets: Fighter[];
    items?: Item[];
    capsules?: Item[];
};
export type Fighter = {
    pid: int;
    petIcon: IconUrl;
    petSwf: PetSwfUrl;
    pose?: string | null; // 模型姿势标签；省略为待机，null 表示保持当前画面。
    petSound: String;
    name: String;
    level: int;
    typeIcon: IconUrl;
    position: FightPosition;
    alive: int;
    anger: int;
    maxAnger: int;
    hp: int;
    maxHp: int;
    rate: int | null; // null 表示本地属性克制表缺项，仅用于阵容预览。

    atk: int;
    def: int;
    spa: int;
    spd: int;
    spe: int;
    skills?: Skill[];
    buffs?: Buff[];
    items?: Item[];
};
export type Skill = {
    id: int;
    name: String;
    power: int;
    anger: int;
    category: String;
    typeIcon: IconUrl;
    tips: String;
    enable: Boolean;
};
export type Buff = {
    id: int;
    name: String;
    count: int;
    icon: IconUrl;
    tips: String;
};
export type Item = {
    id: int;
    targetPids?: int[] | null;
    name: String;
    count: int;
    icon: IconUrl;
    tips: String;
};
export type Move = {
    side: FightSide;
    skill: String;
    category: MoveCategory;
    damage: int;
    critical: int;
    miss: int;
    rate: int;
    soundUrl: String;
    effectUrl: String;
    hits?: int[]; // 模型动画中需要显示受击反馈的帧序号。
    hitTipIds?: int[] | null; // 首次命中时按顺序播放的提示素材。
};
export type Change = {
    left?: ChangeType;
    right?: ChangeType;
};

export const enum EventType {
    HP_INCREASE = 1,
    HP_DECREASE = 2,
    ITEM_HP = 3,
    ITEM_ANGER = 4,
    CATCH_FAILED = 5,
    CATCH_SUCCESS = 6,
    PET_EXCHANGE = 7,
}

export type BaseEvent = {
    side: FightSide;
    delay: int;
};
export type ChangeEvent = BaseEvent & {
    type: EventType.HP_INCREASE | EventType.HP_DECREASE | EventType.ITEM_HP | EventType.ITEM_ANGER;
    change: int;
};
export type CatchEvent = BaseEvent & { type: EventType.CATCH_FAILED | EventType.CATCH_SUCCESS };
export type ExchangeEvent = BaseEvent & { type: EventType.PET_EXCHANGE };
export type Event = ChangeEvent | CatchEvent | ExchangeEvent;

export type Start = {
    urls?: String[];
    tips?: String[];
};
export type End = {
    winner: int;
    alert?: 0 | 2;
};
