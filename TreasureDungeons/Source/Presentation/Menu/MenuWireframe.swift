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

class MenuWireFrame {

    var menuPresenter : MenuPresenter?
    var rootWireframe : RootWireframe?
    var menuViewController : MenuViewController?
    
    func presentMenuInterfaceFromWindow(_ window: UIWindow) {
        let viewController = self.menuViewControllerFromStoryboard()
        viewController.eventHandler = menuPresenter
        self.menuViewController = viewController
        self.menuPresenter!.userInterface = viewController
        self.rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentGameInterface(withPreviews previews: [GamePreview]?) {
        guard let levelViewController = LevelViewController.instantiateFromStoryboard("Main") else {
            return
        }
        
        levelViewController.games = previews
        
        self.menuViewController?.present(levelViewController, animated: true)
    }
    
    func presentOptionInterface() {
        guard let optionViewController = OptionViewController.instantiateFromStoryboard("Main") else {
            return
        }
        
        self.menuViewController?.present(optionViewController, animated: true)
    }
    
    func presentHelpInterface() {
        guard let helpViewController = HelpViewController.instantiateFromStoryboard("Main") else {
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
