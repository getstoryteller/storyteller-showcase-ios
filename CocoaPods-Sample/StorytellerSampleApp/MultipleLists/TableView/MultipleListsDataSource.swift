import Foundation
import StorytellerSDK
import UIKit

// MARK: - MainDataSource

final class MultipleListsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: Internal
    
    var storytellerListsData: [CellData] = []
    var individualDelegates: [Int: IndividualGridViewDelegate] = [:]
    var individualListDelegates: [Int: StorytellerListDelegate] = [:]
    

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storytellerListsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = storytellerListsData[indexPath.row]
        self.tableView = tableView

        switch data {
        case let .label(text):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LabelCell.defaultCellReuseIdentifier,
                for: indexPath) as? LabelCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            cell.bind(text: text)
            return cell
        case let .storiesRow(cellType, categories, height):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoriesRowCell.defaultCellReuseIdentifier,
                for: indexPath) as? StoriesRowCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            let listDelegate = createListDelegate(indexPath: indexPath)
            cell.bind(
                index: indexPath.row,
                categories: categories,
                cellType: cellType,
                height: height,
                delegate: listDelegate)

            return cell
        case let .storiesGrid(cellType, categories):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoriesGridCell.defaultCellReuseIdentifier,
                for: indexPath) as? StoriesGridCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            let listDelegate = createListDelegate(indexPath: indexPath)
            let gridDelegate = createGridDelegate(indexPath: indexPath)
            cell.bind(
                categories: categories,
                cellType: cellType,
                delegate: listDelegate,
                gridDelegate: gridDelegate)
            cell.reloadData()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case let .clipsRow(cellType, collectionId, height):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ClipsRowCell.defaultCellReuseIdentifier,
                for: indexPath) as? ClipsRowCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            let listDelegate = createListDelegate(indexPath: indexPath)
            cell.bind(
                index: indexPath.row,
                collectionId: collectionId,
                cellType: cellType,
                height: height,
                delegate: listDelegate)

            return cell
        case let .clipsGrid(cellType, collectionId):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ClipsGridCell.defaultCellReuseIdentifier,
                for: indexPath) as? ClipsGridCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            let listDelegate = createListDelegate(indexPath: indexPath)
            let gridDelegate = createGridDelegate(indexPath: indexPath)
            cell.bind(
                collectionId: collectionId,
                cellType: cellType,
                delegate: listDelegate,
                gridDelegate: gridDelegate)
            cell.reloadData()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    // MARK: Private

    private var tableView: UITableView?

    private func createGridDelegate(indexPath: IndexPath) -> StorytellerGridViewDelegate {
        let delegate = IndividualGridViewDelegate(indexPath: indexPath)
        delegate.tableView = tableView
        individualDelegates[indexPath.item] = delegate
        return delegate
    }
    
    private func createListDelegate(indexPath: IndexPath) -> StorytellerListDelegate {
        let delegate = StorytellerListDelegate()
        delegate.actionHandler = { [weak self] action in
            switch action {
            case .didLoadData(let dataCount):
                guard dataCount == 0 else { return }
                DispatchQueue.main.async {
                    let labelIndexPath = IndexPath(item: indexPath.item - 1, section: 0)
                    self?.storytellerListsData.remove(at: labelIndexPath.item)
                    self?.storytellerListsData.remove(at: labelIndexPath.item)
                    //remove row with Storyteller component and it's label
                    self?.tableView?.deleteRows(at: [labelIndexPath, indexPath], with: .none)
                }
            }
        }
        individualListDelegates[indexPath.item] = delegate
        return delegate
    }
}
