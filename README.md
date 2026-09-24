# Finder Toolbar Tools

给 Finder 工具栏加两个按钮：

| 按钮 | 点击后 |
| --- | --- |
| 前往路径 | 打开系统自带的“前往文件夹”输入框，可以直接粘贴路径（`⇧⌘G`） |
| 上一级 | 返回当前文件夹的父目录（`⌘↑`） |

两个 App 都只向 Finder 发送快捷键，不调用 BetterTouchTool，也不常驻后台。路径输入框是 macOS 自带的；App 不读取剪贴板或文件内容。

## 构建和安装

在 macOS 上安装 Xcode Command Line Tools，然后运行：

```sh
bash scripts/build.sh
```

构建结果在 `.build/前往路径.app` 和 `.build/上一级.app`。把需要的 App 复制到固定位置，例如 `~/Applications`，再按住 Command，从那里拖进 Finder 工具栏。不要直接拖入 `.build/` 中的副本；重新构建时它们会被替换。

首次点击时，macOS 会要求为各 App 开启辅助功能权限。系统设置的位置是“隐私与安全性 → 辅助功能”。这项权限用于向 Finder 发送按键。

更新已安装的 App 前先备份。更新后如果辅助功能开关仍显示开启，但按钮提示没有权限，可以只移除该 App 的旧记录，再从安装位置添加新版。改过图标或代码的 App 也需要重新签名；构建脚本使用临时签名。

图标固定为白底黑图形。`icons/` 中的深色稿只是设计稿，目前不会自动切换。两个按钮已在 macOS 26.5.2 的 Finder 工具栏中实测。

## 源码

- `apps/`：两个 App 的入口和配置。
- `Sources/ShortcutLauncher.swift`：查找 Finder、检查权限并发送按键。
- `scripts/`：构建和图标生成脚本。

本项目使用 [MIT 许可证](LICENSE)。
