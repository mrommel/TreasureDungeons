//
//  Game.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 22.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import JSONCodable

struct Game {
    
    var identifier: Int?
    var title: String?
    var teaser: String?
    
    var goalsGold: [GoalCondition]?
    var goalsSilver: [GoalCondition]?
    var goalsBronze: [GoalCondition]?
    
    var map: Map?
}

extension Game: JSONDecodable {
    
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.identifier = try decoder.decode("identifier")
        self.title = try decoder.decode("title")
        self.teaser = try decoder.decode("teaser")
    }
}

