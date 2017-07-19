//
//  OptionViewController.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 19.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

class OptionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = false
        
        PlayerProvider.sharedInstance.fetchPlayer(completionHandler: { (player, error) in
            
            if let player = player {
                print("player name: \(player.name) at level: \(player.level!)")
            } else {
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("no error")
                }
            }
        })
    }
}
