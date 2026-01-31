import type {Skill} from "@/types";
import {Button} from "@/components/ui/button";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {Switch} from "@/components/ui/switch";
import {Textarea} from "@/components/ui/textarea";
import {Trash2} from "lucide-react";

export interface SkillEditorProps {
    value: Skill;
    onChange: (value: Skill) => void;
    onRemove?: () => void;
}

export function SkillEditor({value, onChange, onRemove}: SkillEditorProps) {
    return (
        <Card className="w-full">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 py-3">
                <span className="text-sm font-medium">技能</span>
                {onRemove && (
                    <Button type="button" variant="ghost" size="icon-xs" onClick={onRemove}>
                        <Trash2 className="size-3"/>
                    </Button>
                )}
            </CardHeader>
            <CardContent className="space-y-3">
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>ID</Label>
                        <Input
                            type="number"
                            value={value.id}
                            onChange={(e) => onChange({...value, id: Number(e.target.value) || 0})}
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>威力</Label>
                        <Input
                            type="number"
                            value={value.power}
                            onChange={(e) => onChange({...value, power: Number(e.target.value) || 0})}
                        />
                    </div>
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>怒气消耗</Label>
                        <Input
                            type="number"
                            value={value.anger}
                            onChange={(e) => onChange({...value, anger: Number(e.target.value) || 0})}
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>类别</Label>
                        <Input
                            value={value.category}
                            onChange={(e) => onChange({...value, category: e.target.value})}
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
                <div className="space-y-1.5">
                    <Label>属性图标url</Label>
                    <Input
                        value={value.typeIcon}
                        onChange={(e) => onChange({...value, typeIcon: e.target.value})}
                    />
                </div>
                <div className="flex items-center gap-2">
                    <Switch
                        checked={value.enable}
                        onCheckedChange={(checked) => onChange({...value, enable: checked})}
                    />
                    <Label>是否可使用</Label>
                </div>
                <div className="space-y-1.5">
                    <Label>提示 (tips，支持部分html标签)</Label>
                    <Textarea
                        value={value.tips}
                        onChange={(e) => onChange({...value, tips: e.target.value})}
                        rows={2}
                    />
                </div>
            </CardContent>
        </Card>
    );
}
