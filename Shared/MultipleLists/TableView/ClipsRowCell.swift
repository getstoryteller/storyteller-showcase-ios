import Foundation
import StorytellerSDK
import UIKit

final class ClipsRowCell: UITableViewCell {
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
        storytellerClipRow.delegate = nil
        storytellerClipRow.prepareForReuse()
    }

    func bind(
        index: Int,
        collectionId: String,
        cellType: StorytellerListViewCellType,
        height: CGFloat,
        delegate: StorytellerListDelegate)
    {
        storytellerClipRow.collectionId = collectionId
        storytellerClipRow.delegate = delegate
        storytellerClipRow.cellType = cellType.rawValue
        rowHeightConstraint?.constant = height
        storytellerClipRow.reloadData()
    }

    // MARK: Private

    private var storytellerClipRow = StorytellerClipsRowView()

    private var rowHeightConstraint: NSLayoutConstraint?

    private func setupConstraints() {
        contentView.addSubview(storytellerClipRow)

        storytellerClipRow.layoutToEdges(of: contentView)
        rowHeightConstraint = storytellerClipRow.heightAnchor.constraint(equalToConstant: 0)
        rowHeightConstraint?.isActive = true
    }
}
