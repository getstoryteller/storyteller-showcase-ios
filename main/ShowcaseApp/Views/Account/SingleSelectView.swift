import Foundation
import SwiftUI

struct SingleSelectView: View {

    @State private var selectionUpdated = false
    let attribute: PersonalisationAttribute
    let selectedItem: AttributeValue?
    let viewModel: AccountViewModel

    var body: some View {
        List {
            if attribute.nullable {
                SelectableItemLine(title: "Not Set", selected: selectedItem == nil)
                    .onTapGesture {
                        selectionUpdated = true
                        viewModel.personalisationUpdated(for: attribute, actionType: .set(nil))
                    }
            }
            ForEach(attribute.attributeValues, id: \.self) { item in
                SelectableItemLine(title: item.title, selected: selectedItem == item)
                    .onTapGesture {
                        selectionUpdated = true
                        viewModel.personalisationUpdated(for: attribute, actionType: .set(item))
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
