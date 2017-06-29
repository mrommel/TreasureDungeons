//
//  Array.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 29.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import GLKit

extension Array {
    
    subscript( index: GLuint) -> Element? {
        get {
            return self[Int(index)]
        }
        set(newValue) {
            self[Int(index)] = newValue!
        }
    }
}
