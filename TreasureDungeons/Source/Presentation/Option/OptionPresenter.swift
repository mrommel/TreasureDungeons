//
//  OptionPresenter.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 28.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

class OptionPresenter {
    
    var userInterface: OptionViewInterface?
    var interactor: OptionInteractorInput?
    var wireframe: AppWireFrame?
}

extension OptionPresenter: OptionModuleInterface {
    
    func updateView() {
        self.interactor?.fetchPlayer()
    }
    
}

extension OptionPresenter: OptionInteractorOutput {
    
    func found(player: Player?) {
        
        if player != nil {
            self.userInterface?.showPlayer(player)
        } else {
            self.userInterface?.showNoPlayerMessage()
        }
    }

}
