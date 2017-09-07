//
//  Geometry.swift
//  SwiftObjLoader
//
//  Created by Hugo Tunius on 02/09/15.
//  Copyright © 2015 Hugo Tunius. All rights reserved.
//

import Foundation

extension ObjLoading {
    
    // An n dimensional vector
    // repreented by a double array
    public typealias Vector = [Double]

    open class VertexIndex {
        // Vertex index, zero-based
        open let vIndex: Int?
        // Normal index, zero-based
        open let nIndex: Int?
        // Texture Coord index, zero-based
        open let tIndex: Int?

        init(vIndex: Int?, nIndex: Int?, tIndex: Int?) {
            self.vIndex = vIndex
            self.nIndex = nIndex
            self.tIndex = tIndex
        }
    }

    // Consider converting this to a class.
    // Since it's already immutable it would
    // remain thread safe and needless copying
    // would stop. Also applies to Material
    open class Shape {
        open let name: String?
        open let vertices: [Vector]
        open let normals: [Vector]
        open let textureCoords: [Vector]
        open let material: Material?

        // Definition of faces that make up the shape
        // indexes are into the vertices, normals and
        // texture coords of this shape
        //
        // Example:
        //   VertexIndex(vIndex: 4, nIndex: 2, tIndex: 0)
        // Refers to vertices[4], normals[2] and textureCoords[0]
        //
        open let faces: [[VertexIndex]]

        public init(name: String?,
                    vertices: [Vector],
                    normals: [Vector],
                    textureCoords: [Vector],
                    material: Material?,
                    faces: [[VertexIndex]]) {
            self.name = name
            self.vertices = vertices
            self.normals = normals
            self.textureCoords = textureCoords
            self.material = material
            self.faces = faces
        }

        public final func dataForVertexIndex(_ v: VertexIndex) -> (Vector?, Vector?, Vector?) {
            var data: (Vector?, Vector?, Vector?) = (nil, nil, nil)

            if let vi = v.vIndex {
                data.0 = vertices[vi]
            }

            if let ni = v.nIndex {
                data.1 = normals[ni]
            }

            if let ti = v.tIndex {
                data.2 = textureCoords[ti]
            }

            return data
        }
    }

    // From http://floating-point-gui.de/errors/comparison/
    static func doubleEquality(_ a: Double, _ b: Double) -> Bool {
        let diff = abs(a - b)

        if a == b { // shortcut for infinities
            return true
        } else if (a == 0 || b == 0 || diff < .leastNormalMagnitude) {
            return diff < (1e-5 * .leastNormalMagnitude)
        } else {
            let absA = abs(a)
            let absB = abs(b)
            return diff / min((absA + absB), .greatestFiniteMagnitude) < 1e-5
        }
    }


    static func nestedEquality<T>(_ lhs: [[T]], _ rhs: [[T]], equal: ([T], [T]) -> Bool) -> Bool {
        if lhs.count != rhs.count {
            return false
        }

        for i in 0..<lhs.count {
            if false == equal(lhs[i], rhs[i]) {
                return false
            }
        }

        return true
    }
}

extension ObjLoading.Shape: Equatable {}

func ==(lhs: ObjLoading.Shape, rhs: ObjLoading.Shape) -> Bool {
    if lhs.name != rhs.name {
        return false
    }
    
    let lengthCheck: (ObjLoading.Vector, ObjLoading.Vector) -> Bool = { a, b in
        a.count == b.count
    }
    
    if !ObjLoading.nestedEquality(lhs.vertices, rhs.vertices, equal: lengthCheck) ||
        !ObjLoading.nestedEquality(lhs.normals, rhs.normals, equal: lengthCheck) ||
        !ObjLoading.nestedEquality(lhs.textureCoords, rhs.textureCoords, equal: lengthCheck) {
        return false
    }
    
    let valueCheck: (ObjLoading.Vector, ObjLoading.Vector) -> Bool = { a, b in
        for i in 0..<a.count {
            if !ObjLoading.doubleEquality(a[i], b[i]) {
                return false
            }
        }
        return true
    }
    
    if !ObjLoading.nestedEquality(lhs.vertices, rhs.vertices, equal: valueCheck) ||
        !ObjLoading.nestedEquality(lhs.normals, rhs.normals, equal: valueCheck) ||
        !ObjLoading.nestedEquality(lhs.textureCoords, rhs.textureCoords, equal: valueCheck) {
        return false
    }
    
    if !ObjLoading.nestedEquality(lhs.faces, rhs.faces, equal: { $0.count == $1.count }) {
        return false
    }
    
    let vertexIndexCheck: ([ObjLoading.VertexIndex], [ObjLoading.VertexIndex]) -> Bool = { a, b in
        for i in 0..<a.count {
            if a[i] != b[i] {
                return false
            }
        }
        return true
    }
    if !ObjLoading.nestedEquality(lhs.faces, rhs.faces, equal: vertexIndexCheck) {
        return false
    }
    
    if lhs.material != rhs.material {
        return false
    }
    
    return true
}

extension ObjLoading.VertexIndex: Equatable {}

func ==(lhs: ObjLoading.VertexIndex, rhs: ObjLoading.VertexIndex) -> Bool {
    return lhs.vIndex == rhs.vIndex &&
        lhs.nIndex == rhs.nIndex &&
        lhs.tIndex == rhs.tIndex
}

extension ObjLoading.VertexIndex: CustomStringConvertible {
    public var description: String {
        return "\(vIndex)/\(nIndex)/\(tIndex)"
    }
}
