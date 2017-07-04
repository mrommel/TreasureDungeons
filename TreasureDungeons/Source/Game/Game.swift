//
//  Game.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 22.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import JSONCodable

enum GoalType: String {
    case time // time until treasure is found
    case portions // number of portions to collect
}

struct GoalCondition {
    
    let type: GoalType
    let value: Int // value dependant to type
    
    init(ofType type: GoalType, andValue value: Int) {
        self.type = type
        self.value = value
    }
    
    
}

extension GoalCondition: JSONDecodable {
    
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.type = try decoder.decode("type")
        self.value = try decoder.decode("value")
    }
}

extension GoalCondition: JSONEncodable {
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(type, key: "type")
            try encoder.encode(value, key: "value")
        })
    }
}

struct Game {
    
    var goalsGold: [GoalCondition]?
    var goalsSilver: [GoalCondition]?
    var goalsBronze: [GoalCondition]?
    
    var map: Map?
    
    init(fromFile filename: String) {
        
    }
}
