//
//  Random.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 29.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

extension Int {
    // Returns a random Int point number between 0 and Int.max.
    public static var random: Int {
        get {
            return Int.random(n: Int.max)
        }
    }
    
    /**
     Random integer between 0 and n-1.
     
     - parameter n: Int
     
     - returns: Int
     */
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    /**
     Random integer between min and max
     
     - parameter min: Int
     - parameter max: Int
     
     - returns: Int
     */
    public static func random(min: Int = 0, max: Int) -> Int {
        return Int.random(n: max - min + 1) + min
    }
}

extension Double {
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    
    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

extension Float {
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /**
     Create a random num Float
     
     - parameter min: Float
     - parameter max: Float
     
     - returns: Float
     */
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
