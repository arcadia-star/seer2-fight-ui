import * as React from "react";
import {Tooltip, TooltipContent, TooltipProvider, TooltipTrigger} from "@/components/ui/tooltip.tsx";

export function Tips({children, tips}: { children?: React.ReactNode; tips: string }) {
    return <TooltipProvider>
        <Tooltip>
            <TooltipTrigger asChild>
                {children}
            </TooltipTrigger>
            <TooltipContent side="bottom">
                <div className="max-w-100">{tips}</div>
            </TooltipContent>
        </Tooltip>
    </TooltipProvider>
}