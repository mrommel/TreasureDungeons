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
            
            DispatchQueue.main.async() {
                self.startButton.isEnabled = true // need to run on ui thread
            }
            self.games = list
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
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
    
    @IBAction func startOptions(sender: AnyObject) {
        print("options")
    }
    
    @IBAction func startHelp(sender: AnyObject) {
        print("help")
        
        guard let helpViewController = HelpViewController.instantiateFromStoryboard("Main") else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.navigationController?.pushViewController(helpViewController, animated: true)
    }
}
