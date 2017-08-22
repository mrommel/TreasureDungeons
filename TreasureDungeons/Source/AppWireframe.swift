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

    var menuPresenter: MenuPresenter?
    var rootWireframe: RootWireframe?
    var menuViewController: MenuViewController?
    var levelViewController: LevelViewController?
    
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
        
        // Level
        let levelPresenter = LevelPresenter()
        //let levelDataManager = LevelDataManager()
        let levelInteractor = LevelInteractor()
        
        levelInteractor.output = levelPresenter
        //levelInteractor.dataManager = levelDataManager
        
        levelPresenter.interactor = levelInteractor
        levelPresenter.userInterface = levelViewController
        levelPresenter.wireframe = self
        
        //optionDataManager.coreDataStore = coreDataStore
        
        levelViewController.presenter = levelPresenter
        
        // backup
        self.levelViewController = levelViewController
        
        self.menuViewController?.navigationController?.pushViewController(levelViewController, animated: true)
    }
    
    func presentGameInterface(for game: NSInteger) {
        
        guard let gameViewController = GameViewController.instantiateFromStoryboard("Main") else {
            print("Fatal: can't create GameViewController from storyboard")
            return
        }
        
        // setup game
        var game = Game()
        
        let map = Map(width: 5, height: 7)
        
        map.tiles[0, 0] = Tile(at: Point(x: 0, y: 0), type: .wall)
        map.tiles[0, 1] = Tile(at: Point(x: 0, y: 1), type: .wall)
        map.tiles[0, 2] = Tile(at: Point(x: 0, y: 2), type: .wall)
        map.tiles[0, 3] = Tile(at: Point(x: 0, y: 3), type: .wall)
        map.tiles[0, 4] = Tile(at: Point(x: 0, y: 4), type: .wall)
        map.tiles[0, 5] = Tile(at: Point(x: 0, y: 5), type: .wall)
        map.tiles[0, 6] = Tile(at: Point(x: 0, y: 6), type: .wall)
        
        map.tiles[1, 0] = Tile(at: Point(x: 1, y: 0), type: .wall)
        map.tiles[1, 1] = Tile(at: Point(x: 1, y: 1), type: .floor)
        map.tiles[1, 2] = Tile(at: Point(x: 1, y: 2), type: .floor)
        map.tiles[1, 3] = Tile(at: Point(x: 1, y: 3), type: .floor)
        map.tiles[1, 4] = Tile(at: Point(x: 1, y: 4), type: .wall)
        map.tiles[1, 5] = Tile(at: Point(x: 1, y: 5), type: .floor)
        map.tiles[1, 6] = Tile(at: Point(x: 1, y: 6), type: .wall)
        
        map.tiles[2, 0] = Tile(at: Point(x: 2, y: 0), type: .floor)
        map.tiles[2, 1] = Tile(at: Point(x: 2, y: 1), type: .floor)
        map.tiles[2, 2] = Tile(at: Point(x: 2, y: 2), type: .floor)
        map.tiles[2, 3] = Tile(at: Point(x: 2, y: 3), type: .teleporter)
        map.tiles[2, 4] = Tile(at: Point(x: 2, y: 4), type: .floor)
        map.tiles[2, 5] = Tile(at: Point(x: 2, y: 5), type: .floor)
        map.tiles[2, 6] = Tile(at: Point(x: 2, y: 6), type: .wall)
        
        map.tiles[3, 0] = Tile(at: Point(x: 3, y: 0), type: .wall)
        map.tiles[3, 1] = Tile(at: Point(x: 3, y: 1), type: .floor)
        map.tiles[3, 2] = Tile(at: Point(x: 3, y: 2), type: .floor)
        map.tiles[3, 3] = Tile(at: Point(x: 3, y: 3), type: .floor)
        map.tiles[3, 4] = Tile(at: Point(x: 3, y: 4), type: .wall)
        map.tiles[3, 5] = Tile(at: Point(x: 3, y: 5), type: .floor)
        map.tiles[3, 6] = Tile(at: Point(x: 3, y: 6), type: .wall)
        
        map.tiles[4, 0] = Tile(at: Point(x: 4, y: 0), type: .wall)
        map.tiles[4, 1] = Tile(at: Point(x: 4, y: 1), type: .wall)
        map.tiles[4, 2] = Tile(at: Point(x: 4, y: 2), type: .wall)
        map.tiles[4, 3] = Tile(at: Point(x: 4, y: 3), type: .wall)
        map.tiles[4, 4] = Tile(at: Point(x: 4, y: 4), type: .wall)
        map.tiles[4, 5] = Tile(at: Point(x: 4, y: 5), type: .wall)
        map.tiles[4, 6] = Tile(at: Point(x: 4, y: 6), type: .wall)
        
        game.map = map
        
        gameViewController.game = game
        
        // Game
        let gamePresenter = GamePresenter()
        //let gameDataManager = GameDataManager()
        let gameInteractor = GameInteractor()
        
        gameInteractor.output = gamePresenter
        //gameInteractor.dataManager = gameDataManager
        
        gamePresenter.interactor = gameInteractor
        gamePresenter.userInterface = gameViewController
        //gamePresenter.wireframe = appWireframe
        
        //gameDataManager.coreDataStore = coreDataStore
        
        gameViewController.presenter = gamePresenter
        
        self.levelViewController?.navigationController?.pushViewController(gameViewController, animated: true)
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
        
        // Help
        let helpPresenter = HelpPresenter()
        let helpInteractor = HelpInteractor()
        let helpDataManager = HelpDataManager()
        
        helpInteractor.output = helpPresenter
        helpInteractor.dataManager = helpDataManager
        
        helpPresenter.interactor = helpInteractor
        helpPresenter.userInterface = helpViewController
        
        helpViewController.presenter = helpPresenter
        
        self.menuViewController?.navigationController?.pushViewController(helpViewController, animated: true)
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
