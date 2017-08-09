//
//  HelpInteractor.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 09.08.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

protocol HelpInteractorInput {
    
    func fetchHelpContent()
    
}

protocol HelpInteractorOutput {
    
    func fetchedHelp(content: String)
    
}

class HelpInteractor {
    
    var output: HelpInteractorOutput?
    var dataManager: HelpDataManagerOutput?
}

extension HelpInteractor: HelpInteractorInput {
    
    func fetchHelpContent() {
        
        self.dataManager?.loadHelp(completionHandler: { (content, error) in
        
            guard error == nil else {
                self.output?.fetchedHelp(content: "Error")
                return
            }
            
            if let content = content {
                self.output?.fetchedHelp(content: content)
            } else {
                self.output?.fetchedHelp(content: "Error")
            }
        })
    }

    
}
