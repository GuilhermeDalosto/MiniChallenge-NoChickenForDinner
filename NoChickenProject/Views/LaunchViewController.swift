//
//  GameViewController.swift
//  LaunchingScreen
//
//  Created by Fábio França on 19/06/19.
//  Copyright © 2019 Fábio França. All rights reserved.
//

import UIKit
import SpriteKit

class LaunchViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let view = self.view as! SKView? {
      // Load the SKScene from 'GameScene.sks'
      
      let scene = Launch(size: self.view.bounds.size)
      // Set the scale mode to scale to fit the window
      scene.scaleMode = .aspectFill
      
      // Present the scene
      view.presentScene(scene)
      
      
      view.ignoresSiblingOrder = false
//      view.showsFPS = true
//      view.showsNodeCount = true
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.view.removeFromSuperview()
    self.view = nil
  }
  
  deinit {
    print("saiu view launcher")
  }
  
  
}
