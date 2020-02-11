//
//  ViewController.swift
//  StorytellerSampleApp
//
//  Created by Jason Xie on 11/02/2020.
//  Copyright © 2020 Storm Ideas. All rights reserved.
//

import UIKit
import Storyteller

class ViewController: UIViewController {

    @IBOutlet weak var storytellerRowView: StorytellerRowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        storytellerRowView.reloadData()
    }
}

