import StorytellerSDK
import UIKit

final class SettingsView: UIView {
    // MARK: Lifecycle

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.text = "Language:"
        return label
    }()

    let languagePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private lazy var favoriteTeamLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorite Team:"
        return label
    }()
    
    let favoriteTeamPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()

    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        return button
    }()

    // MARK: Private

    private func setupView() {
        backgroundColor = traitCollection.userInterfaceStyle == .light ? .white : .black

        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        stackView.addArrangedSubview(languageLabel)
        stackView.addArrangedSubview(languagePickerView)
        stackView.addArrangedSubview(favoriteTeamLabel)
        stackView.addArrangedSubview(favoriteTeamPickerView)
        stackView.addArrangedSubview(resetButton)
        stackView.addArrangedSubview(UIView())
    }
}
