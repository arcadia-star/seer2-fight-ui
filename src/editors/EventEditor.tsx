import type {Event, Side} from "@/types";
import {EventType} from "@/types";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {Select, SelectContent, SelectItem, SelectTrigger, SelectValue,} from "@/components/ui/select";

export interface EventEditorProps {
    value: Event;
    onChange: (value: Event) => void;
}

const sideOptions = [
    {value: "1", label: "左侧 (1)"},
    {value: "2", label: "右侧 (2)"},
];

const eventTypeOptions = [
    {value: String(EventType.HP_INCREASE), label: "HP 增加"},
    {value: String(EventType.HP_DECREASE), label: "HP 减少"},
    {value: String(EventType.ITEM_HP), label: "道具 HP"},
    {value: String(EventType.ITEM_ANGER), label: "道具怒气"},
    {value: String(EventType.CATCH_FAILED), label: "捕捉失败"},
    {value: String(EventType.CATCH_SUCCESS), label: "捕捉成功"},
    {value: String(EventType.PET_EXCHANGE), label: "主次换位"},
];

function isChangeEvent(
    e: Event
): e is Event & { type: EventType; change?: number } {
    return (
        e.type === EventType.HP_INCREASE ||
        e.type === EventType.HP_DECREASE ||
        e.type === EventType.ITEM_HP ||
        e.type === EventType.ITEM_ANGER
    );
}

export function EventEditor({value, onChange}: EventEditorProps) {
    return (
        <Card className="w-full">
            <CardHeader className="py-3">
                <span className="text-sm font-medium">事件 (Event)</span>
            </CardHeader>
            <CardContent className="space-y-3">
                <div className="space-y-1.5">
                    <Label>阵营 (side)</Label>
                    <Select
                        value={String(value.side)}
                        onValueChange={(v) =>
                            onChange({...value, side: Number(v) as Side})
                        }
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
                    <Label>延迟 (delay)</Label>
                    <Input
                        type="number"
                        value={value.delay}
                        onChange={(e) =>
                            onChange({...value, delay: Number(e.target.value) || 0})
                        }
                    />
                </div>
                <div className="space-y-1.5">
                    <Label>事件类型 (type)</Label>
                    <Select
                        value={String(value.type)}
                        onValueChange={(v) => {
                            const type = Number(v) as Event["type"];
                            if (
                                type === EventType.HP_INCREASE ||
                                type === EventType.HP_DECREASE ||
                                type === EventType.ITEM_HP ||
                                type === EventType.ITEM_ANGER
                            ) {
                                const change =
                                    isChangeEvent(value) && value.change !== undefined
                                        ? value.change
                                        : 0;
                                onChange({...value, type, change} as Event);
                            } else {
                                onChange({...value, type} as Event);
                            }
                        }}
                    >
                        <SelectTrigger className="w-full">
                            <SelectValue/>
                        </SelectTrigger>
                        <SelectContent>
                            {eventTypeOptions.map((opt) => (
                                <SelectItem key={opt.value} value={opt.value}>
                                    {opt.label}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                </div>
                {isChangeEvent(value) && (
                    <div className="space-y-1.5">
                        <Label>变化量 (change)</Label>
                        <Input
                            type="number"
                            value={value.change ?? 0}
                            onChange={(e) =>
                                onChange({
                                    ...value,
                                    change: Number(e.target.value) || 0,
                                } as Event)
                            }
                        />
                    </div>
                )}
            </CardContent>
        </Card>
    );
}
