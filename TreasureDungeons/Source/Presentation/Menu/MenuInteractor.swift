//
//  MenuInteractor.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 25.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

protocol MenuInteractorInput {
    func fetchGamePreviews()
}

protocol MenuInteractorOutput {
    func foundGamePreviews(_ gamePreviews: [GamePreview]?)
}

class MenuInteractor {
    
    var output: MenuInteractorOutput?
    var dataManager: MenuDataManager?
}

extension MenuInteractor: MenuInteractorInput {
    
    func fetchGamePreviews() {
        
        guard let dataManager = self.dataManager else {
            print("Fatal: dataManager not initialized")
            return
        }
        
        dataManager.gamePreviewItems(completionHandler: { (previews, error) in
            
            guard let output = self.output else {
                print("Fatal: output not initialized")
                return
            }
            
            output.foundGamePreviews(previews)
        })
    }
}
