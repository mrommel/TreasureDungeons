//
//  OverviewView.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 22.08.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import Macaw

class OverviewView: MacawView {
    
    let group: Group?
    var game: Game? = nil
    
    required init?(coder aDecoder: NSCoder) {
        let shape = Shape(
            form: Rect(x: 0, y: 0, w: 5, h: 5),
            fill: Color(val: 0xff9e4f),
            place: .move(dx: 0, dy: 0))
        
        self.group = Group(contents: [shape])
        
        super.init(node: self.group!, coder: aDecoder)
    }
    
    func rebuildScene() {
        
        self.group?.contents = []
        
        guard self.game?.map != nil else {
            return
        }
        
        if let map = self.game?.map {
            
            for x in 0..<map.tiles.columnCount() {
                for y in 0..<map.tiles.rowCount() {
                    
                    if let tile = map.tiles[x, y] {
                        
                        switch tile.type {
                        case .floor:
                            let shape = Shape(
                                form: Rect(x: 0, y: 0, w: 1, h: 1),
                                fill: Color.rgb(r: 20, g: 20, b: 20),
                                place: .move(dx: Double(tile.point.x), dy: Double(tile.point.y)))
                            self.group?.contents.append(shape)
                            
                            break
                        case .wall:
                            let shape = Shape(
                                form: Rect(x: 0, y: 0, w: 1, h: 1),
                                fill: Color.rgb(r: 60, g: 60, b: 60),
                                place: .move(dx: Double(tile.point.x), dy: Double(tile.point.y)))
                            self.group?.contents.append(shape)
                            
                            break
                        case .teleporter:
                            let shape = Shape(
                                form: Rect(x: 0, y: 0, w: 1, h: 1),
                                fill: Color.rgb(r: 255, g: 0, b: 0),
                                place: .move(dx: Double(tile.point.x), dy: Double(tile.point.y)))
                            self.group?.contents.append(shape)
                            
                            break
                        case .outside:
                            break
                        }
                    }
                }
            }
            
            self.group?.placeVar.animate(to: Transform.scale(sx: 5, sy: 5))
        }
    }
}

extension OverviewView: CameraChangeListener {
    
    func moveCameraTo(x: Float, andY y: Float, withYaw yaw: Float) {
        print("moveCameraTo: x=\(x), y=\(y), yaw=\(yaw)")
        
        let yawInRadians = Double.pi * 2 - Double(yaw.radians)
        let transform = GeomUtils.centerRotation(node: self.group!, place: .scale(sx: 5, sy: 5), angle: yawInRadians)
        
        //let transforms = [/*Transform.scale(sx: 2, sy: 2),*/
        //    Transform.move(dx: Double(-x) * 5, dy: Double(-y) * 5),
        //    Transform.rotate(angle: Double(yaw), x: 100, y: 100)]
        //let transform = GeomUtils.concat(t1: Transform.rotate(angle: yawInRadians, x: Double(-x), y: Double(-y)),
        //                                 t2: Transform.move(dx: Double(-x), dy: Double(-y)))
        
        self.group?.placeVar.animate(to: transform)
        //self.group?.place.move(dx: Double(x), dy: Double(x))
    }

}
