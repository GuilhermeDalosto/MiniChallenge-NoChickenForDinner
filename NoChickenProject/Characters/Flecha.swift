//
//  Flechas.swift
//  PestControl
//
//  Created by Daniel Leal on 07/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

enum AngularDirection {
  case up
  case down
  case left
  case right
  
  static private let quarter = Double.pi / 2
  
  var radians: CGFloat {
    switch self {
    case .up: return CGFloat(AngularDirection.quarter * 1)
    case .down: return CGFloat(AngularDirection.quarter * 3)
    case .left: return CGFloat(AngularDirection.quarter * 2)
    case .right: return CGFloat(AngularDirection.quarter * 0)
    }
  }
}

class Flecha: SKSpriteNode{
  
  var flechaAtual = 0
  var dano: Int = 5
  var velocidade = Int()
  var rotacao = CGFloat() {
    didSet {
      self.zRotation = self.rotacao
    }
  }
  
  var textureDireita: SKTexture {
    let texture = SKTexture(imageNamed: "FlechaDireita")
    texture.filteringMode = .nearest
    return texture
  }

  var target = CGPoint()
  var moveTo = SKAction()
  var tipoFlecha = 0
  var foiAtirada = false

  
  let flechafire = SKEmitterNode(fileNamed: "FlechaFireVertical.sks")
  let flechafire2 = SKEmitterNode(fileNamed: "FlechaFireHorizontal.sks")
  
  let actionMove = SKAction()
  
  init () {
    let texture = SKTexture(imageNamed: "FlechaDireita")
    texture.filteringMode = .nearest
    super.init(texture: texture, color: .white, size: texture.size())
    self.name = "Flecha"
    setupPhysic()
    zPosition = 25
    self.velocidade = 3
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupPhysic(){
    self.lightingBitMask = 1
    self.physicsBody = SKPhysicsBody(rectangleOf: self.textureDireita.size())
    self.physicsBody?.linearDamping = 1
    self.physicsBody?.friction = 1
    self.physicsBody?.allowsRotation = false
    self.physicsBody?.mass = 0
    self.physicsBody?.usesPreciseCollisionDetection = true
    self.physicsBody?.categoryBitMask = CategoryMask.arrowMask.rawValue
    self.physicsBody?.collisionBitMask = CategoryMask.player.rawValue
    self.physicsBody?.contactTestBitMask = CategoryMask.player.rawValue 
  }
  
  func jogarFlecha (node : SKNode){
    self.moveTo = SKAction.move(to: self.target, duration: TimeInterval(self.velocidade))
    self.run(moveTo) {
      if (self.inParentHierarchy(node)){
        self.flechafire2?.resetSimulation()
        self.flechafire2?.targetNode = nil
        self.flechafire2?.removeFromParent()
        self.removeFromParent()
      }
      self.foiAtirada = false
    }
  }
  
  func setarPosicao(positionGo:CGPoint){
    func rndN(min : Int,max : Int) -> Int{
      let random = Int.random(in: min...max)
      return random
    }
    
    var x = rndN(min: 1, max: 4)
    
    if (x == flechaAtual){ //Verifica se o x é igual ao da flecha anterior gerada, se for, troca
      x = rndN(min: 1, max: 4)
    }
    
    switch x {
    case 1:
      self.position = CGPoint(x: positionGo.x - 600, y: positionGo.y) //Esquerda p/ direita
      self.tipoFlecha = 1
    case 2:
      self.position = CGPoint(x: positionGo.x + 600, y: positionGo.y) //Direita p/ esquerda
      self.tipoFlecha = 2
    case 3:
      self.position = CGPoint(x: positionGo.x, y: positionGo.y + 600) //Cima p/ baixo
      self.tipoFlecha = 3
    case 4:
      self.position = CGPoint(x: positionGo.x, y: positionGo.y - 600) //Baixo p / cima
      self.tipoFlecha = 4
    default:
      break
    }
    flechaAtual = self.tipoFlecha
    self.setarSprite()
  }
  
  func setarSprite(){
    
    flechafire2?.particleRotation = 2.09
    flechafire2?.emissionAngle = 0
    if (flechafire2?.inParentHierarchy(self))!{
      self.flechafire2?.removeFromParent()
    }
    
    if self.tipoFlecha == 1{ // p/ Direita
      self.rotacao = AngularDirection.right.radians
      self.addChild(flechafire2!)
      flechafire2?.emissionAngle = 3.14
    }else if self.tipoFlecha == 2{ // p/ Esquerda
      self.rotacao = AngularDirection.left.radians
 //     flechafire2?.zRotation = -0.87
      flechafire2?.particleRotation = -0.87
      
      self.addChild(flechafire2!)
    }else if self.tipoFlecha == 3{ // p/ Baixo
      self.rotacao = AngularDirection.down.radians
     flechafire2?.particleRotation = 0.61
      flechafire2?.emissionAngle = 1.57
      self.addChild(flechafire2!)
    }else if self.tipoFlecha == 4{ // p/ Alto
      self.rotacao = AngularDirection.up.radians
      flechafire2?.particleRotation = -2.61
      flechafire2?.emissionAngle = 4.71
      self.addChild(flechafire2!)
    }
    self.flechafire2?.position.x = 290
    self.setScale(0.07)
    self.size = CGSize(width: self.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:self.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
  
  
    self.flechafire2?.targetNode = self

  }
  
  func setarAtirarFlecha(position: CGPoint, node : SKNode){
    node.addChild(self)
    self.setarPosicao(positionGo: position)
    self.jogarFlecha(node: node)
    self.foiAtirada = true
  }
  
  
}
