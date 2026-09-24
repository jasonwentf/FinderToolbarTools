# Finder Toolbar Tools

两个可放进 Finder 工具栏的轻量 macOS App：

- **前往路径**：打开 Finder 原生的“前往文件夹”窗口（`⇧⌘G`）。
- **上一级**：在 Finder 中返回父目录（`⌘↑`）。

两个 App 都由同一份 Swift/AppKit 代码直接发送快捷键；不依赖 BetterTouchTool，也不常驻后台。它们只发送按键，不读取文件路径或剪贴板内容。首次使用需要在“系统设置 → 隐私与安全性 → 辅助功能”中允许对应 App 控制电脑。

## 构建

需要 Xcode Command Line Tools。运行 `bash scripts/build.sh`，生成 `.build/前往路径.app` 与 `.build/上一级.app`。构建脚本会制作图标并对本地 App 做临时签名。临时签名的代码更新后，macOS 可能要求重新授予辅助功能权限。

## 安装与更新

首次安装时，将生成的两个 App 复制到固定位置（例如 `~/Applications`），然后按住 Command，从该位置把 App 拖到 Finder 顶部工具栏。不要直接拖入 `.build/` 中的 App；下次构建会重建该目录。工具栏里的 App 没有运行时菜单或常驻进程。

第一次点击时，按提示分别给两个 App 开启辅助功能权限。更新已安装 App 前先备份；更新后如果开关显示开启却仍提示无权限，可在系统设置的辅助功能列表中仅移除该 App 的旧记录，再添加当前安装位置的 App。若保持安装路径不变，通常无需重新拖动工具栏按钮。

当前安装版固定使用不透明的白底黑图形，避免 Finder 窗口失焦时把透明区域显示成灰色颗粒。`icons/` 中的深色反色稿仅供设计参考，构建脚本不会安装它，也不做自动切换。更改已签名 App 包内图标资源后，必须重新签名；临时签名变化也可能需要重新授予辅助功能权限。

## 项目结构

- `apps/GoToFolder/`：前往路径入口。
- `apps/GoUp/`：上一级入口。
- `Sources/ShortcutLauncher.swift`：共同的 Finder 定位、权限检查、快捷键发送与退出逻辑。
- `scripts/build.sh`：构建两个 App。

Finder 文件大小浮层是独立项目 `../FinderSizeOverlay/`，不属于本仓库的构建或部署流程。
