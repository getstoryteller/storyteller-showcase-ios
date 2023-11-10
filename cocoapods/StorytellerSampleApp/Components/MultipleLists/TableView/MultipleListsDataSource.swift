import Foundation
import StorytellerSDK
import UIKit

enum StorytellerCellAction {
    case didForceReload(Int?)
}

// MARK: - MainDataSource

final class MultipleListsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    enum Action {
        case moreAction(StorytellerItem)
        case didForceReload(Int)
    }

    var actionHandler: (Action) -> Void = { _ in }
    var storytellerListsData: [StorytellerItem] = []

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storytellerListsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = storytellerListsData[indexPath.row]

        switch data.layout {
        case .row:
            switch data.videoType {
            case .stories:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: StorytellerStoriesRowTableViewCell.defaultCellReuseIdentifier,
                    for: indexPath
                ) as? StorytellerStoriesRowTableViewCell
                else {
                    fatalError("Proper cell was not found in UITableView")
                }

                cell.actionHandler = { [weak self] action in
                    switch action {
                    case .didForceReload:
                        if let data = self?.storytellerListsData[indexPath.row] {
                            data.forceReload = false
                            self?.storytellerListsData[indexPath.row] = data
                            self?.actionHandler(.didForceReload(indexPath.row))
                        }
                    }
                }

                cell.configure(with: data)

                return cell
            case .clips:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: StorytellerClipsRowTableViewCell.defaultCellReuseIdentifier,
                    for: indexPath
                ) as? StorytellerClipsRowTableViewCell
                else {
                    fatalError("Proper cell was not found in UITableView")
                }

                cell.actionHandler = { [weak self] action in
                    switch action {
                    case .didForceReload:
                        if let data = self?.storytellerListsData[indexPath.row] {
                            data.forceReload = false
                            self?.storytellerListsData[indexPath.row] = data
                            self?.actionHandler(.didForceReload(indexPath.row))
                        }
                    }
                }

                cell.configure(with: data)

                return cell
            }

        case .grid, .singleton:
            switch data.videoType {
            case .stories:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: StorytellerStoriesGridTableViewCell.defaultCellReuseIdentifier,
                    for: indexPath
                ) as? StorytellerStoriesGridTableViewCell
                else {
                    fatalError("Proper cell was not found in UITableView")
                }
                cell.actionHandler = { [weak self] action in
                    switch action {
                    case .didForceReload:
                        if let data = self?.storytellerListsData[indexPath.row] {
                            data.forceReload = false
                            self?.storytellerListsData[indexPath.row] = data
                            self?.actionHandler(.didForceReload(indexPath.row))
                        }
                    }
                }

                cell.configure(with: data)

                return cell
            case .clips:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: StorytellerClipsGridTableViewCell.defaultCellReuseIdentifier,
                    for: indexPath
                ) as? StorytellerClipsGridTableViewCell
                else {
                    fatalError("Proper cell was not found in UITableView")
                }

                cell.actionHandler = { [weak self] action in
                    switch action {
                    case .didForceReload:
                        if let data = self?.storytellerListsData[indexPath.row] {
                            data.forceReload = false
                            self?.storytellerListsData[indexPath.row] = data
                            self?.actionHandler(.didForceReload(indexPath.row))
                        }
                    }
                }

                cell.configure(with: data)

                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
