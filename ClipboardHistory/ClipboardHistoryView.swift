import SwiftUI

struct ClipboardHistoryView: View {
    @EnvironmentObject var viewModel: ClipboardViewModel
    @State private var searchText = ""
    
    var filteredItems: [ClipboardItem] {
        if searchText.isEmpty {
            return viewModel.clipboardItems
        } else {
            return viewModel.clipboardItems.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            List {
                ForEach(filteredItems) { item in
                    ClipboardItemRow(item: item)
                        .onTapGesture {
                            viewModel.copyToClipboard(item)
                            NSApplication.shared.keyWindow?.close()
                        }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 500)
    }
}

struct ClipboardItemRow: View {
    let item: ClipboardItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.preview)
                .lineLimit(2)
                .font(.body)
            
            Text(item.date, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
