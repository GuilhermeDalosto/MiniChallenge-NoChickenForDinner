/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit
import SpriteKit


class GameViewController: UIViewController{
  
  var dados = UserData()
  var secondView = Bool()
  var entrouAnuncio = Bool()
  var newViewController: AdsViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    dados.carregarSecond2()
    secondView = dados.second2
    if let view = self.view as! SKView? {
      //view.showsFPS = true
      //view.showsPhysics = true
      //view.showsFields = true
      if let scene = SKScene(fileNamed: "GameScene") as? GameScene{
        scene.gameViewController = self
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        view.presentScene(scene, transition: SKTransition.fade(with: .blue, duration: 1))
      }
      
      view.ignoresSiblingOrder = true
      //view.showsFPS = true
      //view.showsNodeCount = true
    }
  }
  
  override var prefersHomeIndicatorAutoHidden: Bool {
    return true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.entrouAnuncio = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.setarAds()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    if (!entrouAnuncio){
      super.viewDidDisappear(animated)
      print(self.hashValue)
      self.view.removeFromSuperview()
      self.view = nil
    }
  }
  
  func setarAds(){
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    self.newViewController = storyBoard.instantiateViewController(withIdentifier: "Ads") as? AdsViewController
    newViewController?.iniatilizeAds()
  }
  
  
  func goAds(){
    self.entrouAnuncio = true
    self.present(newViewController!, animated: false, completion: nil)
  }
  
  deinit {
    print("saiu gameView")
  }
  
  
}
