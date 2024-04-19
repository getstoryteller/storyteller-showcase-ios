import Foundation
import SwiftUI

struct AttributeLineItem: View {

    let title: String
    let selectedValues: Set<AttributeValue>

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(selectedItemDisplay)
                .foregroundStyle(.secondary)
        }
    }

    private var selectedItemDisplay: String {
        guard selectedValues.count <= 1 else { return "" }

        return selectedValues.first?.title ?? "Not Set"
    }
}
