//
//  CharactersLayer.swift
//  PestControl
//
//  Created by Daniel Leal on 24/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit


enum CategoryMask:UInt32 {
  case enemy = 0b01 //1
  case sword = 0b10     //2
  case player = 0b11   //3
  case son = 0b100  //4
  case campfire = 0b101 //5
  case enemyInvul = 0b110 //6
  case playerInvul = 0b111 //7
  case trapMask = 0b1000 //8
  case arrowMask = 0b1001 //9
  case cabanaMask = 0b1010 //10
}

class CharactersLayer: SKNode, HudLayerDelegate{

  let audioAndar = SKAudioNode(fileNamed: "Running_On_Grass.mp3")

  func hudLayer(_ hudLayer: Hudlayer, didMovePlayerTo position: CGPoint, flipTo side: Int) {
    
    if (!inTrap){
      self.chickenFather.position.x = self.chickenFather.position.x + position.x
      self.chickenFather.position.y = self.chickenFather.position.y + position.y
      
      if (side == 1 && self.chickenFather.lado == true){//Sprite esquerdo
        self.chickenFather.virar(node: self.chickenFather, lado: 1)
        self.sword.virar(node: self.sword, lado: 1, player : self.chickenFather)
        self.chickenFather.lado = false
        
      }else if (side == -1 && self.chickenFather.lado == false){ //Sprite direito
        self.chickenFather.virar(node: self.chickenFather, lado: -1)
        self.sword.virar(node: self.sword, lado: -1, player: self.chickenFather)
        self.chickenFather.lado = true
      }
    }
  }
  
  func hudLayer3(_ hudLayer: Hudlayer, touchesBegan touched: Bool) { //Quando o toque foi capturado na hud layer
    if (touched == true && self.chickenFather.jumpFather == false){
      self.chickenFather.removeAllActions()
      self.chickenFather.setupJump()
      if (isSound){
        self.addChild(audioAndar)
      }
    }else if (touched == false && self.chickenFather.breathFather == false){
      self.chickenFather.removeAllActions()
      self.chickenFather.setupBreath()
      if (audioAndar.inParentHierarchy(self)){
        self.audioAndar.removeFromParent()
      }
    }
  }
  
  var recoilArma = SKAction.wait(forDuration: 0.1)
  //Action Sword
  func hudLayer2(_ hudLayer: Hudlayer, attackUsed attack: Bool) { //Botao de ataque foi clicado
    if(attack == true && self.chickenFather.canAttack == true){
      var skill1 = SKAction()
      var skill2 = SKAction()
      var skill3 = SKAction()
      if (isSound){
        self.chickenFather.run(SKAction.playSoundFileNamed("Ataque.mp3", waitForCompletion: false))
        self.chickenFather.run(SKAction.changeVolume(by: 0.3, duration: 0.0))
      }

      self.sword.setupPhysics()
      if (self.chickenFather.lado == false){
         skill1 = SKAction.rotate(byAngle: 3.14159, duration: 0.1)
         skill2 = SKAction.rotate(byAngle: -3.14159, duration: 0.3)
         skill3 = SKAction.move(to: CGPoint(x: -570, y: 0), duration: 0.0)
      }else{
         skill1 = SKAction.rotate(byAngle: -3.14159, duration: 0.1)
         skill2 = SKAction.rotate(byAngle: 3.14159, duration: 0.3)
         skill3 = SKAction.move(to: CGPoint(x: +570, y: 0), duration: 0.0)
      }
      self.sword.run(skill1)
      self.sword.run(skill2)
      self.sword.run(skill3)
      self.chickenFather.canAttack = false
      run (recoilArma){
        self.sword.physicsBody = nil
      }
      run(Utils.Actions.waitAttack){
        self.chickenFather.canAttack = true
      }
    }
  }

  var chickenSon = Son()
  var chickenFather = Player()
  var sword = Weapon(nome: "Weapon")
  var campfire1 = Campfire(nome: "Campfire")
  var campfire2 = Campfire(nome: "Campfire2")
  var campfire3 = Campfire(nome: "Campfire3")
  var campfire4 = Campfire(nome: "Campfire4")
  var lightNode = SKLightNode()
  var killEnemyCount = 0
  
  var isSound = Bool()
  var isMusic = Bool()
  var inTrap = false
  
  var arrayTotal = [Enemy]()
  var trashArrayM = [Enemy]()
  var trashArrayF = [Enemy]()
 
  

  override init() {
    super.init()
  }
  
