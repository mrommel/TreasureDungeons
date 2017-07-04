//
//  CGPoint.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 03.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}
