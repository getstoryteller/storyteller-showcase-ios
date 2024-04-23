import StorytellerSDK
import SwiftUI

struct AnalyticsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: AnalyticsViewModel

    var body: some View {
        List {
            Section("Tracking options") {
                Toggle("Allow personalization", isOn: $viewModel.enablePersonalization)
                Toggle("Allow storyteller tracking", isOn: $viewModel.enableStorytellerTracking)
                Toggle("Allow user activity tracking", isOn: $viewModel.enableUserActivityTracking)
            }
        }
        .navigationTitle("Analytics")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.latestTabEvent.send(true)
        }
    }
}
