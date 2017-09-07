//
//  ObjModel.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 07.09.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import GLKit

public enum ObjModelError: Error {
    case noObjectFound
}

class ObjModel : Model {
    
    init(fileName: String, shader: BaseEffect) throws {
        
        // load obj file named "key.obj"
        let fixtureHelper = ObjLoading.FixtureHelper()
        let source = try? fixtureHelper.loadObjFixture(name: fileName)
        
        if let source = source {
            let loader = ObjLoading.ObjLoader(source: source, basePath: fixtureHelper.resourcePath)
            do {
                let shapes = try loader.read()

                if let shape = shapes.first {
                    let (vertices, indices) = ObjModel.verticesAndIndicesFrom(shape: shape)
                    
                    super.init(name: shape.name!, shader: shader, vertices: vertices, indices: indices)
                    self.loadTexture((shape.material?.diffuseTextureMapFilePath?.lastPathComponent)! as String)
                } else {
                    throw ObjModelError.noObjectFound
                }
            }
        } else {
            throw ObjModelError.noObjectFound
        }
    }
    
    init(name: String, shape: ObjLoading.Shape, shader: BaseEffect) {
        
        let (vertices, indices) = ObjModel.verticesAndIndicesFrom(shape: shape)
        
        super.init(name: name, shader: shader, vertices: vertices, indices: indices)
        self.loadTexture((shape.material?.diffuseTextureMapFilePath?.lastPathComponent)! as String)
    }
    
    static func verticesAndIndicesFrom(shape: ObjLoading.Shape) -> ([Vertex], [GLuint]) {
        
        var vertices: [Vertex] = []
        var indices: [GLuint] = []
        var index: GLuint = 0
        
        for vertexIndexes in shape.faces {
            for vertexIndex in vertexIndexes {
                // Will cause an out of bounds error
                // if vIndex, nIndex or tIndex is not normalized
                // to be local to the internal data of the shape
                // instead of global to the file as per the
                // .obj specification
                let (vertexVector, normalVector, textureVector) = shape.dataForVertexIndex(vertexIndex)
                
                var v = Vertex()
                if let vertexVector = vertexVector {
                    v.x = GLfloat(vertexVector[0])
                    v.y = GLfloat(vertexVector[1])
                    v.z = GLfloat(vertexVector[2])
                }
                
                if let normalVector = normalVector {
                    v.nx = GLfloat(normalVector[0])
                    v.ny = GLfloat(normalVector[1])
                    v.nz = GLfloat(normalVector[2])
                }
                
                if let textureVector = textureVector {
                    v.u = GLfloat(textureVector[0])
                    v.v = GLfloat(textureVector[1])
                }
                
                vertices.append(v)
                
                indices.append(index)
                index = index + 1
            }
        }
        
        return (vertices, indices)
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        self.rotationY = self.rotationY + Float(Double.pi * dt / 8)
    }
}
