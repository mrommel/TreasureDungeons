//
//  OptionInteractor.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 28.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

protocol OptionInteractorInput {
    func fetchPlayer()
}

protocol OptionInteractorOutput {
    func found(player: Player?)
}

class OptionInteractor {
    
    var output: OptionInteractorOutput?
    var dataManager: OptionDataManager?
}

extension OptionInteractor: OptionInteractorInput {
    
    func fetchPlayer() {
        
        guard let dataManager = self.dataManager else {
            print("Fatal: dataManager not initialized")
            return
        }
        
        dataManager.playerItem(completionHandler: { (player, error) in
            
            guard let output = self.output else {
                print("Fatal: output not initialized")
                return
            }
            
            output.found(player: player)
        })
    }
}
