import SpriteKit



class Enemy: SKSpriteNode, CampfireObserver, PlayerObserver {
  
  func player(_ player: Player, keepAwayEnemy: Bool) {
    if (keepAwayEnemy){
      afastarEnemyPlayer(player: player)
    }else{
      voltarEnemyPlayer()
    }
  }
  
  
  func campfire(_ campfire: Campfire, didChangeTo state: CampfireState) {
    switch state {
    case .on:
      self.stayAway(from: campfire)
      break
    case .off:
      self.removeConstraint(from: campfire)
      break
    }
  }

  
  var hp = 2
  var attack = false
  var lado = false  //esquerda
  var velocidade:CGFloat = 200
  var dano = 1
  var inScene = false
  var inTutorial = false
  var morreu = false
  
  var seguindoPai = false
  var seguindoSon = false
  
  
  //Enemy Die
  let wait = SKAction.wait(forDuration: 0.7)
  let fantasmaPositionAction = SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 0.5)
  let fantasmaBackPositionAction = SKAction.move(by: CGVector(dx: 0, dy: 0), duration: 0.0)
  let fantasmaAlphaAction = SKAction.fadeAlpha(to: 0.0, duration: 0.5)
  
  let fantasmaHomem : SKSpriteNode! = {
    let fantasma = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("fantasma1"))
    fantasma.setScale(0.01)
    return fantasma
  }()
  
  let fantasmaMulher : SKSpriteNode! = {
    let fantasma = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("fantasma2"))
    fantasma.setScale(0.01)
    return fantasma
  }()
  
  //Constraints
  var constraintCamp = SKConstraint()
  var constraintPlayer: SKConstraint?
  var constraintCampfire = SKConstraint() //Tutorial
  var constraintTrap = SKConstraint()
  var constraintsCabanas = [SKConstraint]()
  
  let mulherEsquerda = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("mulherEsquerda"))
  let mulherDireita = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("mulherDireita"))
  let homemDireito = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("homemDireita"))
  let homemEsquerdo = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("homemEsquerda"))
  
  let textureAtacarHomemEsquerda = Utils.Atlas.sprites.textureNamed("homemVA")
  let textureAtacarHomemDireita = Utils.Atlas.sprites.textureNamed("homemVADir")
  let textureAtacarMulherEsquerda = Utils.Atlas.sprites.textureNamed("mulherVA")
  let textureAtacarMulherDireita = Utils.Atlas.sprites.textureNamed("mulherVADir")
  let spritePontuacao = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("pontuacaoEnemy"))
  

  
  
  init(nome: String, imagedNamed: String) {
    let texture = Utils.Atlas.sprites.textureNamed(imagedNamed)
    super.init(texture: texture, color: .white,
               size: texture.size())
    setScale(0.15)
    name = nome
    zPosition = 20
    self.shadowedBitMask = 1
    self.lightingBitMask = 1
    self.setupPhysic()
    self.setupSound()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Use init()")
  }
  
  
  func movement(target: CGPoint) {
    guard let physicsBody = physicsBody else { return }
    
    let newVelocity = (target - position).normalized()
      * self.velocidade
    physicsBody.velocity = CGVector(point: newVelocity)
    
  }
  
  func setupPhysic(){
    physicsBody = SKPhysicsBody(circleOfRadius: size.width/4)
    physicsBody?.linearDamping = 1
    physicsBody?.friction = 1
    physicsBody?.allowsRotation = false
    physicsBody?.mass = 0
    physicsBody!.categoryBitMask = CategoryMask.enemy.rawValue
    physicsBody?.collisionBitMask = CategoryMask.player.rawValue | CategoryMask.sword.rawValue | CategoryMask.son.rawValue
    physicsBody?.contactTestBitMask = CategoryMask.sword.rawValue | CategoryMask.player.rawValue | CategoryMask.son.rawValue
    
    lightingBitMask = 1
  }
  
  func virar(node : SKSpriteNode, lado : Int,sexo : String){
    if sexo == "m"{
      if lado == 1 && hp > 0{
        node.texture = homemEsquerdo.texture
      }else if hp > 0{
        node.texture = homemDireito.texture
      }
    }
    else{
      if lado == 1 && hp > 0{
        node.texture = mulherEsquerda.texture
      }else if hp > 0{
        node.texture = mulherDireita.texture
      }
    }
  }
  
  var atacarTexture = SKAction()
  var backTexture = SKAction()
  
  var isSound = Bool()
  let dados = UserData()
  
  func setupSound(){
    dados.carregarDadosSettings()
    self.isSound = dados.sons
  }
  
  func atacar(positionPlayer: CGPoint){
    let soundAtacarHomem = "enemyMan.mp3"
    let soundAtacarMulher = "enemyWoman.mp3"
    
    backTexture = SKAction.setTexture(self.texture!)
    self.attack = true
    
    if (self.name == "EnemyMale"){
      if (isSound){
        self.run(SKAction.playSoundFileNamed(soundAtacarHomem, waitForCompletion: false))
      }
      if (self.position.x < positionPlayer.x){
        atacarTexture = SKAction.setTexture(self.textureAtacarHomemDireita)
      }else{
        atacarTexture = SKAction.setTexture(self.textureAtacarHomemEsquerda)
      }
    }else{
      if (isSound){
        self.run(SKAction.playSoundFileNamed(soundAtacarMulher, waitForCompletion: false))
      }
      if (self.position.x < positionPlayer.x){
        atacarTexture = SKAction.setTexture(self.textureAtacarMulherDireita)
      }else{
        atacarTexture = SKAction.setTexture(self.textureAtacarMulherEsquerda)
      }
    }
    
    self.run(atacarTexture)
    self.run(Utils.Actions.timerHalfSecond){
      self.run(self.backTexture)
    }
    
    self.run(Utils.Actions.timerTwoSeconds){
      self.attack = false
    }
    
  }
  
  
  
  //ARRUMAR
    
  func removeConstraint(from campfire: Campfire) {
    self.constraints?.removeLast()
    constraintCamp = SKConstraint.distance(SKRange(lowerLimit: 100), to: campfire)
    self.constraints?.append(self.constraintCamp)
    
  }
  
  func stayAway(from campfire: Campfire) {

    self.constraints?.removeLast()
    constraintCamp = SKConstraint.distance(SKRange(lowerLimit: 400), to: campfire)
    self.constraints?.append(self.constraintCamp)
  }
  
  func afastarEnemyPlayer(player: Player){
    if (inTutorial == false){
      if let constraint = constraintPlayer{
        constraint.enabled = true
      }else{
        constraintPlayer = SKConstraint.distance(SKRange(lowerLimit: 200), to: player)
        constraints?.append(constraintPlayer!)
      }
    }
  }
  
  func voltarEnemyPlayer(){
    if let constraint = constraintPlayer{
      constraint.enabled = false
    }
  }
  
  func setarNovamenteEnemy(){
    if (name == "EnemyMale"){
      self.texture = homemEsquerdo.texture
    }else{
      self.texture = mulherEsquerda.texture
    }
    self.lado = false
    self.hp = 1
    self.morreu = false
    self.setScale(0.15)
    self.lightingBitMask = 1
    self.setupPhysic()
    self.inScene = true
    self.alpha = 1
    self.position = CGPoint(x: self.rndN(min: -1000, max: +1000),y: self.rndN(min: -1000, max: +1000))
  }
  
  func rndN(min : Int,max : Int) -> Int{
    let random = Int.random(in: min...max)
    return random
    
  }

  func mostrarPontuacao(){
    self.spritePontuacao.removeFromParent()
    self.spritePontuacao.color = .yellow 
    self.spritePontuacao.colorBlendFactor = 100
    self.spritePontuacao.zPosition = 1000
    self.spritePontuacao.setScale(1)
    self.addChild(self.spritePontuacao)
    self.spritePontuacao.position.y += 600
  }
  
  func fantasma(){
    if self.name == "EnemyMale"{
      self.texture = fantasmaHomem.texture
    }else{
      self.texture = fantasmaMulher.texture
    }
    self.run(SKAction.sequence([fantasmaPositionAction,fantasmaPositionAction])){
      self.run(self.fantasmaBackPositionAction)
    }
    self.run(wait){
      self.removeFromParent()
      self.removeAllChildren()
      self.removeAllActions()
    }
  }
}
