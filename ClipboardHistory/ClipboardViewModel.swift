import Foundation
import SwiftUI
import Combine

class ClipboardViewModel: ObservableObject {
    static let shared = ClipboardViewModel()
    
    @Published var clipboardItems: [ClipboardItem] = []
    private let maxHistoryItems = 50
    
    func addItem(_ text: String) {
        // Check if this item already exists at the top
        if clipboardItems.isEmpty || clipboardItems[0].text != text {
            let newItem = ClipboardItem(text: text, date: Date())
            clipboardItems.insert(newItem, at: 0)
            
            // Limit history size
            if clipboardItems.count > maxHistoryItems {
                clipboardItems.removeLast()
            }
            
            saveHistory()
        }
    }
    
    func copyToClipboard(_ item: ClipboardItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(item.text, forType: .string)
        
        // Move this item to the top
        if let index = clipboardItems.firstIndex(where: { $0.id == item.id }) {
            let item = clipboardItems.remove(at: index)
            clipboardItems.insert(item, at: 0)
            saveHistory()
        }
    }
    
    func saveHistory() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(clipboardItems) {
            UserDefaults.standard.set(encoded, forKey: "clipboardHistory")
        }
    }
    
    func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "clipboardHistory") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ClipboardItem].self, from: data) {
                clipboardItems = decoded
            }
        }
    }
}

struct ClipboardItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let text: String
    let date: Date
    
    var preview: String {
        let maxLength = 50
        if text.count <= maxLength {
            return text
        } else {
            return String(text.prefix(maxLength)) + "..."
        }
    }
}
