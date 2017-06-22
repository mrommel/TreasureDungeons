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
    
    weak var glkViewController : GameViewController!
    
    init(glkViewController : GameViewController) {
        self.glkViewController = glkViewController
    }
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        for model in self.glkViewController.models {
            model.updateWithDelta(self.glkViewController.timeSinceLastUpdate)
        }
    }
}


class GameViewController: GLKViewController {
    
    var glkView: GLKView!
    var glkUpdater: GLKUpdater!
    var shader: BaseEffect!
    
    var models: [Model] = []
    
    var pitch: Float = 0
    var yaw: Float = 0
    var roll: Float = 0
    var x: Float = 0
    var y: Float = -5
    
    var map: Map? {
        didSet {
            rebuildDungeon()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGLcontext()
        setupGLupdater()
        setupScene()
        
        let map = Map(width: 4, height: 4)
        
        map.tiles[0, 0] = Tile(point: Point(x: 0, y: 0), type: .wall)
        map.tiles[0, 1] = Tile(point: Point(x: 0, y: 1), type: .wall)
        map.tiles[0, 2] = Tile(point: Point(x: 0, y: 2), type: .floor)
        map.tiles[0, 3] = Tile(point: Point(x: 0, y: 3), type: .floor)
        
        map.tiles[1, 0] = Tile(point: Point(x: 1, y: 0), type: .floor)
        map.tiles[1, 1] = Tile(point: Point(x: 1, y: 1), type: .floor)
        map.tiles[1, 2] = Tile(point: Point(x: 1, y: 2), type: .floor)
        map.tiles[1, 3] = Tile(point: Point(x: 1, y: 3), type: .wall)
        
        map.tiles[2, 0] = Tile(point: Point(x: 2, y: 0), type: .wall)
        map.tiles[2, 1] = Tile(point: Point(x: 2, y: 1), type: .floor)
        map.tiles[2, 2] = Tile(point: Point(x: 2, y: 2), type: .floor)
        map.tiles[2, 3] = Tile(point: Point(x: 2, y: 3), type: .wall)
        
        map.tiles[3, 0] = Tile(point: Point(x: 3, y: 0), type: .floor)
        map.tiles[3, 1] = Tile(point: Point(x: 3, y: 1), type: .floor)
        map.tiles[3, 2] = Tile(point: Point(x: 3, y: 2), type: .floor)
        map.tiles[3, 3] = Tile(point: Point(x: 3, y: 3), type: .wall)
        
        self.map = map
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

extension GameViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)
        glkView.drawableDepthFormat = .format16         // for depth testing
        EAGLContext.setCurrent(glkView.context)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(gestureRecognizer:)))
        tapRecognizer.delegate = self
        glkView.addGestureRecognizer(tapRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target:self, action: #selector(GameViewController.pinchDetected(gestureRecognizer:)))
        pinchRecognizer.delegate = self
        glkView.addGestureRecognizer(pinchRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action: #selector(GameViewController.panDetected(gestureRecognizer:)))
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
        
        self.rebuildDungeon()
    }
    
    func rebuildDungeon() {
        
        self.models = []
        
        guard self.map != nil else {
            return
        }
        
        if let map = self.map {
            
            for x in 0..<map.tiles.columnCount() {
                for y in 0..<map.tiles.rowCount() {
                    
                    if let tile = map.tiles[x, y] {
                    
                        switch tile.type {
                        case .floor:
                            let floor0 = Floor(shader: self.shader)
                            floor0.position = GLKVector3(v: (Float(tile.point.x * 2), 0.0, Float(tile.point.y * 2)))
                            self.models.append(floor0)
                            break
                        case .wall:
                            let wall0 = Wall(shader: self.shader)
                            wall0.position = GLKVector3(v: (Float(tile.point.x * 2), 0.0, Float(tile.point.y * 2)))
                            self.models.append(wall0)
                            break
                        }
                    }
                }
            }
            
        }
        
        /*self.models.append(Cube(shader: self.shader))
        
        let wall0 = Wall(shader: self.shader)
        wall0.position = GLKVector3(v: (5.0, 0.0, 0.0))
        self.models.append(wall0)
        
        let floor0 = Floor(shader: self.shader)
        floor0.position = GLKVector3(v: (-1.0, 0.0, -1.0))
        self.models.append(floor0)*/
    }
    
}

extension GameViewController: UIGestureRecognizerDelegate {
    
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
