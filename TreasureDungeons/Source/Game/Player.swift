//
//  Player.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 13.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/*!
    class to store all properties of the current player
*/
class Player: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var level: NSNumber?
    
    func hasWon(newlevel: Int) {
        if let level = self.level {
            self.level = max(level.intValue, newlevel) as NSNumber
        }
    }
    
    func reset() {
        self.name = "default"
        self.level = 0
    }
}

typealias PlayerCompletionBlock = (_ player: Player?, _ error: Error?) -> Void

class PlayerDataManager {
    
    var coreDataStore: CoreDataStore?
    
    func fetchPlayer(completionHandler: @escaping PlayerCompletionBlock) {
        
        let context = coreDataStore?.managedObjectContext
        
        do {
            let players = try context!.fetch(Player.fetchRequest()) as? [Player]
            
            if players != nil && (players?.count)! > 0 {
                completionHandler(players?.first, nil)
            } else {
                // load default
                let player = Player(context: context!)
                player.reset()
                
                // Save the data to coredata
                coreDataStore?.save()
                
                completionHandler(player, nil)
            }
        } catch {
            print("Fetching failed - loading default")
            print("error during read player from db: \(error)")
            
            completionHandler(nil, error)
        }
    }
 
}
