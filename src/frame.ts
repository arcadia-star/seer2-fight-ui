export enum FrameType {
    Idle = 1,
    Move = 2,
    Change = 3,
    Operate = 9,
}

export type IconTips = {
    icon: string,
    tips: string,
}
export type FrameSkill = {
    name: string,
    tips: string,
    category: string,
    power: number,
    anger: number,
    type: IconTips,
}
export type FrameBuff = IconTips & {}
export type FramePet = {
    flash: string,
    avatar: string,
    name: string,
    hp: number,
    hpMax: number,
    anger: number,
    angerMax: number,
    level: number,
    buffs: FrameBuff[],
    petType: IconTips,
    petEmblem: IconTips,
    petEmblem2: IconTips,
    petFeature: IconTips,
    skills: FrameSkill[],
}
export type FrameItem = IconTips & {
    count: number,
}
export type FrameFighter = {
    master: FramePet,
    pets: FramePet[],
    skills: FrameSkill[],
    capsules: FrameItem[],
    items: FrameItem[],
}
export type FrameCommon = {
    background: string,
    round: number,
    weather: IconTips,
}
export type IdleFrame = {
    left: FrameFighter,
    right: FrameFighter,
    common: FrameCommon,
}
export type OperateFrame = {
    left: number,
    right: number,
    pet?: number,
    skill?: number,
    capsule?: number,
    item?: number,
    escape?: number,
}
export type MoveFrameDamage = {
    hit: number,
    cri: number,
    rate: number,
    total: number,
}
export type MoveFrame = {
    start: IdleFrame,
    end: IdleFrame,
    move: number,
    skillName: string,
    skillCategory: MoveSkillCategory,
    damage: MoveFrameDamage,
}
export type ChangeFrame = {
    start: IdleFrame,
    end: IdleFrame,
}
export type Frame = {
    type: FrameType,
    data: IdleFrame | OperateFrame | MoveFrame | ChangeFrame,
    logs: string[],
    timestamp: number,
};

export enum MoveSkillCategory {
    Physical = '物理',
    Typical = '属性',
    Special = '特殊',
    Final = '必杀',
    Fusion = '合体',
}