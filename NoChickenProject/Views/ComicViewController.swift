//
//  ComicViewController.swift
//
//  Created by Guilherme Martins Dalosto de Oliveira on 10/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class ComicViewController: UIViewController {

  
  @IBOutlet weak var image: UIImageView!
   var player = AVAudioPlayer()
   var audio = AVAudioPlayer()
   var i = 0
   var dados = UserData()
   var isMusic = Bool()
   var isSound = Bool()

  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    dados.carregarDadosSettings()
    self.isMusic = dados.musica
    self.isSound = dados.sons
    i = 0
    if isMusic{
      let audioPath = Bundle.main.path(forResource: "HistoriaTrack", ofType: "mp3")!
      do {
        try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath) as URL)
        
      } catch {
        
        print("no file sound")
      }
      player.play()
      player.numberOfLoops = -1
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.view.removeFromSuperview()
    self.view = nil
    if (isMusic){
      player.stop()
    }
  }
  
  @IBAction func botaoAvancar(_ sender: UIButton) {
    if (isSound){
      emitirSom()
    }
    i += 1
    print("\(i)")
    if i == 1{
      image.image = UIImage(named: "hq1")
    }
    if i == 2{
      image.image = UIImage(named: "hq2")
    //  image.center.y -= 500
    }
    if i == 3{
      image.image = UIImage(named: "hq3")
   //   image.center.y += 500
    }
    if i == 4{
      weak var storyBoard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
      weak var newViewController = storyBoard!.instantiateViewController(withIdentifier: "Game") as? GameViewController
      self.present(newViewController!, animated: false, completion: {
      self.image.removeFromSuperview()})
    }
  }

  
  @IBAction func avancarTudo(_ sender: UIButton) {
    if (isSound){
      emitirSom()
    }
    weak var storyBoard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
    weak var newViewController = storyBoard!.instantiateViewController(withIdentifier: "Game") as? GameViewController
    self.present(newViewController!, animated: false, completion: {
    self.image.removeFromSuperview()})
    
  }
  
  func emitirSom(){
    if (isSound){
      let CatSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "selecionado", ofType: "mp3")!)
      do {
        audio = try AVAudioPlayer(contentsOf: CatSound as URL)
        audio.prepareToPlay()
      } catch {
        print("Problem in getting File")
      }
      audio.play()
    }
  }

  deinit {
    print("saiu comic view")
  }
  
}
