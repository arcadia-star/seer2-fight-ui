# Fight UI

赛尔号 2 战斗数据可视化编辑与预览工具。

基于 React + Vite 构建前端编辑器，通过 Ruffle 在现代浏览器中播放 ActionScript 3 编写的 SWF 战斗动画，支持对战斗帧（Frames）数据进行可视化编辑、导入导出与实时预览。

## Demo

- 编辑器：https://ui.733702.xyz/
- 互动演示：https://ui.733702.xyz/demo/demo.html

## 功能特性

- **帧编辑器**：按播放顺序逐帧编辑战斗流程，支持增删改查与复制粘贴
- **子编辑器**：针对竞技场、队伍、精灵、技能、道具、Buff、招式、事件等数据的专用表单编辑器
- **战斗预览**：集成 Ruffle 播放器，编辑时可实时预览 SWF 战斗动画
- **JSON5 支持**：支持 JSON5 格式导入与导出，便于手工编辑与版本管理
- **互动演示**：提供独立页面 `demo.html`，无需加载完整编辑器即可试播任意战斗 JSON
- **现代化 UI**：基于 Radix UI + Tailwind CSS 4，支持暗色主题与响应式布局

## 技术栈

| 类别 | 技术 |
|------|------|
| 框架 | React 19 |
| 语言 | TypeScript 5.7 |
| 构建 | Vite 6 |
| 样式 | Tailwind CSS 4 |
| UI 组件 | Radix UI / shadcn/ui 风格 |
| Flash 播放 | Ruffle |
| 动画 | GSAP |

## 环境要求

- Node.js 18+
- 现代浏览器（支持 ES Modules）

## 快速开始

```bash
# 安装依赖
npm install

# 开发模式
npm run dev

# 构建生产版本
npm run build

# 预览构建产物
npm run preview

# 代码检查
npm run lint
```

开发服务器启动后，默认访问 `http://localhost:5173`。仅试播战斗时可访问 `http://localhost:5173/demo/demo.html`。

## 项目结构

```
fight-ui/
├── public/                    # 静态资源
│   ├── demo/                  # 互动演示页
│   │   ├── demo.html
│   │   ├── DemoPlayer.swf
│   │   └── mock.json
│   ├── FightPlayer.swf        # 主战斗播放器 SWF
│   └── FallbackFont.swf       # 字体回退 SWF
├── src/
│   ├── components/            # 通用组件
│   │   ├── ruffle-player.tsx  # Ruffle 播放器封装
│   │   ├── fullscreen.tsx     # 全屏控制
│   │   └── ui/                # shadcn/ui 风格基础组件
│   ├── editors/               # 数据编辑器
│   │   ├── FramesEditor.tsx   # 帧列表总览与播放控制
│   │   ├── FrameEditor.tsx    # 单帧编辑与类型分发
│   │   ├── ArenaEditor.tsx    # 竞技场数据
│   │   ├── TeamEditor.tsx     # 队伍数据
│   │   ├── PetEditor.tsx      # 精灵数据
│   │   ├── SkillEditor.tsx    # 技能数据
│   │   ├── BuffEditor.tsx     # Buff 数据
│   │   ├── MoveEditor.tsx     # 招式数据
│   │   ├── EventEditor.tsx    # 事件数据
│   │   ├── StartEditor.tsx    # 开场数据
│   │   ├── EndEditor.tsx      # 结算数据
│   │   ├── ChangeEditor.tsx   # 替换/形态变化
│   │   └── ItemEditor.tsx     # 道具数据
│   ├── player/                # 战斗播放逻辑
│   │   ├── fight-player.tsx   # 帧序列播放器
│   │   └── demo-player.tsx    # 演示模式播放器
│   ├── lib/                   # 工具函数
│   ├── types.ts               # 战斗数据类型定义
│   ├── demo.json              # 默认演示数据
│   ├── main.tsx
│   └── index.css
├── flash/                     # Flash AS3 源码（战斗播放器）
│   ├── src/
│   │   ├── FightPlayer.as     # 主播放器入口
│   │   ├── DemoPlayer.as      # 演示播放器入口
│   │   ├── FramePlayer.as     # 帧播放控制器
│   │   ├── data/              # 数据模型
│   │   ├── animation/         # 动画与 UI 组件
│   │   ├── ui/                # UI 元件与素材
│   │   └── utils/             # 工具类
│   ├── lib/                   # AS3 第三方库
│   ├── build.sh               # SWF 编译脚本
│   └── flash.iml
├── flash-assets/              # Flash 资源（素材 SWF）
│   ├── src/
│   ├── build.sh
│   └── flash-assets.iml
├── vite.config.ts
├── package.json
└── tsconfig.json
```

## 帧类型说明

播放器按 `frames` 数组**逐帧顺序播放**。每取到一帧调用 SWF 的 `playFrame(frame)`，SWF 播完后回传 `playEnd`，播放器再进入下一帧。

| 帧类型 | 行为 | 典型用途 |
|--------|------|----------|
| **Sleep** | 等待指定毫秒后自动进入下一帧 | 控制节奏、过渡黑屏 |
| **Start** | 播放「战斗开始」动画，加载资源并渲染双方队伍与场地 | 开场展示 |
| **End** | 播放「战斗结束」动画，显示胜负结算 | 结束画面 |
| **Move** | 播放一次出招动画（伤害、暴击、命中、音效、特效） | 技能动画 |
| **Event** | 播放战斗内事件（血量增减、道具、捕捉、换宠等） | 被动触发与道具使用 |
| **Change** | 播放形态/替换动画 | 换宠、合体、形态切换 |
| **Data** | 仅同步当前战场数据，不播放独立动画 | 刷新 UI、为后续帧准备数据 |

## Flash 播放器构建

`flash/` 目录下包含 ActionScript 3 源码，可通过 Apache Flex SDK（`mxmlc`）编译为 SWF：

```bash
cd flash
bash build.sh
```

编译产物：
- `public/FightPlayer.swf` — 主播放器，配合编辑器使用
- `public/demo/DemoPlayer.swf` — 轻量演示播放器

## 开发说明

- 路径别名 `@` 指向 `src/`
- SWF 文件通过 `assetsInclude: ['**/*.swf']` 被 Vite 视为静态资源
- Ruffle 运行时通过 `vite-plugin-static-copy` 自动复制到 `dist/ruffle/`
- 构建产物包含 `stats.html`（Rollup Visualizer 包体积分析）

## 许可证

Private 项目，未指定开源许可证。
