import Foundation
import SwiftUI

struct SelectableItemLine: View {

    let title: String
    let selected: Bool

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if selected {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
    }
}
