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
    }

    func bind(
        categories: [String],
        cellType: StorytellerListViewCellType,
        delegate: StorytellerListDelegate)
    {
        // Set custom theme for this view instead of using global one
        let configuration = StorytellerStoriesListConfiguration(categories: categories, cellType: cellType, theme: StorytellerThemes.customTheme)
        storytellerGrid.configuration = configuration
        storytellerGrid.delegate = delegate
    }

    func reloadData() {
        storytellerGrid.reloadData()
    }

    // MARK: Private

    private var storytellerGrid = StorytellerStoriesGridView(isScrollable: false)

    private func setupConstraints() {
        contentView.addSubview(storytellerGrid)

        storytellerGrid.layoutToEdges(of: contentView)
    }
}
