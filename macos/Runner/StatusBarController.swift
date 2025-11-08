import Cocoa
import FlutterMacOS

class StatusBarController {
    private var statusItem: NSStatusItem?
    private var menu: NSMenu?
    private var recordingMenuItem: NSMenuItem?
    private var isRecording = false

    // Callback for menu actions
    var onStartRecording: (() -> Void)?
    var onStopRecording: (() -> Void)?
    var onOpenSettings: (() -> Void)?
    var onRestart: (() -> Void)?
    var onCheckForUpdates: (() -> Void)?
    var onQuit: (() -> Void)?

    init() {
        setupStatusBar()
    }

    private func setupStatusBar() {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let statusItem = statusItem else {
            NSLog("StatusBarController: Failed to create status bar item")
            return
        }

        // Set initial icon - using app icon
        if let button = statusItem.button {
            // Load the app icon and resize it for menu bar (16x16 or 18x18 for Retina)
            if let appIcon = NSImage(named: "AppIcon") {
                let iconSize = NSSize(width: 18, height: 18)
                appIcon.size = iconSize
                button.image = appIcon
                button.image?.isTemplate = false // Keep original colors
            } else {
                // Fallback to SF Symbol if app icon not found
                NSLog("StatusBarController: App icon not found, using SF Symbol")
                button.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: "UltraWhisper")
                button.image?.isTemplate = true
            }
        }

        // Create menu
        menu = NSMenu()

        // Recording toggle menu item
        recordingMenuItem = NSMenuItem(
            title: "Start Recording",
            action: #selector(toggleRecording),
            keyEquivalent: ""
        )
        recordingMenuItem?.target = self
        menu?.addItem(recordingMenuItem!)

        menu?.addItem(NSMenuItem.separator())

        // Settings menu item
        let settingsItem = NSMenuItem(
            title: "Settings...",
            action: #selector(openSettings),
            keyEquivalent: ","
        )
        settingsItem.target = self
        menu?.addItem(settingsItem)

        menu?.addItem(NSMenuItem.separator())

        // Check for Updates menu item
        let updateItem = NSMenuItem(
            title: "Check for Updates...",
            action: #selector(checkForUpdates),
            keyEquivalent: ""
        )
        updateItem.target = self
        menu?.addItem(updateItem)

        menu?.addItem(NSMenuItem.separator())

        // Restart menu item
        let restartItem = NSMenuItem(
            title: "Restart",
            action: #selector(restart),
            keyEquivalent: ""
        )
        restartItem.target = self
        menu?.addItem(restartItem)

        // Quit menu item
        let quitItem = NSMenuItem(
            title: "Quit UltraWhisper",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu?.addItem(quitItem)

        // Attach menu to status item
        statusItem.menu = menu

        NSLog("StatusBarController: Status bar initialized successfully")
    }

    // MARK: - Public Methods

    func setRecordingState(_ recording: Bool) {
        isRecording = recording

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Update menu item title
            if recording {
                self.recordingMenuItem?.title = "Stop Recording"
                // Keep the same icon but could add a visual indicator
                // For now, we'll keep it simple with just the menu title change
                // Could add a badge or overlay in the future
            } else {
                self.recordingMenuItem?.title = "Start Recording"
                // Restore normal icon if we changed it
                if let button = self.statusItem?.button {
                    if let appIcon = NSImage(named: "AppIcon") {
                        let iconSize = NSSize(width: 18, height: 18)
                        appIcon.size = iconSize
                        button.image = appIcon
                        button.image?.isTemplate = false // Keep original colors
                    }
                }
            }

            NSLog("StatusBarController: Recording state updated to \(recording)")
        }
    }

    func showStatusBar() {
        guard let statusItem = statusItem else { return }
        statusItem.isVisible = true
        NSLog("StatusBarController: Status bar shown")
    }

    func hideStatusBar() {
        guard let statusItem = statusItem else { return }
        statusItem.isVisible = false
        NSLog("StatusBarController: Status bar hidden")
    }

    // MARK: - Menu Actions

    @objc private func toggleRecording() {
        NSLog("StatusBarController: Toggle recording clicked")
        if isRecording {
            onStopRecording?()
        } else {
            onStartRecording?()
        }
    }

    @objc private func openSettings() {
        NSLog("StatusBarController: Settings clicked")
        onOpenSettings?()
    }

    @objc private func checkForUpdates() {
        NSLog("StatusBarController: Check for updates clicked")
        onCheckForUpdates?()
    }

    @objc private func restart() {
        NSLog("StatusBarController: Restart clicked")
        onRestart?()
    }

    @objc private func quit() {
        NSLog("StatusBarController: Quit clicked")
        onQuit?()
    }

    deinit {
        NSStatusBar.system.removeStatusItem(statusItem!)
        NSLog("StatusBarController: Cleaned up status bar")
    }
}

// MARK: - Flutter Method Call Handler

extension StatusBarController {
    static func handleMethodCall(
        call: FlutterMethodCall,
        result: @escaping FlutterResult,
        controller: StatusBarController
    ) {
        switch call.method {
        case "setRecordingState":
            guard let args = call.arguments as? [String: Any],
                  let recording = args["recording"] as? Bool else {
                result(FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "Missing recording argument",
                    details: nil
                ))
                return
            }
            controller.setRecordingState(recording)
            result(nil)

        case "showStatusBar":
            controller.showStatusBar()
            result(nil)

        case "hideStatusBar":
            controller.hideStatusBar()
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
