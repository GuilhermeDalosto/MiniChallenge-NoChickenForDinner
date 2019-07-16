import SpriteKit

protocol CampfireObserver {
  
  func campfire(_ campfire: Campfire, didChangeTo state: CampfireState)
}

enum CampfireState {
  case on
  case off
}

class Campfire: SKSpriteNode {

  var spritePontuacao = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("pontuacaoCampfire"))
  let pontuacaoPositionAction = SKAction.move(by: CGVector(dx: 0, dy: 300), duration: 1)
  let backPositionPontuacao = SKAction.move(by: CGVector(dx: 0, dy: -300), duration: 0.0)
  let pontuacaoAlphaAction = SKAction.fadeAlpha(to: 0.0, duration: 1)
  
  var observers = [CampfireObserver]()
  
  func turnOn() {
    for observer in self.observers {
      observer.campfire(self, didChangeTo: .on)
    }
  }
  
  func turnOff() {
    for observer in self.observers {
      observer.campfire(self, didChangeTo: .off)
    }
  }
  
  var ligada = false
  
  init(nome: String) {
    let texture = Utils.Atlas.sprites.textureNamed("fogueira1")
    super.init(texture: texture, color: .white,
               size: texture.size())
    name = nome
    zPosition = 15
    setScale(0.17)
    self.shadowedBitMask = 1
    self.lightingBitMask = 1
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Use init()")
  }
  

  func trocarNode(node: SKSpriteNode, imagem : String){
    node.texture = Utils.Atlas.sprites.textureNamed(imagem)
  }
  
  func mostrarPontuacao(){
    self.spritePontuacao.color = .yellow
    self.spritePontuacao.colorBlendFactor = 100
    self.spritePontuacao.zPosition = 1000
    self.spritePontuacao.setScale(0.5)
    self.spritePontuacao.alpha = 1
    self.addChild(self.spritePontuacao)
    self.spritePontuacao.run(SKAction.sequence([pontuacaoPositionAction, pontuacaoAlphaAction, backPositionPontuacao])){
      self.spritePontuacao.removeFromParent()
      self.spritePontuacao.removeAllActions()
    }
  }

}
