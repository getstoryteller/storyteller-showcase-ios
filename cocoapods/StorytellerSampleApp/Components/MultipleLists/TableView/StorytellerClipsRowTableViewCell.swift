import Foundation
import StorytellerSDK
import UIKit

final class StorytellerClipsRowTableViewCell: UITableViewCell, StorytellerListViewDelegate {
    var actionHandler: (StorytellerCellAction) -> Void = { _ in }

    private lazy var headerView: StorytellerRowHeaderView = {
        let header = StorytellerRowHeaderView(frame: .zero)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var storytellerRowViewContainer: StorytellerClipsRowView = {
        let view = StorytellerClipsRowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView, storytellerRowViewContainer])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 18.0
        return stackView
    }()

    private var rowHeightConstraint: NSLayoutConstraint!
    private var stackViewBottomAnchorConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        stackViewBottomAnchorConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: TableViewConstants.roundBottomPadding)

        rowHeightConstraint = storytellerRowViewContainer.heightAnchor.constraint(equalToConstant: TableViewConstants.rowRoundHeight).priority(.defaultHigh)

        NSLayoutConstraint.activate([
            stackViewBottomAnchorConstraint,
            rowHeightConstraint,
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        storytellerRowViewContainer.delegate = nil
        item = nil
    }

    private var item: StorytellerItem?

    func configure(with item: StorytellerItem) {
        self.item = item
        storytellerRowViewContainer.delegate = self

        let config = StorytellerClipsListConfiguration(
            collectionId: item.collection,
            cellType: item.tileType == .rectangular ? .square : .round,
            theme: StorytellerThemeManager.theme(for: item),
            displayLimit: item.count
        )

        storytellerRowViewContainer.configuration = config

        switch item.tileType {
        case .round:
            rowHeightConstraint.constant = TableViewConstants.rowRoundHeight
            stackViewBottomAnchorConstraint.constant = TableViewConstants.roundBottomPadding
        case .rectangular:
            rowHeightConstraint.constant = TableViewConstants.rowSquareHeight
            stackViewBottomAnchorConstraint.constant = TableViewConstants.squareBottomPadding
            switch item.size {
            case .regular:
                break
            case .medium:
                rowHeightConstraint.constant *= 1.5
            case .large:
                rowHeightConstraint.constant *= 2
            }
        }

        headerView.configure(headerText: item.title, extraButtonText: item.moreButtonTitle)

        if item.forceReload {
            storytellerRowViewContainer.reloadData()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        storytellerRowViewContainer.configuration.uiStyle = traitCollection.userInterfaceStyle.storytellerStyle
    }

    func onDataLoadComplete(success _: Bool, error _: Error?, dataCount _: Int) {
        actionHandler(.didForceReload(nil))
    }

    func onDataLoadStarted() {}
    func onPlayerDismissed() {}
}
