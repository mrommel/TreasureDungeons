//
//  LevelViewController.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 04.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

protocol LevelModuleInterface {
    
    func updateView()
    
    func start(game: NSInteger)
}

protocol LevelViewInterface {
    
    //func showNoPlayerMessage()
    //func showPlayer(_ player: Player?)
}

class LevelViewController: UIViewController {
    
    // VIPER
    var presenter: LevelModuleInterface?
    
    var scrollView: UIScrollView?
    let buttonImage = UIImage(named: "bubble_blue") as UIImage?
    var games: [GamePreview]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Levels"
        
        if let previews = self.games {
            for gamePreview in previews {
                self.createGameButton(for: gamePreview)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter?.updateView()
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func createGameButton(for preview: GamePreview) {
        
        let x = CGFloat(preview.x!)
        let y = CGFloat(preview.y!)
        
        let button = UIButton(type: .custom)
        button.setTitle("\(preview.identifier ?? 0)", for: .normal)
        button.tag = preview.identifier!
        button.setTitleColor(UIColor.white, for: .normal)
        button.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: 42, height: 42))
        button.setBackgroundImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(LevelViewController.buttonPressed), for: .touchUpInside)
        
        self.scrollView?.addSubview(button)
    }
    
    func buttonPressed(sender: UIButton!) {
        print("pressed game: \(sender.tag)")
        
        self.presenter?.start(game: sender.tag)
    }
}

extension LevelViewController: LevelViewInterface {
}
