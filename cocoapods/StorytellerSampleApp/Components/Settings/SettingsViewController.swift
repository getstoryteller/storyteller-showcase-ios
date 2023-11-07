import Foundation
import UIKit

final class SettingsViewController: UIViewController, CastView {
    // MARK: Lifecycle

    enum Action {
        case dismiss
    }

    var actionHandler: (Action) -> Void = { _ in }

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    typealias CastView = SettingsView

    override func loadView() {
        view = SettingsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        viewModel.handle(action: .getData)

        castView.languagePickerView.dataSource = self
        castView.languagePickerView.delegate = self
        castView.favoriteTeamPickerView.dataSource = self
        castView.favoriteTeamPickerView.delegate = self
        
        castView.resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
    }
    
    @objc
    func reset() {
        viewModel.handle(action: .reset)
        actionHandler(.dismiss)
    }

    // MARK: Private

    private let viewModel: SettingsViewModel
    
    private func bindViewModel() {
        viewModel.outputActionHandler = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .reload:
                DispatchQueue.main.async {
                    self.castView.languagePickerView.reloadAllComponents()
                    self.castView.favoriteTeamPickerView.reloadAllComponents()
                    
                    let selectedLanguageIndex = self.viewModel.availableLanguages.firstIndex { $0.value == self.viewModel.selectedLanguage }
                    if let selectedLanguageIndex = selectedLanguageIndex {
                        self.castView.languagePickerView.selectRow(selectedLanguageIndex, inComponent: 0, animated: false)
                    }
                    let selectedTeamIndex = self.viewModel.availableTeams.firstIndex { $0.value == self.viewModel.favoriteTeam }
                    if let selectedTeamIndex = selectedTeamIndex {
                        self.castView.favoriteTeamPickerView.selectRow(selectedTeamIndex, inComponent: 0, animated: false)
                    }
                }
            }
        }
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        if pickerView == castView.languagePickerView {
            return viewModel.availableLanguages.count
        }
        if pickerView == castView.favoriteTeamPickerView {
            return viewModel.availableTeams.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        if pickerView == castView.languagePickerView {
            return viewModel.availableLanguages[row].name
        }
        if pickerView == castView.favoriteTeamPickerView {
            return viewModel.availableTeams[row].name
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        if pickerView == castView.languagePickerView {
            viewModel.selectedLanguage = viewModel.availableLanguages[row].value
        }
        if pickerView == castView.favoriteTeamPickerView {
            viewModel.favoriteTeam = viewModel.availableTeams[row].value
        }
    }
}
