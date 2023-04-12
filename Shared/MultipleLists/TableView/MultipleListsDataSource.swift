import Foundation
import StorytellerSDK
import UIKit

// MARK: - MainDataSource

final class MultipleListsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: Internal

    var storytellerListsData: [CellData] = []
    var individualListDelegates: [Int: StorytellerListDelegate] = [:]


    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storytellerListsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = storytellerListsData[indexPath.row]

        switch data {
        case let .label(text):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LabelCell.cellReuseIdentifier,
                for: indexPath) as? LabelCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            cell.bind(text: text)
            return cell
        case let .storiesRow(cellType, categories, height):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoriesRowCell.cellReuseIdentifier,
                for: indexPath) as? StoriesRowCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            let listDelegate = createListDelegate(indexPath: indexPath, tableView: tableView)
            cell.bind(
                index: indexPath.row,
                categories: categories,
                cellType: cellType,
                height: height,
                delegate: listDelegate)

            return cell
        case let .storiesGrid(cellType, categories):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoriesGridCell.cellReuseIdentifier,
                for: indexPath) as? StoriesGridCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            let listDelegate = createListDelegate(indexPath: indexPath, tableView: tableView)
            cell.bind(
                categories: categories,
                cellType: cellType,
                delegate: listDelegate)
            cell.reloadData()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        case let .clipsRow(cellType, collectionId, height):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ClipsRowCell.cellReuseIdentifier,
                for: indexPath) as? ClipsRowCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            let listDelegate = createListDelegate(indexPath: indexPath, tableView: tableView)
            cell.bind(
                index: indexPath.row,
                collectionId: collectionId,
                cellType: cellType,
                height: height,
                delegate: listDelegate)

            return cell
        case let .clipsGrid(cellType, collectionId):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ClipsGridCell.cellReuseIdentifier,
                for: indexPath) as? ClipsGridCell
            else {
                fatalError("Proper cell was not found in UITableView")
            }
            let listDelegate = createListDelegate(indexPath: indexPath, tableView: tableView)
            cell.bind(
                collectionId: collectionId,
                cellType: cellType,
                delegate: listDelegate)
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

    private func createListDelegate(indexPath: IndexPath, tableView: UITableView) -> StorytellerListDelegate {
        let delegate = StorytellerListDelegate()
        delegate.actionHandler = { [weak self] action in
            switch action {
            case .didLoadData(let dataCount):
                guard dataCount == 0 else { return }
                DispatchQueue.main.async {
                    let labelIndexPath = IndexPath(item: indexPath.item - 1, section: 0)
                    //remove row with Storyteller component and it's label
                    self?.storytellerListsData.remove(atOffsets: [labelIndexPath.item, indexPath.item])
                    tableView.deleteRows(at: [labelIndexPath, indexPath], with: .none)
                }
            }
        }
        individualListDelegates[indexPath.item] = delegate
        return delegate
    }
}
