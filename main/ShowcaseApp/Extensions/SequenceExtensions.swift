import Foundation

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, order: SortOrder) -> [Element] {
        return sorted { a, b in
            switch order {
            case .forward:
                return a[keyPath: keyPath] < b[keyPath: keyPath]
            case .reverse:
                return a[keyPath: keyPath] > b[keyPath: keyPath]
            }
        }
    }

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted(by: keyPath, order: .forward)
    }
}
