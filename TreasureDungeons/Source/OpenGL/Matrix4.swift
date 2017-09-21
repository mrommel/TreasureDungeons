//
//  Matrix4.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 26.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import GLKit

extension Float {
    var radians: Float {
        return GLKMathDegreesToRadians(self)
    }
}

public class Matrix4 {
    
    var glkMatrix: GLKMatrix4
    
    public static let identity = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
    
    static func makePerspectiveView(angle: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> Matrix4 {
        let matrix = Matrix4()
        matrix.glkMatrix = GLKMatrix4MakePerspective(angle, aspectRatio, nearZ, farZ)
        return matrix
    }
    
    init() {
        glkMatrix = GLKMatrix4Identity
    }
    
    public convenience init(_ m11: Float, _ m12: Float, _ m13: Float, _ m14: Float,
                            _ m21: Float, _ m22: Float, _ m23: Float, _ m24: Float,
                            _ m31: Float, _ m32: Float, _ m33: Float, _ m34: Float,
                            _ m41: Float, _ m42: Float, _ m43: Float, _ m44: Float) {
        
        self.init()
        self.glkMatrix.m = (m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44)
    }
    
    func copy() -> Matrix4 {
        let newMatrix = Matrix4()
        newMatrix.glkMatrix = self.glkMatrix
        return newMatrix
    }
    
    func scale(x: Float, y: Float, z: Float) {
        glkMatrix = GLKMatrix4Scale(glkMatrix, x, y, z)
    }
    
    func rotateAround(x: Float, y: Float, z: Float) {
        glkMatrix = GLKMatrix4Rotate(glkMatrix, x, 1, 0, 0)
        glkMatrix = GLKMatrix4Rotate(glkMatrix, y, 0, 1, 0)
        glkMatrix = GLKMatrix4Rotate(glkMatrix, z, 0, 0, 1)
    }
    
    func translate(x: Float, y: Float, z: Float) {
        glkMatrix = GLKMatrix4Translate(glkMatrix, x, y, z)
    }
    
    func multiply(left: Matrix4) {
        glkMatrix = GLKMatrix4Multiply(left.glkMatrix, glkMatrix)
    }
    
    var raw: [Float] {
        let value = glkMatrix.m
        //I cannot think of a better way of doing this
        return [value.0, value.1, value.2, value.3, value.4, value.5, value.6, value.7, value.8, value.9, value.10, value.11, value.12, value.13, value.14, value.15]
    }
    
    func transpose() {
        glkMatrix = GLKMatrix4Transpose(glkMatrix)
    }
    
    public static func *(lhs: Matrix4, rhs: Matrix4) -> Matrix4 {
        
        let m = Matrix4.identity
        
        m.glkMatrix.m00 = lhs.glkMatrix.m00 * rhs.glkMatrix.m00 + lhs.glkMatrix.m10 * rhs.glkMatrix.m01 + lhs.glkMatrix.m20 * rhs.glkMatrix.m02 + lhs.glkMatrix.m30 * rhs.glkMatrix.m03
        m.glkMatrix.m01 = lhs.glkMatrix.m01 * rhs.glkMatrix.m00 + lhs.glkMatrix.m11 * rhs.glkMatrix.m01 + lhs.glkMatrix.m21 * rhs.glkMatrix.m02 + lhs.glkMatrix.m31 * rhs.glkMatrix.m03
        m.glkMatrix.m02 = lhs.glkMatrix.m02 * rhs.glkMatrix.m00 + lhs.glkMatrix.m12 * rhs.glkMatrix.m01 + lhs.glkMatrix.m22 * rhs.glkMatrix.m02 + lhs.glkMatrix.m32 * rhs.glkMatrix.m03
        m.glkMatrix.m03 = lhs.glkMatrix.m03 * rhs.glkMatrix.m00 + lhs.glkMatrix.m13 * rhs.glkMatrix.m01 + lhs.glkMatrix.m23 * rhs.glkMatrix.m02 + lhs.glkMatrix.m33 * rhs.glkMatrix.m03
        
        m.glkMatrix.m10 = lhs.glkMatrix.m00 * rhs.glkMatrix.m10 + lhs.glkMatrix.m10 * rhs.glkMatrix.m11 + lhs.glkMatrix.m20 * rhs.glkMatrix.m12 + lhs.glkMatrix.m30 * rhs.glkMatrix.m13
        m.glkMatrix.m11 = lhs.glkMatrix.m01 * rhs.glkMatrix.m10 + lhs.glkMatrix.m11 * rhs.glkMatrix.m11 + lhs.glkMatrix.m21 * rhs.glkMatrix.m12 + lhs.glkMatrix.m31 * rhs.glkMatrix.m13
        m.glkMatrix.m12 = lhs.glkMatrix.m02 * rhs.glkMatrix.m10 + lhs.glkMatrix.m12 * rhs.glkMatrix.m11 + lhs.glkMatrix.m22 * rhs.glkMatrix.m12 + lhs.glkMatrix.m32 * rhs.glkMatrix.m13
        m.glkMatrix.m13 = lhs.glkMatrix.m03 * rhs.glkMatrix.m10 + lhs.glkMatrix.m13 * rhs.glkMatrix.m11 + lhs.glkMatrix.m23 * rhs.glkMatrix.m12 + lhs.glkMatrix.m33 * rhs.glkMatrix.m13
        
        m.glkMatrix.m20 = lhs.glkMatrix.m00 * rhs.glkMatrix.m20 + lhs.glkMatrix.m10 * rhs.glkMatrix.m21 + lhs.glkMatrix.m20 * rhs.glkMatrix.m22 + lhs.glkMatrix.m30 * rhs.glkMatrix.m23
        m.glkMatrix.m21 = lhs.glkMatrix.m01 * rhs.glkMatrix.m20 + lhs.glkMatrix.m11 * rhs.glkMatrix.m21 + lhs.glkMatrix.m21 * rhs.glkMatrix.m22 + lhs.glkMatrix.m31 * rhs.glkMatrix.m23
        m.glkMatrix.m22 = lhs.glkMatrix.m02 * rhs.glkMatrix.m20 + lhs.glkMatrix.m12 * rhs.glkMatrix.m21 + lhs.glkMatrix.m22 * rhs.glkMatrix.m22 + lhs.glkMatrix.m32 * rhs.glkMatrix.m23
        m.glkMatrix.m23 = lhs.glkMatrix.m03 * rhs.glkMatrix.m20 + lhs.glkMatrix.m13 * rhs.glkMatrix.m21 + lhs.glkMatrix.m23 * rhs.glkMatrix.m22 + lhs.glkMatrix.m33 * rhs.glkMatrix.m23
        
        m.glkMatrix.m30 = lhs.glkMatrix.m00 * rhs.glkMatrix.m30 + lhs.glkMatrix.m10 * rhs.glkMatrix.m31 + lhs.glkMatrix.m20 * rhs.glkMatrix.m32 + lhs.glkMatrix.m30 * rhs.glkMatrix.m33
        m.glkMatrix.m31 = lhs.glkMatrix.m01 * rhs.glkMatrix.m30 + lhs.glkMatrix.m11 * rhs.glkMatrix.m31 + lhs.glkMatrix.m21 * rhs.glkMatrix.m32 + lhs.glkMatrix.m31 * rhs.glkMatrix.m33
        m.glkMatrix.m32 = lhs.glkMatrix.m02 * rhs.glkMatrix.m30 + lhs.glkMatrix.m12 * rhs.glkMatrix.m31 + lhs.glkMatrix.m22 * rhs.glkMatrix.m32 + lhs.glkMatrix.m32 * rhs.glkMatrix.m33
        m.glkMatrix.m33 = lhs.glkMatrix.m03 * rhs.glkMatrix.m30 + lhs.glkMatrix.m13 * rhs.glkMatrix.m31 + lhs.glkMatrix.m23 * rhs.glkMatrix.m32 + lhs.glkMatrix.m33 * rhs.glkMatrix.m33
        
        return m
    }
}
