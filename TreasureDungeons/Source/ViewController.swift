//
//  ViewController.swift
//  SpecularLight
//
//  Created by burt on 2016. 3. 1..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import UIKit
import GLKit

class GLKUpdater : NSObject, GLKViewControllerDelegate {
    
    weak var glkViewController : ViewController!
    
    init(glkViewController : ViewController) {
        self.glkViewController = glkViewController
    }
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        for model in self.glkViewController.models {
            model.updateWithDelta(self.glkViewController.timeSinceLastUpdate)
        }
    }
}


class ViewController: GLKViewController {
    
    var glkView: GLKView!
    var glkUpdater: GLKUpdater!
    var shader: BaseEffect!
    
    var models: [Model] = []
    
    var pitch: Float = 0
    var yaw: Float = 0
    var roll: Float = 0
    var x: Float = 0
    var y: Float = -5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGLcontext()
        setupGLupdater()
        setupScene()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        //Transfomr4: Viewport: Normalized -> Window
        //glViewport(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        glClearColor(0.2, 0.2, 0.2, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        //let viewMatrix: GLKMatrix4 = GLKMatrix4Rotate(GLKMatrix4MakeTranslation(0, 0, -5), GLKMathDegreesToRadians(self.rotation), 1, 1, 0)
        var viewMatrix: GLKMatrix4 = GLKMatrix4Identity
        
        //viewMatrix = GLKMatrix4RotateX(viewMatrix, GLKMathDegreesToRadians(20))
        viewMatrix = GLKMatrix4RotateX(viewMatrix, GLKMathDegreesToRadians(self.pitch))
        viewMatrix = GLKMatrix4RotateY(viewMatrix, GLKMathDegreesToRadians(self.yaw))
        viewMatrix = GLKMatrix4RotateZ(viewMatrix, GLKMathDegreesToRadians(self.roll))
        viewMatrix = GLKMatrix4Translate(viewMatrix, self.x, 0, self.y)
        
        
        for model in self.models {
            model.renderWithParentModelViewMatrix(viewMatrix)
        }
        
        // reset pitch
        self.pitch = self.pitch * 0.9
    }
    
}

extension ViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)
        glkView.drawableDepthFormat = .format16         // for depth testing
        EAGLContext.setCurrent(glkView.context)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(gestureRecognizer:)))
        tapRecognizer.delegate = self
        glkView.addGestureRecognizer(tapRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target:self, action: #selector(ViewController.pinchDetected(gestureRecognizer:)))
        pinchRecognizer.delegate = self
        glkView.addGestureRecognizer(pinchRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action: #selector(ViewController.panDetected(gestureRecognizer:)))
        panRecognizer.delegate = self
        glkView.addGestureRecognizer(panRecognizer)
    }
    
    func setupGLupdater() {
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
    }
    
    func setupScene() {
        self.shader = BaseEffect(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
        
        self.shader.projectionMatrix = GLKMatrix4MakePerspective(
            GLKMathDegreesToRadians(85.0),
            GLfloat(self.view.bounds.size.width / self.view.bounds.size.height),
            1,
            150)
        
        self.models.append(Cube(shader: self.shader))
        
        /*let secondCube = Cube(shader: self.shader)
        secondCube.position = GLKVector3(v: (5.0, 0.0, 0.0))
        self.models.append(secondCube)*/
        
        let wall0 = Wall(shader: self.shader)
        wall0.position = GLKVector3(v: (5.0, 0.0, 0.0))
        self.models.append(wall0)
        
        let floor0 = Floor(shader: self.shader)
        floor0.position = GLKVector3(v: (-1.0, 0.0, -1.0))
        self.models.append(floor0)
    }
    
}

extension ViewController: UIGestureRecognizerDelegate {
    
    func panDetected(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: self.view)
        
        if fabs(translation.x) < fabs(translation.y) {
            // pan up / down 
            if translation.y < 0 {
                self.pitch += 0.5
            } else {
                self.pitch -= 0.5
            }
        } else {
            // pan left / right
            if translation.x < 0 {
                self.yaw += 1.0
            } else {
                self.yaw -= 1.0
            }
        }
    }
    
    func pinchDetected(gestureRecognizer: UIGestureRecognizer) {
        //print("pinch")
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        // go forward
        self.x -= sin(GLKMathDegreesToRadians(self.yaw)) * 0.5
        self.y += cos(GLKMathDegreesToRadians(self.yaw)) * 0.5
        
        // TODO: collision detection
    }
}
