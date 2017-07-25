//
//  AppDependencies.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 25.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

class AppDependencies {
 
    var menuWireframe = MenuWireFrame()
    
    init() {
        configureDependencies()
    }
    
    func installRootViewControllerIntoWindow(_ window: UIWindow) {
        self.menuWireframe.presentMenuInterfaceFromWindow(window)
    }
    
    func configureDependencies() {
        
        let coreDataStore = CoreDataStore()
        let rootWireframe = RootWireframe()
        let gameProvider = GameProvider()
        
        let menuPresenter = MenuPresenter()
        let menuDataManager = MenuDataManager()
        let menuInteractor = MenuInteractor()
        
        menuInteractor.output = menuPresenter
        menuInteractor.dataManager = menuDataManager
        
        menuPresenter.interactor = menuInteractor
        menuPresenter.wireframe = menuWireframe
        
        menuWireframe.menuPresenter = menuPresenter
        menuWireframe.rootWireframe = rootWireframe
        
        menuDataManager.gameProvider = gameProvider

    }
    
}
