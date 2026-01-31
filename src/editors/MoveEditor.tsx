import type {Move, Side} from "@/types";
import {MoveCategory, Side as SideEnum} from "@/types";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {Select, SelectContent, SelectItem, SelectTrigger, SelectValue,} from "@/components/ui/select";

export interface MoveEditorProps {
    value: Move;
    onChange: (value: Move) => void;
}

const sideOptions = [
    {value: String(SideEnum.Left), label: "左侧 (1)"},
    {value: String(SideEnum.Right), label: "右侧 (2)"},
];

const categoryOptions = [
    {value: MoveCategory.Physical, label: MoveCategory.Physical},
    {value: MoveCategory.Typical, label: MoveCategory.Typical},
    {value: MoveCategory.Special, label: MoveCategory.Special},
    {value: MoveCategory.Final, label: MoveCategory.Final},
    {value: MoveCategory.Fusion, label: MoveCategory.Fusion},
];

export function MoveEditor({value, onChange}: MoveEditorProps) {
    return (
        <Card className="w-full">
            <CardHeader className="py-3">
                <span className="text-sm font-medium">行动 (Move)</span>
            </CardHeader>
            <CardContent className="space-y-3">
                <div className="space-y-1.5">
                    <Label>阵营 (side)</Label>
                    <Select
                        value={String(value.side)}
                        onValueChange={(v) => onChange({...value, side: Number(v) as Side})}
                    >
                        <SelectTrigger className="w-full">
                            <SelectValue/>
                        </SelectTrigger>
                        <SelectContent>
                            {sideOptions.map((opt) => (
                                <SelectItem key={opt.value} value={opt.value}>
                                    {opt.label}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                </div>
                <div className="space-y-1.5">
                    <Label>技能 (skill)</Label>
                    <Input
                        value={value.skill}
                        onChange={(e) => onChange({...value, skill: e.target.value})}
                    />
                </div>
                <div className="space-y-1.5">
                    <Label>类别 (category)</Label>
                    <Select
                        value={value.category}
                        onValueChange={(v) =>
                            onChange({...value, category: v as Move["category"]})
                        }
                    >
                        <SelectTrigger className="w-full">
                            <SelectValue/>
                        </SelectTrigger>
                        <SelectContent>
                            {categoryOptions.map((opt) => (
                                <SelectItem key={opt.value} value={opt.value}>
                                    {opt.label}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>伤害 (damage)</Label>
                        <Input
                            type="number"
                            value={value.damage}
                            onChange={(e) =>
                                onChange({...value, damage: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>暴击 (critical)</Label>
                        <Input
                            type="number"
                            value={value.critical}
                            onChange={(e) =>
                                onChange({...value, critical: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>miss</Label>
                        <Input
                            type="number"
                            value={value.miss}
                            onChange={(e) =>
                                onChange({...value, miss: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>rate</Label>
                        <Input
                            type="number"
                            value={value.rate}
                            onChange={(e) =>
                                onChange({...value, rate: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                </div>
                <div className="space-y-1.5">
                    <Label>音效 (soundUrl)</Label>
                    <Input
                        value={value.soundUrl}
                        onChange={(e) => onChange({...value, soundUrl: e.target.value})}
                    />
                </div>
                <div className="space-y-1.5">
                    <Label>特效 (effectUrl)</Label>
                    <Input
                        value={value.effectUrl}
                        onChange={(e) => onChange({...value, effectUrl: e.target.value})}
                    />
                </div>
            </CardContent>
        </Card>
    );
}
