//
//  Quaternion.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 12.09.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import GLKit

public extension Float {
    
    fileprivate var sign: Float {
        return self > 0 ? 1 : -1
    }
}

public struct Quaternion {
    public var x: Float
    public var y: Float
    public var z: Float
    public var w: Float
}

extension Quaternion: Hashable {
    public var hashValue: Int {
        return x.hashValue &+ y.hashValue &+ z.hashValue &+ w.hashValue
    }
    
    public static func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
    }
}

public extension Quaternion {
    public static let zero = Quaternion(0, 0, 0, 0)
    public static let identity = Quaternion(0, 0, 0, 1)
    
    public var lengthSquared: Float {
        return x * x + y * y + z * z + w * w
    }
    
    public var length: Float {
        return sqrt(lengthSquared)
    }
    
    public var inverse: Quaternion {
        return -self
    }
    
    /*public var xyz: Vector3 {
        get {
            return Vector3(x, y, z)
        }
        set(v) {
            x = v.x
            y = v.y
            z = v.z
        }
    }*/
    
    public var pitch: Float {
        return asin(min(1, max(-1, 2 * (w * y - z * x))))
    }
    
    public var yaw: Float {
        return atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z))
    }
    
    public var roll: Float {
        return atan2(2 * (w * x + y * z), 1 - 2 * (x * x + y * y))
    }
    
    public init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.init(x: x, y: y, z: z, w: w)
    }
    
    /*public init(axisAngle: Vector4) {
        let r = axisAngle.w * 0.5
        let scale = sin(r)
        let a = axisAngle.xyz * scale
        self.init(a.x, a.y, a.z, cos(r))
    }*/
    
    public init(pitch: Float, yaw: Float, roll: Float) {
        let t0 = cos(yaw * 0.5)
        let t1 = sin(yaw * 0.5)
        let t2 = cos(roll * 0.5)
        let t3 = sin(roll * 0.5)
        let t4 = cos(pitch * 0.5)
        let t5 = sin(pitch * 0.5)
        self.init(
            t0 * t3 * t4 - t1 * t2 * t5,
            t0 * t2 * t5 + t1 * t3 * t4,
            t1 * t2 * t4 - t0 * t3 * t5,
            t0 * t2 * t4 + t1 * t3 * t5
        )
    }
    
    public init(rotationMatrix m: Matrix4) {
        let x = sqrt(max(0, 1 + m.glkMatrix.m00 - m.glkMatrix.m11 - m.glkMatrix.m22)) / 2
        let y = sqrt(max(0, 1 - m.glkMatrix.m00 + m.glkMatrix.m11 - m.glkMatrix.m22)) / 2
        let z = sqrt(max(0, 1 - m.glkMatrix.m00 - m.glkMatrix.m11 + m.glkMatrix.m22)) / 2
        let w = sqrt(max(0, 1 + m.glkMatrix.m00 + m.glkMatrix.m11 + m.glkMatrix.m22)) / 2

        self.init(
            x: x * (x * (m.glkMatrix.m21 - m.glkMatrix.m12)).sign,
            y: y * (y * (m.glkMatrix.m02 - m.glkMatrix.m20)).sign,
            z: z * (z * (m.glkMatrix.m10 - m.glkMatrix.m01)).sign,
            w: w
        )
    }
    
    public init(_ v: [Float]) {
        assert(v.count == 4, "array must contain 4 elements, contained \(v.count)")
        
        x = v[0]
        y = v[1]
        z = v[2]
        w = v[3]
    }
    
    /*public func toAxisAngle() -> Vector4 {
        let scale = xyz.length
        if scale ~= 0 || scale ~= .twoPi {
            return .z
        } else {
            return Vector4(x / scale, y / scale, z / scale, acos(w) * 2)
        }
    }*/
    
    public func toPitchYawRoll() -> (pitch: Float, yaw: Float, roll: Float) {
        return (pitch, yaw, roll)
    }
    
    public func toArray() -> [Float] {
        return [x, y, z, w]
    }
    
    public func dot(_ v: Quaternion) -> Float {
        return x * v.x + y * v.y + z * v.z + w * v.w
    }
    
    public func normalized() -> Quaternion {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }
    
    public func interpolated(with q: Quaternion, by t: Float) -> Quaternion {
        let dot = max(-1, min(1, self.dot(q)))
        if dot ~= 1 {
            return (self + (q - self) * t).normalized()
        }
        
        let theta = acos(dot) * t
        let t1 = self * cos(theta)
        let t2 = (q - (self * dot)).normalized() * sin(theta)
        return t1 + t2
    }
    
    public static prefix func -(q: Quaternion) -> Quaternion {
        return Quaternion(-q.x, -q.y, -q.z, q.w)
    }
    
    public static func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z, lhs.w + rhs.w)
    }
    
    public static func -(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z, lhs.w - rhs.w)
    }
    
    public static func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y,
            lhs.w * rhs.y + lhs.y * rhs.w + lhs.z * rhs.x - lhs.x * rhs.z,
            lhs.w * rhs.z + lhs.z * rhs.w + lhs.x * rhs.y - lhs.y * rhs.x,
            lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z
        )
    }
    
    /*public static func *(lhs: Quaternion, rhs: Vector3) -> Vector3 {
        return rhs * lhs
    }*/
    
    public static func *(lhs: Quaternion, rhs: Float) -> Quaternion {
        return Quaternion(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs, lhs.w * rhs)
    }
    
    public static func /(lhs: Quaternion, rhs: Float) -> Quaternion {
        return Quaternion(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs, lhs.w / rhs)
    }
    
    public static func ~=(lhs: Quaternion, rhs: Quaternion) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y && lhs.z ~= rhs.z && lhs.w ~= rhs.w
    }
}

extension Matrix4 {
    
    /*public convenience init(rotation axisAngle: Vector4) {
        self.init(quaternion: Quaternion(axisAngle: axisAngle))
    }*/
    
    public convenience init(quaternion q: Quaternion) {
        self.init(
            1 - 2 * (q.y * q.y + q.z * q.z), 2 * (q.x * q.y + q.z * q.w), 2 * (q.x * q.z - q.y * q.w), 0,
            2 * (q.x * q.y - q.z * q.w), 1 - 2 * (q.x * q.x + q.z * q.z), 2 * (q.y * q.z + q.x * q.w), 0,
            2 * (q.x * q.z + q.y * q.w), 2 * (q.y * q.z - q.x * q.w), 1 - 2 * (q.x * q.x + q.y * q.y), 0,
            0, 0, 0, 1
        )
    }
}
