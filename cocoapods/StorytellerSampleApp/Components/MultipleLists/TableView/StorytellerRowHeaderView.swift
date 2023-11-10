import StorytellerSDK
import UIKit

final class StorytellerRowHeaderView: UIView {

    // MARK: - Subviews

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var headerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 16.0, leading: 16.0, bottom: 0.0, trailing: 16.0)
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8.0
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(headerView)
        headerView.layoutToEdges(of: self)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(headerText: String?, extraButtonText: String?) {
        headerLabel.text = headerText

        isHidden = headerText?.isEmpty ?? true
    }
}
