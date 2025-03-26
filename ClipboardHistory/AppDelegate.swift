import SwiftUI
import Cocoa
import HotKey
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var clipboardManager: ClipboardManager!
    private var hotKey: HotKey!
    private var historyWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon - make it a background app
        NSApp.setActivationPolicy(.accessory)
        
        // Create status bar item
        setupStatusItem()
        
        // Initialize clipboard manager
        clipboardManager = ClipboardManager()
        
        // Register global hotkey
        registerHotkey()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "clipboard", accessibilityDescription: "Clipboard")
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show History", action: #selector(showHistory), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    @objc private func showHistory() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.historyWindow == nil {
                self.createHistoryWindow()
            }
            
            self.historyWindow?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    private func createHistoryWindow() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 500),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Clipboard History"
        window.center()
        
        // Set close behavior to hide instead of close
        window.isReleasedWhenClosed = false
        
        // Create a hosting controller for the SwiftUI view
        let historyView = ClipboardHistoryView()
            .environmentObject(ClipboardViewModel.shared)
        
        window.contentView = NSHostingView(rootView: historyView)
        historyWindow = window
    }
    
    private func registerHotkey() {
        // Command+Shift+V
        hotKey = HotKey(key: .v, modifiers: [.command, .shift])
        hotKey.keyDownHandler = { [weak self] in
            self?.showHistory()
        }
    }
}
