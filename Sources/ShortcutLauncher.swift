import AppKit
import ApplicationServices
import CoreGraphics

struct FinderShortcut {
    let keyCode: CGKeyCode
    let modifiers: CGEventFlags
    let appName: String
}

private final class ShortcutAppDelegate: NSObject, NSApplicationDelegate {
    let shortcut: FinderShortcut

    init(shortcut: FinderShortcut) {
        self.shortcut = shortcut
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Let Launch Services finish activating Finder after a toolbar click.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) { [self] in
            runShortcut()
        }
    }

    private func runShortcut() {
        guard CGPreflightPostEventAccess() || CGRequestPostEventAccess() else {
            let alert = NSAlert()
            alert.messageText = "请允许“\(shortcut.appName)”使用辅助功能"
            alert.informativeText = "在“系统设置 → 隐私与安全性 → 辅助功能”中开启权限，然后再次点击工具栏按钮。"
            alert.runModal()
            NSApp.terminate(nil)
            return
        }

        guard let finder = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.finder").first else {
            showError("Finder 尚未运行。")
            return
        }

        if NSWorkspace.shared.frontmostApplication?.bundleIdentifier != "com.apple.finder" {
            guard finder.activate(options: []) else {
                showError("无法激活 Finder。")
                return
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) { [self] in
            postShortcut(to: finder.processIdentifier)
        }
    }

    private func postShortcut(to pid: pid_t) {
        guard let down = CGEvent(keyboardEventSource: nil, virtualKey: shortcut.keyCode, keyDown: true),
              let up = CGEvent(keyboardEventSource: nil, virtualKey: shortcut.keyCode, keyDown: false) else {
            showError("无法生成快捷键事件。")
            return
        }

        down.flags = shortcut.modifiers
        up.flags = shortcut.modifiers
        down.postToPid(pid)
        up.postToPid(pid)
        NSApp.terminate(nil)
    }

    private func showError(_ message: String) {
        let alert = NSAlert()
        alert.messageText = "\(shortcut.appName)未执行"
        alert.informativeText = message
        alert.runModal()
        NSApp.terminate(nil)
    }
}

func launchFinderShortcut(_ shortcut: FinderShortcut) {
    let app = NSApplication.shared
    let delegate = ShortcutAppDelegate(shortcut: shortcut)
    app.delegate = delegate
    app.run()
}
