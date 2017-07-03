//
//  ParticleEmitter2.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 30.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import GLKit

class ParticleEmitter {
    
    func addParticle() -> Particle? {
        return nil
    }
}

class Particle: Model {
    
    var vertexList : [Vertex] = [
        Vertex( 0.5, -0.5, 0.5,  1, 0, 0, 1,  1, 0,  0, 0, 1), // 0
        Vertex( 0.5,  0.5, 0.5,  0, 1, 0, 1,  1, 1,  0, 0, 1), // 1
        Vertex(-0.5,  0.5, 0.5,  0, 0, 1, 1,  0, 1,  0, 0, 1), // 2
        Vertex(-0.5, -0.5, 0.5,  0, 0, 0, 1,  0, 0,  0, 0, 1), // 3
    ]
    
    var indexList : [GLuint] = [
        0, 1, 2,
        2, 3, 0,
    ]
    
    var time2Live: TimeInterval
    
    init(shader: BaseEffect, at position: GLKVector3, for time2Live: TimeInterval) {

        self.time2Live = time2Live
        
        super.init(name: "billboard", shader: shader, vertices: vertexList, indices: indexList)
        self.loadTexture("dungeon_01.png")
        
        self.position = position
    }
    
    func faceTo(camera: Camera) {
        
        let angle = atan2(self.position.x - camera.x, self.position.z - camera.y)
        
        self.rotationY = angle
    }
    
    override func render(withParentModelViewMatrix parentModelViewMatrix: GLKMatrix4) {
        if self.time2Live > 0.0 {
            super.render(withParentModelViewMatrix: parentModelViewMatrix)
        }
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        //self.rotationY = self.rotationY + Float(Double.pi * dt / 8)
        self.time2Live -= dt
    }
    
}
