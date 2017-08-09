//
//  LevelPresenter.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 08.08.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

class LevelPresenter {
    
    var userInterface: LevelViewInterface?
    var interactor: LevelInteractorInput?
    var wireframe: AppWireFrame?
}

extension LevelPresenter: LevelModuleInterface {
    
    func updateView() {
        self.interactor?.displayCurrentLevel()
    }
    
    func start(game: NSInteger) {
        self.wireframe?.presentGameInterface(for: game)
    }
}

extension LevelPresenter: LevelInteractorOutput {

}
