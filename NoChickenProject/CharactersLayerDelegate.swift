//
//  CharactersLayerDelegate.swift
//  PestControl
//
//  Created by Daniel Leal on 28/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
protocol CharactersLayerDelegate {
  
  func charLayer(_ charLayer: CharactersLayer, player: Player, enemyMale: [Enemy], enemyFemale: [Enemy], son: Son, weapon: Weapon)
  
  
}
