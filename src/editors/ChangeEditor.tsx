import type {Change, ChangeType} from "@/types";
import {ChangeType as ChangeTypeEnum} from "@/types";
import {Card, CardContent, CardHeader} from "@/components/ui/card";
import {Label} from "@/components/ui/label";
import {Select, SelectContent, SelectItem, SelectTrigger, SelectValue,} from "@/components/ui/select";

export interface ChangeEditorProps {
    value: Change;
    onChange: (value: Change) => void;
}

const NONE = "__none__";
const changeTypeOptions = [
    {value: NONE, label: "无"},
    {value: String(ChangeTypeEnum.Replace), label: "替换 (1)"},
    {value: String(ChangeTypeEnum.Morph), label: "形态 (2)"},
];

export function ChangeEditor({value, onChange}: ChangeEditorProps) {
    return (
        <Card className="w-full">
            <CardHeader className="py-3">
                <span className="text-sm font-medium">换宠 (Change)</span>
            </CardHeader>
            <CardContent className="space-y-3">
                <div className="space-y-1.5">
                    <Label>左侧换宠 (left)</Label>
                    <Select
                        value={value.left !== undefined ? String(value.left) : NONE}
                        onValueChange={(v) =>
                            onChange({
                                ...value,
                                left: v === NONE ? undefined : (Number(v) as ChangeType),
                            })
                        }
                    >
                        <SelectTrigger className="w-full">
                            <SelectValue placeholder="无"/>
                        </SelectTrigger>
                        <SelectContent>
                            {changeTypeOptions.map((opt) => (
                                <SelectItem key={opt.value} value={opt.value}>
                                    {opt.label}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                </div>
                <div className="space-y-1.5">
                    <Label>右侧换宠 (right)</Label>
                    <Select
                        value={value.right !== undefined ? String(value.right) : NONE}
                        onValueChange={(v) =>
                            onChange({
                                ...value,
                                right: v === NONE ? undefined : (Number(v) as ChangeType),
                            })
                        }
                    >
                        <SelectTrigger className="w-full">
                            <SelectValue placeholder="无"/>
                        </SelectTrigger>
                        <SelectContent>
                            {changeTypeOptions.map((opt) => (
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
