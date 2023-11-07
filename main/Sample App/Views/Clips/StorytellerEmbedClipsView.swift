import StorytellerSDK
import SwiftUI

// This is just a converter between UIKit and SwiftUI and will be
// moved to the Storyteller SDK in a future release

struct StorytellerEmbedClipsView : UIViewControllerRepresentable {
    
    let configuration: StorytellerClipsListConfiguration
    
    func makeUIViewController(context: Context) -> StorytellerClipsViewController {
        return StorytellerClipsViewController()
    }
    
    func updateUIViewController(_ uiViewController: StorytellerClipsViewController, context: Context) {
        if let collectionId = configuration.collectionId {
            DispatchQueue.main.async {
                uiViewController.collectionId = collectionId
            }
        }
    }
}
