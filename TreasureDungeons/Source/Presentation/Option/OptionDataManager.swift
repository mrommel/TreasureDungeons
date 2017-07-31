//
//  OptionDataManager.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 31.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

class OptionDataManager {
    
    var coreDataStore : CoreDataStore?

    func playerItem(completionHandler: @escaping PlayerCompletionBlock) {
        
        self.coreDataStore?.fetchPlayer(completionHandler: { (player, error) in
            
            if let player = player {
                print("player name: \(player.name!) at level: \(player.level!)")
                completionHandler(player, nil)
            } else {
                if let error = error {
                    print("error: \(error)")
                    completionHandler(nil, error)
                } else {
                    print("no error")
                    completionHandler(nil, nil)
                }
            }
        })
    }
    
    
}
