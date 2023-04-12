import Foundation
import SwiftUI
import StorytellerSDK

enum StorytellerAction {
    case onDataLoadStarted
    case onDataLoadComplete(success: Bool, error: Error?, dataCount: Int)
    case onPlayerDismissed
    case tileBecameVisible(contentIndex: Int)
}

class StorytellerConfiguration {
    var theme: StorytellerTheme?
    var displayLimit: Int?
    var cellType: StorytellerListViewCellType = .square
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

/// Storyteller stories grid view wrapper.
///
/// - Parameters:
///   - configuration: `StorytellerStoriesConfiguration` instance.
///   - callback: callback with `StorytellerCallbackAction` handler.
///
struct StorytellerStoriesGrid: UIViewRepresentable, StorytellerCallbackable {
    let configuration: StorytellerStoriesConfiguration
    var callback: ((StorytellerAction) -> Void)? = nil
    
    func makeUIView(context: Context) -> StorytellerStoriesGridView {
        let view = StorytellerStoriesGridView(isScrollable: false)
        view.categories = configuration.categories
        view.displayLimit = configuration.displayLimit
        view.delegate = context.coordinator
        view.theme = configuration.theme
        view.cellType = configuration.cellType
        view.reloadData()
        return view
    }
    
    func updateUIView(_ uiView: StorytellerStoriesGridView, context: Context) {
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
        let view = StorytellerClipsGridView(isScrollable: false)
        view.collectionId = configuration.collectionId
        view.displayLimit = configuration.displayLimit
        view.delegate = context.coordinator
        view.theme = configuration.theme
        view.cellType = configuration.cellType
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
    
    func makeUIView(context: Context) -> StorytellerStoriesRowView {
        let view = StorytellerStoriesRowView()
        view.delegate = context.coordinator
        view.categories = configuration.categories
        view.theme = configuration.theme
        view.cellType = configuration.cellType
        view.reloadData()
        return view
    }
    
    func updateUIView(_ uiView: StorytellerStoriesRowView, context: Context) {
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
        view.cellType = configuration.cellType
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

class StorytellerDelegateWrapped: NSObject, StorytellerListViewDelegate {
    init(_ view: StorytellerCallbackable) {
        self.view = view
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
