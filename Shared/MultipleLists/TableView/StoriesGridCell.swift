import Foundation
import StorytellerSDK
import UIKit

// MARK: - StorytellerGridTableViewCell

final class StoriesGridCell: UITableViewCell {
    // MARK: Lifecycle

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }

    // MARK: Internal

    override func prepareForReuse() {
        super.prepareForReuse()
        storytellerGrid.delegate = nil
        storytellerGrid.gridDelegate = nil
        storytellerGrid.prepareForReuse()
    }

    func bind(
        categories: [String],
        cellType: StorytellerListViewCellType,
        delegate: StorytellerListDelegate,
        gridDelegate: StorytellerGridViewDelegate)
    {
        storytellerGrid.categories = categories
        storytellerGrid.delegate = delegate
        storytellerGrid.cellType = cellType.rawValue
        storytellerGrid.gridDelegate = gridDelegate
        // Set custom theme for this view instead of using global one
        storytellerGrid.theme = StorytellerThemes.customTheme
    }

    func reloadData() {
        storytellerGrid.reloadData()
    }

    // MARK: Private

    private var storytellerGrid = StorytellerGridView()

    private func setupConstraints() {
        contentView.addSubview(storytellerGrid)

        storytellerGrid.layoutToEdges(of: contentView)
    }
}