  init(chickenSon: Son, chickenFather:Player, campfire1: Campfire, campfire2: Campfire, campfire3: Campfire, campfire4: Campfire, lightNode: SKLightNode) {
    self.chickenSon = chickenSon
    self.chickenFather = chickenFather
    self.campfire1 = campfire1
    self.campfire2 = campfire2
    self.campfire3 = campfire3
    self.campfire4 = campfire4
    self.lightNode = lightNode
    
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  func setupInitialCharacters(){
    self.addChild(chickenFather)
    self.chickenSon.position.x = self.chickenFather.position.x + 100
    self.addChild(chickenSon)
    self.sword.constraitPlayer = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: 0), to: CGPoint(x: -450, y: 0))
    self.sword.constraints = [self.sword.constraitPlayer]
    self.sword.setScale(1.2)
    self.chickenFather.addChild(sword)
    self.chickenFather.setupActionsFather(sword: self.sword)

  }
  
  func setarObserversPlayer(){
    for enemy in trashArrayM{
      chickenFather.observers.append(enemy)
    }
    for enemy in trashArrayF{
      chickenFather.observers.append(enemy)
    }
  }
  
  func enemyDie(enemies : Enemy){
    self.killEnemyCount += 1
    enemies.removeAllActions()
    enemies.setScale(0.07)
    enemies.lightingBitMask = 0
    enemies.physicsBody = nil
    enemies.morreu = true
    enemies.fantasma()
    enemies.mostrarPontuacao()
    if let index = self.arrayTotal.firstIndex(where: { $0.morreu == true }){
      self.arrayTotal.remove(at: index)
    }
    if enemies.name == "EnemyMale"{
      self.trashArrayM.append(enemies)
    }else{
      self.trashArrayF.append(enemies)
    }
    self.enemySpawn(name: enemies.name!)
  }
  
  
  func setAllEnemy(){
    
    for _ in 0...50{
      
      let newEnemy = Enemy(nome: "EnemyMale", imagedNamed: "homemEsquerda")
      self.trashArrayM.append(newEnemy)
  
      let newEnemyF = Enemy(nome: "EnemyFemale", imagedNamed: "mulherEsquerda")
      self.trashArrayF.append(newEnemyF)
    }
  }
  
  func enemySpawn(name: String){
    
    run(Utils.Actions.timerHalfSecond){
      if name == "EnemyMale"{
        if let enemy = self.trashArrayM.first{
          enemy.removeFromParent()
          enemy.setarNovamenteEnemy()
          self.addChild(enemy)
          self.arrayTotal.append(enemy)
          self.trashArrayM.remove(at: 0)
        }
      }
        
      else if name == "EnemyFemale"{
        if let enemy = self.trashArrayF.first {
          enemy.removeFromParent()
          enemy.setarNovamenteEnemy()
          self.addChild(enemy)
          self.arrayTotal.append(enemy)
          self.trashArrayF.remove(at: 0)
        }
      }
    }
  }
  
  
  func enemyMove(){
  
    for enemy in arrayTotal{
      if enemy.position.distanceTo(chickenSon.position) < enemy.position.distanceTo(chickenFather.position){
        guard enemy.isPaused == false else { return }
        enemy.movement(target: self.chickenSon.position)
        enemy.seguindoSon = true
        enemy.seguindoPai = false
      }else{
        guard enemy.isPaused == false else { return }
        enemy.movement(target: self.chickenFather.position)
        enemy.seguindoSon = false
        enemy.seguindoPai = true
      }
    }
  }

  
  func virarEnemys(){
    
    for enemy in arrayTotal{
      guard enemy.isPaused == false else { return }
      if (enemy.seguindoPai){
        if (enemy.lado == false){
          if enemy.position.x < self.chickenFather.position.x{
              if let name = enemy.name{
                if name == "EnemyMale"{
                  enemy.virar(node: enemy, lado: -1,sexo: "m")
                }else{
                  enemy.virar(node: enemy, lado: -1,sexo: "f")
                }
              }
              enemy.lado = true
            }
        }else if enemy.lado == true{
            if enemy.position.x > self.chickenFather.position.x{
              if let name = enemy.name{
                if name == "EnemyMale"{
                  enemy.virar(node: enemy, lado: 1,sexo: "m")
                }else{
                  enemy.virar(node: enemy, lado: 1,sexo: "f")
                }
              }
              enemy.lado = false
            }
          }
        
      }else if (enemy.seguindoSon){
        if (enemy.lado == false){
          if enemy.position.x < self.chickenSon.position.x{
            if let name = enemy.name{
              if name == "EnemyMale"{
                enemy.virar(node: enemy, lado: -1,sexo: "m")
              }else{
                enemy.virar(node: enemy, lado: -1,sexo: "f")
              }
            }
            enemy.lado = true
          }
        }else if enemy.lado == true{
          if enemy.position.x > self.chickenSon.position.x{
            if let name = enemy.name{
              if name == "EnemyMale"{
                enemy.virar(node: enemy, lado: 1,sexo: "m")
              }else{
                enemy.virar(node: enemy, lado: 1,sexo: "f")
              }
            }
            enemy.lado = false
          }
        }
      }
    }
  }
  
  func setupActionEnemys(){ //Inimigos andando
    var jumpMid = SKAction()
    var jumpSequence = SKAction()
    let jumpUpAction = SKAction.rotate(byAngle: 0.3, duration: 1)
    let jumpDownAction = SKAction.rotate(byAngle: -0.3, duration: 1)
    
    for enemy in arrayTotal{
      jumpMid = SKAction.run{ enemy.zRotation = 0}
      jumpSequence = SKAction.sequence([jumpMid, jumpUpAction, jumpMid, jumpDownAction])
      enemy.run(jumpSequence)
    }

  }
  
  
  func rnd(max : Int) -> Int{
    let rnd = Int.random(in :0...max)
    return rnd
  }
  
  func rndN(min : Int,max : Int) -> Int{
    let random = Int.random(in: min...max)
    return random
    
  }
    
}
