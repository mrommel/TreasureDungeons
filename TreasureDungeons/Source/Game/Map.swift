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
    //case door_h
    //case door_v
    case teleporter
    
    case outside
}

class Tile: Equatable {
    
    let type: TileType
    let point: Point
    
    init(at point: Point, type: TileType) {
        self.point = point
        self.type = type
    }
    
    func canAccess() -> Bool {
        if self.type == .floor {
            return true
        }
        
        return false
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
    
    public func has(point: Point) -> Bool {
        return point.x >= 0 && point.x < self.self.tiles.columnCount() && point.y >= 0 && point.y < self.tiles.rowCount()
    }
    
    public func hasAt(x: Int, y: Int) -> Bool {
        return x >= 0 && x < self.tiles.columnCount() && y >= 0 && y < self.tiles.rowCount()
    }

    /**
     Getter for `Tile` at `position`
     
     - Parameter position: location in the grid to return the `Tile`
     
     - Returns: `Tile` at `position`
     */
    public func tile(at position: Point) -> Tile {
        
        // check bounds
        guard self.has(point: position) else {
            return Tile(at: position, type: .outside)
        }
        
        return self.tiles[position]!
    }
    
    public func tileAt(x: Int, y: Int) -> Tile {
        
        return tile(at: Point(x: x, y: y))
    }
    
}
