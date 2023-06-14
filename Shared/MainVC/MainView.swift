import StorytellerSDK
import UIKit
import WebKit

final class MainView: UIView {
    // MARK: Lifecycle

    enum Action {
        case changeUserTap
        case storyboardExampleTap
        case googleAdsIntergationTap
        case multipleListsTap
        case swiftUITap(cellType: StorytellerListViewCellType, delegate: StorytellerListDelegate?)
        case embeddedClipsTap
    }

    var actionHandler: (Action) -> Void = { _ in }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    let refresher = UIRefreshControl()

    func setupView(with elements: [MainViewElement]) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        elements.forEach { element in
            switch element {
            case .label(let text):
                addLabel(text: text)
            case let .storyRow(cellType, height, delegate):
                addStorytellerRow(cellType: cellType, height: height, delegate: delegate)
            case .changeUserButton:
                addChangeUserButton()
            case .multipleListsButton:
                addMultipleListsButton()
            case .storyboardExampleButton:
                addStoryboardExampleButton()
            case .googleAdsIntegrationButton:
                addGoogleAdsIntegrationButton()
            case let .swiftUIButton(cellType, delegate):
                addSwiftUIButton(cellType: cellType, delegate: delegate)
            case let .embeddedClipsButton:
                addEmbeddedClipsButton()
            }
        }
        stackView.addArrangedSubview(UIView())
    }

    func reload() {
        stackView.arrangedSubviews.forEach {
            ($0 as? StorytellerListView)?.reloadData()
        }
    }

    func finishRefreshing() {
        DispatchQueue.main.async {
            self.refresher.endRefreshing()
        }
    }

    // MARK: Private

    private func addLabel(text: String) {
        let label = UILabel()
        label.text = text
        stackView.addArrangedSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8).isActive = true
    }

    private func addStorytellerRow(cellType: StorytellerListViewCellType, height: CGFloat?, delegate: StorytellerListDelegate) {
        let row = StorytellerStoriesRowView()

        // Set thumbnail shape.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view#Attributes
        row.cellType = cellType

        // Set delegate to use.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view-delegate#HowToUse
        row.delegate = delegate

        row.translatesAutoresizingMaskIntoConstraints = false
        if let height = height {
            row.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        stackView.addArrangedSubview(row)
        stackView.setCustomSpacing(24, after: row)
        row.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }

    private func addChangeUserButton() {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Change User", for: .normal)
        button.addTarget(self, action: #selector(didTapChangeUser), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }

    private func addMultipleListsButton() {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Multiple Lists", for: .normal)
        button.addTarget(self, action: #selector(didTapMultipleLists), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }

    private func addStoryboardExampleButton() {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Storyboard Example", for: .normal)
        button.addTarget(self, action: #selector(didTapStoryboardExample), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }

    private func addGoogleAdsIntegrationButton() {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Google Ads Integration", for: .normal)
        button.addTarget(self, action: #selector(didTapGoogleAdsIntegrationExample), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }

    private func addSwiftUIButton(cellType: StorytellerListViewCellType, delegate: StorytellerListDelegate?) {
        let button = SubclassedUIButton()
        button.cellType = cellType
        button.delegate = delegate
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("SwiftUI", for: .normal)
        button.addTarget(self, action: #selector(didTapSwiftUI), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }
    
    private func addEmbeddedClipsButton() {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Embedded Clips", for: .normal)
        button.addTarget(self, action: #selector(didTapEmbeddedClips), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }

    @objc private func didTapChangeUser() {
        actionHandler(.changeUserTap)
    }

    @objc private func didTapMultipleLists() {
        actionHandler(.multipleListsTap)
    }

    @objc private func didTapStoryboardExample() {
        actionHandler(.storyboardExampleTap)
    }

    @objc private func didTapGoogleAdsIntegrationExample() {
        actionHandler(.googleAdsIntergationTap)
    }

    @objc private func didTapSwiftUI(sender: SubclassedUIButton) {
        guard let cellType = sender.cellType, let delegate = sender.delegate else { return }
        actionHandler(.swiftUITap(cellType: cellType, delegate: delegate))
    }
    
    @objc private func didTapEmbeddedClips() {
        actionHandler(.embeddedClipsTap)
    }

    private func setupView() {
        var backgroundColor = UIColor.white
        if #available(iOS 13.0, *) {
            backgroundColor = traitCollection.userInterfaceStyle == .light ? .white : .black
        }
        self.backgroundColor = backgroundColor

        addSubview(scrollView)
        scrollView.layoutToEdges(of: self)

        scrollView.addSubview(stackView)
        stackView.layoutToEdges(of: scrollView)

        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        scrollView.refreshControl = refresher
    }
}

class SubclassedUIButton: UIButton {
    var cellType: StorytellerListViewCellType?
    weak var delegate: StorytellerListDelegate?
}
