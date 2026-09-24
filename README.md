# Finder Toolbar Tools

两个可放进 Finder 工具栏的轻量 macOS App：

- **前往路径**：打开 Finder 原生的“前往文件夹”窗口（`⇧⌘G`）。
- **上一级**：在 Finder 中返回父目录（`⌘↑`）。

两个 App 都由同一份 Swift/AppKit 代码直接发送快捷键；不依赖 BetterTouchTool，也不常驻后台。它们只发送按键，不读取文件路径或剪贴板内容。首次使用需要在“系统设置 → 隐私与安全性 → 辅助功能”中允许对应 App 控制电脑。

## 构建

需要 Xcode Command Line Tools。运行 `bash scripts/build.sh`，生成 `.build/前往路径.app` 与 `.build/上一级.app`。构建脚本会制作图标并对本地 App 做临时签名。临时签名的代码更新后，macOS 可能要求重新授予辅助功能权限。

按住 Command，把 App 拖到 Finder 顶部工具栏。工具栏里的 App 没有运行时菜单或常驻进程。

当前图标是白底黑图形；`icons/` 同时保存深色反色设计稿。Finder 工具栏是否支持按系统外观自动选择 App 图标，需要在实际系统中单独确认。更改已签名 App 包内图标资源后，必须重新签名。

## 项目结构

- `apps/GoToFolder/`：前往路径入口。
- `apps/GoUp/`：上一级入口。
- `Sources/ShortcutLauncher.swift`：共同的 Finder 定位、权限检查、快捷键发送与退出逻辑。
- `scripts/build.sh`：构建两个 App。

Finder 文件大小浮层是独立项目 `../FinderSizeOverlay/`，不属于本仓库的构建或部署流程。
