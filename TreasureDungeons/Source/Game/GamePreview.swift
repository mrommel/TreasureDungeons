//
//  GamePreview.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 11.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import JSONCodable

struct GamePreview {
    
    var identifier: Int?
    var title: String?
    var teaser: String?
    var x: Float?
    var y: Float?
}

extension GamePreview: JSONDecodable {
    
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.identifier = try decoder.decode("identifier")
        self.title = try decoder.decode("title")
        self.teaser = try decoder.decode("teaser")
        
        self.x = try decoder.decode("x")
        self.y = try decoder.decode("y")
    }
}
