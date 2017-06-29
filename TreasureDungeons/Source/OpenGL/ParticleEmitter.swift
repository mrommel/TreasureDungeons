//
//  ParticleEmitter.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 29.06.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation
import GLKit

enum ParticleType {
    case radial
}

struct TexturedColoredVertex {
    var vertex: GLKVector2
    var texture: GLKVector2
    var color: GLKVector4
}

class Particle {
    
    var timeToLive: GLfloat = 0.0
    var position: GLKVector2 = GLKVector2()
    var startPos: GLKVector2 = GLKVector2()
    var angle: GLfloat = 0.0
    var radius: GLfloat = 0.0
    var radiusDelta: GLfloat = 0.0
    
    var radialAcceleration: GLfloat = 0.0
    var tangentialAcceleration: GLfloat = 0.0
    
    var direction: GLKVector2 = GLKVector2()
    
    var rotation: GLfloat = 0.0
    var rotationDelta: GLfloat = 0.0
    
    var color: GLKVector4 = GLKVector4()
    var deltaColor: GLKVector4 = GLKVector4()
    
    var degreesPerSecond: GLfloat = 0.0
    
    var particleSize: GLfloat = 0.0
    var particleSizeDelta: GLfloat = 0.0
    
    init() {
        
    }
}

struct ParticleQuad {
    var bl: TexturedColoredVertex
    var br: TexturedColoredVertex
    var tl: TexturedColoredVertex
    var tr: TexturedColoredVertex
}

class ParticleEmitter {
    
    var active: Bool = false
    
    var emissionRate: GLfloat = 0.0
    var emitCounter: GLfloat = 0
    let maxParticles: GLuint = 1000
    
    var particleIndex: GLint = 0
    var particleCount: GLuint = 0
    
    let particleLifespan: GLfloat = 0.5921
    let particleLifespanVariance: GLfloat = 0.0000
    
    let sourcePosition: GLKVector2 = GLKVector2(v: (150.00, 50.00))
    let sourcePositionVariance: GLKVector2 = GLKVector2(v: (0.00, 0.00))
    
    let angle: GLfloat = 268.77
    let angleVariance: GLfloat = 0.0
    let speed: GLfloat = 225.00
    let speedVariance: GLfloat = 30.00
    
    let rotatePerSecond: GLfloat = 0.0
    let rotatePerSecondVariance: GLfloat = 201.32
    
    var radialAcceleration: GLfloat = 0.0
    var radialAccelVariance: GLfloat = 0.0
    var tangentialAcceleration: GLfloat = 0.0
    var tangentialAccelVariance: GLfloat = 0.0
    
    var minRadius: GLfloat = 0.0            // Radius from source below which a particle dies
    var minRadiusVariance: GLfloat = 0.0    // Variance of the minRadius
    var maxRadius: GLfloat = 142.11         // Max radius at which particles are drawn when rotating
    var maxRadiusVariance: GLfloat = 15.79  // Variance of the maxRadius
    
    let startColor: GLKVector4 = GLKVector4(v: (0.83, 0.52, 0.18, 1.00))
    let startColorVariance: GLKVector4 = GLKVector4(v: (0.00, 0.20, 0.20, 0.50))
    let finishColor: GLKVector4 = GLKVector4(v: (0.21, 0.01, 0.00, 1.00))
    let finishColorVariance: GLKVector4 = GLKVector4(v: (0.00, 0.00, 0.00, 1.00))
    
    var startParticleSize: GLfloat = 42.53
    var startParticleSizeVariance: GLfloat = 0.0
    var finishParticleSize: GLfloat = 8.33
    var finishParticleSizeVariance: GLfloat = 0.0
    
    let duration: GLfloat = -1.0
    var elapsedTime: GLfloat = 0.0
    
    let gravity: GLKVector2 = GLKVector2(v: (0.0, 0.0) )
    
    var rotationStart: GLfloat = 0.0
    var rotationStartVariance: GLfloat = 0.0
    var rotationEnd: GLfloat = 0.0
    var rotationEndVariance: GLfloat = 0.0
    
    var particles: [Particle?]
    var quads: [ParticleQuad?]
    var emitterType: ParticleType = .radial
    
    let opacityModifyRGB: Bool = false
    
    let blendFuncSource: Int = 770
    let blendFuncDestination: Int = 1
    
    // rendering
    let shaderEffect: BaseEffect
    var verticesID: GLuint = 0                 // Holds the buffer name of the VBO that stores the color and vertices info for the particles
    //let vertexIndex: GLint                  // Stores the index of the vertices being used for each particle
    var indices: [GLuint?]                  // Array holding an index reference into an array of quads for rendering
    
