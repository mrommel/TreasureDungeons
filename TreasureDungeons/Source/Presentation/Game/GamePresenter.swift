//
//  GamePresenter.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 08.08.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

class GamePresenter {
    
    var userInterface: GameViewInterface?
    var interactor: GameInteractorInput?
    //var wireframe: AppWireFrame?
}

extension GamePresenter: GameModuleInterface {
    
    func updateView() {
        //self.interactor?.displayCurrentLevel()
    }
}

extension GamePresenter: GameInteractorOutput {
    
}
