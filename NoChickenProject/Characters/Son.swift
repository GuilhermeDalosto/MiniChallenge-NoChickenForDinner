import SpriteKit

class Son: SKSpriteNode {
  
  
  var hp = 40
  var campfire = 0 // Campfire em que ele está
  var movingSon = false
  var foiAtingido = false
  var qtdFoiAtingido = 0
  
  var barrinhaDeMedo = SKShapeNode(rect: CGRect(x: -210, y: 350, width: 400, height: 80), cornerRadius: 20)
  var preencherBarrinhaDeMedo = SKShapeNode()
  var spritePontuacao = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("pontuacaoSon"))
  let pontuacaoPositionAction = SKAction.move(by: CGVector(dx: 0, dy: 550), duration: 1)
  let backPositionPontuacao = SKAction.move(by: CGVector(dx: 0, dy: -550), duration: 0.0)
  let pontuacaoAlphaAction = SKAction.fadeAlpha(to: 0.0, duration: 2)
  
  var constraintCampfire1 = SKConstraint.distance(SKRange(lowerLimit: 100), to: CGPoint(x: -1280, y: 640))
  var constraintCampfire2 = SKConstraint.distance(SKRange(lowerLimit: 100), to: CGPoint(x: 1280, y: 640))
  var constraintCampfire3 = SKConstraint.distance(SKRange(lowerLimit: 100), to: CGPoint(x: -1280, y: -640))
  var constraintCampfire4 = SKConstraint.distance(SKRange(lowerLimit: 100), to: CGPoint(x: 1280, y: -640))
  
  var foiAchado = false
  
  init() {
    let texture = Utils.Atlas.sprites.textureNamed("filhoEsquerda")
    super.init(texture: texture, color: .white,
               size: texture.size())
    name = "Son"
    zPosition = 220
    setScale(0.1)
    self.shadowedBitMask = 1
    self.lightingBitMask = 1
    self.setupPhysics()
    self.constraints = [constraintCampfire1,constraintCampfire2,constraintCampfire3,constraintCampfire4]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Use init()")
  }
  
  //MUDEI AQUI
  func willRun(){
    if (movingSon == false){
      
      var x = rndN(min: 1, max: 4)
      while x == self.campfire {
        x = rndN(min: 1, max: 4)
        print(x)
      }
      
        self.movingSon = true
        if x == 1 {
          self.run(SKAction.move(to: CGPoint(x: -1180, y: 640) , duration: 2))
          self.campfire = 1
          self.run(Utils.Actions.timerThreeSeconds){
            self.movingSon = false
            self.foiAchado = false
          }
        }else if x == 2 {
          self.run(SKAction.move(to: CGPoint(x: 1280, y: 540) , duration: 2))
          self.campfire = 2
          self.run(Utils.Actions.timerThreeSeconds){
            self.movingSon = false
            self.foiAchado = false
          }
        } else if x == 3 {
          self.run(SKAction.move(to: CGPoint(x: -1180, y: -540), duration: 2))
          self.campfire = 3
          self.run(Utils.Actions.timerThreeSeconds){
            self.movingSon = false
            self.foiAchado = false
          }
        } else if x == 4 {
          self.run(SKAction.move(to: CGPoint(x: 1200, y: -560) , duration: 2))
          self.campfire = 4
          self.run(Utils.Actions.timerThreeSeconds){
            self.movingSon = false
            self.foiAchado = false
          }
        }
      self.qtdFoiAtingido = 0
      self.barrinhaDeMedo.removeFromParent()
      self.preencherBarrinhaDeMedo.removeFromParent()
    }
  }
  
  func setupPhysics(){
    physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/3)
    physicsBody?.affectedByGravity = false
    physicsBody?.allowsRotation = false
    physicsBody?.usesPreciseCollisionDetection = false
    physicsBody?.mass = 10000000
    physicsBody?.categoryBitMask = CategoryMask.son.rawValue
    
  }
  
  func rndN(min : Int,max : Int) -> Int{
    let random = Int.random(in: min...max)
    return random
    
  }
  
  func mostrarPontuacao(){
    self.spritePontuacao.color = .yellow
    self.spritePontuacao.colorBlendFactor = 100
    self.spritePontuacao.zPosition = 1000
    self.spritePontuacao.setScale(1)
    self.spritePontuacao.alpha = 1
    self.addChild(self.spritePontuacao)
    self.spritePontuacao.run(SKAction.sequence([pontuacaoPositionAction, pontuacaoAlphaAction, backPositionPontuacao])){
        self.spritePontuacao.removeFromParent()
        self.spritePontuacao.removeAllActions()
    }
  }
  
  func setarBarraDeMedo(){
    self.barrinhaDeMedo.fillColor = .clear
    self.barrinhaDeMedo.lineWidth = 10
    self.barrinhaDeMedo.strokeColor = .yellow
    self.barrinhaDeMedo.zPosition = 300
    self.addChild(self.barrinhaDeMedo)
  }
  
  func aumentarMedo(qtdAtaque: Int){
    let i = Double(qtdAtaque) * 133.33
    self.preencherBarrinhaDeMedo.removeFromParent()
    self.preencherBarrinhaDeMedo = SKShapeNode(rect: CGRect(x: -210, y: 350, width: i, height: 80), cornerRadius: 20)
    self.preencherBarrinhaDeMedo.fillColor = .yellow
    self.preencherBarrinhaDeMedo.zPosition = 400
    self.addChild(preencherBarrinhaDeMedo)
  }
  
}
