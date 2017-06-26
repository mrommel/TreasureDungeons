//
//  Skybox.swift
//  AnimateCube
//
//  Created by burt on 2016. 2. 28..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import GLKit

class Skybox : Model {
    let vertexList : [Vertex] = [
        
        // Front
        Vertex( 1, -1, 1,  1, 0, 0, 1,  0.25, 0.33,  0, 0, 1), // 0
        Vertex( 1,  1, 1,  0, 1, 0, 1,  0.25, 0.66,  0, 0, 1), // 1
        Vertex(-1,  1, 1,  0, 0, 1, 1,  0.0, 0.66,  0, 0, 1), // 2
        Vertex(-1, -1, 1,  0, 0, 0, 1,  0.0, 0.33,  0, 0, 1), // 3
        
        // Back
        Vertex(-1, -1, -1, 0, 0, 1, 1,  0.75, 0.33,  0, 0,-1), // 4
        Vertex(-1,  1, -1, 0, 1, 0, 1,  0.75, 0.66,  0, 0,-1), // 5
        Vertex( 1,  1, -1, 1, 0, 0, 1,  0.5, 0.66,  0, 0,-1), // 6
        Vertex( 1, -1, -1, 0, 0, 0, 1,  0.5, 0.33,  0, 0,-1), // 7
        
        // Left
        Vertex(-1, -1,  1, 1, 0, 0, 1,  1.0, 0.33, -1, 0, 0), // 8
        Vertex(-1,  1,  1, 0, 1, 0, 1,  1.0, 0.66, -1, 0, 0), // 9
        Vertex(-1,  1, -1, 0, 0, 1, 1,  0.75, 0.66, -1, 0, 0), // 10
        Vertex(-1, -1, -1, 0, 0, 0, 1,  0.75, 0.33, -1, 0, 0), // 11
        
        // Right
        Vertex( 1, -1, -1, 1, 0, 0, 1,  0.5, 0.33,  1, 0, 0), // 12
        Vertex( 1,  1, -1, 0, 1, 0, 1,  0.5, 0.66,  1, 0, 0), // 13
        Vertex( 1,  1,  1, 0, 0, 1, 1,  0.25, 0.66,  1, 0, 0), // 14
        Vertex( 1, -1,  1, 0, 0, 0, 1,  0.25, 0.33,  1, 0, 0), // 15
        
        // Top
        Vertex( 1,  1,  1, 1, 0, 0, 1,  0.25, 0.33,  0, 1, 0), // 16
        Vertex( 1,  1, -1, 0, 1, 0, 1,  0.25, 0.0,  0, 1, 0), // 17
        Vertex(-1,  1, -1, 0, 0, 1, 1,  0.5, 0.0,  0, 1, 0), // 18
        Vertex(-1,  1,  1, 0, 0, 0, 1,  0.5, 0.33,  0, 1, 0), // 19
        
        // Bottom
        Vertex( 1, -1, -1, 1, 0, 0, 1,  0.5, 0.66,  0,-1, 0), // 20
        Vertex( 1, -1,  1, 0, 1, 0, 1,  0.5, 1,  0,-1, 0), // 21
        Vertex(-1, -1,  1, 0, 0, 1, 1,  0.25, 1,  0,-1, 0), // 22
        Vertex(-1, -1, -1, 0, 0, 0, 1,  0.25, 0.66,  0,-1, 0), // 23
        
    ]
    
    let indexList : [GLubyte] = [
        
        // Front
        0, 2, 1,
        2, 0, 3, 
        
        // Back
        4, 6, 5,
        6, 4, 7,
        
        // Left
        8, 10, 9,
        10, 8, 11,
        
        // Right
        12, 14, 13,
        14, 12, 15,
        
        // Top
        16, 18, 17,
        18, 16, 19,
        
        // Bottom
        20, 22, 21,
        22, 20, 23
    ]
    
    init(shader: BaseEffect) {
        super.init(name: "skybox", shader: shader, vertices: vertexList, indices: indexList)
        self.loadTexture("skybox.png")
        
        self.scale = 30.0
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        //self.rotationZ = self.rotationZ + Float(M_PI*dt)
        //self.rotationY = self.rotationY + Float(Double.pi * dt / 8)
    }

}

