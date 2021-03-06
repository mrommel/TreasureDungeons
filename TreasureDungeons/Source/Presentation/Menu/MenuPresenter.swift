//
//  MenuPresenter.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 25.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

class MenuPresenter {
    
    var userInterface: MenuViewInterface?
    var interactor: MenuInteractorInput?
    var wireframe: AppWireFrame?
}

extension MenuPresenter: MenuModuleInterface {
    
    func startLevels(withPreviews previews: [GamePreview]?) {
        self.wireframe?.presentLevelsInterface(withPreviews: previews)
    }
    
    func startOptions() {
        self.wireframe?.presentOptionInterface()
    }
    
    func startHelp() {
        self.wireframe?.presentHelpInterface()
    }

    func updateView() {
        self.interactor?.fetchGamePreviews()
    }
}

extension MenuPresenter: MenuInteractorOutput {
    
    func foundGamePreviews(_ gamePreviews: [GamePreview]?) {
        if gamePreviews?.count == 0 {
            userInterface?.showNoGamePreviewsMessage()
        } else {
            userInterface?.showGamePreviews(gamePreviews)
        }
    }
}
