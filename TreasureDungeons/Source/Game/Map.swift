//
//  Map.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 22.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

class Point: Equatable {
    
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

func == (lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

enum TileType {
    case floor
    case wall
}

class Tile: Equatable {
    
    let type: TileType
    let point: Point
    
    init(point: Point, type: TileType) {
        self.point = point
        self.type = type
    }
}

func == (lhs: Tile, rhs: Tile) -> Bool {
    return lhs.type == rhs.type && lhs.point == rhs.point
}

class Map {
    
    var tiles: Array2D<Tile>
    
    init(width: Int, height: Int) {
        self.tiles = Array2D<Tile>(columns: width, rows: height)
    }
    
}
