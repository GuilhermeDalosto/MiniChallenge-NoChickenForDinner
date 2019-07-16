//
//  GameOverScene.swift
//  PestControl
//
//  Created by Guilherme Martins Dalosto de Oliveira on 30/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//
import SpriteKit
import AVFoundation

class GameOverSceneLayer : SKNode {
  
  var dados = UserData()
  var isSound = Bool()
  var isMusic = Bool()
  var base = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("GameOver"))
  var retry = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("Replay10"))
  var menu = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("Home10"))
  var scoreLabel = SKLabelNode(fontNamed: "Kelmscott")
  var scoreLabel2 = SKLabelNode(fontNamed: "Kelmscott")
  var arrayScores = [Int]()
  var bestScore = 0
  
  var deathChicken = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("paiDireita"))
  var deathChickenSon = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("filhoEsquerda"))
  
  var menuView = MenuViewController()
  var gameScene: GameScene?
  
  var timer: Timer?
  var audio = AVAudioPlayer()
  
  func gameOver(scorePlayer :Int, timeSurvive: Int){
    
    
    menuView.addScoreAndSubmitToGC(score: scorePlayer)
    
    base.setScale(0.2)
    base.zPosition = 10000
    base.size = CGSize(width: base.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:base.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    
    retry.setScale(0.5)
    retry.size = CGSize(width: retry.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:retry.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    retry.position.x = -base.size.width/1.22
    retry.position.y = -base.size.height/0.47
    retry.zPosition = 10000
    retry.name = "ReplayButton"
    
    menu.setScale(0.7)
    menu.size = CGSize(width: menu.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:menu.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    menu.position.x = base.size.width/0.87
    menu.position.y = -base.size.height/0.47
    menu.zPosition = 10000
    menu.name = "MenuButton"
    
    scoreLabel.text = "\(scorePlayer)"
    scoreLabel.fontSize = 150
    scoreLabel.position.y = -base.size.height/6
    scoreLabel.position.x = base.size.width/1.5
    scoreLabel.fontColor = .white
    scoreLabel.zPosition = 10000
    
    dados.guardarDadosPlayer(score: scorePlayer)
    dados.carregarDadosPlayer()
    
    self.arrayScores = dados.arrayScore
    if let best = arrayScores.max(){
      self.bestScore = best
    }
    
    scoreLabel2.text = "\(bestScore)"
    scoreLabel2.fontSize = 150
    scoreLabel2.position.y = -base.size.height/1.11
    scoreLabel2.position.x = base.size.width/1.5
    scoreLabel2.fontColor = .white
    scoreLabel2.zPosition = 10000
    
    self.addChild(base)
    base.addChild(retry)
    base.addChild(menu)
    base.addChild(scoreLabel)
    base.addChild(scoreLabel2)
    
  }
  

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches{
      let location = touch.location(in: self)
      let touchedNodes = self.nodes(at: location)

      for touchedNode in touchedNodes{
        if touchedNode.name == "ReplayButton"{
          if (isSound){
            emitirSom()
          }
          
          if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            
            self.scene?.view?.presentScene(scene)
            
          }
        }

        if touchedNode.name == "MenuButton"{
          if (isSound){
            emitirSom()
          }
          gameScene?.cleanScene()
          if let scene = SKScene(fileNamed: "GameScene") {
            self.scene?.view?.presentScene(nil)
          }
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
        }
      }
    }
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

}
