//
//  MenuViewController.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 03.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

protocol MenuModuleInterface {

    func updateView()
    
    func startLevels(withPreviews: [GamePreview]?)
    func startOptions()
    func startHelp()
}

protocol MenuViewInterface {
    
    func showNoGamePreviewsMessage()
    func showGamePreviews(_ data: [GamePreview]?)
}

class MenuViewController: UIViewController {
 
    @IBOutlet weak var startButton: UIButton!
    var games: [GamePreview]?
    var presenter: MenuModuleInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        
        self.startButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        
        self.presenter?.updateView()
    }
    
    @IBAction func startGame(sender: AnyObject) {
        
        self.presenter?.startLevels(withPreviews: self.games)
    }
    
    @IBAction func startOptions(sender: AnyObject) {
        
        self.presenter?.startOptions()
    }
    
    @IBAction func startHelp(sender: AnyObject) {
        
        self.presenter?.startHelp()
    }
}

extension MenuViewController: MenuViewInterface {
    
    func showGamePreviews(_ data: [GamePreview]?) {
        print("loaded list with \(data?.count ?? 0) items")
        
        DispatchQueue.main.async() {
            self.startButton.isEnabled = true // need to run on ui thread
        }
        self.games = data
    }

    func showNoGamePreviewsMessage() {
        print("showNoGamePreviewsMessage")
    }
}
