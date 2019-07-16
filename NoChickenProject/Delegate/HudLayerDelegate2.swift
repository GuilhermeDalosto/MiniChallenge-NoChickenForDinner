//
//  HudLayerDelegate2.swift
//  PestControl
//
//  Created by Daniel Leal on 27/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
protocol HudLayerDelegate2 {
  func hudLayer2(_ hudLayer: Hudlayer, attackUsed attack: Bool)
  func hudLayer4(_ hudLayer : Hudlayer, pauseButtonUsed pauseIsOn: Bool)
  func hudLayer5(_ hudLayer: Hudlayer, playButtonUsed playIsOn: Bool)
  func hudLayer6(_ hudLayer: Hudlayer, comboButtonUsed comboIsOn: Bool)
  func hudLayer7(_ hudLayer: Hudlayer, velocity: CGPoint)
  func canRemoveMusic(_hudLayer: Hudlayer, canRemove: Bool) 
  
}
