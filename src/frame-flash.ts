import {FramePet, IdleFrame, MoveFrame, MoveFrameDamage, MoveSkillCategory} from "@/frame.ts";

export enum FlashEventType {
    MOVE_START = "moveStart",
    MOVE_END = "moveEnd",
    HIT = "hit",
    READY = "ready",
    PLAY = "play",
    ERROR = "error",
    INFO = "info",
    INIT = "init",
    PLAY_END = "playEnd",
}

export enum FlashMoveLabelType {
    Physical = "物理攻击",
    Typical = "属性攻击",
    Special = "特殊攻击",
    Final = "必杀",
    Fusion = "合体攻击",
    Miss = "闪避",
    Cri = "被暴击",
    Hit = "被打",
    Win = "胜利",
    Dying = "濒死",
    Dead = "失败",
    Idle = "待机",
}

const skillCategory2Flash: Record<MoveSkillCategory, FlashMoveLabelType> = {
    [MoveSkillCategory.Physical]: FlashMoveLabelType.Physical,
    [MoveSkillCategory.Typical]: FlashMoveLabelType.Typical,
    [MoveSkillCategory.Special]: FlashMoveLabelType.Special,
    [MoveSkillCategory.Final]: FlashMoveLabelType.Final,
    [MoveSkillCategory.Fusion]: FlashMoveLabelType.Fusion,
}

function buildHitLabel(damage: MoveFrameDamage) {
    if (damage.hit <= 0) {
        return FlashMoveLabelType.Miss;
    }
    if (damage.cri > 0) {
        return FlashMoveLabelType.Cri;
    }
    return FlashMoveLabelType.Hit
}

function buildIdleLabel(pet: FramePet) {
    if (pet.hp <= 0) {
        return FlashMoveLabelType.Dead;
    }
    if (pet.hp / pet.hpMax < 0.5) {
        return FlashMoveLabelType.Dying;
    }
    return FlashMoveLabelType.Idle
}

export function build4UpdatePet(frame: IdleFrame, change: boolean) {
    return {
        leftUrl: frame.left.master.flash,
        rightUrl: frame.right.master.flash,
        leftLabel: buildIdleLabel(frame.left.master),
        rightLabel: buildIdleLabel(frame.right.master),
        change: change
    }
}

export function build4PlayFight(frame: MoveFrame) {
    const param = {
        moveSide: frame.move,
        moveLabel: skillCategory2Flash[frame.skillCategory],
        hitLabel: buildHitLabel(frame.damage),
        leftLabel: buildIdleLabel(frame.end.left.master),
        rightLabel: buildIdleLabel(frame.end.right.master),
    };
    if (frame.skillCategory === MoveSkillCategory.Typical) {
        param.hitLabel = FlashMoveLabelType.Idle;
    }
    return param;
}