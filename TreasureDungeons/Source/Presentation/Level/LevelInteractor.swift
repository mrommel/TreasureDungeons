//
//  LevelInteractor.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 08.08.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

protocol LevelInteractorInput {
    func displayCurrentLevel()
}

protocol LevelInteractorOutput {
    //func found(player: Player?)
}

class LevelInteractor {
    
    var output: LevelInteractorOutput?
    //var dataManager: LevelDataManager?
}

extension LevelInteractor: LevelInteractorInput {
    
    func displayCurrentLevel() {
        //
    }

}
