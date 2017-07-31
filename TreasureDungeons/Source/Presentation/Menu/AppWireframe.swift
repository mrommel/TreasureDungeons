//
//  MenuWireframe.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 25.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

let kMenuViewControllerIdentifier = "MenuViewController"

class AppWireFrame {

    var menuPresenter : MenuPresenter?
    var rootWireframe : RootWireframe?
    var menuViewController : MenuViewController?
    
    func presentMenuInterfaceFromWindow(_ window: UIWindow) {
        let viewController = self.menuViewControllerFromStoryboard()
        viewController.presenter = menuPresenter
        self.menuViewController = viewController
        self.menuPresenter!.userInterface = viewController
        self.rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentLevelsInterface(withPreviews previews: [GamePreview]?) {
        
        guard let levelViewController = LevelViewController.instantiateFromStoryboard("Main") else {
            print("Fatal: can't create LevelViewController from storyboard")
            return
        }
        
        levelViewController.games = previews
        
        self.menuViewController?.present(levelViewController, animated: true)
    }
    
    func presentGameInterface() {
        
    }
    
    func presentOptionInterface() {
        
        guard let optionViewController = OptionViewController.instantiateFromStoryboard("Main") else {
            print("Fatal: can't create OptionViewController from storyboard")
            return
        }
        
        let coreDataStore = CoreDataStore()
        
        // Options
        let optionPresenter = OptionPresenter()
        let optionDataManager = OptionDataManager()
        let optionInteractor = OptionInteractor()
        
        optionInteractor.output = optionPresenter
        optionInteractor.dataManager = optionDataManager
        
        optionPresenter.interactor = optionInteractor
        optionPresenter.userInterface = optionViewController
        //optionPresenter.wireframe = appWireframe
        
        optionDataManager.coreDataStore = coreDataStore
        
        optionViewController.presenter = optionPresenter
        
        //self.menuViewController?.present(optionViewController, animated: true)
        self.menuViewController?.navigationController?.pushViewController(optionViewController, animated: true)
    }
    
    func presentHelpInterface() {
        
        guard let helpViewController = HelpViewController.instantiateFromStoryboard("Main") else {
            print("Fatal: can't create HelpViewController from storyboard")
            return
        }
         
        self.menuViewController?.present(helpViewController, animated: true)
    }
    
    private func menuViewControllerFromStoryboard() -> MenuViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: kMenuViewControllerIdentifier) as! MenuViewController
        return viewController
    }
    
    private func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
}
