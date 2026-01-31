import type {
    Arena,
    Change,
    ChangeFrame,
    End,
    EndFrame,
    Event,
    EventFrame,
    Frame,
    Move,
    MoveFrame,
    SleepFrame,
    Start,
    StartFrame,
    Team,
} from "@/types";
import {MoveCategory} from "@/types";
import {ArenaEditor} from "@/editors/ArenaEditor";
import {ChangeEditor} from "@/editors/ChangeEditor";
import {EndEditor} from "@/editors/EndEditor";
import {EventEditor} from "@/editors/EventEditor";
import {MoveEditor} from "@/editors/MoveEditor";
import {StartEditor} from "@/editors/StartEditor";
import {StringArrayField} from "@/components/StringArrayField";
import {Button} from "@/components/ui/button";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {Select, SelectContent, SelectItem, SelectTrigger, SelectValue,} from "@/components/ui/select";
import {Trash2} from "lucide-react";

const defaultTeam = (): Team => ({
    pets: [],
    items: [],
    capsules: [],
});

const defaultArena = (): Arena => ({
    left: defaultTeam(),
    right: defaultTeam(),
    round: 0,
    mapSwf: "",
    mapSound: "",
    weatherIcon: "",
    weatherTips: "",
});

const defaultStart = (): Start => ({urls: [], tips: []});
const defaultEnd = (): End => ({winner: 0});
const defaultMove = (): Move => ({
    side: 1,
    skill: "",
    category: MoveCategory.Physical,
    damage: 0,
    critical: 0,
    miss: 0,
    rate: 0,
    soundUrl: "",
    effectUrl: "",
});
const defaultEvent = (): Event => ({
    side: 1,
    delay: 0,
    type: 1,
    change: 0,
});
const defaultChange = (): Change => ({});

type FrameKind =
    | "sleep"
    | "start"
    | "end"
    | "move"
    | "event"
    | "change"
    | "data";

export function getFrameKind(frame: Frame): FrameKind {
    if ("sleep" in frame) return "sleep";
    if ("start" in frame) return "start";
    if ("end" in frame) return "end";
    if ("move" in frame) return "move";
    if ("event" in frame) return "event";
    if ("change" in frame) return "change";
    if ("data" in frame) return "data";
    return "data";
}

export type {FrameKind};

export interface FrameEditorProps {
    value: Frame;
    onChange: (value: Frame) => void;
    onRemove?: () => void;
    index?: number;
}

