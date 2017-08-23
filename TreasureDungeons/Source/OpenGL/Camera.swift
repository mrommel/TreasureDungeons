//
//  Camera.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 26.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import GLKit

protocol CameraChangeListener {
    
    func moveCameraTo(x: Float, andY y: Float, withYaw yaw: Float)
    
}

class Camera {
 
    fileprivate var pitch: Float = 0
    fileprivate var yaw: Float = 0
    //fileprivate var roll: Float = 0
    var x: Float = -2
    var y: Float = -2
    
    fileprivate var changeListeners: [CameraChangeListener] = []
    
    init() {
        
    }
    
    var viewMatrix: GLKMatrix4 {
        get {
            var viewMatrix: GLKMatrix4 = GLKMatrix4Identity
            viewMatrix = GLKMatrix4RotateX(viewMatrix, GLKMathDegreesToRadians(self.pitch))
            viewMatrix = GLKMatrix4RotateY(viewMatrix, GLKMathDegreesToRadians(self.yaw))
            //viewMatrix = GLKMatrix4RotateZ(viewMatrix, GLKMathDegreesToRadians(self.roll))
            viewMatrix = GLKMatrix4Translate(viewMatrix, self.x, 0, self.y)
            return viewMatrix
        }
    }
    
    var positionOnMap: Point {
        get {
            return Point(x: -Int((self.x - 1.0) / 2.0) , y: -Int((self.y - 1.0) / 2.0))
        }
    }
    
    var predictedPositionOnMap: Point {
        get {
            let newX = self.x - sin(GLKMathDegreesToRadians(self.yaw)) * 0.5
            let newY = self.y + cos(GLKMathDegreesToRadians(self.yaw)) * 0.5
        
            return Point(x: -Int((newX - 1.0) / 2.0) , y: -Int((newY - 1.0) / 2.0))
        }
    }
    
    func moveForward() {
        self.x = self.x - sin(GLKMathDegreesToRadians(self.yaw)) * 0.5
        self.y = self.y + cos(GLKMathDegreesToRadians(self.yaw)) * 0.5
        
        for changeListener in self.changeListeners {
            changeListener.moveCameraTo(x: self.x, andY: self.y, withYaw: self.yaw)
        }
    }

    func turn(leftAndRight value: Float) {
        self.yaw -= value
        
        for changeListener in self.changeListeners {
            changeListener.moveCameraTo(x: self.x, andY: self.y, withYaw: self.yaw)
        }
    }
    
    func reset() {
        self.pitch = self.pitch * 0.95
    }
    
    func addChangeListener(changeListener: CameraChangeListener) {
        self.changeListeners.append(changeListener)
    }
}
