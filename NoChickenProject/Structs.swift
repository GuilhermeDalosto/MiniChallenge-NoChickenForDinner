//
//  Structs.swift
//  No Chicken for Dinner
//
//  Created by Daniel Leal on 28/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

struct Utils {
  private init() { }
  
  struct Actions {
    private init() { }
    
    static let timeTurnCampfire = SKAction.wait(forDuration: 10) //Fogueira
    static let timerQuick = SKAction.wait(forDuration: 0.1)
    static let timerHalfSecond = SKAction.wait(forDuration: 0.5)
    static let timerTwoSeconds = SKAction.wait(forDuration: 2)
    static let timerThreeSeconds = SKAction.wait(forDuration: 3)
    static let timerFourSeconds = SKAction.wait(forDuration: 4)
    static let waitAttack = SKAction.wait(forDuration: 0.2)
  }
  
  struct Size {
    private init() { }
    static let screenSize = UIScreen.main.bounds.size
  }
  
  struct Atlas{
    static let sprites = SKTextureAtlas(named: "Sprites")
  }
  

}
