//
//  HelpPresenter.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 09.08.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

class HelpPresenter {
    
    var userInterface: HelpViewInterface?
    var interactor: HelpInteractorInput?
    //var wireframe: AppWireFrame?
    
}

extension HelpPresenter: HelpModuleInterface {
    
    func updateView() {
        self.interactor?.fetchHelpContent()
    }
}

extension HelpPresenter: HelpInteractorOutput {
    
    func fetchedHelp(content: String) {
        self.userInterface?.show(content: content)
    }
}
