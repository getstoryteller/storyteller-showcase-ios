import Foundation
import StorytellerSDK
import UIKit

final class LabelCell: UITableViewCell {
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

    func bind(text: String) {
        label.text = text
    }

    // MARK: Private

    private let label = UILabel()

    private func setupConstraints() {
        contentView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true
    }
}
