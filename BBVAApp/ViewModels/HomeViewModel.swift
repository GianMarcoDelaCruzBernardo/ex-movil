import Foundation; import Combine
final class HomeViewModel: ObservableObject {
    @Published var items: [ItemModel] = ItemModel.catalog; @Published var searchText = ""; @Published var selectedCategory: ItemCategory? = nil
    @Published private(set) var filteredItems: [ItemModel] = ItemModel.catalog
    init() {
        let search = $searchText.debounce(for: .milliseconds(150), scheduler: RunLoop.main).removeDuplicates()
        Publishers.CombineLatest3($items, search, $selectedCategory).map { (items, text, cat) -> [ItemModel] in
            let q = text.trimmed; return items.filter { (cat == nil || $0.category == cat) && (q.isEmpty || $0.name.localizedStandardContains(q) || $0.subtitle.localizedStandardContains(q)) }
        }.receive(on: RunLoop.main).assign(to: &$filteredItems)
    }
}
