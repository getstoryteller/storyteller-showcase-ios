import StorytellerSDK
import SwiftUI

struct FeedImageView: View {
    let item: ButtonItem

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                if let title = item.title {
                    CellHeaderTitle(title: title)
                }
                Spacer()
            }

            Spacer()

            if let imageUrl = URL(string: item.url) {
                Button {
                    switch item.action.type {
                    case .inApp:
                        guard let category = URLComponents(string: item.action.url)?.queryItems?.first(where: { $0.name == "categoryId" })?.value else { return }
                        Storyteller.openCategory(category: category)
                    case .web:
                        break
                    }
                } label: {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(.rect(cornerRadius: 4))
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }

                }
            }
        }
        .padding(.vertical, item.title != nil ? 12 : 0)
        .padding(.horizontal, 12)
    }
}
