//
//  DeeplinkPreviewController.swift
//  StorytellerSampleApp
//
//  Created by Michał Januszewski on 10.02.2021
//  Copyright © 2021 Storm Ideas. All rights reserved.
//

import UIKit
import StorytellerSDK

class DeeplinkPreviewController: UIViewController {
    var deeplinkUrl: String?

    @IBOutlet weak var deeplinkLabel: UILabel!

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        deeplinkLabel.text = deeplinkUrl
    }
}
