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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Test"
    }
    
    
    @IBAction func startGame(sender: AnyObject) {
        
        guard let mapViewController = GameViewController.instantiateFromStoryboard("Main") else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
}
