//
//  GameOverDelegate.swift
//  PestControl
//
//  Created by Daniel Leal on 31/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
protocol GameOverDelegate {
  func gameover(_gameoverLayer: GameOverSceneLayer, removeScene remove: Bool)
}
