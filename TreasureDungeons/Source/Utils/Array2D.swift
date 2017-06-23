//
//  Array2D.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 22.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

public class Array2D <T: Equatable> {
    
    fileprivate var columns: Int = 0
    fileprivate var rows: Int = 0
    fileprivate var array: Array<T?> = Array<T?>()
    
    public init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        self.array = Array<T?>(repeating: nil, count: rows * columns)
    }
    
    public subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
    
    public func columnCount() -> Int {
        return columns
    }
    
    public func rowCount() -> Int {
        return rows
    }
}

extension Array2D {
    
    subscript(point: Point) -> T? {
        get {
            return array[(point.y * columns) + point.x]
        }
        set(newValue) {
            array[(point.y * columns) + point.x] = newValue
        }
    }
    
}

extension Array2D {
    
    public func fill(with value: T) {
        
        for x in 0..<columns {
            for y in 0..<rows {
                self[x, y] = value
            }
        }
    }
}
