//
//  ParticleEmitter2.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 30.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import GLKit

typealias ParticleDeletionCallback = (Particle?) -> Void

class ParticleEmitter {
    
    let effect: BaseEffect
    var particles: [Particle]
    var identifiers: Int = 0
    
    var particleDeletionCallback: ParticleDeletionCallback?
    
    init(shader effect: BaseEffect) {
        self.effect = effect
        self.particles = [Particle]()
    }
    
    func addParticle(at position: GLKVector3, for time2Live: TimeInterval) {
        let particle = Particle(shader: self.effect, with: self.identifiers, at: position, for: time2Live)
        self.identifiers += 1
        self.particles.append(particle)
    }
    
    func updateWithDelta(_ dt: TimeInterval, andFaceTo camera: Camera) {
        for particle in self.particles {
            particle.updateWithDelta(dt)
            particle.faceTo(camera: camera)
        }
        
        // delete already dead objects
        let itemsToDelete = self.particles.filter { $0.time2Live < 0 }
        
        for itemToDelete in itemsToDelete {
            if let particleDeletionCallback = self.particleDeletionCallback {
                particleDeletionCallback(itemToDelete)
            }
            if let indexOfParticle = self.particles.index(where: { $0.identifier == itemToDelete.identifier }) {
                self.particles.remove(at: indexOfParticle)
            }
        }
    }
    
    func render(withParentModelViewMatrix parentModelViewMatrix: GLKMatrix4) {
        for particle in self.particles {
            particle.render(withParentModelViewMatrix: parentModelViewMatrix)
        }
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
    
    let identifier: Int
    var time2Live: TimeInterval
    
    init(shader: BaseEffect, with identifier: Int, at position: GLKVector3, for time2Live: TimeInterval) {

        self.identifier = identifier
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

extension Particle: Equatable {
    
}

func == (lhs: Particle, rhs: Particle) -> Bool {
    return lhs.identifier == rhs.identifier
}
