import SwiftUI
import StorytellerSDK

struct AccountView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: AccountViewModel
    @Binding var isShowing: Bool
    @State var showingAlert: Bool = false
    @State var userId: String = ""

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
            if !viewModel.personalisationAttributes.isEmpty {
                Section("Personalisation") {
                    ForEach(viewModel.allAttributes) { attribute in
                        let selectedItems = viewModel.personalisationAttributes[attribute] ?? Set<AttributeValue>()
                        if attribute.allowMultiple {
                            NavigationLink(destination: MultiSelectView(attribute: attribute, selectedItems: selectedItems, viewModel: viewModel)) {
                                AttributeLineItem(title: attribute.title, selectedValues: selectedItems)
                            }
                        } else {
                            NavigationLink(destination: SingleSelectView(attribute: attribute, selectedItem: selectedItems.first, viewModel: viewModel)) {
                                AttributeLineItem(title: attribute.title, selectedValues: selectedItems)
                            }
                        }
                    }
                }
            }
            Section("Analytics") {
                NavigationLink(destination: AnalyticsView(viewModel: viewModel.analyticsViewModel)) {
                    Text("User Privacy Preferences")
                }
            }

            Section("User") {
                HStack {
                    Text("User ID")
                    Spacer()
                    TextField("User ID", text: $userId) { focus in
                        if !focus, viewModel.userId != userId {
                            viewModel.userId = userId
                        }
                    }
                    .foregroundStyle(Color.secondary)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .onChange(of: viewModel.userId) { newValue in
                        userId = newValue
                    }
                }
            }

            Section("Settings") {
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
        .onAppear {
            userId = viewModel.userId
        }
    }
    
    func submit() {
        showingAlert = false
    }
}
