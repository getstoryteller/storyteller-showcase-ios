import SwiftUI
import StorytellerSDK

struct AccountView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: AccountViewModel
    @Binding var isShowing: Bool
    @State var showingAlert: Bool = false
    
    // This view demonstrates how to pass User Attributes to the Storyteller SDK
    // for the purposes of personalization and targeting of stories.
    // The corresponding code which interacts with the Storyteller SDK is
    // visible in the StorytellerService class.
    // There is more information available about this feature in our
    // documentation here https://www.getstoryteller.com/documentation/ios/custom-attributes
    
    // The code here also shows to enable and disable event tracking for
    // the Storyteller SDK. The corresponding code which interacts with the
    // Storyteller SDK is visible in the StorytellerService class.
    var body: some View {
        List {
            Section("Personalisation") {
                if !viewModel.favoriteTeams.isEmpty {
                    Picker("Favorite Teams", selection: $viewModel.favoriteTeam) {
                        Text("Not Set").tag("")
                        ForEach(viewModel.favoriteTeams) { team in
                            Text(team.name).tag(team.value)
                        }
                    }.pickerStyle(NavigationLinkPickerStyle())
                }
                if !viewModel.languages.isEmpty {
                    Picker("Language", selection: $viewModel.language) {
                        Text("Not Set").tag("")
                        ForEach(viewModel.languages) { language in
                            Text(language.name).tag(language.value)
                        }
                    }.pickerStyle(NavigationLinkPickerStyle())
                }
                Toggle("Has Account", isOn: $viewModel.hasAccount)
            }
            Section("Settings") {
                Toggle("Allow Event Tracking", isOn: $viewModel.allowEventTracking)
                Button("Reset") {
                    viewModel.resetUser()
                    showingAlert = true
                }.tint(colorScheme == .dark ? .white : .black)
                Button("Log Out") {
                    isShowing = false
                    viewModel.logout()
                }
                .tint(Color(.activeRed))
            }
            Section("App Info") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(verbatim: AppVersionProvider.appVersion())
                }
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset completed!", isPresented: $showingAlert) {
            Button("OK", action: submit)
        }
    }
    
    func submit() {
        showingAlert = false
    }
}