    init(shaderEffect: BaseEffect) {
        
        self.shaderEffect = shaderEffect
        
        self.particles = [Particle]()
        self.quads = [ParticleQuad]()
        
        self.emitterType = .radial
        
        self.emissionRate = GLfloat(self.maxParticles) / self.particleLifespan
        self.emitCounter = 0
        
        // Allocate the memory necessary for the particle emitter arrays
        self.particles = [Particle?](repeating: nil, count: Int(maxParticles)) // malloc( sizeof(Particle) * maxParticles )
        self.quads = [ParticleQuad?](repeating: nil, count: Int(maxParticles)) // calloc(sizeof(ParticleQuad), Int(maxParticles))
        self.indices = [GLuint?](repeating: nil, count: Int(maxParticles) * 6) // calloc(sizeof(GLushort), Int(maxParticles) * 6)
        
        // Set up the indices for all particles. This provides an array of indices into the quads array that is used during
        // rendering. As we are rendering quads there are six indices for each particle as each particle is made of two triangles
        // that are each defined by three vertices.
        for i in 0..<maxParticles {
            indices[i*6+0] = i*4+0
            indices[i*6+1] = i*4+1
            indices[i*6+2] = i*4+2
            
            indices[i*6+5] = i*4+2
            indices[i*6+4] = i*4+3
            indices[i*6+3] = i*4+1
        }
        
        // Set up texture coordinates for all particles as these will not change.
        for i in 0..<maxParticles {
            quads[i]??.bl.texture.x = 0;
            quads[i]??.bl.texture.y = 0;
            
            quads[i]??.br.texture.x = 1;
            quads[i]??.br.texture.y = 0;
            
            quads[i]??.tl.texture.x = 0;
            quads[i]??.tl.texture.y = 1;
            
            quads[i]??.tr.texture.x = 1;
            quads[i]??.tr.texture.y = 1;
        }
        
        // If one of the arrays cannot be allocated throw an assertion as this is bad
        //NSAssert(particles && quads, @"ERROR - ParticleEmitter: Could not allocate arrays.");
        
        // Generate the vertices VBO
        glGenBuffers(1, &verticesID)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), verticesID)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<ParticleQuad>.size * Int(maxParticles), quads, GLenum(GL_DYNAMIC_DRAW))
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        
        // By default the particle emitter is active when created
        self.active = true
        
        // Set the particle count to zero
        self.particleCount = 0
        
        // Reset the elapsed time
        self.elapsedTime = 0
    }
    
    func renderParticles() {
        
        //glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        //shaderEffect.texture2d0.name = texture.name
        //shaderEffect.texture2d0.enabled = YES
        
        //[shaderEffect prepareToDraw];
        self.shaderEffect.prepareToDraw()
        
        // Bind to the verticesID VBO and popuate it with the necessary vertex, color and texture informaiton
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), verticesID)
        
        // Using glBufferSubData means that a copy is done from the quads array to the buffer rather than recreating the buffer which
        // would be an allocation and copy. The copy also only takes over the number of live particles. This provides a nice performance
        // boost.
        glBufferSubData(GLenum(GL_ARRAY_BUFFER), 0, MemoryLayout<ParticleQuad>.size * Int(self.particleIndex), self.quads)
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))
        
        // Configure the vertex pointer which will use the currently bound VBO for its data
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.position.rawValue),
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<TexturedColoredVertex>.size),
            BUFFER_OFFSET(0))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.color.rawValue),
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<TexturedColoredVertex>.size),
            BUFFER_OFFSET(2 * MemoryLayout<GLfloat>.size))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.texCoord0.rawValue),
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<TexturedColoredVertex>.size),
            BUFFER_OFFSET(6 * MemoryLayout<GLfloat>.size))
        
        // Set the blend function based on the configuration
        glBlendFunc(GLenum(self.blendFuncSource), GLenum(self.blendFuncDestination))
        
        // Now that all of the VBOs have been used to configure the vertices, pointer size and color
        // use glDrawArrays to draw the points
        glDrawElements(GLenum(GL_TRIANGLES), particleIndex * 6, GLenum(GL_UNSIGNED_SHORT), self.indices)
        //glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), nil)
        
        // Unbind the current VBO
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: n)
    }
    
    func updateWithDelta(delta: TimeInterval) {
        
        // If the emitter is active and the emission rate is greater than zero then emit particles
        if (self.active && self.emissionRate > 0) {
            let rate = 1.0 / self.emissionRate
            
            if (self.particleCount < self.maxParticles) {
                self.emitCounter += Float(delta)
            }
            
            while (self.particleCount < self.maxParticles && self.emitCounter > rate) {
                self.addParticle()
                self.emitCounter -= rate
            }
            
            self.elapsedTime += Float(delta)
            
            if (self.duration != -1.0 && self.duration < elapsedTime) {
                self.stopParticleEmitter()
            }
        }
        
        // Reset the particle index before updating the particles in this emitter
        particleIndex = 0
        
        // Loop through all the particles updating their location and color
        while (GLuint(particleIndex) < particleCount) {
            
            // Get the particle for the current particle index
            let currentParticle = self.particles[Int(particleIndex)]
            
            // Reduce the life span of the particle
            currentParticle?.timeToLive -= Float(delta)
            
            // If the current particle is alive then update it
            if ((currentParticle?.timeToLive)! > 0) {
                
                // If maxRadius is greater than 0 then the particles are going to spin otherwise they are effected by speed and gravity
                if (self.emitterType == .radial) {
                    
                    // Update the angle of the particle from the sourcePosition and the radius.  This is only done of the particles are rotating
                    currentParticle?.angle += (currentParticle?.degreesPerSecond)! * Float(delta)
                    currentParticle?.radius += (currentParticle?.radiusDelta)! * Float(delta)
                    
                    var tmp = GLKVector2()
                    tmp.x = sourcePosition.x - cos((currentParticle?.angle)!) * (currentParticle?.radius)!
                    tmp.y = sourcePosition.y - sin((currentParticle?.angle)!) * (currentParticle?.radius)!
                    currentParticle?.position = tmp
                    
                } else {
                    var tmp: GLKVector2
                    var radial: GLKVector2 = GLKVector2()
                    var tangential: GLKVector2
                    
                    // By default this emitters particles are moved relative to the emitter node position
                    let positionDifference: GLKVector2 = GLKVector2Subtract(currentParticle!.startPos, GLKVector2())
                    currentParticle?.position = GLKVector2Subtract((currentParticle?.position)!, positionDifference)
                    
                    if ((currentParticle?.position.x)! > 0 || (currentParticle?.position.y)! > 0) {
                        radial = GLKVector2Normalize((currentParticle?.position)!)
                    }
                    
                    tangential = radial;
                    radial = GLKVector2MultiplyScalar(radial, (currentParticle?.radialAcceleration)!)
                    
                    let newy: GLfloat = tangential.x
                    tangential.x = -tangential.y
                    tangential.y = newy
                    tangential = GLKVector2MultiplyScalar(tangential, (currentParticle?.tangentialAcceleration)!)
                    
                    tmp = GLKVector2Add( GLKVector2Add(radial, tangential), gravity)
                    tmp = GLKVector2MultiplyScalar(tmp, Float(delta))
                    currentParticle?.direction = GLKVector2Add((currentParticle?.direction)!, tmp)
                    tmp = GLKVector2MultiplyScalar((currentParticle?.direction)!, Float(delta))
                    currentParticle?.position = GLKVector2Add((currentParticle?.position)!, tmp)
                    
                    // Now apply the difference calculated early causing the particles to be relative in position to the emitter position
                    currentParticle?.position = GLKVector2Add((currentParticle?.position)!, positionDifference)
                }
                
                // Update the particles color
                currentParticle?.color.r += ((currentParticle?.deltaColor.r)! * Float(delta))
                currentParticle?.color.g += ((currentParticle?.deltaColor.g)! * Float(delta))
                currentParticle?.color.b += ((currentParticle?.deltaColor.b)! * Float(delta))
                currentParticle?.color.a += ((currentParticle?.deltaColor.a)! * Float(delta))
                
                var c: GLKVector4
                
                if (self.opacityModifyRGB) {
                    c = GLKVector4(v: ((currentParticle?.color.r)! * (currentParticle?.color.a)!, (currentParticle?.color.g)! * (currentParticle?.color.a)!, (currentParticle?.color.b)! * (currentParticle?.color.a)!, (currentParticle?.color.a)!))
                } else {
                    c = (currentParticle?.color)!
                }
                
                // Update the particle size
                currentParticle?.particleSize += (currentParticle?.particleSizeDelta)! * Float(delta)
                currentParticle?.particleSize = max(0, (currentParticle?.particleSize)!)
                
                // Update the rotation of the particle
                currentParticle?.rotation += (currentParticle?.rotationDelta)! * Float(delta)
                
                // As we are rendering the particles as quads, we need to define 6 vertices for each particle
                let halfSize: GLfloat = currentParticle!.particleSize * 0.5
                
                // If a rotation has been defined for this particle then apply the rotation to the vertices that define
                // the particle
                if (currentParticle?.rotation != 0.0) {
                    let x1: Float = -halfSize
                    let y1: Float = -halfSize
                    let x2: Float = halfSize
                    let y2: Float = halfSize
                    let x: Float = currentParticle!.position.x
                    let y: Float = currentParticle!.position.y
                    let r: Float = GLKMathDegreesToRadians(currentParticle!.rotation)
                    let cr: Float = cos(r)
                    let sr: Float = sin(r)
                    let ax: Float = x1 * cr - y1 * sr + x
                    let ay: Float = x1 * sr + y1 * cr + y
                    let bx: Float = x2 * cr - y1 * sr + x
                    let by: Float = x2 * sr + y1 * cr + y
                    let cx: Float = x2 * cr - y2 * sr + x
                    let cy: Float = x2 * sr + y2 * cr + y
                    let dx: Float = x1 * cr - y2 * sr + x
                    let dy: Float = x1 * sr + y2 * cr + y
                    
                    quads[Int(particleIndex)]?.bl.vertex.x = ax
                    quads[Int(particleIndex)]?.bl.vertex.y = ay
                    quads[Int(particleIndex)]?.bl.color = c
                    
                    quads[Int(particleIndex)]?.br.vertex.x = bx
                    quads[Int(particleIndex)]?.br.vertex.y = by
                    quads[Int(particleIndex)]?.br.color = c
                    
                    quads[Int(particleIndex)]?.tl.vertex.x = dx
                    quads[Int(particleIndex)]?.tl.vertex.y = dy
                    quads[Int(particleIndex)]?.tl.color = c
                
                    quads[Int(particleIndex)]?.tr.vertex.x = cx
                    quads[Int(particleIndex)]?.tr.vertex.y = cy
                    quads[Int(particleIndex)]?.tr.color = c
                } else {
                    // Using the position of the particle, work out the four vertices for the quad that will hold the particle
                    // and load those into the quads array.
                    quads[Int(particleIndex)]?.bl.vertex.x = (currentParticle?.position.x)! - halfSize
                    quads[Int(particleIndex)]?.bl.vertex.y = (currentParticle?.position.y)! - halfSize
                    quads[Int(particleIndex)]?.bl.color = c
                    
                    quads[Int(particleIndex)]?.br.vertex.x = (currentParticle?.position.x)! + halfSize
                    quads[Int(particleIndex)]?.br.vertex.y = (currentParticle?.position.y)! - halfSize
                    quads[Int(particleIndex)]?.br.color = c
                    
                    quads[Int(particleIndex)]?.tl.vertex.x = (currentParticle?.position.x)! - halfSize
                    quads[Int(particleIndex)]?.tl.vertex.y = (currentParticle?.position.y)! + halfSize
                    quads[Int(particleIndex)]?.tl.color = c
                    
                    quads[Int(particleIndex)]?.tr.vertex.x = (currentParticle?.position.x)! + halfSize
                    quads[Int(particleIndex)]?.tr.vertex.y = (currentParticle?.position.y)! + halfSize
                    quads[Int(particleIndex)]?.tr.color = c
                }
                
                // Update the particle and vertex counters
                particleIndex += 1
            } else {
                
                // As the particle is not alive anymore replace it with the last active particle 
                // in the array and reduce the count of particles by one.  This causes all active particles
                // to be packed together at the start of the array so that a particle which has run out of
                // life will only drop into this clause once
                if (particleIndex != GLint(particleCount) - 1) {
                    particles[Int(particleIndex)] = particles[Int(particleCount) - 1]
                }
                
                particleCount -= 1
            }
        }
    }
    
    func addParticle() {
        
        let particle = Particle()
        
        // Init the position of the particle.  This is based on the source position of the particle emitter
        // plus a configured variance.  The RANDOM_MINUS_1_TO_1 macro allows the number to be both positive
        // and negative
        particle.position.x = sourcePosition.x + sourcePositionVariance.x * Float.random(min: -1, max: 1)
        particle.position.y = sourcePosition.y + sourcePositionVariance.y * Float.random(min: -1, max: 1)
        particle.startPos.x = sourcePosition.x
        particle.startPos.y = sourcePosition.y
        
        // Init the direction of the particle.  The newAngle is calculated using the angle passed in and the
        // angle variance.
        let newAngle: GLfloat = GLKMathDegreesToRadians(angle + angleVariance * Float.random(min: -1, max: 1))
        
        // Create a new GLKVector2 using the newAngle
        let vector: GLKVector2 = GLKVector2Make(cosf(newAngle), sinf(newAngle))
        
        // Calculate the vectorSpeed using the speed and speedVariance which has been passed in
        let vectorSpeed: GLfloat = speed + speedVariance * Float.random(min: -1, max: 1)
        
        // The particles direction vector is calculated by taking the vector calculated above and
        // multiplying that by the speed
        particle.direction = GLKVector2MultiplyScalar(vector, vectorSpeed)
        
        // Calculate the particles life span using the life span and variance passed in
        particle.timeToLive = max(0, particleLifespan + particleLifespanVariance * Float.random(min: -1, max: 1))
        
        let startRadius: Float = maxRadius + maxRadiusVariance * Float.random(min: -1, max: 1)
        let endRadius: Float = minRadius + minRadiusVariance * Float.random(min: -1, max: 1)
        
        // Set the default diameter of the particle from the source position
        particle.radius = startRadius
        particle.radiusDelta = (endRadius - startRadius) / particle.timeToLive
        particle.angle = GLKMathDegreesToRadians(angle + angleVariance * Float.random(min: -1, max: 1))
        particle.degreesPerSecond = GLKMathDegreesToRadians(rotatePerSecond + rotatePerSecondVariance * Float.random(min: -1, max: 1))
        
        particle.radialAcceleration = radialAcceleration + radialAccelVariance * Float.random(min: -1, max: 1)
        particle.tangentialAcceleration = tangentialAcceleration + tangentialAccelVariance * Float.random(min: -1, max: 1)
        
        // Calculate the particle size using the start and finish particle sizes
        let particleStartSize: GLfloat = startParticleSize + startParticleSizeVariance * Float.random(min: -1, max: 1)
        let particleFinishSize: GLfloat = finishParticleSize + finishParticleSizeVariance * Float.random(min: -1, max: 1)
        particle.particleSizeDelta = ((particleFinishSize - particleStartSize) / particle.timeToLive)
        particle.particleSize = max(0, particleStartSize)
        
        // Calculate the color the particle should have when it starts its life.  All the elements
        // of the start color passed in along with the variance are used to calculate the star color
        var start = GLKVector4( v: (0, 0, 0, 0 ))
        start.r = startColor.r + startColorVariance.r * Float.random(min: -1, max: 1)
        start.g = startColor.g + startColorVariance.g * Float.random(min: -1, max: 1)
        start.b = startColor.b + startColorVariance.b * Float.random(min: -1, max: 1)
        start.a = startColor.a + startColorVariance.a * Float.random(min: -1, max: 1)
        
        // Calculate the color the particle should be when its life is over.  This is done the same
        // way as the start color above
        var end = GLKVector4( v: (0, 0, 0, 0 ))
        end.r = finishColor.r + finishColorVariance.r * Float.random(min: -1, max: 1)
        end.g = finishColor.g + finishColorVariance.g * Float.random(min: -1, max: 1)
        end.b = finishColor.b + finishColorVariance.b * Float.random(min: -1, max: 1)
        end.a = finishColor.a + finishColorVariance.a * Float.random(min: -1, max: 1)
        
        // Calculate the delta which is to be applied to the particles color during each cycle of its
        // life.  The delta calculation uses the life span of the particle to make sure that the
        // particles color will transition from the start to end color during its life time.  As the game
        // loop is using a fixed delta value we can calculate the delta color once saving cycles in the
        // update method
        
        particle.color = start
        particle.deltaColor.r = ((end.r - start.r) / particle.timeToLive)
        particle.deltaColor.g = ((end.g - start.g) / particle.timeToLive)
        particle.deltaColor.b = ((end.b - start.b) / particle.timeToLive)
        particle.deltaColor.a = ((end.a - start.a) / particle.timeToLive)
        
        // Calculate the rotation
        let startA: GLfloat = rotationStart + rotationStartVariance * Float.random(min: -1, max: 1)
        let endA: GLfloat = rotationEnd + rotationEndVariance * Float.random(min: -1, max: 1)
        particle.rotation = startA
        particle.rotationDelta = (endA - startA) / particle.timeToLive
        
        
        self.particles[particleCount] = particle
        self.particleCount += 1
    }
    
    func stopParticleEmitter() {
        
        self.active = false
        self.elapsedTime = 0
        self.emitCounter = 0
    }
    
    func reset() {
        
        self.active = true
        self.elapsedTime = 0
        
        for i in 0..<particleCount {
            self.particles[i]??.timeToLive = 0
        }
        self.emitCounter = 0
        self.emissionRate = Float(self.maxParticles) / self.particleLifespan
    }
}
