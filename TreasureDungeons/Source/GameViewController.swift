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
    @IBOutlet weak var positionLabel: UILabel!
    var glkUpdater: GLKUpdater!
    var shader: BaseEffect!
    
    var models: [Model] = []
    
    var pitch: Float = 0
    var yaw: Float = 0
    var roll: Float = 0
    var x: Float = -2
    var y: Float = -2
    
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
        
        let map = Map(width: 5, height: 7)
        
        map.tiles[0, 0] = Tile(at: Point(x: 0, y: 0), type: .wall)
        map.tiles[0, 1] = Tile(at: Point(x: 0, y: 1), type: .wall)
        map.tiles[0, 2] = Tile(at: Point(x: 0, y: 2), type: .wall)
        map.tiles[0, 3] = Tile(at: Point(x: 0, y: 3), type: .wall)
        map.tiles[0, 4] = Tile(at: Point(x: 0, y: 4), type: .wall)
        map.tiles[0, 5] = Tile(at: Point(x: 0, y: 5), type: .wall)
        map.tiles[0, 6] = Tile(at: Point(x: 0, y: 6), type: .wall)
        
        map.tiles[1, 0] = Tile(at: Point(x: 1, y: 0), type: .wall)
        map.tiles[1, 1] = Tile(at: Point(x: 1, y: 1), type: .floor)
        map.tiles[1, 2] = Tile(at: Point(x: 1, y: 2), type: .floor)
        map.tiles[1, 3] = Tile(at: Point(x: 1, y: 3), type: .floor)
        map.tiles[1, 4] = Tile(at: Point(x: 1, y: 4), type: .wall)
        map.tiles[1, 5] = Tile(at: Point(x: 1, y: 5), type: .floor)
        map.tiles[1, 6] = Tile(at: Point(x: 1, y: 6), type: .wall)
        
        map.tiles[2, 0] = Tile(at: Point(x: 2, y: 0), type: .floor)
        map.tiles[2, 1] = Tile(at: Point(x: 2, y: 1), type: .floor)
        map.tiles[2, 2] = Tile(at: Point(x: 2, y: 2), type: .floor)
        map.tiles[2, 3] = Tile(at: Point(x: 2, y: 3), type: .floor)
        map.tiles[2, 4] = Tile(at: Point(x: 2, y: 4), type: .floor)
        map.tiles[2, 5] = Tile(at: Point(x: 2, y: 5), type: .floor)
        map.tiles[2, 6] = Tile(at: Point(x: 2, y: 6), type: .wall)
        
        map.tiles[3, 0] = Tile(at: Point(x: 3, y: 0), type: .wall)
        map.tiles[3, 1] = Tile(at: Point(x: 3, y: 1), type: .floor)
        map.tiles[3, 2] = Tile(at: Point(x: 3, y: 2), type: .floor)
        map.tiles[3, 3] = Tile(at: Point(x: 3, y: 3), type: .floor)
        map.tiles[3, 4] = Tile(at: Point(x: 3, y: 4), type: .wall)
        map.tiles[3, 5] = Tile(at: Point(x: 3, y: 5), type: .floor)
        map.tiles[3, 6] = Tile(at: Point(x: 3, y: 6), type: .wall)
        
        map.tiles[4, 0] = Tile(at: Point(x: 4, y: 0), type: .wall)
        map.tiles[4, 1] = Tile(at: Point(x: 4, y: 1), type: .wall)
        map.tiles[4, 2] = Tile(at: Point(x: 4, y: 2), type: .wall)
        map.tiles[4, 3] = Tile(at: Point(x: 4, y: 3), type: .wall)
        map.tiles[4, 4] = Tile(at: Point(x: 4, y: 4), type: .wall)
        map.tiles[4, 5] = Tile(at: Point(x: 4, y: 5), type: .wall)
        map.tiles[4, 6] = Tile(at: Point(x: 4, y: 6), type: .wall)
        
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
        
        // construct view matrix = camera
        var viewMatrix: GLKMatrix4 = GLKMatrix4Identity
        viewMatrix = GLKMatrix4RotateX(viewMatrix, GLKMathDegreesToRadians(self.pitch))
        viewMatrix = GLKMatrix4RotateY(viewMatrix, GLKMathDegreesToRadians(self.yaw))
        viewMatrix = GLKMatrix4RotateZ(viewMatrix, GLKMathDegreesToRadians(self.roll))
        viewMatrix = GLKMatrix4Translate(viewMatrix, self.x, 0, self.y)
        
        for model in self.models {
            model.renderWithParentModelViewMatrix(viewMatrix)
        }
        
        // reset pitch
        self.pitch = self.pitch * 0.95
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
        
        let aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height)
        self.shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), Float(aspect), 0.1, 100)
        
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
                        case .outside:
                            break
                        }
                    }
                }
            }
            
        }
        
        self.models.append(Skybox(shader: self.shader))
        
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
        let newX = self.x - sin(GLKMathDegreesToRadians(self.yaw)) * 0.5
        let newY = self.y + cos(GLKMathDegreesToRadians(self.yaw)) * 0.5
        
        let positionOnMap = Point(x: -Int((newX - 1.0) / 2.0) , y: -Int((newY - 1.0) / 2.0))
        
        let tileOnMap = self.map?.tile(at: positionOnMap)
        
        if let tileOnMap = tileOnMap {
            
            // collision detection
            if tileOnMap.canAccess() {
                self.x = newX
                self.y = newY
         
                self.positionLabel.text = "\(positionOnMap.x),\(positionOnMap.y) => \(tileOnMap.type)"
            }
        }
    }
}
