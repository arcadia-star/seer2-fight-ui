import type {Start} from "@/types";
import {StringArrayField} from "@/components/StringArrayField";
import {Card, CardContent, CardHeader} from "@/components/ui/card";

export interface StartEditorProps {
    value: Start;
    onChange: (value: Start) => void;
}

export function StartEditor({value, onChange}: StartEditorProps) {
    return (
        <Card className="w-full">
            <CardHeader className="py-3">
                <span className="text-sm font-medium">开始 (Start)</span>
            </CardHeader>
            <CardContent className="space-y-4">
                <StringArrayField
                    value={value.urls ?? []}
                    onChange={(urls) => onChange({...value, urls})}
                    label="URL 列表 (urls)"
                    addLabel="添加 URL"
                    itemPlaceholder="https://..."
                />
                <StringArrayField
                    value={value.tips ?? []}
                    onChange={(tips) => onChange({...value, tips})}
                    label="提示 (tips)"
                    addLabel="添加提示"
                    itemPlaceholder="一条提示"
                />
            </CardContent>
        </Card>
    );
}
