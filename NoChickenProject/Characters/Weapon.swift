//
//  Weapon.swift
//  PestControl
//
//  Created by Daniel Leal on 27/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
class Weapon: SKSpriteNode{
  
  var constraitPlayer = SKConstraint()
  
  init(nome: String) {
    let texture = Utils.Atlas.sprites.textureNamed(nome)
    super.init(texture: texture, color: .white,
               size: texture.size())
    name = nome
    zPosition = -100
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Use init()")
  }
  
  func setupPhysics (){
    physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width/2, height: self.size.height))
    physicsBody?.linearDamping = 1
    physicsBody?.friction = 1
    physicsBody?.allowsRotation = false
    physicsBody?.mass = 1
    physicsBody?.usesPreciseCollisionDetection = true
    physicsBody?.categoryBitMask = CategoryMask.sword.rawValue
  }
  var imagemUm = Utils.Atlas.sprites.textureNamed("weapon")
  var imagemDois = Utils.Atlas.sprites.textureNamed("weaponR")
  
  func virar(node : SKSpriteNode, lado : Int, player: Player){
    if lado == 1{
      self.texture = imagemUm
      self.constraitPlayer = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: 0), to: CGPoint(x: -450, y: 0))
      self.constraints = [self.constraitPlayer]
    }else{
      self.texture = imagemDois
      self.constraitPlayer = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: 0), to: CGPoint(x: +450, y: 0))
      self.constraints = [self.constraitPlayer]
    }
  }
}
