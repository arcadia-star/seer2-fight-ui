import {useEffect, useRef} from "react"
import {gsap} from "gsap"
import Miss from "@/assets/fightSplash/miss.svg"
import HzAbsorb from "@/assets/fightSplash/hz_absorb.svg"
import HzBj from "@/assets/fightSplash/hz_bj.svg"
import HzYb from "@/assets/fightSplash/hz_yb.svg"
import HzWr from "@/assets/fightSplash/hz_wr.svg"
import HzKz from "@/assets/fightSplash/hz_kz.svg"
import BgYb from "@/assets/fightSplash/bg_yb.svg"
import BgWr from "@/assets/fightSplash/bg_wr.svg"
import BgKz from "@/assets/fightSplash/bg_kz.svg"
import Minus from "@/assets/fightSplash/d_-.svg"
import Num0 from "@/assets/fightSplash/d_0.svg"
import Num1 from "@/assets/fightSplash/d_1.svg"
import Num2 from "@/assets/fightSplash/d_2.svg"
import Num3 from "@/assets/fightSplash/d_3.svg"
import Num4 from "@/assets/fightSplash/d_4.svg"
import Num5 from "@/assets/fightSplash/d_5.svg"
import Num6 from "@/assets/fightSplash/d_6.svg"
import Num7 from "@/assets/fightSplash/d_7.svg"
import Num8 from "@/assets/fightSplash/d_8.svg"
import Num9 from "@/assets/fightSplash/d_9.svg"

interface DamageProps {
    hit: number,
    cri: number,
    rate: number,
    total: number,
    className?: string,
}

export function Damage({hit, total, cri, rate, className}: DamageProps) {
    const containerRef = useRef<HTMLDivElement>(null)
    const hzRef = useRef<HTMLImageElement>(null)
    const bgRef = useRef<HTMLImageElement>(null)
    const minusRef = useRef<HTMLImageElement>(null)
    const numsRef = useRef<HTMLImageElement[]>([])

    const nums = (total + "").split("").map(e => {
        const num = Number(e);
        const src =
            num === 0 && Num0 ||
            num === 1 && Num1 ||
            num === 2 && Num2 ||
            num === 3 && Num3 ||
            num === 4 && Num4 ||
            num === 5 && Num5 ||
            num === 6 && Num6 ||
            num === 7 && Num7 ||
            num === 8 && Num8 ||
            num === 9 && Num9 ||
            Num0;
        return {src, num};
    });

    const hz = cri > 0 && HzBj
        || rate > 100 && HzKz
        || rate < 100 && HzWr
        || HzYb;
    const bg = rate > 100 && BgKz
        || rate < 100 && BgWr
        || BgYb;

    useEffect(() => {
        if (!containerRef.current) return

        // 创建动画时间线
        const tl = gsap.timeline()

        // 初始状态：所有元素都是隐藏和缩小的
        gsap.set(containerRef.current, {
            opacity: 0,
            scale: 0.3,
            y: 50,
        })

        // 如果是 miss 或吸收，使用简单的弹跳动画
        if (hit <= 0 || total <= 0) {
            tl.to(containerRef.current, {
                opacity: 1,
                scale: 1,
                y: 0,
                duration: 0.15,
                ease: "back.out(1.7)"
            })
                .to(containerRef.current, {
                    y: -15,
                    duration: 0.1,
                    ease: "power2.out"
                })
                .to(containerRef.current, {
                    y: 0,
                    duration: 0.1,
                    ease: "bounce.out"
                })
                .to(containerRef.current, {
                    opacity: 0,
                    scale: 0.8,
                    duration: 0.3,
                    ease: "power2.in"
                }, "+=0.4")
        } else {
            // 伤害数字动画 - 所有元素同时出现

            // 设置所有元素的初始状态
            const numberElements = [minusRef.current, ...numsRef.current].filter(Boolean)
            const allElements = [bgRef.current, hzRef.current, ...numberElements].filter(Boolean)

            // 设置初始状态
            gsap.set(allElements, {
                opacity: 0,
                scale: 0.3,
                y: 30,
                rotation: () => Math.random() * 20 - 10
            })

            if (bgRef.current) {
                gsap.set(bgRef.current, {
                    opacity: 0,
                    scale: 0,
                    rotation: -15
                })
            }

            // 所有元素同时弹出
            tl.to(containerRef.current, {
                opacity: 1,
                scale: 1.2,
                y: -10,
                duration: 0.15,
                ease: "back.out(1.7)"
            })
                .to(allElements, {
                    opacity: 1,
                    scale: 1,
                    y: 0,
                    rotation: 0,
                    duration: 0.2,
                    ease: "back.out(1.7)"
                }, "-=0.1")

            // 暴击震动效果（如果是暴击）
            if (cri > 0) {
                tl.to(containerRef.current, {
                    x: "+=3",
                    duration: 0.03,
                    repeat: 4,
                    yoyo: true,
                    ease: "power2.inOut"
                }, "+=0.1")
            }

            // 上浮并淡出
            tl.to(containerRef.current, {
                y: -40,
                opacity: 0.7,
                duration: 0.4,
                ease: "power2.out"
            }, "+=0.3")
                .to(containerRef.current, {
                    y: -80,
                    opacity: 0,
                    scale: 0.8,
                    duration: 0.3,
                    ease: "power2.in"
                }, "-=0.2")
        }

        // 清理函数
        return () => {
            tl.kill()
        }
    }, [hit, total, cri, rate])

    return <div
        ref={containerRef}
        className={className}
    >{
        hit <= 0 && <img src={Miss} alt="miss" className="h-[60px]"/>
        || total <= 0 && <img src={HzAbsorb} alt="absorb" className="h-[60px]"/>
        ||
      <div className="flex items-center h-[160px]">
        <img
          ref={hzRef}
          src={hz}
          alt="hit"
          className="h-[40px]"
        />
        <div className="relative flex content-center items-center">
          <img
            ref={bgRef}
            src={bg}
            alt="bg"
            className="absolute opacity-90 -z-1 w-1/1 h-[160px]"
          />
          <img
            ref={minusRef}
            src={Minus}
            alt="-"
            className="ml-[-10px] h-[60px]"
          />
            {nums.map((e, i) =>
                <img
                    key={i}
                    ref={el => {
                        numsRef.current[i] = el!
                    }}
                    src={e.src}
                    alt={e.num + ""}
                    className="ml-[-10px] h-[80px]"
                />
            )}
        </div>
      </div>
    }</div>
}