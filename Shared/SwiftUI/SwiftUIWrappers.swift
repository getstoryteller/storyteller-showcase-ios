import Foundation
import StorytellerSDK
import SwiftUI

enum StorytellerAction {
    case onDataLoadStarted
    case onDataLoadComplete(success: Bool, error: Error?, dataCount: Int)
    case onPlayerDismissed
}

// Every time you change one of these properties, the view will reload
struct CommonConfiguration {
    var theme: StorytellerTheme?
    var displayLimit: Int?
    var cellType: StorytellerListViewCellType = .square
    // Dummy var to trigger list reload
    var triggerReload = false
}

// Every time you change one of these properties, the view will reload
struct StoriesConfiguration {
    var categories: [String] = .init()
    var common = CommonConfiguration()

    static var `default`: StoriesConfiguration {
        StoriesConfiguration()
    }
}

// Every time you change one of these properties, the view will reload
struct ClipsConfiguration {
    var collectionId: String = .init()
    var common = CommonConfiguration()

    static var `default`: ClipsConfiguration {
        ClipsConfiguration()
    }
}

/// Storyteller stories grid view wrapper.
///
/// - Parameters:
///   - configuration: `StoriesConfiguration` instance.
///   - callback: callback with `StorytellerCallbackAction` handler.
///
struct StorytellerStoriesGrid: UIViewRepresentable, StorytellerCallbackable {
    let configuration: StoriesConfiguration
    var callback: ((StorytellerAction) -> Void)?

    func makeUIView(context: Context) -> StorytellerStoriesGridView {
        let view = StorytellerStoriesGridView(isScrollable: false)
        view.delegate = context.coordinator
        updateAndReloadView(view)

        return view
    }

    func updateUIView(_ uiView: StorytellerStoriesGridView, context: Context) {
        updateAndReloadView(uiView)
    }

    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }

    func updateAndReloadView(_ view: StorytellerStoriesGridView) {
        view.categories = configuration.categories
        view.displayLimit = configuration.common.displayLimit
        view.theme = configuration.common.theme
        view.cellType = configuration.common.cellType
        view.reloadData()
    }
}

/// Storyteller clips grid view wrapper.
///
/// - Parameters:
///   - configuration: `ClipsConfiguration` instance.
///   - callback: callback with `StorytellerCallbackAction` handler.
///
struct StorytellerClipsGrid: UIViewRepresentable, StorytellerCallbackable {
    let configuration: ClipsConfiguration
    var callback: ((StorytellerAction) -> Void)?

    func makeUIView(context: Context) -> StorytellerClipsGridView {
        let view = StorytellerClipsGridView(isScrollable: false)
        view.delegate = context.coordinator
        updateAndReloadView(view)

        return view
    }

    func updateUIView(_ uiView: StorytellerClipsGridView, context: Context) {
        updateAndReloadView(uiView)
    }

    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }

    func updateAndReloadView(_ view: StorytellerClipsGridView) {
        view.collectionId = configuration.collectionId
        view.displayLimit = configuration.common.displayLimit
        view.theme = configuration.common.theme
        view.cellType = configuration.common.cellType
        view.reloadData()
    }
}

/// Storyteller stories row view wrapper.
///
/// - Parameters:
///   - configuration: `StoriesConfiguration` instance.
///   - callback: callback with `StorytellerCallbackAction` handler.
///
struct StorytellerStoriesRow: UIViewRepresentable, StorytellerCallbackable {
    let configuration: StoriesConfiguration
    var callback: ((StorytellerAction) -> Void)?

    func makeUIView(context: Context) -> StorytellerStoriesRowView {
        let view = StorytellerStoriesRowView()
        view.delegate = context.coordinator
        updateAndReloadView(view)

        return view
    }

    func updateUIView(_ uiView: StorytellerStoriesRowView, context: Context) {
        updateAndReloadView(uiView)
    }

    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }

    func updateAndReloadView(_ view: StorytellerStoriesRowView) {
        view.categories = configuration.categories
        view.displayLimit = configuration.common.displayLimit
        view.theme = configuration.common.theme
        view.cellType = configuration.common.cellType
        view.reloadData()
    }
}

/// Storyteller clips row view wrapper.
///
/// - Parameters:
///   - configuration: `ClipsConfiguration` instance.
///   - callback: callback with `StorytellerCallbackAction` handler.
///
struct StorytellerClipsRow: UIViewRepresentable, StorytellerCallbackable {
    let configuration: ClipsConfiguration
    var callback: ((StorytellerAction) -> Void)?

    func makeUIView(context: Context) -> StorytellerClipsRowView {
        let view = StorytellerClipsRowView()
        view.delegate = context.coordinator
        updateAndReloadView(view)

        return view
    }

    func updateUIView(_ uiView: StorytellerClipsRowView, context: Context) {
        updateAndReloadView(uiView)
    }

    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }

    func updateAndReloadView(_ view: StorytellerClipsRowView) {
        view.collectionId = configuration.collectionId
        view.displayLimit = configuration.common.displayLimit
        view.theme = configuration.common.theme
        view.cellType = configuration.common.cellType
        view.reloadData()
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

    private var view: StorytellerCallbackable
}
