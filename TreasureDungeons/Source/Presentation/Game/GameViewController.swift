//
//  ViewController.swift
//  SpecularLight
//
//  Created by burt on 2016. 3. 1..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import UIKit
import GLKit
import SCLAlertView

protocol GameModuleInterface {
    
    func updateView()
}

protocol GameViewInterface {
    
    //func showNoPlayerMessage()
    //func showPlayer(_ player: Player?)
}

class GLKUpdater : NSObject, GLKViewControllerDelegate {
    
    weak var glkViewController : GameViewController!
    
    init(glkViewController : GameViewController) {
        self.glkViewController = glkViewController
    }
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        for model in self.glkViewController.models {
            model.updateWithDelta(self.glkViewController.timeSinceLastUpdate)
        }
        
        self.glkViewController.emitter?.updateWithDelta(self.glkViewController.timeSinceLastUpdate, andFaceTo: self.glkViewController.camera!)
    }
}


class GameViewController: GLKViewController {
    
    // VIPER
    var presenter: GameModuleInterface?
    
    var glkView: GLKView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var overviewLabel: OverviewView!
    var glkUpdater: GLKUpdater!
    var shader: BaseEffect!
    
    // movement
    var lastLocation: CGPoint?
    var movementTime: Timer?
    
    var models: [Model] = []
    
    var camera: Camera?
    
    var emitter: ParticleEmitter?
    
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGLcontext()
        setupGLupdater()
        setupCamera()
        setupScene()
        setupParticleEmitter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        navigationController?.hidesBarsOnSwipe = false
        
        self.presenter?.updateView()
        
        SCLAlertView().showNotice("Hello Notice", subTitle: "This is a more descriptive notice text.") // Notice
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
        
        glCullFace(GLenum(GL_FRONT_AND_BACK))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        // construct view matrix = camera
        if let viewMatrix = camera?.viewMatrix {
            for model in self.models {
                model.render(withParentModelViewMatrix: viewMatrix)
            }
            
            self.emitter?.render(withParentModelViewMatrix: viewMatrix)
        }

        // reset pitch
        self.camera?.reset()
    }
}

extension GameViewController: GameViewInterface {
}

extension GameViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if(touch.view == self.glkView) {
                let location = touch.location(in: self.glkView)
                
                self.lastLocation = location
                self.restartTimer()
            }
        }
    }
    
    func restartTimer() {
        self.movementTime?.invalidate() // stop timer
        self.movementTime = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(GameViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        // go forward
        if let positionOnMap = self.camera?.predictedPositionOnMap {
            if let tileOnMap = self.game?.map?.tile(at: positionOnMap) {
                // collision detection
                if tileOnMap.canAccess() {
                    self.camera?.moveForward()
                    
                    self.positionLabel.text = "\(positionOnMap.x),\(positionOnMap.y) => \(tileOnMap.type)"
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if(touch.view == self.glkView) {
                let location = touch.location(in: self.glkView)
                let translation = self.lastLocation! - location
                
                // pan left / right
                self.camera?.turn(leftAndRight: -Float(translation.x / 80.0))
                
                self.restartTimer()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if(touch.view == self.glkView) {
                let location = touch.location(in: self.glkView)
                let translation = self.lastLocation! - location
                
                // pan left / right
                self.camera?.turn(leftAndRight: -Float(translation.x / 80.0))
                
                self.movementTime?.invalidate() // stop timer
            }
        }
    }
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)
        glkView.drawableDepthFormat = .format16         // for depth testing
        glkView.isUserInteractionEnabled = true
        EAGLContext.setCurrent(glkView.context)
    }
    
    func setupGLupdater() {
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
    }
    
    func setupCamera() {
        self.camera = Camera()
        self.camera?.addChangeListener(changeListener: self.overviewLabel)
    }
    
    func setupScene() {
        self.shader = BaseEffect(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
        
        let aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height)
        self.shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), Float(aspect), 0.1, 100)
        
        self.rebuildDungeon()
        
        self.overviewLabel.game = self.game
        self.overviewLabel.rebuildScene()
    }
    
    func setupParticleEmitter() {
        self.emitter = ParticleEmitter(shader: self.shader)
        
        self.emitter?.addParticle(at: GLKVector3(v: (0.5, 0.0, 0.5)), for: 60.0)
    }
    
    func rebuildDungeon() {
        
        self.models = []
        
        guard self.game?.map != nil else {
            return
        }
        
        if let map = self.game?.map {
            
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
                        case .teleporter:
                            let teleporter0 = Teleporter(shader: self.shader)
                            teleporter0.position = GLKVector3(v: (Float(tile.point.x * 2), 0.0, Float(tile.point.y * 2)))
                            self.models.append(teleporter0)
                            break
                        case .outside:
                            break
                        }
                    }
                }
            }
        }
        
        /*let bottle = Bottle(shader: self.shader)
        bottle.position = GLKVector3(v: (3.0, -1.0, 3.0))
        self.models.append(bottle)*/
        
        /*let diamond = Diamond(shader: self.shader)
        diamond.position = GLKVector3(v: (3.0, -1.0, 3.0))
        self.models.append(diamond)*/
        
        do {
            let key = try Key(shader: self.shader)
            key.position = GLKVector3(v: (3.0, 0.0, 3.0))
            self.models.append(key)
        } catch {
            print("can't load key")
        }
            
        self.models.append(Skybox(shader: self.shader))
    }

}
