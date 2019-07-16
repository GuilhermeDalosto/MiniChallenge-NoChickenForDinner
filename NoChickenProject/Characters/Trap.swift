import SpriteKit

class Trap: SKSpriteNode {
  
  
  var timerAtiva = 0
  var timer = Timer()
  var canChangePosition = false
  
  var constraintCampfire1 = SKConstraint.distance(SKRange(lowerLimit: 400), to: CGPoint(x: -1280, y: 640))
  var constraintCampfire2 = SKConstraint.distance(SKRange(lowerLimit: 400), to: CGPoint(x: 1280, y: 640))
  var constraintCampfire3 = SKConstraint.distance(SKRange(lowerLimit: 400), to: CGPoint(x: -1280, y: -640))
  var constraintCampfire4 = SKConstraint.distance(SKRange(lowerLimit: 400), to: CGPoint(x: 1280, y: -640))
  
  
  init() {
    let texture = Utils.Atlas.sprites.textureNamed("trap")
    super.init(texture: texture, color: .white,
               size: texture.size())
    name = "Trap"
    position = CGPoint(x: -1960, y: 1280)
    zPosition = 17
    setScale(0.1)
    setupPhysics()
    self.constraints = [constraintCampfire1,constraintCampfire2,constraintCampfire3,constraintCampfire4]
  }
  
  func setupPhysics(){
    lightingBitMask = 1
    physicsBody = SKPhysicsBody(circleOfRadius: size.width/3)
    physicsBody?.mass = 1000000
    physicsBody?.affectedByGravity = false
    physicsBody?.allowsRotation = false
    physicsBody?.categoryBitMask = CategoryMask.trapMask.rawValue
    physicsBody?.collisionBitMask = CategoryMask.player.rawValue | CategoryMask.sword.rawValue
    physicsBody?.contactTestBitMask = CategoryMask.player.rawValue | CategoryMask.sword.rawValue
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Use init()")
  }
  
  func contarTempoAtiva(){
    self.timerAtiva = 0
       timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {  _ in
       if self.isPaused == false{
          self.timerAtiva += 1
        if (self.timerAtiva % 10 == 0){
          self.canChangePosition = true
        }
      }
    })
  }
  
}
