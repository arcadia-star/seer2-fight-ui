import {Button} from "@/components/ui/button";
import {Input} from "@/components/ui/input";
import {Label} from "@/components/ui/label";
import {Plus, Trash2} from "lucide-react";

export interface StringArrayFieldProps {
    value: string[];
    onChange: (value: string[]) => void;
    label?: string;
    addLabel?: string;
    itemPlaceholder?: string;
    className?: string;
}

/**
 * 编辑 string[] 的通用组件：逐项输入，支持空字符串，不依赖换行分割。
 */
export function StringArrayField({
                                     value,
                                     onChange,
                                     label,
                                     addLabel = "添加一项",
                                     itemPlaceholder,
                                     className,
                                 }: StringArrayFieldProps) {
    const updateAt = (index: number, str: string) => {
        const next = [...value];
        next[index] = str;
        onChange(next);
    };

    const removeAt = (index: number) => {
        const next = value.filter((_, i) => i !== index);
        onChange(next);
    };

    const append = () => {
        onChange([...value, ""]);
    };

    const list = Array.isArray(value) ? value : [];

    return (
        <div className={className}>
            {label != null && (
                <Label className="mb-2 block">{label}</Label>
            )}
            <div className="space-y-2">
                {list.map((item, i) => (
                    <div key={i} className="flex gap-2 items-center">
                        <Input
                            value={item}
                            onChange={(e) => updateAt(i, e.target.value)}
                            placeholder={itemPlaceholder ?? `第 ${i + 1} 项`}
                            className="flex-1 min-w-0"
                        />
                        <Button
                            type="button"
                            variant="ghost"
                            size="icon"
                            onClick={() => removeAt(i)}
                            title="删除"
                            className="shrink-0"
                        >
                            <Trash2 className="size-4"/>
                        </Button>
                    </div>
                ))}
                <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={append}
                >
                    <Plus className="size-4 mr-1"/>
                    {addLabel}
                </Button>
            </div>
        </div>
    );
}
