import Foundation
import SwiftUI
import StorytellerSDK

enum StorytellerAction {
    case contentDidChange(CGSize)
    case onDataLoadStarted
    case onDataLoadComplete(success: Bool, error: Error?, dataCount: Int)
    case onPlayerDismissed
    case tileBecameVisible(contentIndex: Int)
}

class StorytellerConfiguration {
    var theme: UITheme?
    var displayLimit: Int?
    var cellType: StorytellerCellType = .square
}

class StorytellerStoriesConfiguration: StorytellerConfiguration {
    var categories: [String] = .init()
    
    static var `default`: StorytellerStoriesConfiguration {
        StorytellerStoriesConfiguration()
    }
}

class StorytellerClipsConfiguration: StorytellerConfiguration {
    var collectionId: String = .init()
    
    static var `default`: StorytellerClipsConfiguration {
        StorytellerClipsConfiguration()
    }
}

enum StorytellerCellType: String, Codable {
    case round = "Round"
    case square = "Square"
}

/// Storyteller stories grid view wrapper.
///
/// - Parameters:
///   - configuration: `StorytellerStoriesConfiguration` instance.
///   - callback: callback with `StorytellerCallbackAction` handler.
///
struct StorytellerStoriesGrid: UIViewRepresentable, StorytellerCallbackable {
    let configuration: StorytellerStoriesConfiguration
    var callback: ((StorytellerAction) -> Void)? = nil
    
    func makeUIView(context: Context) -> StorytellerGridView {
        let view = StorytellerGridView()
        view.categories = configuration.categories
        view.displayLimit = configuration.displayLimit
        view.delegate = context.coordinator
        view.gridDelegate = context.coordinator
        view.theme = configuration.theme
        view.cellType = configuration.cellType.rawValue
        view.reloadData()
        return view
    }
    
    func updateUIView(_ uiView: StorytellerGridView, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }
}

/// Storyteller clips grid view wrapper.
///
/// - Parameters:
///   - configuration: `StorytellerClipsConfiguration` instance.
///   - callback: callback with `StorytellerCallbackAction` handler.
///
struct StorytellerClipsGrid: UIViewRepresentable, StorytellerCallbackable {
    let configuration: StorytellerClipsConfiguration
    var callback: ((StorytellerAction) -> Void)? = nil
    
    func makeUIView(context: Context) -> StorytellerClipsGridView {
        let view = StorytellerClipsGridView()
        view.collectionId = configuration.collectionId
        view.displayLimit = configuration.displayLimit
        view.delegate = context.coordinator
        view.gridDelegate = context.coordinator
        view.theme = configuration.theme
        view.cellType = configuration.cellType.rawValue
        view.reloadData()
        
        return view
    }
    
    func updateUIView(_ uiView: StorytellerClipsGridView, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }
}

/// Storyteller stories row view wrapper.
///
/// - Parameters:
///   - configuration: `StorytellerStoriesConfiguration` instance.
///   - callback: callback with `StorytellerCallbackAction` handler.
///
struct StorytellerStoriesRow: UIViewRepresentable, StorytellerCallbackable {
    let configuration: StorytellerStoriesConfiguration
    var callback: ((StorytellerAction) -> Void)? = nil
    
    func makeUIView(context: Context) -> StorytellerRowView {
        let view = StorytellerRowView()
        view.delegate = context.coordinator
        view.categories = configuration.categories
        view.cellType = configuration.cellType.rawValue
        view.theme = configuration.theme
        view.cellType = configuration.cellType.rawValue
        view.reloadData()
        return view
    }
    
    func updateUIView(_ uiView: StorytellerRowView, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }
}

/// Storyteller clips row view wrapper.
///
/// - Parameters:
///   - configuration: `StorytellerClipsConfiguration` instance.
///   - callback: callback with `StorytellerCallbackAction` handler.
///
struct StorytellerClipsRow: UIViewRepresentable, StorytellerCallbackable {
    let configuration: StorytellerClipsConfiguration
    var callback: ((StorytellerAction) -> Void)? = nil
    
    func makeUIView(context: Context) -> StorytellerClipsRowView {
        let view = StorytellerClipsRowView()
        view.delegate = context.coordinator
        view.collectionId = configuration.collectionId
        view.theme = configuration.theme
        view.cellType = configuration.cellType.rawValue
        view.reloadData()
        return view
    }
    
    func updateUIView(_ uiView: StorytellerClipsRowView, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }
}

protocol StorytellerCallbackable {
    var callback: ((StorytellerAction) -> Void)? { get }
}

class StorytellerDelegateWrapped: NSObject, StorytellerListViewDelegate, StorytellerGridViewDelegate {
    init(_ view: StorytellerCallbackable) {
        self.view = view
    }
    
    func contentSizeDidChange(_ size: CGSize) {
        view.callback?(.contentDidChange(size))
    }
    
    func onDataLoadStarted() {
        view.callback?(.onDataLoadStarted)
    }
    
    func onDataLoadComplete(success: Bool, error: Error?, dataCount: Int) {
        view.callback?(.onDataLoadComplete(success: success, error: error, dataCount: dataCount))
    }
    
    func onPlayerDismissed() {
        view.callback?(.onPlayerDismissed)
    }
    
    func tileBecameVisible(contentIndex: Int) {
        view.callback?(.tileBecameVisible(contentIndex: contentIndex))
    }
    
    private var view: StorytellerCallbackable
}
