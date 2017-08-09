//
//  HelpViewController.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 04.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

protocol HelpModuleInterface {
    
    func updateView()
}

protocol HelpViewInterface {

    func show(content: String)
}

class HelpViewController: UIViewController {
    
    // VIPER
    var presenter: HelpModuleInterface?
    
    @IBOutlet weak var contentWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter?.updateView()
        
        navigationController?.hidesBarsOnSwipe = false
    }
}

extension HelpViewController: HelpViewInterface {
    
    func show(content: String) {
        self.contentWebView.loadHTMLString(content, baseURL: nil)
    }
}
