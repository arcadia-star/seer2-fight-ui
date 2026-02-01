# Fight UI

赛尔号 2 战斗数据可视化编辑与预览工具。基于 React + Vite 构建，支持对战斗帧（Frames）数据进行编辑、导入导出，并通过 Ruffle 播放
SWF 战斗动画进行预览。

## Demo

https://ui.733702.xyz/

https://ui.733702.xyz/demo/demo.html

## 功能特性

- **帧编辑器**：可视化编辑战斗流程中的各类帧，按播放顺序逐帧编辑与预览
- **子编辑器**：针对竞技场、队伍、精灵、技能、道具、Buff、招式、事件等数据的专用编辑器
- **JSON5 支持**：支持 JSON5 格式的导入与导出，便于手工编辑与版本管理
- **战斗预览**：集成 Ruffle 播放器，实时预览 SWF 战斗动画与帧播放
- **互动演示**：提供独立页面 `demo.html`，可直接用播放器加载任意战斗 JSON 进行试播（见下方「互动 Demo」）
- **现代化 UI**：基于 Radix UI + Tailwind CSS，支持主题与响应式布局

## 技术栈

| 类别       | 技术                    |
|----------|-----------------------|
| 框架       | React 19              |
| 构建       | Vite 6                |
| 语言       | TypeScript 5.7        |
| 样式       | Tailwind CSS 4        |
| UI 组件    | Radix UI、shadcn/ui 风格 |
| Flash 播放 | Ruffle                |
| 动画       | GSAP                  |

## 环境要求

- Node.js 18+
- 现代浏览器（需支持 ES 模块）

## 快速开始

### 安装依赖

```bash
npm install
```

### 开发模式

```bash
npm run dev
```

启动后访问本地开发地址（通常为 `http://localhost:5173`）。仅试播战斗、不编辑时，可访问 **`/demo/demo.html`** 使用互动演示（见「互动
Demo」）。

### 构建生产版本

```bash
npm run build
```

产物在 `dist` 目录。预览构建结果：

```bash
npm run preview
```

### 代码检查

```bash
npm run lint
```

## 项目结构

```
fight-ui/
├── public/              # 静态资源
│   ├── demo/            # 互动演示：demo.html + DemoPlayer.swf + mock.json
│   ├── FallbackFont.swf
│   └── FightPlayer.swf   # 战斗播放器 SWF
├── src/
│   ├── components/      # 通用组件（Ruffle 播放器、全屏、UI 等）
│   ├── editors/        # 各类数据编辑器
│   │   ├── FramesEditor.tsx   # 主入口：帧列表与整体编辑
│   │   ├── FrameEditor.tsx   # 单帧编辑与类型分发
│   │   ├── ArenaEditor.tsx   # 竞技场
│   │   ├── TeamEditor.tsx    # 队伍
│   │   ├── PetEditor.tsx     # 精灵
│   │   ├── SkillEditor.tsx   # 技能
│   │   ├── MoveEditor.tsx    # 招式
│   │   └── ...
│   ├── player/         # 战斗播放逻辑（FightPlayer）
│   ├── lib/            # 工具函数
│   ├── types.ts        # 战斗相关类型定义
│   ├── main.tsx
│   └── index.css
├── flash/              # Flash 相关源码（.as）
├── index.html
├── package.json
├── vite.config.ts
└── tsconfig.json
```

## 帧类型（按播放器视角）

播放器按 `frames` 数组顺序**逐帧**播放：每取到一帧就调用 SWF 的 `playFrame(frame)`；SWF 播完该帧后回传 `playEnd`
，播放器再切到下一帧。不同帧类型决定当前这一步要播什么内容。

| 帧类型        | 播放器行为                                                                      | 典型用途                         |
|------------|----------------------------------------------------------------------------|------------------------------|
| **Sleep**  | 等待指定毫秒后视为播完，触发下一帧                                                          | 控制节奏、预留黑屏或过渡时间               |
| **Start**  | 播「战斗开始」：加载 `start.urls`、展示 `start.tips`，并可用本帧附带的 `data` 渲染双方队伍与场地          | 开场展示双方精灵、回合数、地图与天气等          |
| **End**    | 播「战斗结束」：根据 `end.winner`（1=左侧胜 / 2=右侧胜 / 0=平局）显示结算                          | 结束画面、胜负与奖励展示                 |
| **Move**   | 播「一次出招」：左侧或右侧（`move.side`）使用技能 `move.skill`，包含伤害、暴击、命中、音效与特效等              | 单次技能动画与伤害数字                  |
| **Event**  | 播「战斗内事件」：如血量增减、道具回血/回怒、捕捉成功/失败等（由 `event.type` + `event.change` 等区分）       | 道具使用、捕捉、被动触发等                |
| **Change** | 播「形态/替换」：左侧和/或右侧的替换或形态变化（`change.left` / `change.right` 为 Replace / Morph） | 换宠、合体、形态切换                   |
| **Data**   | 仅同步「当前战场数据」：把本帧的 `data`（竞技场、双方队伍、回合、地图与天气等）交给 SWF，不播单独动画，播完即进入下一帧          | 在无专门动画的时机刷新 UI 状态、或为后续帧准备好数据 |

整体数据结构：

- **globalVolume / mapVolume**：全局与地图音量，播放器在每帧前会传给 SWF（如 `updateGlobalSound` / `updateMapSound`）。
- **frames**：上述帧类型组成的数组，顺序即播放顺序；每帧可带 `data`（当前战场快照）、`logs`、`_name` 等公共字段。

编辑器支持从 JSON/JSON5 导入，编辑后可导出为 JSON5 供本仓库播放器或 Flash 使用。

---

## 互动 Demo（demo.html）

项目提供独立演示页 **`public/demo/demo.html`**，用 Ruffle 加载 **DemoPlayer.swf**，可直接在浏览器里试播战斗数据，无需跑完整编辑界面。

- **用法**：用本地静态服务打开站点后访问 `/demo/demo.html`（开发时 `npm run dev`
  下为 `http://localhost:5173/demo/demo.html`）。
- **数据来源**：页面内通过 `DemoPlayer.swf?playUrl=mock.json` 加载战斗 JSON；`playUrl` 指向的 JSON 需为符合上述 `Frames`
  结构的战斗数据。
- **用途**：快速验证某份 JSON 在播放器中的效果、调试 SWF 与 Ruffle 兼容性、或给他人一个「只播不编」的演示入口。

## 开发说明

- 路径别名：`@` 指向 `src/`
- 构建时会通过 `vite-plugin-static-copy` 将 Ruffle 运行时复制到输出目录的 `ruffle/`
- SWF 通过 `assetsInclude: ['**/*.swf']` 被 Vite 视为静态资源处理

## 许可证

Private 项目，未指定开源许可证。
