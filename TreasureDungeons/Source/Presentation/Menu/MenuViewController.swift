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
}

protocol MenuViewInterface {
    
    func showNoGamePreviewsMessage()
    func showGamePreviews(_ data: [GamePreview]?)
}

class MenuViewController: UIViewController {
 
    @IBOutlet weak var startButton: UIButton!
    var games: [GamePreview]?
    
    //var interactor: MenuInteractor?
    //var presenter: MenuPresenter?
    var eventHandler: MenuModuleInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        
        self.startButton.isEnabled = false
        
        /*self.gameProvider.loadGamePreviewList(completionHandler: { (list, error) in
            print("loaded list with \(list?.count ?? 0) items")
            
            DispatchQueue.main.async() {
                self.startButton.isEnabled = true // need to run on ui thread
            }
            self.games = list
        })*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        
        self.eventHandler?.updateView()
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
        
        guard let optionViewController = OptionViewController.instantiateFromStoryboard("Main") else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.navigationController?.pushViewController(optionViewController, animated: true)
    }
    
    @IBAction func startHelp(sender: AnyObject) {
        
        guard let helpViewController = HelpViewController.instantiateFromStoryboard("Main") else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.navigationController?.pushViewController(helpViewController, animated: true)
    }
}

extension MenuViewController: MenuViewInterface {
    
    func showGamePreviews(_ data: [GamePreview]?) {
        print("showGamePreviews")
    }

    func showNoGamePreviewsMessage() {
        print("showNoGamePreviewsMessage")
    }
}
