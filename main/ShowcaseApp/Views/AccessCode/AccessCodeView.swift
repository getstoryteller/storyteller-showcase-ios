import Combine
import SwiftUI

@MainActor
class AccessCodeViewModel: ObservableObject {
    @ObservedObject var dataService: DataGateway = DependencyContainer.shared.dataService
    @Published var code: String = ""
    @Published var verificationInProgress: Bool = false
    @Published var codeVerificationStatus: DataGateway.CodeVerificationStatus = .none
    var cancellables: Set<AnyCancellable> = []


    init() {
        dataService.$codeVerificationStatus
            .subscribe(on: RunLoop.main)
            .sink { [weak self] status in
                self?.codeVerificationStatus = status
                self?.verificationInProgress = false
            }
            .store(in: &cancellables)
    }

    func verifyCode() {
        verificationInProgress = true
        dataService.verifyCode(code)
    }
}

struct AccessCodeView: View {
    @StateObject var viewModel: AccessCodeViewModel

    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: 8.0) {
                LogoArea()
                    .padding(.bottom, 4.0)
                AccessCodeField(viewModel: viewModel)
                VerifyButton(viewModel: viewModel)
            }
            .padding()
            .background(Color(.AccessCode.background))
            .cornerRadius(4.0)
            .shadow(radius: 10)
        }
        .padding()
    }

    init() {
        _viewModel = StateObject(wrappedValue: AccessCodeViewModel())
    }
}

struct LogoArea: View {
    var body: some View {
        VStack {
            HStack {
                Image(.logoIcon)
                Image(.AccessCode.storyteller)
            }
            Text("Please enter your unique access code to proceed.")
                .font(.system(size: 17, weight: .regular))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 200)
    }
}

struct AccessCodeField: View {
    @ObservedObject var viewModel: AccessCodeViewModel
    @FocusState private var isCodeEntryFocused: Bool

    var body: some View {
        VStack {
            HStack {
                Image(.AccessCode.key)
                TextField("Enter Access Code", text: $viewModel.code)
                    .focused($isCodeEntryFocused)
                    .foregroundColor(Color(.AccessCode.inputText))
                    .textInputAutocapitalization(.characters)
            }
            .frame(height: 48)
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 4.0)
                    .stroke(borderColor, lineWidth: 1.0)
            )
            .background(Color(.AccessCode.inputFieldBackground))
            .cornerRadius(4.0)
            if viewModel.codeVerificationStatus == .incorrect {
                Label("The access code you entered is incorrect. Please double-check your code and try again.", systemImage: "exclamationmark.circle.fill")
                    .foregroundColor(Color(.activeRed))
                    .font(.system(size: 12, weight: .regular))
            }
        }
        .onAppear {
            // This has to be called after displaying the field
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isCodeEntryFocused = true
            }
        }
        .onChange(of: viewModel.code, perform: { value in
            viewModel.codeVerificationStatus = .none
        })
    }

    var borderColor: Color {
        switch viewModel.codeVerificationStatus {
        case .none: Color(.AccessCode.inputFieldBackground)
        case .verifying: Color(.AccessCode.activeBlue)
        case .incorrect: Color(.activeRed)
        }
    }
}

struct VerifyButton: View {
    @ObservedObject var viewModel: AccessCodeViewModel

    var body: some View {
        Button(
            action: { viewModel.verifyCode() },
            label: {
                if viewModel.verificationInProgress {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity)
                        .tint(.white)
                } else {
                    Text("Verify")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
            }
        )
        .frame(height: 48.0)
        .buttonStyle(.borderedProminent)
        .tint(Color(.AccessCode.activeBlue))
        .buttonBorderShape(.roundedRectangle(radius: 4.0))
    }
}
