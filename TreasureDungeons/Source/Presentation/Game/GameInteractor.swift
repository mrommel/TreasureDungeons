//
//  GameInteractor.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 08.08.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

protocol GameInteractorInput {
    //func displayCurrentLevel()
}

protocol GameInteractorOutput {
    //func found(player: Player?)
}

class GameInteractor {
    
    var output: GameInteractorOutput?
    //var dataManager: GameDataManager?
}

extension GameInteractor: GameInteractorInput {

}
