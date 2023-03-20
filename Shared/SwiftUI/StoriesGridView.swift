//
//  StoriesGridView.swift
//  StorytellerSampleApp
//
//  Created by Michał on 20/03/2023.
//  Copyright © 2023 Storm Ideas. All rights reserved.
//

import Foundation
import SwiftUI
import StorytellerSDK
import Combine

struct StoriesGridView: UIViewRepresentable, StorytellerCallbackable {
    var reloadDataSubject: PassthroughSubject<Void, Never>
    let callback: (StorytellerCallbackAction) -> Void
    @State var cancellable: AnyCancellable? = nil
  
    func makeUIView(context: Context) -> StorytellerGridView {
        let view = StorytellerGridView()
        view.delegate = context.coordinator
        view.gridDelegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: StorytellerGridView, context: Context) {
        DispatchQueue.main.async {
            self.cancellable = reloadDataSubject.sink { text in
                uiView.reloadData()
            }
        }
        uiView.reloadData()
    }
    
    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }
}
