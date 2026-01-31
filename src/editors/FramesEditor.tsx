import * as React from "react";
import {useRef} from "react";
import type {EndFrame, EventFrame, Frame, Frames, MoveFrame, SleepFrame} from "@/types";
import {FrameEditor, getFrameKind} from "@/editors/FrameEditor";
import {Button} from "@/components/ui/button";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {ScrollArea} from "@/components/ui/scroll-area";
import {Tabs, TabsContent, TabsList, TabsTrigger} from "@/components/ui/tabs";
import {toast} from "sonner";
import {Copy, FileDown, FileUp, Plus, Trash2} from "lucide-react";
import {FightPlayer} from "@/player/fight-player.tsx";
import {RufflePlayerEl} from "@/components/ruffle-player.tsx";
import mock from '@/demo.json'

function copyTextToClipboard(text: string): Promise<void> {
    if (navigator.clipboard?.writeText) {
        return navigator.clipboard.writeText(text);
    }
    const el = document.createElement("textarea");
    el.value = text;
    el.style.position = "fixed";
    el.style.opacity = "0";
    document.body.appendChild(el);
    el.select();
    try {
        document.execCommand("copy");
        return Promise.resolve();
    } finally {
        document.body.removeChild(el);
    }
}

const FRAME_KIND_LABELS: Record<ReturnType<typeof getFrameKind>, string> = {
    sleep: "Sleep",
    start: "Start",
    end: "End",
    move: "Move",
    event: "Event",
    change: "Change",
    data: "Data",
};

function getFrameDisplayName(frame: Frame): string {
    if (frame._name?.trim()) return frame._name;
    const kind = getFrameKind(frame);
    if (kind === "sleep") return `Sleep ${(frame as SleepFrame).sleep ?? 0}ms`;
    if (kind === "start") return "Start";
    if (kind === "end") {
        const w = (frame as EndFrame).end?.winner ?? 0;
        return w === 1 ? "End (左胜)" : w === 2 ? "End (右胜)" : "End (平局)";
    }
    if (kind === "move") return (frame as MoveFrame).move?.skill || "Move";
    if (kind === "event") return `Event #${(frame as EventFrame).event?.type ?? ""}`;
    if (kind === "change") return "Change";
    return "Data";
}

const defaultFrame = (): Frame => ({
    logs: [],
    sleep: 0,
    _name: "",
});

