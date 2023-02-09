import Foundation
import StorytellerSDK
import UIKit

enum CellData {
    case label(text: String)
    case storiesRow(cellType: StorytellerListViewCellType, categories: [String], height: CGFloat)
    case storiesGrid(cellType: StorytellerListViewCellType, categories: [String])
    case clipsRow(cellType: StorytellerListViewCellType, collectionId: String, height: CGFloat)
    case clipsGrid(cellType: StorytellerListViewCellType, collectionId: String)
}

final class MultipleListsViewModel {
    // MARK: Lifecycle

    init(storytellerManager: StorytellerManager) {
        self.storytellerManager = storytellerManager
        
        if !storytellerManager.isInitalised {
            storytellerManager.setupBackendSettings { error in
                print("[Error] \(error)")
            } onComplete: { [weak self] in
                guard let self = self else { return }
                self.outputActionHandler(.reload(self.data))
            }
        }
    }

    // MARK: Internal

    enum InputAction {
        case getData
        case viewWillDisappear
    }

    enum OutputAction {
        case showError(Error)
        case reload([CellData])
    }
    
    enum OutputNavigationAction {
        case viewWillDisappear
    }

    var outputActionHandler: (MultipleListsViewModel.OutputAction) -> Void = { _ in }
    var outputNavigationActionHandler: (MultipleListsViewModel.OutputNavigationAction) -> Void = { _ in }
    
    lazy var data: [CellData] = [
        .label(text: "Storyteller Row View Round"),
        .storiesRow(cellType: .round, categories: [], height: 110),
        .label(text: "Storyteller Row View Square"),
        .storiesRow(cellType: .square, categories: [], height: 220),
        .label(text: "Storyteller Row View Square with 0 elements"),
        .storiesRow(cellType: .square, categories: ["zero"], height: 220),
        .label(text: "Storyteller Grid View"),
        .storiesGrid(cellType: .square, categories: []),
        .label(text: "Storyteller Clips Row View"),
        .clipsRow(cellType: .square, collectionId: "clipssample", height: 220),
        .label(text: "Storyteller Clips Grid View"),
        .clipsGrid(cellType: .square, collectionId: "clipssample")
    ]

    func handle(action: InputAction) {
        switch action {
        case .getData:
            outputActionHandler(.reload(data))
        case .viewWillDisappear:
            outputNavigationActionHandler(.viewWillDisappear)
        }
    }

    // MARK: Private

    private let storytellerManager: StorytellerManager
    private let storytellerDelegate = StorytellerListDelegate()
}
