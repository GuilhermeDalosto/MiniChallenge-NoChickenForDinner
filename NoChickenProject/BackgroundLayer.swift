//
//  BackgroundLayer.swift
//  PestControl
//
//  Created by Daniel Leal on 24/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit


class Background: SKNode{

  var background = SKTileMapNode()
  var lightNode = SKLightNode()
  var lightFire = SKLightNode()
  var lightFire2 = SKLightNode()
  var lightFire3 = SKLightNode()
  var lightFire4 = SKLightNode()
  
  var campfire = Campfire(nome: "Campfire")
  var campfire2 = Campfire(nome: "Campfire2")
  var campfire3 = Campfire(nome: "Campfire3")
  var campfire4 = Campfire(nome: "Campfire4")
  
  
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // [weak self]
  
  
  
}
