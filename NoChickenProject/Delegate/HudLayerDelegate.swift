//
//  HudLayer_Delegate.swift
//  PestControl
//
//  Created by Daniel Leal on 27/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
protocol HudLayerDelegate {
  func hudLayer(_ hudLayer: Hudlayer, didMovePlayerTo position: CGPoint, flipTo side: Int)
  
  func hudLayer2(_ hudLayer: Hudlayer, attackUsed attack: Bool)
  
  func hudLayer3(_ hudLayer: Hudlayer, touchesBegan touched: Bool)
  

}
