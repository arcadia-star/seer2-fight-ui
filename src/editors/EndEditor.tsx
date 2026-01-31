import type {End} from "@/types";
import {Side} from "@/types";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Label} from "@/components/ui/label";
import {Select, SelectContent, SelectItem, SelectTrigger, SelectValue,} from "@/components/ui/select";

export interface EndEditorProps {
    value: End;
    onChange: (value: End) => void;
}

const winnerOptions = [
    {value: String(Side.Left), label: "左侧胜 (1)"},
    {value: String(Side.Right), label: "右侧胜 (2)"},
    {value: "0", label: "平局 (0)"},
];

export function EndEditor({value, onChange}: EndEditorProps) {
    return (
        <Card className="w-full">
            <CardHeader className="py-3">
                <span className="text-sm font-medium">结束 (End)</span>
            </CardHeader>
            <CardContent className="space-y-3">
                <div className="space-y-1.5">
                    <Label>胜方 (winner)</Label>
                    <Select
                        value={String(value.winner)}
                        onValueChange={(v) =>
                            onChange({winner: Number(v)})
                        }
                    >
                        <SelectTrigger className="w-full">
                            <SelectValue/>
                        </SelectTrigger>
                        <SelectContent>
                            {winnerOptions.map((opt) => (
                                <SelectItem key={opt.value} value={opt.value}>
                                    {opt.label}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                </div>
            </CardContent>
        </Card>
    );
}
