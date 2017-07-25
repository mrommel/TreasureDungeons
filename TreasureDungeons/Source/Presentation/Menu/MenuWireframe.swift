//
//  MenuWireframe.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 25.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

let MenuViewControllerIdentifier = "MenuViewController"

class MenuWireFrame : NSObject {

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
    
    /*func presentAddInterface() {
        addWireframe?.presentAddInterfaceFromViewController(listViewController!)
    }*/
    
    func menuViewControllerFromStoryboard() -> MenuViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: MenuViewControllerIdentifier) as! MenuViewController
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
    
}
