import SwiftUI
import StorytellerSDK

struct ActionLinkView: View {
    @State var link: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "link")
                .foregroundColor(.secondary)
                .font(.system(size: 140))
                .padding(.bottom, 20)
            Text("This Link Would Navigate User To:")
                .foregroundColor(.secondary)
                .fontWeight(.regular)
            Text(link)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
        }
        .navigationTitle("Action Link")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    ActionLinkView(link: "test link")
}
