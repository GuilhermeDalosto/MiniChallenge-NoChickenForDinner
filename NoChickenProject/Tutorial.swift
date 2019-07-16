//
//  Tutorial.swift
//  No Chicken for Dinner
//
//  Created by Daniel Leal on 17/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class Tutorial: SKNode {
  
  var labelFilho = SKLabelNode()
  
  var labelAlerta = SKLabelNode()
  
  var labelInimigos = SKLabelNode()
  
  var labelFogueira = SKLabelNode()
  
  var labelContinue = SKLabelNode()
  
  var labelCombo = SKLabelNode()
  
  var labelFlecha = SKLabelNode()
  
  var labelTrap = SKLabelNode()
  
  let lightFire = SKLightNode()
  
  let dedo = SKSpriteNode(imageNamed: "dedodedo")
  
  let luzAux2 = SKLightNode()
  
  let luzAux3 = SKLightNode()
  
  let loop = SKAction.moveBy(x: -60, y: -60, duration: 0.25)
  
  let loopR = SKAction.moveBy(x: +60, y: +60, duration: 0.25)
  
  var changeTheLight = SKAction()
  
  var changeTheLightReturn = SKAction()
  
  var changeTheLightSequence = SKAction()
  
  var dados = UserData()
  
  var changeSize = SKAction()
  
  var seta = SKSpriteNode(imageNamed: "seta")
  
  
  var sawCampfire = false
  var sawSon = false
  var sawEnemy = false
  var sawAlert = false
  var sawAttention = false
  var sawCombo = false
  var sawTrap = false
  
  override init() {
    super.init()
    
    self.setarLuz3()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func carregarDados(){
    dados.carregarDadosTutorial()
    self.sawCampfire = dados.campfire
    self.sawSon = dados.filho
    self.sawAlert = dados.alerta
    self.sawEnemy = dados.inimigo
    self.sawCombo = dados.combo
    self.sawAttention = dados.attention
    self.sawTrap = dados.trap
  }
  
  func setarLuz3(){
    
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
    luzAux3.alpha = 1
    luzAux3.categoryBitMask = 1
    luzAux3.falloff = 3
    luzAux3.lightColor = .green
    luzAux3.ambientColor = .black
    luzAux3.setScale(0.5)
  }
  
  
  func setupLabelFilho(son: Son){
    self.removeAllChildren()
    labelFilho.text = NSLocalizedString("filho", comment:  "")
    labelFilho.fontColor = .white
    labelFilho.fontSize = 30
    labelFilho.fontName = "Kelmscott"
    labelFilho.zPosition = 1000
    var newValue = self.convert(CGPoint(x: son.position.x, y: son.position.y + 50), to: self)
    var constraintLabel = SKConstraint.distance(SKRange(constantValue: 0), to: newValue)
    labelFilho.constraints = [constraintLabel]

    
    self.addChild(self.labelFilho)
  }
  
  
  func setupLabelEnemy(enemy :Enemy, attackButton: SKSpriteNode){
    self.luzAux3.removeFromParent()
    self.removeAllChildren()
    
    labelInimigos.text = NSLocalizedString("inimigo", comment:  "")
    labelInimigos.fontColor = .white
    labelInimigos.fontSize = 30
    labelInimigos.fontName = "Kelmscott"
    labelInimigos.zPosition = 1000
    
    let newValue = self.convert(CGPoint(x: enemy.position.x, y: enemy.position.y + 50), to: self)
    let constraintLabel = SKConstraint.distance(SKRange(constantValue: 0), to: newValue)
    labelInimigos.constraints = [constraintLabel]
    
    luzAux3.xScale = attackButton.xScale/2
    luzAux3.yScale = attackButton.yScale/2
    
    self.changeSize = SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.16, duration: 0.4), SKAction.scale(to: 0.14, duration: 0.3)]))
    
    self.addChild(self.labelInimigos)
    self.labelInimigos.position = enemy.position
    attackButton.run(changeSize)
    attackButton.addChild(self.luzAux3)
    
  }
  
  
  func setupLabelCampfire(campfire : Campfire){
    self.removeAllChildren()
    labelFogueira.text = NSLocalizedString("fogueira", comment:  "")
    labelFogueira.fontColor = .white
    labelFogueira.fontSize = 30
    labelFogueira.fontName = "Kelmscott"
    labelFogueira.zPosition = 1000
    
    let newValue = self.convert(CGPoint(x: campfire.position.x, y: campfire.position.y + 50), to: self)
    let constraintLabel = SKConstraint.distance(SKRange(constantValue: 0), to: newValue)
    labelFogueira.constraints = [constraintLabel]
    
    dedo.zPosition = 1000
    dedo.setScale(3)
    dedo.position.x += 50
    dedo.position.y -= 50
    
    self.addChild(self.labelFogueira)
    campfire.addChild(dedo)
    dedo.run(SKAction.repeatForever(SKAction.sequence([loop,loopR,loopR,loop])))
    
  }
  
  func setupLabelFlechas(player: Player, campfire : Campfire){
    self.removeAllChildren()
    labelFlecha.text = NSLocalizedString("alertArrow", comment:  "")
    labelFlecha.fontColor = .red
    labelFlecha.fontSize = 30
    labelFlecha.fontName = "Kelmscott"
    labelFlecha.zPosition = 1000
    
    if campfire.position.y < player.position.y{
      labelFlecha.position.y = player.position.y + 90
    }else{
      labelFlecha.position.y = player.position.y - 90
    }
    
    labelFlecha.position.x = player.position.x
    
    
    labelContinue.text = NSLocalizedString("continue", comment: "")
    labelContinue.fontColor = .white
    labelContinue.fontSize = 30
    labelContinue.zPosition = 1000
    
    
    labelContinue.position.x = player.position.x
    labelContinue.position.y = player.position.y - 200
    
    self.addChild(self.labelFlecha)
    self.addChild(self.labelContinue)
  }
  
  func setupLabelTrap(trap: Trap, player: Player, attackButton: SKSpriteNode){
    self.luzAux3.removeFromParent()
    self.removeAllChildren()
    labelTrap.text = NSLocalizedString("trap", comment:  "")
    labelTrap.fontColor = .white
    labelTrap.fontSize = 30
    labelTrap.fontName = "Kelmscott"
    labelTrap.zPosition = 1000
    
    var newValue = self.convert(CGPoint(x: trap.position.x, y: trap.position.y + 50), to: self)
    var constraintLabel = SKConstraint.distance(SKRange(constantValue: 0), to: newValue)
    labelTrap.constraints = [constraintLabel]
    
    luzAux3.xScale = attackButton.xScale/2
    luzAux3.yScale = attackButton.yScale/2
    self.changeSize = SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.16, duration: 0.4), SKAction.scale(to: 0.14, duration: 0.3)]))
    
    
    self.addChild(self.labelTrap)
    attackButton.run(changeSize)
    attackButton.addChild(self.luzAux3)
  }
  
  func setupLabelAlerta(player : Player){
    self.luzAux3.removeFromParent()
    self.removeAllChildren()
    
    labelAlerta.text = NSLocalizedString("dicaAlerta", comment:  "")
    labelAlerta.fontColor = .white
    labelAlerta.fontSize = 30
    labelAlerta.fontName = "Kelmscott"
    labelAlerta.zPosition = 1000
    
    labelAlerta.position = player.position
    labelAlerta.position.y += 90
 
    let constraintLabel = SKConstraint.distance(SKRange(constantValue: 80), to: player)
    
    labelAlerta.constraints = [constraintLabel]
    
    self.addChild(labelAlerta)
    //alerta.addChild(luzAux3)
    
  }
  
  
  func setupContinue(player: Player){
    
    labelContinue.text = NSLocalizedString("continue", comment: "")
    labelContinue.fontColor = .white
    labelContinue.fontSize = 30
    labelContinue.zPosition = 1000
    
    
    labelContinue.position.x = player.position.x
    labelContinue.position.y = player.position.y - 200
    
    self.addChild(self.labelContinue)
  }
  
  func setupLabelCombo(player: Player){
    labelCombo.text = NSLocalizedString("dicaCombo", comment: "")
    labelCombo.fontColor = .white
    labelCombo.fontSize = 30
    labelCombo.zPosition = 1000
    
    
    labelCombo.position.x = player.position.x
    labelCombo.position.y = player.position.y - 200
    
    self.addChild(self.labelCombo)
    
  }
  
  
}
