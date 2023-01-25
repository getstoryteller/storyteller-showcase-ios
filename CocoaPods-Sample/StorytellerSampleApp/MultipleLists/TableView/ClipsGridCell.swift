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
        storytellerGrid.gridDelegate = nil
        storytellerGrid.prepareForReuse()
    }

    func bind(
        collectionId: String,
        cellType: StorytellerListViewCellType,
        delegate: StorytellerListDelegate,
        gridDelegate: StorytellerGridViewDelegate)
    {
        storytellerGrid.collectionId = collectionId
        storytellerGrid.delegate = delegate
        storytellerGrid.gridDelegate = gridDelegate
        storytellerGrid.cellType = cellType.rawValue
    }

    func reloadData() {
        storytellerGrid.reloadData()
    }

    // MARK: Private

    private var storytellerGrid = StorytellerClipsGridView()

    private func setupConstraints() {
        contentView.addSubview(storytellerGrid)

        storytellerGrid.translatesAutoresizingMaskIntoConstraints = false
        storytellerGrid.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        storytellerGrid.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        storytellerGrid.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        storytellerGrid.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
