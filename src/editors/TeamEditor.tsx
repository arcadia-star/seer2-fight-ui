import type {Item, Pet, Team} from "@/types";
import {PetEditor} from "@/editors/PetEditor";
import {ItemEditor} from "@/editors/ItemEditor";
import {Button} from "@/components/ui/button";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Tabs, TabsContent, TabsList, TabsTrigger} from "@/components/ui/tabs";
import {Plus} from "lucide-react";

const defaultPet = (): Pet => ({
    pid: 0,
    petIcon: "",
    petSwf: "",
    petSound: "",
    name: "",
    level: 100,
    typeIcon: "",
    position: 0,
    alive: 1,
    anger: 100,
    maxAnger: 100,
    hp: 600,
    maxHp: 600,
    rate: 0,
    atk: 0,
    def: 0,
    spa: 0,
    spd: 0,
    spe: 0,
    skills: [],
    buffs: [],
});

const defaultItem = (): Item => ({
    id: 0,
    name: "",
    count: 1,
    icon: "",
    tips: "",
});

export interface TeamEditorProps {
    value: Team;
    onChange: (value: Team) => void;
    title?: string;
}

export function TeamEditor({value, onChange, title = "队伍"}: TeamEditorProps) {
    const pets = value.pets ?? [];
    const items = value.items ?? [];
    const capsules = value.capsules ?? [];

    return (
        <Card className="w-full">
            <CardHeader className="py-3">
                <span className="text-sm font-medium">{title}</span>
            </CardHeader>
            <CardContent>
                <Tabs defaultValue="pets">
                    <TabsList className="w-full">
                        <TabsTrigger value="pets" className="flex-1">
                            宠物 ({pets.length})
                        </TabsTrigger>
                        <TabsTrigger value="items" className="flex-1">
                            道具 ({items.length})
                        </TabsTrigger>
                        <TabsTrigger value="capsules" className="flex-1">
                            胶囊 ({capsules.length})
                        </TabsTrigger>
                    </TabsList>
                    <TabsContent value="pets" className="space-y-2 mt-2">
                        {pets.map((pet, i) => (
                            <PetEditor
                                key={i}
                                value={pet}
                                onChange={(p) => {
                                    const next = [...pets];
                                    next[i] = p;
                                    onChange({...value, pets: next});
                                }}
                                onRemove={() => {
                                    const next = pets.filter((_, j) => j !== i);
                                    onChange({...value, pets: next});
                                }}
                            />
                        ))}
                        <Button
                            type="button"
                            variant="outline"
                            size="sm"
                            className="w-full"
                            onClick={() =>
                                onChange({...value, pets: [...pets, defaultPet()]})
                            }
                        >
                            <Plus className="size-4 mr-1"/> 添加宠物
                        </Button>
                    </TabsContent>
                    <TabsContent value="items" className="space-y-2 mt-2">
                        {items.map((item, i) => (
                            <ItemEditor
                                key={i}
                                value={item}
                                onChange={(it) => {
                                    const next = [...items];
                                    next[i] = it;
                                    onChange({...value, items: next});
                                }}
                                onRemove={() => {
                                    const next = items.filter((_, j) => j !== i);
                                    onChange({...value, items: next});
                                }}
                            />
                        ))}
                        <Button
                            type="button"
                            variant="outline"
                            size="sm"
                            className="w-full"
                            onClick={() =>
                                onChange({...value, items: [...items, defaultItem()]})
                            }
                        >
                            <Plus className="size-4 mr-1"/> 添加道具
                        </Button>
                    </TabsContent>
                    <TabsContent value="capsules" className="space-y-2 mt-2">
                        {capsules.map((item, i) => (
                            <ItemEditor
                                key={i}
                                value={item}
                                onChange={(it) => {
                                    const next = [...capsules];
                                    next[i] = it;
                                    onChange({...value, capsules: next});
                                }}
                                onRemove={() => {
                                    const next = capsules.filter((_, j) => j !== i);
                                    onChange({...value, capsules: next});
                                }}
                            />
                        ))}
                        <Button
                            type="button"
                            variant="outline"
                            size="sm"
                            className="w-full"
                            onClick={() =>
                                onChange({
                                    ...value,
                                    capsules: [...capsules, defaultItem()],
                                })
                            }
                        >
                            <Plus className="size-4 mr-1"/> 添加胶囊
                        </Button>
                    </TabsContent>
                </Tabs>
            </CardContent>
        </Card>
    );
}
