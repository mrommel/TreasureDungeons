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
        
        self.dataManager?.gamePreviewItems(completionHandler: { (previews, error) in
            self.output?.foundGamePreviews(previews)
        })
    }
}
