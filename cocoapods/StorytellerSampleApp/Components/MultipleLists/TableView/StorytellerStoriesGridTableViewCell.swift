import Foundation
import StorytellerSDK
import UIKit

final class StorytellerStoriesGridTableViewCell: UITableViewCell, StorytellerListViewDelegate {
    var actionHandler: (StorytellerCellAction) -> Void = { _ in }

    private lazy var headerView: StorytellerRowHeaderView = {
        let header = StorytellerRowHeaderView(frame: .zero)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var storytellerGridViewContainer: StorytellerStoriesGridView = {
        let view = StorytellerStoriesGridView(isScrollable: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var gridLeadingConstraint: NSLayoutConstraint!
    private var gridTrailingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(headerView)
        headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        contentView.addSubview(storytellerGridViewContainer)

        gridLeadingConstraint = storytellerGridViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        gridTrailingConstraint = storytellerGridViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        NSLayoutConstraint.activate([
            headerView.bottomAnchor.constraint(equalTo: storytellerGridViewContainer.topAnchor, constant: -18.0),
            storytellerGridViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            gridLeadingConstraint,
            gridTrailingConstraint,
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        storytellerGridViewContainer.delegate = nil
    }

    private var item: StorytellerItem?
    func configure(with item: StorytellerItem) {
        self.item = item
        storytellerGridViewContainer.delegate = self

        let singletonMode = item.layout == .singleton && item.tileType == .rectangular

        let config = StorytellerStoriesListConfiguration(
            categories: item.categories,
            cellType: item.tileType == .rectangular ? .square : .round,
            theme: StorytellerThemeManager.theme(for: item),
            displayLimit: singletonMode ? 1 : item.count
        )

        storytellerGridViewContainer.configuration = config

        headerView.configure(headerText: item.title, extraButtonText: item.moreButtonTitle)

        if singletonMode && traitCollection.horizontalSizeClass == .regular {
            let singletonPadding: CGFloat = 100
            gridLeadingConstraint.constant = singletonPadding
            gridTrailingConstraint.constant = -singletonPadding
        }

        if item.forceReload {
            storytellerGridViewContainer.reloadData()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        storytellerGridViewContainer.configuration.uiStyle = traitCollection.userInterfaceStyle.storytellerStyle
        layoutSubviews()
    }

    func onDataLoadComplete(success _: Bool, error _: Error?, dataCount _: Int) {
        actionHandler(.didForceReload(nil))
    }

    func onDataLoadStarted() {}
    func onPlayerDismissed() {}
}
