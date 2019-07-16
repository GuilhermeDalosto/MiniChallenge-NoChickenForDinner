//
//  HudLayer.swift
//  PestControl
//
//  Created by Daniel Leal on 24/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation


class Hudlayer: SKNode{
  var delegate:HudLayerDelegate?
  var delegate2:HudLayerDelegate2?
  var delegate3:HudLayerDelegate?
  
  var buttonIsOn = false
  var timeLabel = SKLabelNode()
  var playButton = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("Play"))  //Para acessar na game scene
  var attackButton =  SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("Attack"))//Para acessar na game scene
  var pauseButton =  SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("Pause")) //Para acessar na game scene
  var foiPausado = false
  var botaoCombo = SKSpriteNode()
  
  
  var placaPause = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("placaPause"))
  var placaplay = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("placaPlay"))
  var menu = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("Home10"))
  var audio = AVAudioPlayer()
  
  var player = Player()
  var labelFilho = SKLabelNode()
  var hpFranguin = SKLabelNode()
  var lado = 0
  var isSound = Bool()
  var isMusic = Bool()
  
  var game: GameScene?

  
  //HP
  var healthBar = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("HP"))
  var healthBar2 = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("HP"))
  var img = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("iconePai"))
  var img2 = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("iconeFilho"))
  
  //Botao joystick
  lazy var analogJoystick: AnalogJoystick = {
    let js = AnalogJoystick(diameter: (Utils.Size.screenSize.width/Utils.Size.screenSize.height)*162.03, colors: nil, images: (substrate: UIImage(named: "Base"), stick: UIImage(named: "Stick")))
    js.zPosition = 500
    return js
  }()
  
  
  func setupJoystick(player: Player){
    self.addChild(analogJoystick)
    
    analogJoystick.trackingHandler = { [unowned self] data in
      if (data.velocity.x.isLess(than: 0)){//Sprite esquerdo
        self.lado = 1
        
      }else if (!(data.velocity.x.isLess(than: 0))){ //Sprite direito
        self.lado = -1
      }
      let positionPlayer = CGPoint(x: player.position.x + (data.velocity.x * 0.05),
                                   y: player.position.y + (data.velocity.y * 0.05))
      
      self.delegate?.hudLayer(self, didMovePlayerTo: positionPlayer, flipTo: self.lado)
      self.delegate?.hudLayer3(self, touchesBegan: true)
    }

    analogJoystick.setScale(0.5)
    analogJoystick.position = CGPoint(x: player.position.x - 300, y: -(Utils.Size.screenSize.height/3.2))
    
    analogJoystick.position = CGPoint(x: -(self.scene?.size.width)!/3.5, y: -(self.scene?.size.height)!/7)
    
    // over here
    analogJoystick.stopHandler = {
      self.delegate?.hudLayer3(self, touchesBegan: false)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches{
      let location = touch.location(in: self)
      let touchedNodes = self.nodes(at: location)
      for touchedNode in touchedNodes{
        if touchedNode.name == "attackButton" && self.foiPausado == false{
          self.delegate?.hudLayer2(self, attackUsed: true)   //Enviar pra characters layer
          self.delegate2?.hudLayer2(self, attackUsed: true)  //Enviar pra game scene
          self.delegate3?.hudLayer2(self, attackUsed: true)  //Para tutorial
        }
        if touchedNode.name == "pauseButton" && self.foiPausado == false{ //Pausou o game
          self.delegate2?.hudLayer4(self, pauseButtonUsed: true)
          self.addPlay()
          self.pauseButton.removeFromParent()
          self.placaPause.removeFromParent()
          self.foiPausado = true
          if (isSound){
            emitirSom()
          }
        }
        if touchedNode.name == "PlayButton" { //Voltou ao game
          self.delegate2?.hudLayer5(self, playButtonUsed: true)
          self.placaplay.removeFromParent()
          self.playButton.removeFromParent()
          self.menu.removeFromParent()
          self.addPause()
          self.foiPausado = false
          if (isSound){
            emitirSom()
          }
        }
        if touchedNode.name == "comboButton" {
          self.delegate2?.hudLayer6(self, comboButtonUsed: true)
        }
        if touchedNode.name == "MenuButton"{
          if (isSound){
            emitirSom()
          }
          delegate2?.canRemoveMusic(_hudLayer: self, canRemove: true)
          self.game?.cleanScene()
          if let scene = SKScene(fileNamed: "GameScene") {
            self.scene?.view?.presentScene(nil)  
          }
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
          
        }
      }
    }
  }


  //Botao de ataque
  func setupAttack (){
    let attackButton:SKSpriteNode = {
      let attack = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("Attack"))
      attack.position = CGPoint(x: +(self.scene?.size.width)!/3.5, y: -(self.scene?.size.height)!/7)
      attack.zPosition = 500
      attack.name = "attackButton"
      attack.size = CGSize(width: attack.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:attack.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
      attack.setScale(0.16)
      return attack
    }()
    
   
    self.attackButton = attackButton
    self.addChild(attackButton)
  }

  
  //Pause button
  func setupPause(){
    self.placaPause.position = CGPoint(x: -(self.scene?.size.width)!/2.3, y: (self.scene?.size.height)!/8)
    self.placaPause.setScale(0.05)
    self.placaPause.size = CGSize(width: placaPause.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:placaPause.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    self.placaPause.zPosition = 500
    
    pauseButton.name = "pauseButton"
    pauseButton.position = CGPoint(x: self.placaPause.size.width/0.9, y: -(self.placaPause.size.height/0.5))
    pauseButton.zPosition = 500
    pauseButton.setScale(7)
    pauseButton.size = CGSize(width: pauseButton.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:pauseButton.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)

  }
  
  func addPause (){
    self.placaPause.alpha = 1
    self.addChild(self.placaPause)
    self.placaPause.addChild(self.pauseButton)
  }
  
  //Quando foi pausado
  func setupPlay(){
    
    self.placaplay.position = CGPoint(x: self.frame.width, y: self.frame.height)
    self.placaplay.setScale(0.3)
    self.placaplay.zPosition = 10000
    
    playButton.setScale(0.4)
    playButton.size = CGSize(width: playButton.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:playButton.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    playButton.position.x = self.placaplay.size.width/3.5
    playButton.position.y = -self.placaplay.size.height/2.7
    playButton.zPosition = 10000
    playButton.name = "PlayButton"
    
    menu.name = "MenuButton"
    menu.position.x = -self.placaplay.size.width/3.5
    menu.position.y = -self.placaplay.size.height/2.7
    menu.setScale(0.8)
    menu.size = CGSize(width: menu.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:menu.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    menu.zPosition = 10000
    
  }
  
  func addPlay(){
    self.addChild(placaplay)
    self.placaplay.addChild(playButton)
    self.placaplay.addChild(menu)
  }
  
  func setupTimeLabel(positionx: CGSize){
    timeLabel.text = "0"
    timeLabel.position.x = self.frame.width/2
    timeLabel.position.y = (self.scene?.size.height)!/5.5
    timeLabel.fontColor = .white
    timeLabel.fontSize = 30
    timeLabel.fontName = "Kelmscott"
    timeLabel.zPosition = 500
    self.addChild(timeLabel)
  }
  
  func setTimeLabel(position: CGSize, timeAux: Int){
    timeLabel.text = "\(timeAux)"
  }
  
  func setupHealth(){

    self.healthBar.position  = CGPoint(x: -(self.scene?.size.width)!/2.5, y: +(self.scene?.size.height)!/5)
    self.healthBar.size = CGSize(width: healthBar.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:healthBar.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    self.healthBar.anchorPoint = CGPoint(x: 0, y: 0.5)

    self.zPosition = 500
    self.addChild(healthBar)
   
    self.healthBar2.position = CGPoint(x: +(self.scene?.size.width)!/2.5, y: +(self.scene?.size.height)!/5)
    self.healthBar2.size = CGSize(width: healthBar2.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:healthBar2.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    self.healthBar2.anchorPoint = self.healthBar.anchorPoint
    self.healthBar2.xScale = -1
    self.zPosition = 500
    self.addChild(healthBar2)
    
  }
  
  func setupIcon(){
    self.img.position = CGPoint(x: -(self.scene?.size.width)!/2.4, y: +(self.scene?.size.height)!/5)
    self.img.setScale(0.06)
    self.img.size = CGSize(width: img.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:img.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    self.img.zPosition = 500
    
    self.addChild(img)
    
    print("icone - \(img.size)")
    
    self.img2.position = CGPoint(x: +(self.scene?.size.width)!/2.4, y: +(self.scene?.size.height)!/5)
    self.img2.setScale(0.06)
    self.img2.size = CGSize(width: img2.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:img2.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
    self.img2.zPosition = 500
    
    self.addChild(img2)
    
  }
  
  func decHp2(mult: Int){
    for _ in 1...mult{
      self.healthBar2.xScale += 0.025
    }
    
    
  }
  
  func decHp(mult: Int){
    for _ in 1...mult{
      self.healthBar.xScale -= 0.025
    }
  }
  
  func setupCombo(){
    let buttonCombo:SKSpriteNode = {
      let combo = SKSpriteNode (texture: Utils.Atlas.sprites.textureNamed("ComboNormal"))
      combo.position = CGPoint(x: +(self.scene?.size.width)!/3.0, y: -((self.scene?.size.height)!)/33)
      combo.size = CGSize(width: combo.size.width/Utils.Size.screenSize.width*Utils.Size.screenSize.width , height:combo.size.height/Utils.Size.screenSize.height*Utils.Size.screenSize.height)
      combo.alpha = 0.4
      combo.zPosition = 500
      combo.name = "comboButton"
      combo.setScale(0.10)
      return combo
    }()
    self.botaoCombo = buttonCombo
    self.addChild(botaoCombo)
  }
  
  //Combo
  var changeTheLight = SKAction()
  var changeTheLightReturn = SKAction()
  var changeTheLightSequence = SKAction()
  let luzAux3 = SKLightNode()
  var changeSize = SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.12, duration: 0.4), SKAction.scale(to: 0.13, duration: 0.4)]))
  var jaTemLuz = false
  
  func setarLuz3(){
    luzAux3.categoryBitMask = 1
    luzAux3.falloff = 4
    luzAux3.lightColor = .orange
    luzAux3.ambientColor = .black
    luzAux3.xScale = self.botaoCombo.xScale/2
    luzAux3.yScale = self.botaoCombo.yScale/2
    luzAux3.setScale(0.5)
    
    changeTheLight = SKAction.customAction(withDuration: 0.4) {
      (node, elapsedTime) in
      if self.luzAux3.alpha > 0.5 {
        self.luzAux3.alpha -= 0.1
        self.luzAux3.lightColor = .init(red: 0.96, green: 0.54, blue: 0.10, alpha: self.luzAux3.alpha)
      }
    }
    
    changeTheLightReturn = SKAction.customAction(withDuration: 0.4) {
      (node, elapsedTime) in
      if self.luzAux3.alpha < 1.0 {
        self.luzAux3.alpha += 0.1
        self.luzAux3.lightColor = .init(red: 0.96, green: 0.54, blue: 0.10, alpha: self.luzAux3.alpha)
      }
    }
    
    changeTheLightSequence = SKAction.sequence([changeTheLight,changeTheLightReturn])
    luzAux3.run(SKAction.repeatForever(changeTheLightSequence))
    luzAux3.alpha = 0
  }
  
  func trocarCombo(canCombo: Bool){
    if (canCombo){
      if (jaTemLuz == false){
       
        self.botaoCombo.run(changeSize)
        self.botaoCombo.texture = Utils.Atlas.sprites.textureNamed("ComboAtivo")
        self.botaoCombo.alpha = 1
        self.botaoCombo.addChild(luzAux3)
        self.jaTemLuz = true
      }
    
    }else{
      self.luzAux3.removeFromParent()
      self.botaoCombo.texture = Utils.Atlas.sprites.textureNamed("ComboNormal")
      self.botaoCombo.alpha = 0.4
      self.jaTemLuz = false
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


