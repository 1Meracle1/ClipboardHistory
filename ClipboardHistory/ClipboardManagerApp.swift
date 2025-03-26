import SwiftUI

@main
struct ClipboardManagerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var clipboardViewModel = ClipboardViewModel()
  
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
