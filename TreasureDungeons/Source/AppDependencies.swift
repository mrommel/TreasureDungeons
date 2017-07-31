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
 
    var appWireframe = AppWireFrame()
    
    init() {
        configureDependencies()
    }
    
    func installRootViewControllerIntoWindow(_ window: UIWindow) {
        self.appWireframe.presentMenuInterfaceFromWindow(window)
    }
    
    func configureDependencies() {
        
        let rootWireframe = RootWireframe()
        let gameProvider = GameProvider()
        
        // Menu
        let menuPresenter = MenuPresenter()
        let menuDataManager = MenuDataManager()
        let menuInteractor = MenuInteractor()
        
        menuInteractor.output = menuPresenter
        menuInteractor.dataManager = menuDataManager
        
        menuPresenter.interactor = menuInteractor
        menuPresenter.wireframe = appWireframe
        
        appWireframe.menuPresenter = menuPresenter
        appWireframe.rootWireframe = rootWireframe
        
        menuDataManager.gameProvider = gameProvider
    }
    
}
