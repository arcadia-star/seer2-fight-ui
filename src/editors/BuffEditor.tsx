import type {Buff} from "@/types";
import {Button} from "@/components/ui/button";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {Textarea} from "@/components/ui/textarea";
import {Trash2} from "lucide-react";

export interface BuffEditorProps {
    value: Buff;
    onChange: (value: Buff) => void;
    onRemove?: () => void;
}

export function BuffEditor({value, onChange, onRemove}: BuffEditorProps) {
    return (
        <Card className="w-full">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 py-3">
                <span className="text-sm font-medium">Buff</span>
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
                        <Label>层数 (count)</Label>
                        <Input
                            type="number"
                            value={value.count}
                            onChange={(e) => onChange({...value, count: Number(e.target.value) || 0})}
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
                    <Label>图标url</Label>
                    <Input
                        value={value.icon}
                        onChange={(e) => onChange({...value, icon: e.target.value})}
                    />
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
