import Foundation
import StorytellerSDK
import UIKit

final class ClipsGridCell: UITableViewCell {
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
        collectionId: String,
        cellType: StorytellerListViewCellType,
        delegate: StorytellerListDelegate)
    {
        storytellerGrid.collectionId = collectionId
        storytellerGrid.delegate = delegate
        storytellerGrid.cellType = cellType
    }

    func reloadData() {
        storytellerGrid.reloadData()
    }

    // MARK: Private

    private var storytellerGrid = StorytellerClipsGridView(isScrollable: false)

    private func setupConstraints() {
        contentView.addSubview(storytellerGrid)

        storytellerGrid.layoutToEdges(of: contentView)
    }
}
