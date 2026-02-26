import type {Pet, Position} from "@/types";
import {Position as PositionEnum} from "@/types";
import {BuffEditor} from "@/editors/BuffEditor";
import {SkillEditor} from "@/editors/SkillEditor";
import {Button} from "@/components/ui/button";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {Select, SelectContent, SelectItem, SelectTrigger, SelectValue,} from "@/components/ui/select";
import {Tabs, TabsContent, TabsList, TabsTrigger} from "@/components/ui/tabs";
import {Plus, Trash2} from "lucide-react";

const defaultBuff = () => ({id: 0, name: "", count: 0, icon: "", tips: ""});
const defaultSkill = () => ({
    id: 0,
    name: "",
    power: 0,
    anger: 0,
    category: "",
    typeIcon: "",
    tips: "",
    enable: true,
});

export interface PetEditorProps {
    value: Pet;
    onChange: (value: Pet) => void;
    onRemove?: () => void;
}

export function PetEditor({value, onChange, onRemove}: PetEditorProps) {
    const positionOptions = [
        {value: String(PositionEnum.Default), label: "默认 (0)"},
        {value: String(PositionEnum.Master), label: "主位 (1)"},
        {value: String(PositionEnum.Slave), label: "副位 (2)"},
    ];

    return (
        <Card className="w-full">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 py-3">
                <span className="text-sm font-medium">精灵 - {value.name || "未命名"}</span>
                {onRemove && (
                    <Button type="button" variant="ghost" size="icon-xs" onClick={onRemove}>
                        <Trash2 className="size-3"/>
                    </Button>
                )}
            </CardHeader>
            <CardContent className="space-y-3">
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>pid</Label>
                        <Input
                            type="number"
                            value={value.pid}
                            onChange={(e) => onChange({...value, pid: Number(e.target.value) || 0})}
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>等级</Label>
                        <Input
                            type="number"
                            value={value.level}
                            onChange={(e) => onChange({...value, level: Number(e.target.value) || 0})}
                        />
                    </div>
                </div>
                <div className="space-y-1.5">
                    <Label>名称</Label>
                    <Input
                        value={value.name}
                        onChange={(e) => onChange({...value, name: e.target.value})}
                    />
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>精灵图标url</Label>
                        <Input
                            value={value.petIcon}
                            onChange={(e) => onChange({...value, petIcon: e.target.value})}
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>属性图标url</Label>
                        <Input
                            value={value.typeIcon}
                            onChange={(e) => onChange({...value, typeIcon: e.target.value})}
                        />
                    </div>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>战斗动画url (petSwf)</Label>
                        <Input
                            value={value.petSwf}
                            onChange={(e) => onChange({...value, petSwf: e.target.value})}
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>精灵叫声url (petSound)</Label>
                        <Input
                            value={value.petSound}
                            onChange={(e) => onChange({...value, petSound: e.target.value})}
                        />
                    </div>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>位置</Label>
                        <Select
                            value={String(value.position)}
                            onValueChange={(v) =>
                                onChange({...value, position: Number(v) as Position})
                            }
                        >
                            <SelectTrigger className="w-full">
                                <SelectValue/>
                            </SelectTrigger>
                            <SelectContent>
                                {positionOptions.map((opt) => (
                                    <SelectItem key={opt.value} value={opt.value}>
                                        {opt.label}
                                    </SelectItem>
                                ))}
                            </SelectContent>
                        </Select>
                    </div>
                    <div className="space-y-1.5">
                        <Label>存活 (alive)</Label>
                        <Input
                            type="number"
                            value={value.alive}
                            onChange={(e) => onChange({...value, alive: Number(e.target.value) || 0})}
                        />
                    </div>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>怒气</Label>
                        <Input
                            type="number"
                            value={value.anger}
                            onChange={(e) => onChange({...value, anger: Number(e.target.value) || 0})}
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>最大怒气</Label>
                        <Input
                            type="number"
                            value={value.maxAnger}
                            onChange={(e) =>
                                onChange({...value, maxAnger: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>体力</Label>
                        <Input
                            type="number"
                            value={value.hp}
                            onChange={(e) => onChange({...value, hp: Number(e.target.value) || 0})}
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>最大体力</Label>
                        <Input
                            type="number"
                            value={value.maxHp}
                            onChange={(e) =>
                                onChange({...value, maxHp: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>克制系数 (rate)</Label>
                        <Input
                            type="number"
                            value={value.rate}
                            onChange={(e) =>
                                onChange({...value, rate: Number(e.target.value) || 0})
                            }
                        />
                    </div>

                    <div className="space-y-1.5">
                        <Label>速度等级</Label>
                        <Input
                            type="number"
                            value={value.spe}
                            onChange={(e) =>
                                onChange({...value, spe: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                </div>
                <div className="grid grid-cols-4 gap-2">
                    <div className="space-y-1.5">
                        <Label>物攻等级</Label>
                        <Input
                            type="number"
                            value={value.atk}
                            onChange={(e) =>
                                onChange({...value, atk: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>物防等级</Label>
                        <Input
                            type="number"
                            value={value.def}
                            onChange={(e) =>
                                onChange({...value, def: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>特攻等级</Label>
                        <Input
                            type="number"
                            value={value.spa}
                            onChange={(e) =>
                                onChange({...value, spa: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>特防等级</Label>
                        <Input
                            type="number"
                            value={value.spd}
                            onChange={(e) =>
                                onChange({...value, spd: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                </div>

                <Tabs defaultValue="skills">
                    <TabsList className="w-full">
                        <TabsTrigger value="skills" className="flex-1">
                            技能 ({(value.skills ?? []).length})
                        </TabsTrigger>
                        <TabsTrigger value="buffs" className="flex-1">
                            Buff ({(value.buffs ?? []).length})
                        </TabsTrigger>
                    </TabsList>
                    <TabsContent value="skills" className="space-y-2 mt-2">
                        {(value.skills ?? []).map((skill, i) => (
                            <SkillEditor
                                key={i}
                                value={skill}
                                onChange={(s) => {
                                    const skills = value.skills ?? [];
                                    const next = [...skills];
                                    next[i] = s;
                                    onChange({...value, skills: next});
                                }}
                                onRemove={() => {
                                    const skills = value.skills ?? [];
                                    const next = skills.filter((_, j) => j !== i);
                                    onChange({...value, skills: next});
                                }}
                            />
                        ))}
                        <Button
                            type="button"
                            variant="outline"
                            size="sm"
                            className="w-full"
                            onClick={() =>
                                onChange({...value, skills: [...(value.skills ?? []), defaultSkill()]})
                            }
                        >
                            <Plus className="size-4 mr-1"/> 添加技能
                        </Button>
                    </TabsContent>
                    <TabsContent value="buffs" className="space-y-2 mt-2">
                        {(value.buffs ?? []).map((buff, i) => (
                            <BuffEditor
                                key={i}
                                value={buff}
                                onChange={(b) => {
                                    const buffs = value.buffs ?? [];
                                    const next = [...buffs];
                                    next[i] = b;
                                    onChange({...value, buffs: next});
                                }}
                                onRemove={() => {
                                    const buffs = value.buffs ?? [];
                                    const next = buffs.filter((_, j) => j !== i);
                                    onChange({...value, buffs: next});
                                }}
                            />
                        ))}
                        <Button
                            type="button"
                            variant="outline"
                            size="sm"
                            className="w-full"
                            onClick={() =>
                                onChange({...value, buffs: [...(value.buffs ?? []), defaultBuff()]})
                            }
                        >
                            <Plus className="size-4 mr-1"/> 添加 Buff
                        </Button>
                    </TabsContent>
                </Tabs>
            </CardContent>
        </Card>
    );
}