export function FrameEditor({
                                value,
                                onChange,
                                onRemove,
                                index = 0,
                            }: FrameEditorProps) {
    const kind = getFrameKind(value);
    const logs = value.logs ?? [];

    const setLogs = (next: string[]) => {
        onChange({...value, logs: next} as Frame);
    };

    const baseWithName = () => ({logs, _name: value._name ?? ""});

    const setKind = (newKind: FrameKind) => {
        const base = baseWithName();
        if (newKind === "sleep") {
            const sleep = (value as SleepFrame).sleep ?? 0;
            onChange({...base, sleep} as Frame);
            return;
        }
        const data =
            "data" in value && value.data
                ? value.data
                : defaultArena();
        if (newKind === "start") {
            const start = (value as StartFrame).start ?? defaultStart();
            onChange({...base, data, start} as Frame);
            return;
        }
        if (newKind === "end") {
            const end = (value as EndFrame).end ?? defaultEnd();
            onChange({...base, data, end} as Frame);
            return;
        }
        if (newKind === "move") {
            const move = (value as MoveFrame).move ?? defaultMove();
            onChange({...base, data, move} as Frame);
            return;
        }
        if (newKind === "event") {
            const event = (value as EventFrame).event ?? defaultEvent();
            onChange({...base, data, event} as Frame);
            return;
        }
        if (newKind === "change") {
            const change = (value as ChangeFrame).change ?? defaultChange();
            onChange({...base, data, change} as Frame);
            return;
        }
        onChange({...base, data} as Frame);
    };

    const arena = "data" in value && value.data ? value.data : defaultArena();
    const hasData = kind !== "sleep";

    return (
        <div className="space-y-4">
            {/* 1. 帧独有属性 */}
            <Card>
                <CardHeader className="py-3">
                    <div className="flex items-center gap-2">
                        <span className="text-sm font-medium">帧独有属性</span>
                        <span className="text-muted-foreground text-xs">#{index + 1}</span>
                        <Select
                            value={kind}
                            onValueChange={(v) => setKind(v as FrameKind)}
                        >
                            <SelectTrigger className="w-[120px] ml-auto">
                                <SelectValue/>
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem value="sleep">Sleep</SelectItem>
                                <SelectItem value="start">Start</SelectItem>
                                <SelectItem value="end">End</SelectItem>
                                <SelectItem value="move">Move</SelectItem>
                                <SelectItem value="event">Event</SelectItem>
                                <SelectItem value="change">Change</SelectItem>
                                <SelectItem value="data">Data</SelectItem>
                            </SelectContent>
                        </Select>
                        {onRemove && (
                            <Button type="button" variant="ghost" size="icon-xs" onClick={onRemove}>
                                <Trash2 className="size-3"/>
                            </Button>
                        )}
                    </div>
                </CardHeader>
                <CardContent className="space-y-3">
                    <div className="space-y-1.5">
                        <Label>帧名称 (_name)</Label>
                        <Input
                            value={value._name ?? ""}
                            onChange={(e) =>
                                onChange({...value, _name: e.target.value} as Frame)
                            }
                            placeholder="可选，用于列表显示"
                        />
                    </div>
                    {kind === "sleep" && (
                        <div className="space-y-1.5">
                            <Label>睡眠时长 (sleep，毫秒，结束后播放下一帧)</Label>
                            <Input
                                type="number"
                                value={(value as SleepFrame).sleep ?? 0}
                                onChange={(e) =>
                                    onChange({...value, sleep: Number(e.target.value) || 0} as Frame)
                                }
                            />
                        </div>
                    )}
                    {kind === "start" && (
                        <StartEditor
                            value={(value as StartFrame).start ?? defaultStart()}
                            onChange={(start) => onChange({...value, start} as Frame)}
                        />
                    )}
                    {kind === "end" && (
                        <EndEditor
                            value={(value as EndFrame).end ?? defaultEnd()}
                            onChange={(end) => onChange({...value, end} as Frame)}
                        />
                    )}
                    {kind === "move" && (
                        <MoveEditor
                            value={(value as MoveFrame).move ?? defaultMove()}
                            onChange={(move) => onChange({...value, move} as Frame)}
                        />
                    )}
                    {kind === "event" && (
                        <EventEditor
                            value={(value as EventFrame).event ?? defaultEvent()}
                            onChange={(event) => onChange({...value, event} as Frame)}
                        />
                    )}
                    {kind === "change" && (
                        <ChangeEditor
                            value={(value as ChangeFrame).change ?? defaultChange()}
                            onChange={(change) => onChange({...value, change} as Frame)}
                        />
                    )}
                    {kind === "data" && (
                        <p className="text-muted-foreground text-sm">仅包含 Arena 与日志，无额外帧属性。</p>
                    )}
                </CardContent>
            </Card>

            {/* 2. Arena（战场 + 左右队伍）- 仅当有 data 时 */}
            {hasData && (
                <ArenaEditor
                    value={arena}
                    onChange={(data) => onChange({...value, data} as Frame)}
                />
            )}

            {/* 3. 日志 */}
            <Card>
                <CardHeader className="py-3">
                    <span className="text-sm font-medium">日志属性</span>
                </CardHeader>
                <CardContent>
                    <StringArrayField
                        value={logs}
                        onChange={setLogs}
                        label="日志 (logs，支持部分html标签)"
                        addLabel="添加日志"
                        itemPlaceholder="一条日志"
                    />
                </CardContent>
            </Card>
        </div>
    );
}