export function FramesEditor() {
    const [data, setData] = React.useState<Frames>(mock as Frames || {
        globalVolume: 100,
        mapVolume: 100,
        frames: [],
    });
    const [selectedIndex, setSelectedIndex] = React.useState<number | null>(null);
    const [mainTab, setMainTab] = React.useState<"edit" | "io">("edit");
    const ruffleRef = useRef<RufflePlayerEl>(null);

    const frames = data.frames ?? [];
    const selectedFrame = selectedIndex !== null ? frames[selectedIndex] : null;

    const updateFrame = (index: number, frame: Frame) => {
        const next = [...frames];
        next[index] = frame;
        setData({...data, frames: next});
    };

    /** 复制帧：在当前位置后新增一帧（内容为该帧的副本） */
    const duplicateFrame = (e: React.MouseEvent, index: number) => {
        e.stopPropagation();
        const frame = frames[index];
        if (!frame) return;
        const copy = JSON.parse(JSON.stringify(frame)) as Frame;
        const next = [...frames];
        next.splice(index + 1, 0, copy);
        setData({...data, frames: next});
        setSelectedIndex(index + 1);
        setMainTab("edit");
        toast.success("已新增一帧");
    };

    const removeFrame = (index: number) => {
        const next = frames.filter((_, i) => i !== index);
        setData({...data, frames: next});
        if (selectedIndex === index) setSelectedIndex(null);
        else if (selectedIndex !== null && selectedIndex > index)
            setSelectedIndex(selectedIndex - 1);
    };

    const addFrame = () => {
        const next = [...frames, defaultFrame()];
        setData({...data, frames: next});
        setSelectedIndex(next.length - 1);
    };

    const handleImport = (text: string) => {
        try {
            const parsed = JSON.parse(text) as Frames;
            if (typeof parsed.globalVolume !== "number" || typeof parsed.mapVolume !== "number") {
                throw new Error("Invalid Frames JSON");
            }
            const importedFrames = parsed.frames != null && Array.isArray(parsed.frames) ? parsed.frames : [];
            setData({...parsed, frames: importedFrames});
            setSelectedIndex(null);
        } catch (e) {
            alert("导入失败：" + (e instanceof Error ? e.message : String(e)));
        }
    };

    const copyJson = async (text: string, label: string) => {
        try {
            await copyTextToClipboard(text);
            toast.success(`已复制 ${label} 到剪贴板`);
        } catch {
            toast.error("复制失败，请检查剪贴板权限或使用 HTTPS");
        }
    };

    const handleExport = () => {
        const blob = new Blob([JSON.stringify(data, null, 2)], {type: "application/json"});
        const url = URL.createObjectURL(blob);
        const a = document.createElement("a");
        a.href = url;
        a.download = "frames.json";
        a.click();
        URL.revokeObjectURL(url);
    };

    return (
        <div className="flex h-screen overflow-hidden bg-muted/30">
            {/* 左侧边栏：固定高度，内部滚动，不撑开主页面 */}
            <aside className="flex h-full w-72 min-w-0 flex-col overflow-hidden border-r bg-card shrink-0">
                <div className="shrink-0 border-b p-4 space-y-3">
                    <h1 className="text-sm font-semibold">Frames 生成工具</h1>
                    <div className="space-y-1.5">
                        <Label className="text-xs">全局音量</Label>
                        <Input
                            type="number"
                            min={0}
                            max={100}
                            value={data.globalVolume}
                            onChange={(e) =>
                                setData({...data, globalVolume: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label className="text-xs">地图音量</Label>
                        <Input
                            type="number"
                            min={0}
                            max={100}
                            value={data.mapVolume}
                            onChange={(e) =>
                                setData({...data, mapVolume: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                    <Button type="button" className="w-full" onClick={addFrame}>
                        <Plus className="size-4 mr-2"/> 添加帧
                    </Button>
                </div>
                <div className="min-h-0 flex-1 overflow-hidden">
                    <ScrollArea className="h-full">
                        <div className="p-2 space-y-1">
                            {frames.length === 0 ? (
                                <p className="text-muted-foreground py-4 text-center text-xs">
                                    暂无帧
                                </p>
                            ) : (
                                frames.map((frame, i) => {
                                    const kind = getFrameKind(frame);
                                    const label = FRAME_KIND_LABELS[kind];
                                    const name = getFrameDisplayName(frame);
                                    const isSelected = selectedIndex === i;
                                    return (
                                        <div
                                            key={i}
                                            className={`flex items-center gap-2 rounded-md border px-2 py-2 text-xs transition-colors ${
                                                isSelected ? "border-primary bg-primary/10" : "hover:bg-muted/50"
                                            }`}
                                        >
                                            <button
                                                type="button"
                                                className="flex-1 min-w-0 text-left"
                                                onClick={() => {
                                                    setSelectedIndex(i);
                                                    //setMainTab("edit");
                                                }}
                                            >
                                                <div className="font-medium">#{i + 1}</div>
                                                <div className="text-muted-foreground truncate">{label}</div>
                                                <div className="truncate">{name}</div>
                                            </button>
                                            <Button
                                                type="button"
                                                variant="ghost"
                                                size="icon-xs"
                                                onClick={(e) => duplicateFrame(e, i)}
                                                title="复制（新增一帧）"
                                            >
                                                <Copy className="size-3"/>
                                            </Button>
                                            <Button
                                                type="button"
                                                variant="ghost"
                                                size="icon-xs"
                                                onClick={(e) => {
                                                    e.stopPropagation();
                                                    removeFrame(i);
                                                }}
                                                title="删除"
                                            >
                                                <Trash2 className="size-3"/>
                                            </Button>
                                        </div>
                                    );
                                })
                            )}
                        </div>
                    </ScrollArea>
                </div>
            </aside>

            {/* 主栏：可滚动，仅左栏固定 */}
            <main className="flex min-h-0 flex-1 flex-col min-w-0 overflow-auto">
                <Tabs value={mainTab} onValueChange={(v) => setMainTab(v as "edit" | "io")}
                      className="flex-1 flex flex-col">
                    <div className="border-b px-4">
                        <TabsList className="h-10">
                            <TabsTrigger value="edit">编辑</TabsTrigger>
                            <TabsTrigger value="io">导入 / 导出 / 预览</TabsTrigger>
                            <TabsTrigger value="play">播放</TabsTrigger>
                        </TabsList>
                    </div>
                    <TabsContent value="edit" className="flex-1 m-0 overflow-auto p-4">
                        {selectedFrame === undefined ? (
                            <div className="flex items-center justify-center h-full text-muted-foreground text-sm">
                                请在左侧选择或添加一帧进行编辑
                            </div>
                        ) : selectedFrame === null ? null : (
                            <div className="max-w-3xl mx-auto space-y-4">
                                <FrameEditor
                                    index={selectedIndex ?? 0}
                                    value={selectedFrame}
                                    onChange={(f) => selectedIndex !== null && updateFrame(selectedIndex, f)}
                                />
                            </div>
                        )}
                    </TabsContent>
                    <TabsContent value="io" className="flex-1 m-0 overflow-auto p-4">
                        <div className="max-w-3xl mx-auto space-y-4">
                            <Card>
                                <CardHeader className="flex flex-row items-center justify-between">
                                    <span className="text-sm font-medium">导入 / 导出</span>
                                    <div className="flex gap-2">
                                        <Button type="button" variant="outline" size="sm" onClick={handleExport}>
                                            <FileDown className="size-4 mr-1"/> 导出 JSON
                                        </Button>
                                        <label className="cursor-pointer">
                                            <input
                                                type="file"
                                                accept=".json,application/json"
                                                className="hidden"
                                                onChange={(e) => {
                                                    const file = e.target.files?.[0];
                                                    if (!file) return;
                                                    const reader = new FileReader();
                                                    reader.onload = () => {
                                                        const text = reader.result as string;
                                                        handleImport(text);
                                                    };
                                                    reader.readAsText(file);
                                                }}
                                            />
                                            <span
                                                className="inline-flex items-center justify-center rounded-md text-sm font-medium border bg-background px-3 py-2 h-8 cursor-pointer hover:bg-accent">
                        <FileUp className="size-4 mr-1"/> 导入 JSON
                      </span>
                                        </label>
                                    </div>
                                </CardHeader>
                            </Card>
                            <Card>
                                <CardHeader className="flex flex-row items-center justify-between space-y-0">
                                    <div>
                                        <span className="text-sm font-medium">当前帧 JSON</span>
                                        <CardDescription>仅在选择了一帧时显示</CardDescription>
                                    </div>
                                    {selectedFrame != null && (
                                        <Button
                                            type="button"
                                            variant="outline"
                                            size="sm"
                                            onClick={() =>
                                                copyJson(JSON.stringify(selectedFrame, null, 2), "当前帧 JSON")
                                            }
                                        >
                                            <Copy className="size-4 mr-1"/> 复制 JSON
                                        </Button>
                                    )}
                                </CardHeader>
                                <CardContent>
                                    {selectedFrame != null ? (
                                        <pre className="bg-muted rounded-md p-4 text-xs overflow-auto max-h-64">
                        {JSON.stringify(selectedFrame, null, 2)}
                      </pre>
                                    ) : (
                                        <p className="text-muted-foreground text-sm">未选择帧</p>
                                    )}
                                </CardContent>
                            </Card>
                            <Card>
                                <CardHeader className="flex flex-row items-center justify-between space-y-0">
                                    <span className="text-sm font-medium">总 JSON (Frames)</span>
                                    <Button
                                        type="button"
                                        variant="outline"
                                        size="sm"
                                        onClick={() =>
                                            copyJson(JSON.stringify(data, null, 2), "总 JSON")
                                        }
                                    >
                                        <Copy className="size-4 mr-1"/> 复制 JSON
                                    </Button>
                                </CardHeader>
                                <CardContent>
                    <pre className="bg-muted rounded-md p-4 text-xs overflow-auto max-h-96">
                      {JSON.stringify(data, null, 2)}
                    </pre>
                                </CardContent>
                            </Card>
                        </div>
                    </TabsContent>
                    <TabsContent value="play" className="flex-1 m-0 overflow-auto p-4">
                        <FightPlayer ruffleRef={ruffleRef} frames={data}
                                     idx={selectedIndex || 0} onChangeIdx={setSelectedIndex}/>
                    </TabsContent>
                </Tabs>
            </main>
        </div>
    );
}

function CardDescription({children}: { children: React.ReactNode }) {
    return <p className="text-muted-foreground text-xs mt-0.5">{children}</p>;
}
