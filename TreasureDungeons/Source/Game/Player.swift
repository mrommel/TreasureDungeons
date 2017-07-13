//
//  Player.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 13.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import JSONCodable

/*!
    class to store all properties of the current player
*/
struct Player {
    
    var name: String?
    var level: Int = 0
    
    init() {
        self.name = "default"
        self.level = 0
    }
    
    mutating func hasWon(newlevel: Int) {
        self.level = max(self.level, newlevel)
    }
    
    mutating func reset() {
        self.name = "default"
        self.level = 0
    }
}

extension Player: JSONDecodable {
    
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.name = try decoder.decode("name")
        self.level = try decoder.decode("level")
    }
}

typealias PlayerCompletionBlock = (_ player: Player?, _ error: Error?) -> Void

class PlayerProvider {
    
    lazy var documentPath: String? = {
        return Bundle.main.resourcePath!
    }()
    
    init() {
        
    }
    
    func loadPlayer(completionHandler: @escaping PlayerCompletionBlock) {
        
        let filePath = documentPath! + "/player.json"
        
        do {
            let jsonData = try NSData(contentsOf: NSURL(fileURLWithPath: filePath) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            let object = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
            
            if let dictionary = object as? JSONObject {
                do {
                    let player = try Player(object: dictionary)
                    completionHandler(player, nil)
                } catch _ as NSError {
                    let player = Player()
                    completionHandler(player, nil)
                }
            }
        } catch let error as NSError {
            completionHandler(nil, error)
            print("error during read player from disc: \(error)")
        }
        
        return
    }
}
