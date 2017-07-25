//
//  MenuDataManager.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 25.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

class MenuDataManager {
    
    //var coreDataStore : CoreDataStore?
    var gameProvider: GameProvider?
    
    func gamePreviewItems(completionHandler: @escaping GamesCompletionBlock) {
        self.gameProvider?.loadGamePreviewList(completionHandler: completionHandler)
    }
    
}
