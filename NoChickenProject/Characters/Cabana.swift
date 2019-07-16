//
//  Cabana.swift
//  No Chicken for Dinner
//
//  Created by Daniel Leal on 22/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class Cabana: SKSpriteNode{
  
  let imagem = SKTexture(imageNamed: "cabana")
  
  init() {
    super.init(texture: imagem, color: .white, size: imagem.size())
    self.zPosition = 1
    self.shadowedBitMask = 1
    self.lightingBitMask = 1
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
