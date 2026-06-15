package utils {
import animation.ext.ImgPet;
import animation.ext.S1Pet;

import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.ConvolutionFilter;
import flash.filters.DisplacementMapFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.filters.GradientBevelFilter;
import flash.filters.GradientGlowFilter;
import flash.filters.ShaderFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

/**
 * 帧位图缓存器：把已加载动画里子元件 MovieClip（真正的动画）的帧预渲染为 BitmapData 存储。
 *
 * 缓存结构（url -> {
 *     children: { childKey -> { frameIndex -> { bitmapData, offsetX, offsetY, width, height } } },
 *     frameToChildKey: { innerMcFrameIndex -> childKey },
 *     childCount: int
 * }）
 *
 * 外层 MovieClip 是容器，它只有一层，各关键帧放入同一个或不同的子元件作为真正的动画。
 * 遍历外层帧时，多帧可能指向同一个子元件实例，通过 childKey 引用计数避免重复渲染。
 */
public class FrameBitmapCache {

    /**
     * 特效量判定阈值：递归子节点数大于该值才预渲染。0 表示预渲染所有非空帧。
     */
    public static var complexityThreshold:int = 3000;

    // url -> cacheEntry
    private static var _cache:Object = {};

    /**
     * 预渲染指定 MovieClip 的子元件动画帧到位图缓存。重复调用对同一 url 是幂等的。
     * @param url    动画资源 URL
     * @param outerMc 外层容器 MovieClip（S1Pet / ImgPet / 原始 MC）
     */
    public static function preload(url:String, outerMc:MovieClip):void {
        if (!url || !outerMc || _cache[url]) {
            return;
        }

        // 解包外层容器，得到有标签的内层 MC
        var innerMc:MovieClip = unwrapInner(outerMc);
        if (!innerMc || innerMc.totalFrames <= 0) {
            return;
        }

        var cacheEntry:Object = {
            children: {},
            frameToChildKey: {},
            childCount: 0,
            totalFrames: innerMc.totalFrames
        };
        _cache[url] = cacheEntry;

        var processedChildren:Dictionary = new Dictionary(true);
        var childId:int = 0;

        innerMc.stop();
        for (var i:int = 1; i <= innerMc.totalFrames; i++) {
            innerMc.gotoAndStop(i);
            if (innerMc.numChildren === 0) {
                continue;
            }
            var childMc:MovieClip = innerMc.getChildAt(0) as MovieClip;
            if (!childMc) {
                continue;
            }
            // 同一子元件实例可能出现在多个父帧，只渲染一次
            if (processedChildren[childMc] !== undefined) {
                // 复用已有 childKey
                cacheEntry.frameToChildKey[i] = processedChildren[childMc];
                continue;
            }

            cacheEntry.frameToChildKey[i] = childId;
            processedChildren[childMc] = childId;

            var childFrames:Object = {};
            cacheEntry.children[childId] = childFrames;
            cacheEntry.childCount++;

            // 渲染子元件所有帧
            childMc.stop();
            for (var j:int = 1; j <= childMc.totalFrames; j++) {
                childMc.gotoAndStop(j);
                if (childMc.numChildren === 0) {
                    continue;
                }
                if (complexityThreshold > 0 && countDescendants(childMc) < complexityThreshold) {
                    continue;
                }
                var rawBounds:Rectangle = childMc.getBounds(childMc);
                if (!rawBounds || rawBounds.width <= 0 || rawBounds.height <= 0) {
                    continue;
                }

                // getBounds 返回未缩放的本地坐标。
                // bitmapData.draw 不应用 source 自身的 scaleX/scaleY，
                // 因此直接用 getBounds 的值决定 BitmapData 尺寸和位移矩阵。
                // 显示时由 BitmapCachedPet 负责累乘缩放系数。
                var w:int = Math.ceil(rawBounds.width);
                var h:int = Math.ceil(rawBounds.height);

                if(w <= 0 || h <= 0) {
                    continue;
                }
                var bitmapData:BitmapData = new BitmapData(w, h, true, 0x00000000);
                var matrix:Matrix = new Matrix();
                matrix.translate(-rawBounds.x, -rawBounds.y);
                bitmapData.draw(childMc, matrix);
                childFrames[j] = {
                    bitmapData: bitmapData,
                    offsetX: rawBounds.x,
                    offsetY: rawBounds.y,
                    width: w,
                    height: h
                };
            }
            childMc.gotoAndStop(1);
            childId++;
        }
        innerMc.gotoAndStop(1);
    }

    /**
     * 取指定 url 内层 MC 某帧对应的子元件缓存帧。
     * @param url            动画资源 URL
     * @param innerFrameIndex 内层 MC 的当前帧下标
     * @param childFrameIndex 子元件当前帧下标
     */
    public static function getCachedChildFrame(url:String, innerFrameIndex:int, childFrameIndex:int):Object {
        var cacheEntry:Object = _cache[url];
        if (!cacheEntry) return null;
        if (innerFrameIndex < 1 || innerFrameIndex > cacheEntry.totalFrames) return null;
        var childKey:* = cacheEntry.frameToChildKey[innerFrameIndex];
        if (childKey === undefined) {
            return null;
        }
        var childFrames:Object = cacheEntry.children[childKey];
        if (!childFrames) {
            return null;
        }
        return childFrames[childFrameIndex];
    }

    public static function has(url:String):Boolean {
        var entry:Object = _cache[url];
        return entry != null && entry.childCount > 0;
    }

    public static function clear(url:String):void {
        var cacheEntry:Object = _cache[url];
        if (!cacheEntry) {
            return;
        }
        for (var childKey:String in cacheEntry.children) {
            var childFrames:Object = cacheEntry.children[childKey];
            for (var frameKey:String in childFrames) {
                var frame:Object = childFrames[frameKey];
                if (frame && frame.bitmapData) {
                    (frame.bitmapData as BitmapData).dispose();
                }
            }
        }
        delete _cache[url];
    }

    public static function clearAll():void {
        for (var url:String in _cache) {
            clear(url);
        }
    }

    /**
     * 解包外层容器，返回有标签的内层 MC（即 gotoAndStop(label) 实际作用的那个）。
     * S1Pet / ImgPet 的 getChildAt(0) 返回 origin MC，再往下一层才是标签 MC。
     */
    private static function unwrapInner(outerMc:MovieClip):MovieClip {
        if (outerMc is S1Pet || outerMc is ImgPet) {
            var child0:DisplayObject = outerMc.getChildAt(0);
            if (child0 is MovieClip) {
                return child0 as MovieClip;
            }
        }
        return outerMc;
    }

    /**
     * 递归计算显示对象的渲染复杂度权重。
     * 各特效权重（按实际渲染开销排序）：
     *   - 不可见 (visible=false)             → 0，跳过整棵子树
     *   - 有遮罩 (mask)                     → +30
     *   - 滤镜 (filters) — 按类型细化，见 filterWeight()
     *   - 非 normal 混合模式 (blendMode)     → +20
     *   - 透明度 < 1.0 (alpha)              → +8
     *   - 非恒等颜色变换 (colorTransform)    → +6
     *   - 缩放/旋转 (scaleX/Y, rotation)    → +5 每项
     *   - 已缓存为位图 (cacheAsBitmap)       → +2，不递归子节点
     *   - 每个子节点自身                     → +1
     */
    private static function countDescendants(mc:DisplayObject, depth:int = 0):int {
        if (!(mc is DisplayObjectContainer)) {
            return 0;
        }

        // 避免极端深层嵌套导致计数过久，10 层足以覆盖所有常见动画结构
        if(depth > 10) {
            return 0;
        }

        // 不可见：无渲染开销，跳过整棵子树
        if (!mc.visible) {
            return 0;
        }

        var count:int = 0;

        // 滤镜 — 按具体类型细化权值
        if (mc.filters && mc.filters.length > 0) {
            for (var fi:int = 0; fi < mc.filters.length; fi++) {
                count += filterWeight(mc.filters[fi]);
            }
        }

        // 混合模式
        if (mc.blendMode && mc.blendMode !== BlendMode.NORMAL) {
            count += 20;
        }

        // 颜色变换
        var ct:ColorTransform = mc.transform.colorTransform;
        if (ct && (
                ct.redMultiplier !== 1 || ct.greenMultiplier !== 1
                || ct.blueMultiplier !== 1 || ct.alphaMultiplier !== 1
                || ct.redOffset !== 0 || ct.greenOffset !== 0
                || ct.blueOffset !== 0 || ct.alphaOffset !== 0)) {
            count += 6;
        }

        // 透明度
        if (mc.alpha < 1.0) {
            count += 8;
        }

        // 缩放
        if (mc.scaleX !== 1.0 || mc.scaleY !== 1.0) {
            count += 5;
        }

        // 旋转
        if (mc.rotation !== 0) {
            count += 5;
        }

        // 遮罩
        if (mc.mask) {
            count += 10;
        }

        // 已缓存为位图：子树已经过优化，不再深入递归
        if (mc.cacheAsBitmap) {
            return count + 2;
        }

        var container:DisplayObjectContainer = mc as DisplayObjectContainer;
        for (var i:int = 0; i < container.numChildren; i++) {
            count += 1; // 子节点自身
            count += countDescendants(container.getChildAt(i), depth + 1);
        }
        return count;
    }

    /**
     * 按滤镜类型计算渲染开销权重。（权值我改过，下面这些是AI给的权重）
     * 复杂度从低到高：
     *   ColorMatrixFilter    → 8              (简单矩阵乘法，无核)
     *   BlurFilter           → 16 + blurX/2 + blurY/2  (可分离高斯，模糊半径越大越慢)
     *   GlowFilter           → 20 + blurX/2 + blurY/2  (模糊 + 合成)
     *   DropShadowFilter     → 20 + blurX/2 + blurY/2  (同 Glow + 偏移)
     *   BevelFilter          → 28 + blurX/2 + blurY/2  (高光/阴影多通道)
     *   GradientGlowFilter   → 28 + blurX/2 + blurY/2  (模糊 + 逐像素渐变色)
     *   GradientBevelFilter  → 35 + blurX/2 + blurY/2  (多通道 + 渐变，最重的内置滤镜)
     *   ConvolutionFilter    → 12 + matrixX * matrixY * 2  (核大小决定采样数)
     *   DisplacementMapFilter → 40             (随机内存访问)
     *   ShaderFilter         → 50             (未知着色器，保守估计)
     *   其他/未知             → 25             (保守默认)
     */
    private static function filterWeight(filter:BitmapFilter):int {
        if (filter is ColorMatrixFilter) {
            return 8;
        }
        if (filter is BlurFilter) {
            var bf:BlurFilter = filter as BlurFilter;
            return int(bf.blurX * 5) + int(bf.blurY * 5);
        }
        if (filter is GlowFilter) {
            var gf:GlowFilter = filter as GlowFilter;
            return 5 + int(gf.blurX * 5) + int(gf.blurY * 5);
        }
        if (filter is DropShadowFilter) {
            var ds:DropShadowFilter = filter as DropShadowFilter;
            return 20 + int(ds.blurX / 2) + int(ds.blurY / 2);
        }
        if (filter is BevelFilter) {
            var bef:BevelFilter = filter as BevelFilter;
            return 28 + int(bef.blurX / 2) + int(bef.blurY / 2);
        }
        if (filter is GradientGlowFilter) {
            var ggf:GradientGlowFilter = filter as GradientGlowFilter;
            return 28 + int(ggf.blurX / 2) + int(ggf.blurY / 2);
        }
        if (filter is GradientBevelFilter) {
            var gbf:GradientBevelFilter = filter as GradientBevelFilter;
            return 35 + int(gbf.blurX / 2) + int(gbf.blurY / 2);
        }
        if (filter is ConvolutionFilter) {
            var cf:ConvolutionFilter = filter as ConvolutionFilter;
            return 12 + cf.matrixX * cf.matrixY * 2;
        }
        if (filter is DisplacementMapFilter) {
            return 10;
        }
        if (filter is ShaderFilter) {
            return 20;
        }
        return 10; // 未知滤镜
    }
}
}