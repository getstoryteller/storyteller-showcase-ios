import SwiftUI

class HomeTabsViewModel: ObservableObject {
    let tabBarOptions: [String]
    let selectedTab: Binding<Int>

    var selectedTabName: String {
        tabBarOptions.isEmpty ? "Home" : tabBarOptions[selectedTab.wrappedValue]
    }

    init(tabs: [String], selectedTab: Binding<Int>) {
        self.tabBarOptions = tabs
        self.selectedTab = selectedTab
    }
}

struct HomeTabsView: View {
    @ObservedObject var viewModel: HomeTabsViewModel
    @Binding var currentTabOnComplete: Int
    @Namespace var namespace
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(zip(self.viewModel.tabBarOptions.indices, self.viewModel.tabBarOptions)),
                            id: \.0,
                            content: {
                        index, name in
                        TabBarItem(currentTab: self.viewModel.selectedTab, namespace: namespace.self, tabBarItemName: name, tab: index)
                            .padding(.horizontal, 10)
                    })
                }
            }
            .onAppear(perform: {
                StorytellerInstanceDelegate.currentLocation = viewModel.selectedTabName
            })
            .onChange(of: viewModel.selectedTab.wrappedValue, perform: { tapped in
                StorytellerInstanceDelegate.currentLocation = viewModel.selectedTabName

                Task {
                    withAnimation {
                        let tapped = max(tapped - 1, 0)
                        withAnimation(.easeInOut(duration: 0.35)) {
                            value.scrollTo(tapped, anchor: .leading)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation {
                                    self.currentTabOnComplete = viewModel.selectedTab.wrappedValue
                                }
                            }
                        }
                    }
                }
            })
        }
    }
}

struct TabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            withAnimation(.spring) {
                self.currentTab = tab
            }
        } label: {
            VStack(spacing: 5) {
                Text(tabBarItemName)
                    .foregroundColor(.primary)
                    .font(.custom("SFProText-Semibold", size: 16))
                    .padding(.top, 12)
                if currentTab == tab {
                    Color.yellow
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
