//
//  LevelViewController.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 04.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import UIKit

class LevelViewController: UIViewController {
    
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
        
        guard let gameViewController = GameViewController.instantiateFromStoryboard("Main") else {
            let alert = UIAlertController(title: "Alert", message: "Cannot open GameViewController", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        map.tiles[2, 3] = Tile(at: Point(x: 2, y: 3), type: .floor)
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
        
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
}
