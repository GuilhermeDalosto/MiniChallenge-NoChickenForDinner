//
//  GameScene.swift
//  LaunchingScreen
//
//  Created by Fábio França on 19/06/19.
//  Copyright © 2019 Fábio França. All rights reserved.
//

import SpriteKit
import GameplayKit

class Launch: SKScene {
  let cameraNode = SKCameraNode() //Criacao do node que sera a camera
  
  let background = SKSpriteNode(imageNamed: "fundoAzul")
  let label = SKSpriteNode(imageNamed: "HiFolks")
  let fabio = SKSpriteNode(imageNamed: "branco")
  let nunu = SKSpriteNode(imageNamed: "laranja")
  let daniel = SKSpriteNode(imageNamed: "azul")
  let adriano = SKSpriteNode(imageNamed: "preto")
  let gui = SKSpriteNode(imageNamed: "rosa")
  
  let actionDescer = SKAction.moveTo(y: UIScreen.main.bounds.size.height/5, duration: 0.7)
  let actionRolar1 = SKAction.rotate(byAngle: -6.28319, duration: 0.7)
  let actionRolar2 = SKAction.rotate(byAngle: 6.28319, duration: 0.7)
  let actionCrescer = SKAction.scale(to: 0.5, duration: 0.7)
  var actions = Array<SKAction>()
  var groupActionsRolar = SKAction()
  var groupActionsCair = SKAction()
  
  var totalSeconds:Int = 0
  let layerFinish = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width*1.5, height: UIScreen.main.bounds.size.height*1.5))
  let actionFinish = SKAction.fadeAlpha(to: 1, duration: 1)
  
  // --------------------------------------------------
  override func didMove(to view: SKView) {
  
    restartTimer()
    
    self.camera = self.cameraNode //Configurando o node da camera como camera da cena
    self.cameraNode.position = CGPoint(x: self.size.width/2, y: self.size.height/2)//Configurando a posicao inicial da camera
    
    self.layerFinish.zPosition = 2000
    self.layerFinish.alpha = 0
    self.layerFinish.fillColor = .black
    self.layerFinish.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
    addChild(layerFinish)
    
    self.background.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    self.background.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
    self.addChild(self.background)
    
    label.setScale(0.6)
    self.label.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
    addChild(label)
    
    fabio.setScale(0.25)
    fabio.position = CGPoint(x: UIScreen.main.bounds.size.width/2.26, y: UIScreen.main.bounds.size.height/1.68)
    fabio.zPosition = 1
    addChild(fabio)
    
    gui.setScale(0.25)
    gui.position = CGPoint(x: UIScreen.main.bounds.size.width/2.26, y: UIScreen.main.bounds.size.height/1.68)
    gui.zPosition = 2
    addChild(gui)
    
    nunu.setScale(0.25)
    nunu.position = CGPoint(x: UIScreen.main.bounds.size.width/2.26, y: UIScreen.main.bounds.size.height/1.68)
    nunu.zPosition = 3
    addChild(nunu)
    
    daniel.setScale(0.25)
    daniel.position = CGPoint(x: UIScreen.main.bounds.size.width/2.26, y: UIScreen.main.bounds.size.height/1.68)
    daniel.zPosition = 4
    addChild(daniel)
    
    adriano.setScale(0.25)
    adriano.position = CGPoint(x: UIScreen.main.bounds.size.width/2.26, y: UIScreen.main.bounds.size.height/1.68)
    adriano.zPosition = 5
    addChild(adriano)
    
    // --------------------------------------------------
    actions.append(actionCrescer)
    actions.append(actionDescer)
    groupActionsCair = SKAction.group(actions)
    actions.removeAll()
    actions.append(actionRolar1)
    actions.append(SKAction.moveTo(x: UIScreen.main.bounds.size.width/1.35, duration: 0.7))
    groupActionsRolar = SKAction.group(actions)
    adriano.run(SKAction.sequence([groupActionsCair,groupActionsRolar]))
    
    actions.removeAll()
    actions.append(actionCrescer)
    actions.append(actionDescer)
    groupActionsCair = SKAction.group(actions)
    actions.removeAll()
    actions.append(actionRolar2)
    actions.append(SKAction.moveTo(x: UIScreen.main.bounds.size.width/3.7, duration: 0.7))
    groupActionsRolar = SKAction.group(actions)
    daniel.run(SKAction.sequence([SKAction.wait(forDuration: 0.7),groupActionsCair,groupActionsRolar]))
    
    actions.removeAll()
    actions.append(actionCrescer)
    actions.append(actionDescer)
    groupActionsCair = SKAction.group(actions)
    actions.removeAll()
    actions.append(actionRolar1)
    actions.append(SKAction.moveTo(x: UIScreen.main.bounds.size.width/1.6, duration: 0.7))
    groupActionsRolar = SKAction.group(actions)
    nunu.run(SKAction.sequence([SKAction.wait(forDuration: 1.4),groupActionsCair,groupActionsRolar]))
    
    actions.removeAll()
    actions.append(actionCrescer)
    actions.append(actionDescer)
    groupActionsCair = SKAction.group(actions)
    actions.removeAll()
    actions.append(actionRolar2)
    actions.append(SKAction.moveTo(x: UIScreen.main.bounds.size.width/2.6, duration: 0.7))
    groupActionsRolar = SKAction.group(actions)
    gui.run(SKAction.sequence([SKAction.wait(forDuration: 2.1),groupActionsCair,groupActionsRolar]))
    
    actions.removeAll()
    actions.append(actionCrescer)
    actions.append(actionDescer)
    groupActionsCair = SKAction.group(actions)
    actions.removeAll()
    actions.append(actionRolar1)
    actions.append(SKAction.moveTo(x: UIScreen.main.bounds.size.width/2, duration: 0.7))
    groupActionsRolar = SKAction.group(actions)
    fabio.run(SKAction.sequence([SKAction.wait(forDuration: 2.8),groupActionsCair,groupActionsRolar]))
    
    layerFinish.run(SKAction.sequence([SKAction.wait(forDuration: 3.8),actionFinish]))

  }
  
  func restartTimer(){
    
    let wait:SKAction = SKAction.wait(forDuration: 1)
    let finishTimer:SKAction = SKAction.run {
      self.totalSeconds += 1
      self.restartTimer()
    }
    let seq:SKAction = SKAction.sequence([wait, finishTimer])
    self.run(seq)

  }
  
  
  func touchDown(atPoint pos : CGPoint) {
    
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  
  override func update(_ currentTime: TimeInterval) {
    if self.totalSeconds == 5{
      let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let newViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.window?.rootViewController = newViewController

    }
  }
  
  func cleanScene() {
    if let s = self.view?.scene {
      
      NotificationCenter.default.removeObserver(self)
      self.children
        .forEach {
          $0.removeAllActions()
          $0.removeAllChildren()
          $0.removeFromParent()
      }
      s.removeAllActions()
      s.removeAllChildren()
      s.removeFromParent()
    }
  }
  
  
  deinit {
    print("saiu launcher")
    cleanScene()
  }
}
