import Foundation
import SwiftUI

enum SelectActionType {
    case add(AttributeValue)
    case remove(AttributeValue)
    case set(AttributeValue?)
}

struct MultiSelectView: View {

    @State private var selectionUpdated = false
    let attribute: PersonalisationAttribute
    let selectedItems: Set<AttributeValue>
    let viewModel: AccountViewModel

    var body: some View {
        List {
            if attribute.nullable {
                SelectableItemLine(title: "Not Set", selected: selectedItems.isEmpty)
                    .onTapGesture {
                        selectionUpdated = true
                        viewModel.personalisationUpdated(for: attribute, actionType: .set(nil))
                    }
            }
            ForEach(attribute.attributeValues, id: \.self) { item in
                SelectableItemLine(title: item.title, selected: selectedItems.contains(item))
                .onTapGesture {
                    selectionUpdated = true
                    viewModel.personalisationUpdated(for: attribute, actionType: selectedItems.contains(item) ? .remove(item) : .add(item))
                }
            }
        }
        .onDisappear {
            if selectionUpdated {
                viewModel.personalisationUpdated()
            }
        }
    }
}
