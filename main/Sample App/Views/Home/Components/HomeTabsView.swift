import SwiftUI

class HomeTabsViewModel: ObservableObject {
    let tabBarOptions: [String]
    let tabHandler: Binding<Int>
    
    init(tabs: [String], tabChangeHandler: Binding<Int>) {
        self.tabBarOptions = tabs
        self.tabHandler = tabChangeHandler
    }
}

struct HomeTabsView: View {
    @ObservedObject var viewModel: HomeTabsViewModel
    @Namespace var namespace
    
    init(tabs: [String], tabChangeHandler: Binding<Int>) {
        self._viewModel = ObservedObject(wrappedValue: HomeTabsViewModel(tabs: tabs, tabChangeHandler: tabChangeHandler))
    }
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Array(zip(self.viewModel.tabBarOptions.indices, self.viewModel.tabBarOptions)),
                            id: \.0,
                            content: {
                        index, name in
                        TabBarItem(currentTab: self.viewModel.tabHandler, namespace: namespace.self, tabBarItemName: name, tab: index)
                    })
                }
                .padding(.horizontal)
            }
            .edgesIgnoringSafeArea(.all)
            .onChange(of: viewModel.tabHandler.wrappedValue) { _, tapped in
                withAnimation {
                    value.scrollTo(tapped, anchor: .leading)
                }
            }
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
            self.currentTab = tab
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
