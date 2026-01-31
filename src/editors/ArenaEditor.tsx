import type {Arena} from "@/types";
import {TeamEditor} from "@/editors/TeamEditor";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {Tabs, TabsContent, TabsList, TabsTrigger} from "@/components/ui/tabs";

export interface ArenaEditorProps {
    value: Arena;
    onChange: (value: Arena) => void;
}

export function ArenaEditor({value, onChange}: ArenaEditorProps) {
    return (
        <Card className="w-full">
            <CardHeader className="py-3">
                <span className="text-sm font-medium">战场 (Arena)</span>
            </CardHeader>
            <CardContent className="space-y-3">
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>回合 (round)</Label>
                        <Input
                            type="number"
                            value={value.round}
                            onChange={(e) =>
                                onChange({...value, round: Number(e.target.value) || 0})
                            }
                        />
                    </div>
                </div>
                <div className="space-y-1.5">
                    <Label>地图 SWF (mapSwf)</Label>
                    <Input
                        value={value.mapSwf}
                        onChange={(e) => onChange({...value, mapSwf: e.target.value})}
                    />
                </div>
                <div className="space-y-1.5">
                    <Label>地图音效 (mapSound)</Label>
                    <Input
                        value={value.mapSound}
                        onChange={(e) => onChange({...value, mapSound: e.target.value})}
                    />
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1.5">
                        <Label>天气图标 (weatherIcon)</Label>
                        <Input
                            value={value.weatherIcon}
                            onChange={(e) =>
                                onChange({...value, weatherIcon: e.target.value})
                            }
                        />
                    </div>
                    <div className="space-y-1.5">
                        <Label>天气说明 (weatherTips)</Label>
                        <Input
                            value={value.weatherTips}
                            onChange={(e) =>
                                onChange({...value, weatherTips: e.target.value})
                            }
                        />
                    </div>
                </div>

                <Tabs defaultValue="left">
                    <TabsList className="w-full">
                        <TabsTrigger value="left" className="flex-1">
                            左侧队伍
                        </TabsTrigger>
                        <TabsTrigger value="right" className="flex-1">
                            右侧队伍
                        </TabsTrigger>
                    </TabsList>
                    <TabsContent value="left" className="mt-2">
                        <TeamEditor
                            value={value.left}
                            onChange={(team) => onChange({...value, left: team})}
                            title="左侧队伍"
                        />
                    </TabsContent>
                    <TabsContent value="right" className="mt-2">
                        <TeamEditor
                            value={value.right}
                            onChange={(team) => onChange({...value, right: team})}
                            title="右侧队伍"
                        />
                    </TabsContent>
                </Tabs>
            </CardContent>
        </Card>
    );
}
