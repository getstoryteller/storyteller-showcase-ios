//
//  MatchCenterView.swift
//  ShowcaseApp
//
//  Created by Sergiu Todirascu on 07.08.2024.
//

import SwiftUI
import StorytellerSDK

struct MatchCenterView: View {
    @State var storytellerModel: StorytellerStoriesListModel = {
        var theme = StorytellerTheme()

        theme.light.lists.grid.columns = 1
        theme.light.tiles.title.show = false
        theme.light.tiles.circularTile.unreadIndicatorColor = UIColor(hexString: "#C8102E")
        theme.light.tiles.circularTile.unreadBorderWidth = 3
        theme.dark = theme.light

        return StorytellerStoriesListModel(
            categories: ["live-stories"],
            cellType: .round,
            theme: theme,
            displayLimit: 1
        )
    }()

    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack(alignment: .center) {
            Image(.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
            StorytellerStoriesGrid(model: storytellerModel)
                .frame(width: 90, height: 90)
                .offset(y: -120)
        }
        .onReceive(timer, perform: { input in
            storytellerModel.reloadData()
        })
    }
}

#Preview {
    MatchCenterView()
}
