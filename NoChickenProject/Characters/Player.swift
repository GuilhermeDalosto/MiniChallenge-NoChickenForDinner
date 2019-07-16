import SpriteKit

protocol PlayerObserver {
  
  func player(_ player: Player, keepAwayEnemy: Bool)
  
}


class Player: SKSpriteNode {
  
  var observers = [PlayerObserver]()
  
  func turnOn() {
    for observer in self.observers {
      observer.player(self, keepAwayEnemy: true)
    }
  }
  
  func turnOff() {
    for observer in self.observers {
      observer.player(self, keepAwayEnemy: false)
    }
  }
  
  var score = 0
  var hp = 40
  var lado = false
  let velocityMultiplier : CGFloat = 0.01
  var jump = false
  var breath = true
  var jumpFather = false
  var breathFather = true
  
  let fire = SKEmitterNode(fileNamed: "Fire2.sks")
  
  
  //Constraint para cabanas
  var constraintsCabanas = [SKConstraint]()
  
  //Player constraint - Tutorial
  var constraintEnemy = SKConstraint()
  var constraintCampfire = SKConstraint()
  var constraintSon = SKConstraint()
  var constraintTrap = SKConstraint()
  
  //Constraints p/ alerta
  
  var constraintDireita = SKConstraint()
  var constraintsEsquerda = SKConstraint()
  var constraintBaixo = SKConstraint()
  var constraintAlto = SKConstraint()
  
  //Actions Player
  var jumpUpChickenFather = SKAction()
  var jumpDownChickenFather = SKAction()
  var jumpSequenceChickenFather = SKAction()
  var breathChickenFather = SKAction()
  
  var canAttack = true
  
  init() {
    let texture = Utils.Atlas.sprites.textureNamed("paiEsquerda")
    super.init(texture: texture, color: .white,
               size: texture.size())
    name = "Player"
    zPosition = 200
    setScale(0.1)
    self.shadowedBitMask = 1
    self.lightingBitMask = 1
    self.setupPhysic()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Use init()")
  }
  
  func setupActionsFather(sword: Weapon){ //Frango pular
    jumpUpChickenFather = SKAction.customAction(withDuration: 0.3){
      (node, elapsedTime) in
      if self.anchorPoint.y > 0.4 {
        self.anchorPoint.y -= 0.1
        sword.anchorPoint.y -= 0.1
      }
    }
    
    jumpDownChickenFather = SKAction.customAction(withDuration: 0.3){
      (node, elapsedTime) in
      if self.anchorPoint.y < 0.5 {
        self.anchorPoint.y += 0.1
        sword.anchorPoint.y += 0.1
      }
    }
    
    jumpSequenceChickenFather = SKAction.sequence([jumpUpChickenFather,jumpDownChickenFather])
    self.breathChickenFather = SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.12, duration: 0.5), SKAction.scale(to: 0.13, duration: 0.5)]))
    
  }
  
  func setupBreath(){
    self.jumpFather = false
    self.breathFather = true
    self.run(self.breathChickenFather)
  }
  
  func setupJump(){
    self.jumpFather = true
    self.breathFather = false
    self.run(SKAction.repeatForever(jumpSequenceChickenFather))
    self.run(jumpDownChickenFather)
  }
  
  let imageUm = Utils.Atlas.sprites.textureNamed("paiEsquerda")
  let imageDois = Utils.Atlas.sprites.textureNamed("paiDireita")
  
  func virar(node : SKSpriteNode, lado : Int){
    if lado == 1 {  //Virar pra esquerda
      node.texture = imageUm
    }else if lado == -1 {  //Virar pra direita
      node.texture = imageDois
    }
  }
  
  func setupPhysic(){
    self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/3)
    self.physicsBody?.linearDamping = 1
    self.physicsBody?.friction = 1
    self.physicsBody?.allowsRotation = false
    self.physicsBody?.mass = 1000
    self.physicsBody?.usesPreciseCollisionDetection = true
    physicsBody?.categoryBitMask = CategoryMask.player.rawValue
    physicsBody?.collisionBitMask = CategoryMask.son.rawValue
    physicsBody?.contactTestBitMask  = CategoryMask.son.rawValue
  }
  
}
