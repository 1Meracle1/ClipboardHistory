import Foundation
import Cocoa
import Combine

class ClipboardManager: NSObject {
    private var lastChangeCount: Int = 0
    private var timer: Timer?
    
    override init() {
        super.init()
        lastChangeCount = NSPasteboard.general.changeCount
        startMonitoringClipboard()
        loadHistory()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startMonitoringClipboard() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let pasteboard = NSPasteboard.general
            let currentChangeCount = pasteboard.changeCount
            
            if currentChangeCount != self.lastChangeCount {
                self.lastChangeCount = currentChangeCount
                
                if let string = pasteboard.string(forType: .string),
                   !string.isEmpty {
                    // Add to view model
                    ClipboardViewModel.shared.addItem(string)
                }
            }
        }
    }
    
    private func loadHistory() {
        ClipboardViewModel.shared.loadHistory()
    }
}
