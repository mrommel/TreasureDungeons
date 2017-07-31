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
