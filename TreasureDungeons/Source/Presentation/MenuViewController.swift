//
//  MenuViewController.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 03.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
 
    @IBOutlet weak var startButton: UIButton!
    let gameProvider: GameProvider = GameProvider()
    var games: [GamePreview]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        
        self.startButton.isEnabled = false
        
        self.gameProvider.loadGamePreviewList(completionHandler: { (list, error) in
            print("loaded list with \(list?.count ?? 0) items")
            self.startButton.isEnabled = true
            self.games = list
        })
    }
    
    @IBAction func startGame(sender: AnyObject) {
        
        guard let levelViewController = LevelViewController.instantiateFromStoryboard("Main") else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        levelViewController.games = self.games
        
        self.navigationController?.pushViewController(levelViewController, animated: true)
    }
}