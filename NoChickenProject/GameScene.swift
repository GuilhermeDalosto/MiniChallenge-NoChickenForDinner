import SpriteKit
import AudioToolbox
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate, HudLayerDelegate2{
  
  override init(size: CGSize) {
      super.init(size: size)
  }
 
  func hudLayer2(_ hudLayer: Hudlayer, attackUsed attack: Bool) { //Botao de ataque usado
    self.attack = attack
    run(Utils.Actions.timerQuick){
      self.attack = false
    }
  }
  
  func hudLayer4(_ hudLayer: Hudlayer, pauseButtonUsed pauseIsOn: Bool) {  //Botao de pause usado
    if (pauseIsOn == true){
      canUpdate = false
      self.isPaused = true
      self.timer?.invalidate()
      self.timer2?.invalidate()
      self.timer3?.invalidate()
      self.hud.analogJoystick.disabled = true
      for nodes in self.hud.children{
        if (nodes != self.hud.playButton){
          nodes.alpha = 0.1
        }
      }
      self.char.alpha = 0.2
    }
  }
  
  func hudLayer5(_ hudLayer: Hudlayer, playButtonUsed playIsOn: Bool) {
    if (playIsOn == true){
      canUpdate = true
      self.isPaused = false
      self.setUpTimer()
      self.setUpTimer2()
      self.setupTimer3()
      self.hud.analogJoystick.disabled = false
      for nodes in self.hud.children{
        if (nodes != self.hud.playButton){
          nodes.alpha = 1
        }
      }
      self.char.alpha = 1
    }
  }
  
  func hudLayer6(_ hudLayer: Hudlayer, comboButtonUsed comboIsOn: Bool) {
    if (self.willCombo){
      canCombo()
    }
  }
  
  func hudLayer7(_ hudLayer: Hudlayer, velocity: CGPoint) {
    if (velocity.x < 0){ //Pai movendo para esquerda
      self.direcaoX = false
    }else{
      self.direcaoX = true
    }
    
    if (velocity.y < 0){ //Pai indo para baixo
      self.direcaoY = false
    }else{
      self.direcaoY = true
    }
  }
  
  func canRemoveMusic(_hudLayer: Hudlayer, canRemove: Bool) {
    if (canRemove){
      if (isMusic){
        self.audioPlayer.stop()
      }
    }
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    background =
      (childNode(withName: "background") as! SKTileMapNode)
    
    func movement(target: CGPoint,speed: CGFloat) {
      guard let physicsBody = physicsBody else { return }
      let newVelocity = (target - position).normalized()
        * speed
      physicsBody.velocity = CGVector(point: newVelocity)
      
    }
    
  }
  

  var auxPos = CGPoint()
  var canUpdate = true
  var lightBonfireCount = 0
  var timeSurvive = 0
  var foundSon = 0
  var killEnemyCount = 0
  var entrouLoading = false
  var inLoading = false
  
  var isMusic = Bool()
  var isSound = Bool()
  
  
  //Layers e Views
  var char = CharactersLayer() //Char Layer
  var hud = Hudlayer()  //Hud layer
  var endGameScene = GameOverSceneLayer()
  var layerAlert = AlertLayer()
  var alertIsOn = false
  var loading = LoadingLayer()
  var dados = UserData()
  
  //Characters Iniciais
  var player = Player()
  var son = Son()
  
  //Novo array enemy
  var setEnemy = Set<Enemy>()
  
  //Background
  var background: SKTileMapNode!
  let lightNode = SKLightNode()
  let lightFire = SKLightNode()
  let lightFire2 = SKLightNode()
  let lightFire3 = SKLightNode()
  let lightFire4 = SKLightNode()
  
  var campfire = Campfire(nome: "Campfire")
  var campfire2 = Campfire(nome: "Campfire2")
  var campfire3 = Campfire(nome: "Campfire3")
  var campfire4 = Campfire(nome: "Campfire4")
  var campfireLigada = Campfire(nome: "Campfire")
  
  //Particulas Fogueira
  let fp = SKEmitterNode(fileNamed:"FireFogueira2")
  let fp2 = SKEmitterNode(fileNamed:"FireFogueira2")
  let fp3 = SKEmitterNode(fileNamed:"FireFogueira2")
  let fp4 = SKEmitterNode(fileNamed:"FireFogueira2")
  
  let fpp = SKEmitterNode(fileNamed:"FireFogueira1")
  let fpp2 = SKEmitterNode(fileNamed:"FireFogueira1")
  let fpp3 = SKEmitterNode(fileNamed:"FireFogueira1")
  let fpp4 = SKEmitterNode(fileNamed:"FireFogueira1")
  
  
  //Cabanas
  var arrayCabanas:[Cabana] = {
    var array = [Cabana]()
    for _ in 0...7{
      array.append(Cabana())
    }
    return array
  }()
  
  func setarCabanas(){
    var constraintsCabanas = [SKConstraint]()
    arrayCabanas[0].position = CGPoint(x: 0, y: 640)
    arrayCabanas[1].position = CGPoint(x: 0, y: -640)
    arrayCabanas[2].position = CGPoint(x: -800, y: -860)
    arrayCabanas[3].position = CGPoint(x: 800, y: +900)
    arrayCabanas[4].position = CGPoint(x: -800, y: +900)
    arrayCabanas[5].position = CGPoint(x: 800, y: -860)
    arrayCabanas[6].position = CGPoint(x: -1600, y: 0)
    arrayCabanas[7].position = CGPoint(x: 1600, y: 0)
    
    for cabana in arrayCabanas{
      cabana.setScale(0.3)
      self.addChild(cabana)
      constraintsCabanas.append(SKConstraint.distance(SKRange(lowerLimit: 200), to: cabana.position))
    }
    
    self.char.chickenFather.constraints = constraintsCabanas
    
    for enemy in self.char.trashArrayF{
      enemy.constraints = constraintsCabanas
    }
    
    for enemy in self.char.trashArrayM{
      enemy.constraints = constraintsCabanas
    }
    
    for constraint in constraintsCabanas {
      for trap in arrayTraps{
        trap.constraints?.append(constraint)
      }
    }
    
  }
  
  
  func setarCampfires(){
    
    // Particulas da campfire
    self.fp?.position = campfire.position
    self.fp2?.position = campfire2.position
    self.fp3?.position = campfire3.position
    self.fp4?.position = campfire4.position
    
    self.fpp?.position = campfire.position
    self.fpp2?.position = campfire2.position
    self.fpp3?.position = campfire3.position
    self.fpp4?.position = campfire4.position
    
    self.fp?.position.y += 30
    self.fp2?.position.y += 30
    self.fp3?.position.y += 30
    self.fp4?.position.y += 30
    
    self.fpp?.position.y += 30
    self.fpp2?.position.y += 30
    self.fpp3?.position.y += 30
    self.fpp4?.position.y += 30
    
    
    self.addChild(fp!)
    self.addChild(fp2!)
    self.addChild(fp3!)
    self.addChild(fp4!)
    self.addChild(fpp!)
    self.addChild(fpp2!)
    self.addChild(fpp3!)
    self.addChild(fpp4!)
    
    
    fp?.isHidden = true
    fp2?.isHidden = true
    fp3?.isHidden = true
    fp4?.isHidden = true
   
    
    let constraintsCampfire1 = SKConstraint.distance(SKRange(lowerLimit: 100), to: campfire)
    let constraintsCampfire2 = SKConstraint.distance(SKRange(lowerLimit: 100), to: campfire2)
    let constraintsCampfire3 = SKConstraint.distance(SKRange(lowerLimit: 100), to: campfire3)
    let constraintsCampfire4 = SKConstraint.distance(SKRange(lowerLimit: 100), to: campfire4)
    
    self.char.chickenFather.constraints?.append(constraintsCampfire1)
    self.char.chickenFather.constraints?.append(constraintsCampfire2)
    self.char.chickenFather.constraints?.append(constraintsCampfire3)
    self.char.chickenFather.constraints?.append(constraintsCampfire4)
    
    self.char.chickenSon.constraints?.append(constraintsCampfire1)
    self.char.chickenSon.constraints?.append(constraintsCampfire2)
    self.char.chickenSon.constraints?.append(constraintsCampfire3)
    self.char.chickenSon.constraints?.append(constraintsCampfire4)
    
    for enemy in self.char.trashArrayM{
      enemy.constraints?.append(constraintsCampfire1)
      enemy.constraints?.append(constraintsCampfire2)
      enemy.constraints?.append(constraintsCampfire3)
      enemy.constraints?.append(constraintsCampfire4)
      campfire.observers.append(enemy)
      campfire2.observers.append(enemy)
      campfire3.observers.append(enemy)
      campfire4.observers.append(enemy)
    }
    
    for enemy in self.char.trashArrayF{
      enemy.constraints?.append(constraintsCampfire1)
      enemy.constraints?.append(constraintsCampfire2)
      enemy.constraints?.append(constraintsCampfire3)
      enemy.constraints?.append(constraintsCampfire4)
      campfire.observers.append(enemy)
      campfire2.observers.append(enemy)
      campfire3.observers.append(enemy)
      campfire4.observers.append(enemy)
    }
    
  }
  
  //Camera
  var cameraFollow = true
  
  //Variáveis
  var attack = false
  
  //Variaveis para a trap
  var direcaoX = false  //Esquerda
  var direcaoY = false  //Baixo
  var trapsInScene = 0
  var maximoTrap = 9
  var arrayTraps: [Trap] = {
    var array = [Trap]()
    for _ in 0...9{
      array.append(Trap())
    }
    return array
  }()
  var positionTrap = CGPoint()
  
  
  //Variaveis para flecha
  var arrayFlechas: [Flecha] = {
    var array = [Flecha]()
    for _ in 1...11{
      array.append(Flecha())
    }
    return array
  }()
  
  //Audio
  var audioPlayer = AVAudioPlayer()
  
  //Tempo
  var timeAux = 0 //Tempo de jogo
  var timer: Timer?
  var timer2: Timer?
  var timer3: Timer?
  
  //Acao player
  let breath = SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.12, duration: 0.5), SKAction.scale(to: 0.13, duration: 0.5)]))
  var willCombo = false
  var killCombo = 0
  var comboInUse = false
  
  //Particula
  var snow = SKEmitterNode()
  func setarSnow(){
    self.snow = SKEmitterNode(fileNamed: "snow.sks")!
    self.snow.zPosition = -100
    self.snow.position = CGPoint(x: 0, y: UIScreen.main.bounds.height/1.3)
    self.snow.advanceSimulationTime(5)
    self.hud.addChild(self.snow)
  }
  
  //Criacão das layers
  func setupHudLayer() {  //Criacão da hud layer
    let hudLayer2 = Hudlayer()
    
    self.addChild(hudLayer2)
    hudLayer2.setupJoystick(player: self.char.chickenFather)
    hudLayer2.setupAttack()
    hudLayer2.setupTimeLabel(positionx: self.size)
    hudLayer2.setupPause()
    hudLayer2.addPause()
    hudLayer2.setupPlay()
    hudLayer2.setupHealth()
    hudLayer2.setupIcon()
    hudLayer2.setupCombo()
    hudLayer2.setarLuz3()
    hudLayer2.game = self
    hudLayer2.isSound = self.isSound
    hudLayer2.isMusic = self.isMusic
    self.hud = hudLayer2
    
  }
  
  func setupCharacterLayer(){
    let charLayer2 = CharactersLayer(chickenSon: self.son, chickenFather: self.player, campfire1: self.campfire, campfire2: self.campfire2, campfire3: self.campfire3, campfire4: self.campfire4, lightNode: self.lightNode)
    charLayer2.isMusic = self.isMusic
    charLayer2.isSound = self.isSound
    charLayer2.setupInitialCharacters()
    charLayer2.chickenFather.run(breath)
    charLayer2.setAllEnemy()
    charLayer2.setarObserversPlayer()
    self.addChild(charLayer2)
    self.char = charLayer2
  }
  
  func setupAlertLayer(){
    self.layerAlert.setupAlerts()
    self.addChild(self.layerAlert)
  }
  
  func setupMusic(){
    if (isMusic){
      let audioPath = Bundle.main.path(forResource: "musicInGame", ofType: "mp3")!
      do {
        try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath) as URL)
      } catch {
        print("no file sound")
      }
      self.audioPlayer.play()
      audioPlayer.numberOfLoops = -1
    }
  }
  
  func setupSound(){
    if isSound{
      self.setupAudioFogueira()
      self.listener = self.player
    }
  }
  
  func setupData(){
    let dados = UserData()
    dados.carregarDadosSettings()
  }
  
  //Acender Fogueira
  var moving = false
  var timeMoved:Timer?
  var contadorMoved = 0
  var canTurnOnCampfire = false
  var locationCampfire = CGPoint()
  var campfireIsOn = 0
  
  func setupTimerMoved(){//Tempo para que o touches moved possa ligar a campfire
    timeMoved = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
      if (self.moving == true){
        self.contadorMoved += 1
        if (self.contadorMoved == 1){
          self.canTurnOnCampfire = true
        }
      }
      else if (self.moving == false){
        self.contadorMoved = 0
        self.canTurnOnCampfire = false
      }
    })
  }
  
  func setupCampfire(){ //Pegar a posicao do touches moved e relacionar a fogueira correspondente
    if (locationCampfire == campfire.position){
      self.campfireIsOn = 1
    }else if (locationCampfire == campfire2.position){
      self.campfireIsOn = 2
    }else if (locationCampfire == campfire3.position){
      self.campfireIsOn = 3
    }else if(locationCampfire == campfire4.position){
      self.campfireIsOn = 4
    }
    self.acendeuFogueiraTut = true
    lightBonfireCount += 1
  }
  
  func turnOnCampfire(){

    
    
    //Ligar a fogueira selecionada
    if (canTurnOnCampfire){
      
      self.setupCampfire()
      switch self.campfireIsOn {
      case 1:
        if (self.campfire.ligada == false){
          self.atirarFlecha()
          fp?.isHidden = false
          fpp?.particleSpeed = 200
          self.campfiresAction(campfire: campfire, idCampfire: 1)
          self.campfireLigada.position = self.campfire.position
          self.campfire.ligada = true
          self.campfire.mostrarPontuacao()
          self.char.chickenSon.qtdFoiAtingido = 0
          self.char.chickenSon.preencherBarrinhaDeMedo.removeFromParent()
          run(Utils.Actions.timeTurnCampfire){
            self.fp?.isHidden = true
            self.fpp?.particleSpeed = 50
            
            //Voltar a campfire para o estado normal
            self.campfireCancelActions(campfire: self.campfire, idCampfire: 1)
            self.run(Utils.Actions.timeTurnCampfire){
              self.campfire.ligada = false
            
            }
          }
        }
        break;
      case 2:
        if (self.campfire2.ligada == false){
          self.atirarFlecha()
          fp2?.isHidden = false
          fpp2?.particleSpeed = 200
          self.campfiresAction(campfire: campfire2, idCampfire: 2)
          self.campfireLigada.position = self.campfire2.position
          self.campfire2.ligada = true
          self.campfire2.mostrarPontuacao()
          self.char.chickenSon.qtdFoiAtingido = 0
          self.char.chickenSon.preencherBarrinhaDeMedo.removeFromParent()
          run(Utils.Actions.timeTurnCampfire){
            self.fp2?.isHidden = true
             self.fpp2?.particleSpeed = 50
            self.campfireCancelActions(campfire: self.campfire2, idCampfire: 2)
            self.run(Utils.Actions.timeTurnCampfire){
              self.campfire2.ligada = false
            }
          }
        }
        break;
      case 3:
        if (self.campfire3.ligada == false){
          self.atirarFlecha()
          fp3?.isHidden = false
          fpp3?.particleSpeed = 200
          self.campfiresAction(campfire: campfire3, idCampfire: 3)
          self.campfireLigada.position = self.campfire3.position
          self.campfire3.ligada = true
          self.campfire3.mostrarPontuacao()
          self.char.chickenSon.qtdFoiAtingido = 0
          self.char.chickenSon.preencherBarrinhaDeMedo.removeFromParent()
          run(Utils.Actions.timeTurnCampfire){
            self.fp3?.isHidden = true
             self.fpp3?.particleSpeed = 50
            self.campfireCancelActions(campfire: self.campfire3, idCampfire: 3)
            self.run(Utils.Actions.timeTurnCampfire){
              self.campfire3.ligada = false
            }
          }
        }
        break;
      case 4:
        if (self.campfire4.ligada == false){
          self.atirarFlecha()
          fp4?.isHidden = false
          fpp4?.particleSpeed = 200
          self.campfiresAction(campfire: campfire4, idCampfire: 4)
          self.campfireLigada.position = self.campfire4.position
          self.campfire4.ligada = true
          self.campfire4.mostrarPontuacao()
          self.char.chickenSon.qtdFoiAtingido = 0
          self.char.chickenSon.preencherBarrinhaDeMedo.removeFromParent()
          run(Utils.Actions.timeTurnCampfire){
            self.fp4?.isHidden = true
             self.fpp4?.particleSpeed = 50
            self.campfireCancelActions(campfire: self.campfire4, idCampfire: 4)
            self.run(Utils.Actions.timeTurnCampfire){
              self.campfire4.ligada = false
            }
          }
        }
        break;
      default: break
      }
    }
  }
  
  //Audio Fogueira
  let audioFogueira = SKAudioNode(fileNamed: "Fire.mp3")
  let audioFogueira2 = SKAudioNode(fileNamed: "Fire.mp3")
  let audioFogueira3 = SKAudioNode(fileNamed: "Fire.mp3")
  let audioFogueira4 = SKAudioNode(fileNamed: "Fire.mp3")
  
  func setupAudioFogueira(){
    self.audioFogueira.isPositional = true
    self.audioFogueira2.isPositional = true
    self.audioFogueira3.isPositional = true
    self.audioFogueira4.isPositional = true
    self.audioFogueira.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
    self.audioFogueira2.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
    self.audioFogueira3.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
    self.audioFogueira4.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
    
    self.campfire.addChild(self.audioFogueira)
    self.campfire2.addChild(self.audioFogueira2)
    self.campfire3.addChild(self.audioFogueira3)
    self.campfire4.addChild(self.audioFogueira4)
  }
  
  //Funções da scene
  func vibrate(){
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    //camera.run(SKAction.screenZoomWithNode(camera, amount: CGPoint(x: -15, y: 0), oscillations: 4, duration: 2))
  }
  
  func vibrate2(){
    AudioServicesPlaySystemSound(1520)
    // camera.run(SKAction.screenZoomWithNode(camera, amount: CGPoint(x: -15, y: 0), oscillations: 4, duration: 2))
  }
  
  func vibrate3(){
    AudioServicesPlaySystemSound(1521)
  }
  
  func startLoading(){
    self.addChild(loading)
    self.loading.setupLoading()
    
  }
  
  func stopLoading(){
    loading.removeFromParent()
  }
  
  let wait = SKAction.wait(forDuration: 4)
  
  
  override func didMove(to view: SKView) {
  
    dados.carregarDadosSettings()
    self.isMusic = dados.musica
    self.isSound = dados.sons
    canUpdate = true
    if entrouLoading == false {
      self.inLoading = true
      self.startLoading()
      self.setupMusic()
      self.setupSound()
      self.setupData()
      self.setupWorldPhysics()
      entrouLoading = true
      self.run(wait){
        self.inLoading = false
        self.stopLoading()
        self.setupTutorial()
        self.physicsWorld.contactDelegate = self
        self.setupCamera()
        self.setupHudLayer()
        self.setupAlertLayer()
        self.setUpTimer()
        self.setUpTimer2()
        self.setupTimer3()
        self.setupTimerMoved()
        self.setarSnow()
        self.setupCharacterLayer()
        self.setarCabanas()
        self.setarCampfires()
        self.hud.delegate = self.char //Hud enviar informções para char
        self.hud.delegate2 = self //Hud trazer informações
        self.listener = self.player
      }
    }
    else{
      self.setupMusic()
      self.setupSound()
      self.setupData()
      self.setupWorldPhysics()
      self.setupTutorial()
      self.physicsWorld.contactDelegate = self
      self.setupCamera()
      self.setupHudLayer()
      self.setupAlertLayer()
      self.setUpTimer()
      self.setUpTimer2()
      self.setupTimer3()
      self.setupTimerMoved()
      self.setarSnow()
      self.setupCharacterLayer()
      self.setarCabanas()
      self.setarCampfires()
      self.hud.delegate = self.char //Hud enviar informções para char
      self.hud.delegate2 = self //Hud trazer informações
      self.listener = self.player
    }

  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    endGameScene.touchesBegan(touches, with: event)
    self.children.forEach { (node) in
      node.touchesBegan(touches, with: event)
    }
    
    if (tutorialFilho){
      self.isPaused = false
      self.tutorial.removeAllChildren()
      self.tutorialFilho = false
      self.hud.analogJoystick.disabled = false
      self.hud.attackButton.isUserInteractionEnabled = false
      self.char.chickenFather.constraintSon.enabled = false
      self.playAll()
    }
    
    if (tutorialFlechas){
      self.isPaused = false
      self.tutorial.removeAllChildren()
      self.tutorialFlechas = false
      self.hud.analogJoystick.disabled = false
      self.hud.attackButton.isUserInteractionEnabled = false
      self.setUpTimer()
      self.setUpTimer2()
      self.char.chickenFather.constraintCampfire.enabled = false
      self.playAll()
    }
    
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    self.children.forEach{
      (node) in
      node.touchesMoved(touches, with: event)
    }
    
    if(self.char.chickenFather.position.distanceTo(campfire.position) < 300 || self.char.chickenFather.position.distanceTo(campfire2.position) < 300
      || self.char.chickenFather.position.distanceTo(campfire3.position) < 300 || self.char.chickenFather.position.distanceTo(campfire4.position) < 300) {
      
      for touch in touches{
        let location = touch.location(in: self)
        self.moving = true
        if (location.distanceTo(campfire.position) < 50){
          self.locationCampfire = campfire.position
        }else if (location.distanceTo(campfire2.position) < 50){
          self.locationCampfire = campfire2.position
        }else if (location.distanceTo(campfire3.position) < 50){
          self.locationCampfire = campfire3.position
        }else if (location.distanceTo(campfire4.position) < 50){
          self.locationCampfire = campfire4.position
        }
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    self.children.forEach{
      (node) in
      node.touchesEnded(touches, with: event)
    }
    self.moving = false
  }
  
  override func update(_ currentTime: TimeInterval) {
    
    if(canUpdate){
      if (canRodarTutorial){
        self.rodarTutorial()
      }
      self.layerAlert.position = self.camera!.position
      self.hud.setTimeLabel(position: self.size, timeAux: self.timeAux)
      //  self.saveEnemies()
      
      if (self.player.lado == false){
        lightNode.position.x = player.position.x + 35
        lightNode.position.y = player.position.y + 40
      }else {
        lightNode.position.x = player.position.x - 35
        lightNode.position.y = player.position.y + 40
      }
      if (cameraFollow) {
        self.smoothCamera.setCamera(position: self.player.position)
        self.hud.position = self.smoothCamera.position
      }
      else{
        self.hud.position = auxPos
      }
      
      //Filho
      self.proximidadeFilho()
      
      //Alerta
      if (self.char.chickenSon.hp < 20){
        if (self.char.chickenSon.position.distanceTo(self.char.chickenFather.position) > 300){
          self.setupAlertsPlayer()
          self.alertIsOn = true
        }else{
          self.layerAlert.emmiterAlert1?.isHidden = true
          self.layerAlert.emmiterAlert2?.isHidden = true
          self.layerAlert.emmiterAlert3?.isHidden = true
          self.layerAlert.emmiterAlert4?.isHidden = true
        }
      }
    }
    
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    
    guard canUpdate else { return }
    
    var targetEnemy: SKPhysicsBody? = nil
    var targetEspada: SKPhysicsBody? = nil
    var targetPlayer: SKPhysicsBody? = nil
    var targetSon: SKPhysicsBody? = nil
    var targetTrap: SKPhysicsBody? = nil
    var targetArrow: SKPhysicsBody? = nil
    
    //Target Colisoes
    if ((contact.bodyA.node?.name == "EnemyMale") || (contact.bodyA.node?.name == "EnemyFemale"))  {
      targetEnemy = contact.bodyA
    }else if ((contact.bodyB.node?.name == "EnemyMale") || (contact.bodyB.node?.name == "EnemyFemale")){
      targetEnemy = contact.bodyB
    }
    
    if (contact.bodyA.node?.name == "Weapon"){
      targetEspada = contact.bodyA
    }else if (contact.bodyB.node?.name == "Weapon"){
      targetEspada = contact.bodyB
    }
    
    if (contact.bodyA.node?.name == "Player"){
      targetPlayer = contact.bodyA
    }else if (contact.bodyB.node?.name == "Player"){
      targetPlayer = contact.bodyB
    }
    
    if (contact.bodyA.node?.name == "Son"){
      targetSon = contact.bodyA
    }else if (contact.bodyB.node?.name == "Son"){
      targetSon = contact.bodyB
    }
    
    if (contact.bodyA.node?.name == "Trap"){
      targetTrap = contact.bodyA
    }else if (contact.bodyB.node?.name == "Trap"){
      targetTrap = contact.bodyB
    }
    
    if (contact.bodyA.node?.name == "Flecha"){
      targetArrow = contact.bodyA
    }else if (contact.bodyB.node?.name == "Flecha"){
      targetArrow = contact.bodyB
    }
    
    
    //Colisoes
    
    //Espada e Enemys
    if (targetEspada != nil && targetEnemy !=  nil){
      if let enemy = targetEnemy?.node as? Enemy{
        enemy.hp -= 1
        if (enemy.hp == 0){
          self.char.enemyDie(enemies: enemy)
          self.killCombo += 1
        }
        enemy.physicsBody?.categoryBitMask = CategoryMask.enemyInvul.rawValue
        run(Utils.Actions.timerTwoSeconds){
          enemy.physicsBody?.categoryBitMask = CategoryMask.enemy.rawValue
        }
        
        if (tutorialEnemy == true){
          self.char.chickenFather.constraintEnemy.enabled = false
          self.playAll()
          self.setUpTimer()
          self.setUpTimer2()
          self.tutorial.labelInimigos.removeFromParent()
          self.tutorial.luzAux3.removeFromParent()
          self.hud.attackButton.removeAllActions()
          self.char.chickenFather.turnOff()
          self.hud.attackButton.removeAllActions()
          tutorialEnemy = false
          
        }
      }
    }
    
    //Player e Enemys
    if (targetPlayer != nil && targetEnemy != nil){
      
      if let enemy = targetEnemy?.node as? Enemy{
        if (enemy.hp > 0){
          
          if (enemy.attack == false){
            enemy.atacar(positionPlayer: self.char.chickenFather.position)
            if !(comboInUse){
              player.hp -= enemy.dano
              self.hud.decHp(mult: enemy.dano)
            }
            if (player.hp <= 0){
              self.hud.analogJoystick.disabled = true
              self.hud.isHidden = true
              self.gameOver()
            }
          }
        }
      }
    }
    
    //Colisao son e enemy
    if (targetSon != nil && targetEnemy != nil){
       if let enemy = targetEnemy?.node as? Enemy{
          if (enemy.attack == false){
            enemy.atacar(positionPlayer: self.char.chickenSon.position)
            self.char.chickenSon.foiAtingido = true
          }
        }
      }
    
    //Trap e player
    if (targetTrap != nil && targetPlayer != nil){
      if let trap = targetTrap?.node as? Trap{
        if comboInUse == false{
          self.char.inTrap = true
          self.hud.attackButton.isUserInteractionEnabled = true
          self.hud.botaoCombo.isUserInteractionEnabled = true
          let textureAntiga = self.player.texture
          self.player.texture = Utils.Atlas.sprites.textureNamed("PaiPreso")
          self.char.sword.alpha = 0
          run(Utils.Actions.timerThreeSeconds){
            self.char.inTrap = false
            self.hud.attackButton.isUserInteractionEnabled = false
            self.hud.botaoCombo.isUserInteractionEnabled = false
            self.player.texture = textureAntiga
            self.char.sword.alpha = 1
          }
          trap.removeFromParent()
          if (tutorialTrap){
            self.tutorial.removeAllChildren()
            self.tutorialTrap = false
            self.setUpTimer()
            self.setUpTimer2()
            self.char.chickenFather.constraintTrap.enabled = false
            self.playAll()
            self.hud.attackButton.removeAllActions()
            self.tutorial.luzAux3.removeFromParent()
            self.voltarEnemysTrap()
          }
        }
      }
    }
    
    //Colisao entre trap e espada
    if (targetTrap != nil && targetEspada != nil){
      if let trap = targetTrap?.node as? Trap{
        trap.removeFromParent()
        self.trapsInScene -= 1
        if (tutorialTrap){
          self.tutorial.removeAllChildren()
          self.tutorialTrap = false
          self.setUpTimer()
          self.setUpTimer2()
          self.char.chickenFather.constraintTrap.enabled = false
          self.playAll()
          self.hud.attackButton.removeAllActions()
          self.tutorial.luzAux3.removeFromParent()
          self.voltarEnemysTrap()
        }
      }
    }
    
    //Colisao entre flecha e player
    if (targetArrow != nil && targetPlayer != nil){
      if let flecha = targetArrow?.node as? Flecha{
        self.setupEmmiterPai()
        flecha.flechafire2?.particleBirthRate = 0
        flecha.flechafire2?.resetSimulation()
        flecha.flechafire2?.targetNode = nil
        flecha.flechafire2?.removeFromParent()
        flecha.flechafire2?.particleAlpha = 0.0
        flecha.removeFromParent()
        if (!comboInUse){
          self.player.hp -= flecha.dano
          self.hud.decHp(mult: flecha.dano)
        }
        flecha.removeFromParent()
        if (player.hp <= 0){
          self.hud.analogJoystick.disabled = true
          self.hud.isHidden = true
          self.gameOver()
        }
      }
    }
    
    //Colisao entre flecha e espada
    if (targetEspada != nil && targetArrow != nil){
      if let flecha = targetArrow?.node as? Flecha{
        flecha.flechafire2?.particleBirthRate = 0
        flecha.flechafire2?.resetSimulation()
        flecha.flechafire2?.targetNode = nil
        flecha.flechafire2?.removeFromParent()
        flecha.flechafire2?.particleAlpha = 0.0
        flecha.removeFromParent()
      }
    }
    
    //Colisao entre flecha e inimigo
    if (targetEspada != nil && targetEnemy != nil){
      if let flecha = targetArrow?.node as? Flecha{
        flecha.flechafire2?.particleBirthRate = 0
        flecha.flechafire2?.resetSimulation()
        flecha.flechafire2?.targetNode = nil
        flecha.flechafire2?.removeFromParent()
        flecha.flechafire2?.particleAlpha = 0.0
        flecha.removeFromParent()
      }
    }  
  }
  
  let smoothCamera: SKSmoothCameraNode  = {
    let smoothCamera = SKSmoothCameraNode(cameraAlpha: 0.8)
    return smoothCamera
  }()
  
  
  func setupCamera() {
    
    self.camera = self.smoothCamera
    
    guard let camera = camera, let view = view else { return }
    
    let zeroDistance = SKRange(constantValue: 0)
    let playerConstraint = SKConstraint.distance(zeroDistance,
                                                 
                                                 to: player)
    let xInset = min(view.bounds.width/2 * camera.xScale,
                     background.frame.width/2)
    let yInset = min(view.bounds.height/2 * camera.yScale,
                     background.frame.height/2)
    
    let constraintRect = background.frame.insetBy(dx: xInset,
                                                  
                                                  dy: yInset)
    let xRange = SKRange(lowerLimit: constraintRect.minX,
                         upperLimit: constraintRect.maxX)
    let yRange = SKRange(lowerLimit: constraintRect.minY,
                         upperLimit: constraintRect.maxY)
    let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
    edgeConstraint.referenceNode = background
    
    camera.constraints = [playerConstraint, edgeConstraint]
    
  }
  
  func setupWorldPhysics() {
    var changeTheLight = SKAction()
    var changeTheLigthReturn = SKAction()
    var changeTheLigthSequence = SKAction()
    
    campfire.position = CGPoint(x: -1280, y: 640)
    campfire2.position = CGPoint(x: 1280, y: 640)
    campfire3.position = CGPoint(x: -1280, y: -640)
    campfire4.position = CGPoint(x: 1280, y: -640)
    background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
    background.lightingBitMask = 1 
    lightNode.categoryBitMask = 1
    lightNode.falloff = 1.5
    lightNode.ambientColor = .black
    lightNode.lightColor = UIColor.init(white: 0.9, alpha: 0.8)
    lightNode.shadowColor = .black
    
    changeTheLight = SKAction.customAction(withDuration: 0.2){
      (node, elapsedTime) in
      if self.lightNode.alpha > 0.9{
        self.lightNode.alpha -= 0.1
        self.lightNode.lightColor = UIColor.init(white: 0.5, alpha: self.lightNode.alpha)
      }
    }
    
    changeTheLigthReturn = SKAction.customAction(withDuration: 0.2){
      (node, elapsedTime) in
      if self.lightNode.alpha < 1.0{
        self.lightNode.alpha += 0.1
        self.lightNode.lightColor = UIColor.init(white: 0.5, alpha: self.lightNode.alpha)
      }
    }
    
    changeTheLigthSequence = SKAction.sequence([changeTheLight, changeTheLigthReturn])
    self.lightNode.run(SKAction.repeatForever(changeTheLigthSequence))
    
    lightFire.falloff = 7
    lightFire.ambientColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
    lightFire.lightColor = UIColor.init(white: 0.9, alpha: 0.7)
    lightFire.shadowColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
    
    lightFire2.falloff = 7
    lightFire2.ambientColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
    lightFire2.lightColor = UIColor.init(white: 0.9, alpha: 0.7)
    lightFire2.shadowColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
    
    lightFire3.falloff = 7
    lightFire3.ambientColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
    lightFire3.lightColor = UIColor.init(white: 0.9, alpha: 0.7)
    lightFire3.shadowColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
    
    lightFire4.falloff = 7
    lightFire4.ambientColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
    lightFire4.lightColor = UIColor.init(white: 0.9, alpha: 0.7)
    lightFire4.shadowColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
    
    lightFire.position = campfire.position
    lightFire2.position = campfire2.position
    lightFire3.position = campfire3.position
    lightFire4.position = campfire4.position
    
    addChild(lightNode)
    addChild(lightFire)
    addChild(lightFire2)
    addChild(lightFire3)
    addChild(lightFire4)
    
    addChild(campfire)
    addChild(campfire2)
    addChild(campfire3)
    addChild(campfire4)
  }
  
  
  //TIMER PARA FUNCOES ESPECIFICAS DA CENA
  func setUpTimer(){
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {  _ in
      if (self.isPaused == false){
        self.timeAux += 1
        self.hud.hpFranguin.text = "\(self.son.hp)"
        self.timeSurvive += 1
        
        
        if (self.timeAux%2 == 0){
          self.char.enemySpawn(name: "EnemyMale")
          self.char.enemySpawn(name: "EnemyFemale")
        }
        
        if self.timeAux.isMultiple(of: 10) && self.trapsInScene < self.maximoTrap{
          self.trapGenerate()
        }
        
        self.trocarPosicaoTrap()
        
        if (self.char.chickenSon.position.distanceTo(self.char.chickenFather.position) > 400) && !(self.comboInUse) && self.char.chickenSon.movingSon == false{
          self.char.chickenSon.hp -= 1
          self.hud.decHp2(mult: 1)
          if (self.char.chickenSon.hp < 10){
            self.vibrate()
          }
        }
        
        if self.char.chickenSon.hp == 0{
          self.hud.analogJoystick.disabled = true
          self.hud.isHidden = true
          self.gameOver()
        }
        
        if (self.killCombo >= 5){
          self.willCombo = true
          self.hud.trocarCombo(canCombo: true)
        }
        
      }
    })
  }
  
  //TIMER PARA INIMIGOS E TRAP
  func setUpTimer2(){
    timer2 = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: {  _ in
      if (self.isPaused == false){
        self.char.enemyMove()
        self.char.virarEnemys()
        self.char.setupActionEnemys()
        self.takePositionTrap()
      }
    })
  }
  
  
  //TIMER PARA CAMPFIRE/ FLECHAS
  func setupTimer3(){
    timer3 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {  _ in
      if (self.isPaused == false){
        self.turnOnCampfire()
        self.setarTarget()
      }
    })
  }
  
  func setupScore(){
    self.killEnemyCount = self.char.killEnemyCount
    let totalPontosEnemy = killEnemyCount * 10
    let totalPontosTimer = timeSurvive * 10
    let totalPontosFoundSon = foundSon * 150
    let totalPontosCampfire = lightBonfireCount * 100
    
    self.char.chickenFather.score = Int(totalPontosTimer) + Int(totalPontosEnemy) + totalPontosFoundSon + totalPontosCampfire
    
    killEnemyCount = 0
    timeSurvive = 0
    foundSon = 0
    lightBonfireCount = 0
    
    
    
  }
  
  var primeiraFilho = true
  
  func proximidadeFilho(){
    if char.chickenSon.position.distanceTo(player.position) <= 150 && tutorialFilho == false && tutorialAlerta == false && char.chickenSon.foiAchado == false && !inLoading{
     
      
      if primeiraFilho {
        primeiraFilho = false
      }else{
        foundSon += 1
        char.chickenSon.mostrarPontuacao()
      }
      
      char.chickenSon.foiAchado = true
      
      char.chickenSon.setarBarraDeMedo()
      run(Utils.Actions.timerThreeSeconds){
        var timerAtingiuSon: Timer?
        timerAtingiuSon = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { _ in
          if (self.char.chickenSon.foiAtingido){
            self.char.chickenSon.qtdFoiAtingido += 1
            print(self.char.chickenSon.qtdFoiAtingido)
            self.char.chickenSon.aumentarMedo(qtdAtaque: self.char.chickenSon.qtdFoiAtingido)
            self.char.chickenSon.foiAtingido = false
          }
          if (self.char.chickenSon.qtdFoiAtingido >= 3){
            self.char.chickenSon.willRun()
            timerAtingiuSon?.invalidate()
          }
        })
      }
    }
  }
  
  //Ads
  var gameViewController: GameViewController?
  
  var entrouGameOver = false
  func gameOver(){
    if (entrouGameOver == false){
      self.setupScore()
      if endGameScene.parent != nil{
        self.endGameScene.removeAllChildren()
        self.endGameScene.removeFromParent()
      }
      endGameScene.gameScene = self
      if (isMusic){
        self.audioPlayer.stop()
      }
      self.char.chickenFather.texture = Utils.Atlas.sprites.textureNamed("sos")
      self.char.sword.removeFromParent()
      self.layerAlert.removeFromParent()
      self.entrouGameOver = true
      run(Utils.Actions.timerTwoSeconds){
        self.isPaused = true
        self.canUpdate = false
        self.timer?.invalidate()
        self.timer2?.invalidate()
        self.timer3?.invalidate()
        self.camera?.position = CGPoint(x: 0, y: 0)
        self.endGameScene.base.position = self.camera!.position
        self.endGameScene.gameOver(scorePlayer: self.char.chickenFather.score, timeSurvive: self.timeAux)
        self.addChild(self.endGameScene)
       //self.gameViewController?.goAds()
      }
    }
  }
  
  func setupAlertsPlayer(){
    var esqDir = false //False -- Alerta pra esquerda   True -- Alerta pra direita
    var baixoCima = false //False -- Alerta pra baixo   True -- Alerta pra cima
    if (self.char.chickenSon.position.x < self.char.chickenFather.position.x){  //Entao alerta pra esquerda
      esqDir = false
    }else{  //Alerta pra direita
      esqDir = true
    }
    
    if (self.char.chickenSon.position.y < self.char.chickenFather.position.y){ //Entao alerta pra baixo
      baixoCima = false
    }else{ //Alerta pra cima
      baixoCima = true
    }
    
    if (esqDir == false && baixoCima == true){
      self.layerAlert.setarAlerta(position: 1)
    }else if (esqDir == true && baixoCima == true){
      self.layerAlert.setarAlerta(position: 2)
    }else if (esqDir == false && baixoCima == false){
      self.layerAlert.setarAlerta(position: 3)
    }else if (esqDir == true && baixoCima == false){
      self.layerAlert.setarAlerta(position: 4)
    }
    
  }
  
  func campfiresAction(campfire: Campfire, idCampfire: Int){
    switch (idCampfire){
    case 1:
      self.lightFire.falloff = 0.2
      self.audioFogueira.run(SKAction.changeVolume(to: 2.5, duration: 0.0))
    case 2:
      self.lightFire2.falloff = 0.2
      self.audioFogueira2.run(SKAction.changeVolume(to: 2.5, duration: 0.0))
    case 3:
      self.lightFire3.falloff = 0.2
      self.audioFogueira3.run(SKAction.changeVolume(to: 2.5, duration: 0.0))
    case 4:
      self.lightFire4.falloff = 0.2
      self.audioFogueira4.run(SKAction.changeVolume(to: 2.5, duration: 0.0))
    default:
      break
    }
   // campfire.trocarNode(node: campfire, imagem: "fogueira2")
    self.setupConstraintEnemys(campfire: campfire)
  }
  
  func campfireCancelActions(campfire: Campfire, idCampfire: Int){
    switch (idCampfire){
    case 1:
      self.lightFire.falloff = 7
      self.audioFogueira.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
    case 2:
      self.lightFire2.falloff = 7
      self.audioFogueira2.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
    case 3:
      self.lightFire3.falloff = 7
      self.audioFogueira3.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
    case 4:
      self.lightFire4.falloff = 7
      self.audioFogueira4.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
    default:
      break
    }
    //campfire.trocarNode(node: campfire, imagem: "fogueira1")
    self.cancelConstraintsEnemy()
  }
  
  func canCombo(){
    
    if !tutorialAlerta{
      
      if (self.tutorialCombo){
        self.setUpTimer()
        self.setUpTimer2()
        self.playAll()
        self.hud.analogJoystick.alpha = 1
        self.hud.attackButton.alpha = 1
        self.tutorialCombo = false
        self.tutorial.labelCombo.removeFromParent()
        self.char.chickenFather.physicsBody?.categoryBitMask = CategoryMask.player.rawValue
      }
      setEnemy.removeAll()
      saveEnemies()
      
      if (setEnemy.count == 0){
        return
      }else{
      self.willCombo = false
      self.comboInUse = true
      self.killCombo = 0
      self.hud.trocarCombo(canCombo: false)
      self.hud.analogJoystick.disabled = true
      self.hud.attackButton.isUserInteractionEnabled = true
      
      let posAux = player.position
      var enemiesCount = 0
      auxPos = posAux
      self.stopFollow()
      
      cameraFollow = false
      let volta = SKAction.move(to: posAux, duration: 0.0)
      var combo = Array<SKAction>()
      let audioCombo = SKAction.playSoundFileNamed("Combo.mp3", waitForCompletion: false)
      
      for enemy in setEnemy{
        enemiesCount += 1
        let andar = SKAction.move(to: enemy.position, duration: 0.1)
        let espera = SKAction.wait(forDuration: 0.0)
        let vibrar = SKAction.run{
          self.vibrate2()
        }
        let remove = SKAction.run{
          self.char.enemyDie(enemies: enemy)
          
        }
        if isSound{
          let seq = SKAction.sequence([andar,vibrar,audioCombo,espera,remove])
          combo.append(seq)
        }
        else{
          let seq = SKAction.sequence([andar,vibrar,espera,remove])
          combo.append(seq)
        }
      }
      let rotate = SKAction.rotate(byAngle: 100, duration: TimeInterval(enemiesCount) * 0.1)
      let playerBack = SKAction.rotate(byAngle: -100, duration: 0.0)
      
      let seq2 = SKAction.sequence(combo)
      self.player.run(rotate)
      
      self.player.addChild(self.player.fire!)
      self.player.fire?.position = CGPoint(x: -1000, y: 350)
      self.player.fire?.targetNode = self
      self.player.fire?.particleBirthRate = 1000
      self.player.fire?.run(SKAction.scale(to: 5, duration: 0))
      player.run(SKAction.sequence([seq2,volta]))
      
      let cameraBack = SKAction.wait(forDuration: TimeInterval(enemiesCount)*0.1 + 0.1)
      
      run(cameraBack){
        self.player.fire?.position = CGPoint(x: 300, y: 240)
        self.player.fire?.targetNode = nil
        self.player.fire?.particleBirthRate = 150
        self.player.fire?.run(SKAction.scale(to: 1, duration: 0.0))
        self.player.fire?.removeFromParent()
        self.followBack()
        self.cameraFollow = true
        self.comboInUse = false
        self.hud.analogJoystick.disabled = false
        self.hud.attackButton.isUserInteractionEnabled = false
        self.player.run(playerBack)
      }
      }
    }
  }
    
    
    func saveEnemies(){
      
      for enemy in char.arrayTotal{
        if (enemy.parent == nil){
          return
        }
        else{
          if enemy.position.distanceTo(self.player.position) < 300{
            setEnemy.insert(enemy)
          }
        }
      }
    }
    
    func stopFollow(){
      let backConstraint = SKConstraint.distance(SKRange(constantValue: 0), to: auxPos)
      camera?.constraints = [backConstraint]
      
    }
    
    func followBack(){
      let playerConstraint = SKConstraint.distance(SKRange(constantValue: 0),
                                                   to: player)
      camera?.constraints = [playerConstraint]
      
    }
    
    func setupConstraintEnemys(campfire: Campfire){
      campfire.turnOn()
    }
    
    func cancelConstraintsEnemy(){
      campfire.turnOff()
    }
    
    
    func takePositionTrap(){
      var positionInitial:CGPoint = player.position
      
      if self.direcaoX{
        positionInitial.x += 150
      }else{
        positionInitial.x -= 150
      }
      if self.direcaoY{
        positionInitial.y += 150
      }else{
        positionInitial.y -= 150
      }
      
      print(positionInitial)
      
      if (positionInitial.x > 2000){
        positionInitial.x -= 400
      }else if (positionInitial.x < -1920){
        positionInitial.x += 400
      }
      if (positionInitial.y < -1120){
        positionInitial.y += 400
      }else if (positionInitial.y > 1360){
        positionInitial.y -= 400
      }
      
      self.positionTrap = positionInitial
    }
    
    
    func trocarPosicaoTrap(){ //A cada segundo verifica se a trap já ficou ativar por 10s, caso sim, troca a posicao dela
      
      for trap in arrayTraps{
        if trap.canChangePosition{
          trap.position = self.positionTrap
          trap.canChangePosition = false
          trap.timerAtiva = 0
        }
      }
    }
    
    func trapGenerate(){
      var validouPlayer = false
      arrayTraps[self.trapsInScene].removeFromParent()
      
      arrayTraps[self.trapsInScene].position = self.positionTrap
      
      if (self.positionTrap.distanceTo(self.char.chickenFather.position) > 150){
        validouPlayer = true
      }
      
      if (!validouPlayer){
        arrayTraps[self.trapsInScene].position = CGPoint(x: self.positionTrap.x + 150, y: self.positionTrap.y + 150)
      }
      
      
      //Criar constraints p/ outras traps
      var constraintTraps = [SKConstraint]()
      
      for trap in arrayTraps{
        if trap != arrayTraps[self.trapsInScene]{
          constraintTraps.append(SKConstraint.distance(SKRange(lowerLimit: 200), to: trap))
        }
      }
      
      for constraint in constraintTraps{
        arrayTraps[self.trapsInScene].constraints?.append(constraint)
      }
      
      arrayTraps[self.trapsInScene].contarTempoAtiva()
      self.addChild(arrayTraps[self.trapsInScene])
      self.trapsInScene += 1
    }
    
    func setarTarget(){
      var contador = 0
      for flecha in arrayFlechas{
        flecha.flechafire2?.targetNode = self
        if (contador.isMultiple(of: 2)){
          flecha.target = CGPoint(x: (self.player.position.x), y: self.player.position.y)
        }else{
          flecha.target = CGPoint(x: (self.player.position.x), y: self.player.position.y)
        }
        contador += 1
      }
    }
    
    func atirarFlecha(){
      arrayFlechas[1].setarAtirarFlecha(position: self.player.position, node: self)
      run(Utils.Actions.timerHalfSecond){
        self.arrayFlechas[2].setarAtirarFlecha(position: self.player.position, node: self)
        self.run(Utils.Actions.timerHalfSecond){
          self.arrayFlechas[3].setarAtirarFlecha(position: self.player.position, node: self)
          self.run(Utils.Actions.timerHalfSecond){
            self.arrayFlechas[4].setarAtirarFlecha(position: self.player.position, node: self)
            self.run(Utils.Actions.timerHalfSecond){
              self.arrayFlechas[5].setarAtirarFlecha(position: self.player.position, node: self)
              self.run(Utils.Actions.timerHalfSecond){
                self.arrayFlechas[6].setarAtirarFlecha(position: self.player.position, node: self)
                self.run(Utils.Actions.timerHalfSecond){
                  self.arrayFlechas[7].setarAtirarFlecha(position: self.player.position, node: self)
                  self.run(Utils.Actions.timerHalfSecond){
                    self.arrayFlechas[8].setarAtirarFlecha(position: self.player.position, node: self)
                    self.run(Utils.Actions.timerHalfSecond){
                      self.arrayFlechas[9].setarAtirarFlecha(position: self.player.position, node: self)
                      self.run(Utils.Actions.timerHalfSecond){
                        self.arrayFlechas[10].setarAtirarFlecha(position: self.player.position, node: self)
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    
    func setupEmmiterPai(){
      if let emmiterPai = SKEmitterNode(fileNamed: "FireFrango.sks"){
        emmiterPai.setScale(5)
        emmiterPai.position.y -= 50
        self.player.addChild(emmiterPai)
      }
    }
    
    
    //Tutorial
    var tutorial = Tutorial()
    var canRodarTutorial = false
    var acendeuFogueiraTut = false
    var campfireAux = Campfire(nome: "Campfire1")
    var achouFilho = false
    
    
    //Valores p/ serem alterados fora do TUTORIAL ex. : Touches Began e DidBegin
    var tutorialFilho = false
    var tutorialEnemy = false
    var tutorialCampfire = false
    var tutorialFlechas = false
    var tutorialTrap = false
    var tutorialAlerta = false //Relacionar as demais funcoes na cena, como nao poder usar o combo, o filho nao poder correr e etc
    var auxiliarAlerta = false //Para verificar no setup das paredes
    var tutorialCombo = false
    
    //Variaveis p/ verificacao no tutorial
    var entrouFilho = false // Valor muda no TUTORIAL
    var entrouEnemy = false  // Valor muda no TUTORIAL
    var entrouCampfire = false
    var entrouFlechas = false
    var entrouTrap = false
    var entrouAlerta = false
    var entrouCombo = false
    
    func setupTutorial(){
      tutorial.carregarDados()
      self.addChild(tutorial)
      self.canRodarTutorial = true
    }
    
    func rodarTutorial(){
      if self.tutorial.sawSon == false && entrouFilho == false{ //ALTERAR
        
        if (self.char.chickenFather.position.distanceTo(self.char.chickenSon.position) < 150 && entrouFilho == false){
          self.char.chickenFather.constraintSon = SKConstraint.distance(SKRange(upperLimit: 150), to: self.char.chickenSon.position)  //COLOCAR PRA CIMA
          self.char.chickenFather.constraints?.append(self.char.chickenFather.constraintSon)
          self.stopAll() //Pausar enemys //COLOCAR PRA CIMA
          self.tutorial.setupLabelFilho(son: self.char.chickenSon) //Em cima da cabeça
          self.tutorial.setupContinue(player: self.char.chickenFather)
          self.tutorial.sawSon =  true
          self.dados.setupSawSon(saw: true)
          self.tutorialFilho = true //p Touches began
          self.entrouFilho = true
          self.isPaused = true
          self.hud.analogJoystick.disabled = true
          self.hud.attackButton.isUserInteractionEnabled = true
        }
      }
      
      if self.tutorial.sawEnemy == false && entrouEnemy == false && tutorialAlerta == false{ //ALTERAAAAAR
        if let enemy = aproximouEnemy(){
          enemy.inTutorial = true
          self.char.chickenFather.constraintEnemy = SKConstraint.distance(SKRange(upperLimit: 120), to: enemy.position)
          self.char.chickenFather.constraints?.append(self.char.chickenFather.constraintEnemy)
          self.timer?.invalidate()
          self.timer2?.invalidate()
          self.tutorial.setupLabelEnemy(enemy: enemy, attackButton: self.hud.attackButton)
          self.char.chickenFather.turnOn()
          self.stopAll()
          enemy.physicsBody?.isDynamic = false
          self.tutorial.sawEnemy = true
          self.dados.setupSawEnemy(saw: true)
          entrouEnemy = true
          tutorialEnemy = true
          enemy.inTutorial = false
        }
      }
      
      if self.tutorial.sawCampfire == false && entrouCampfire == false && tutorialEnemy == false && tutorialAlerta == false{  //Nao pode ir no mesmo momento do tutorial dos inimigos
        if let campfire = aproximouCampfire(){
          self.afastarEnemysCampfire(campfire: campfire)
          self.tutorial.setupLabelCampfire(campfire: campfire)
          self.char.chickenFather.constraintCampfire = SKConstraint.distance(SKRange(lowerLimit: 60, upperLimit: 150), to: campfire.position)
          self.char.chickenFather.constraints?.append(self.char.chickenFather.constraintCampfire)
          self.timer?.invalidate()
          self.timer2?.invalidate()
          self.stopAll()
          self.entrouCampfire = true
          self.tutorialCampfire = true
          self.campfireAux = campfire
          
          self.dados.setupSawCampfire(saw: true)
        }
      }
      
      if self.tutorial.sawAttention == false && self.acendeuFogueiraTut && entrouFlechas == false{
        self.tutorial.dedo.removeFromParent()
        self.tutorial.labelFogueira.removeFromParent()
        self.tutorial.setupLabelFlechas(player: self.char.chickenFather, campfire: campfireAux)
        self.hud.analogJoystick.disabled = true
        self.hud.attackButton.isUserInteractionEnabled = true
        entrouFlechas = true
        tutorialFlechas = true
        self.isPaused = true
        
        self.dados.setupSawAttention(saw: true)
      }
      
      if self.tutorial.sawTrap == false && entrouTrap == false && tutorialAlerta == false{
        if let trap = aproximouTrap(){
          self.char.chickenFather.constraintTrap = SKConstraint.distance(SKRange(upperLimit: 150), to: trap)
          self.char.chickenFather.constraints?.append(self.char.chickenFather.constraintTrap)
          trap.physicsBody?.isDynamic = false
          self.afastarEnemysTrap(trap: trap)
          self.stopAll()
          self.timer?.invalidate()
          self.timer2?.invalidate()
          self.tutorial.setupLabelTrap(trap: trap, player: self.char.chickenFather, attackButton: self.hud.attackButton)
          
          entrouTrap = true
          tutorialTrap = true
          
          self.dados.setupSawTrap(saw: true)
        }
      }
      
      
      if self.tutorial.sawCombo == false && entrouCombo == false && tutorialAlerta == false{
        
        if self.willCombo{
          self.stopAll()
          self.timer?.invalidate()
          self.timer2?.invalidate()
          self.entrouCombo = true
          self.tutorialCombo = true
          self.char.chickenFather.physicsBody?.categoryBitMask = CategoryMask.playerInvul.rawValue
          self.hud.analogJoystick.disabled = true
          self.hud.attackButton.isUserInteractionEnabled = true
          self.hud.analogJoystick.alpha = 0.3
          self.hud.attackButton.alpha = 0.3
          self.tutorial.setupLabelCombo(player: self.char.chickenFather)
          self.dados.setupSawCombo(saw: true)
        }
      }
      
      
      //ALERTA
      if (self.tutorial.sawAlert == false && entrouAlerta == false){
        if (self.alertIsOn){
          self.tutorial.setupLabelAlerta(player: self.char.chickenFather)
          self.char.chickenFather.physicsBody?.categoryBitMask = CategoryMask.playerInvul.rawValue
          self.stopAll()
          self.timer?.invalidate()
          self.timer2?.invalidate()
          self.char.chickenFather.turnOn()
          self.hud.attackButton.isUserInteractionEnabled = true
          self.entrouAlerta = true
          self.tutorialAlerta = true
          self.cancelAlert()
          self.dados.setupSawAlert(saw: true)
        }
      }
    }
    
    
    func aproximouEnemy() -> Enemy?{
      for enemy in self.char.arrayTotal{
        if (enemy.position.distanceTo(self.char.chickenFather.position) < 200){
          return enemy
        }
      }
      return nil
    }
    
    func stopAll (){
      for enemy in self.char.arrayTotal{
        enemy.isPaused = true
      }

    }
    
    func playAll (){
      for enemy in self.char.arrayTotal{
        enemy.isPaused = false
      }
      for enemy in self.char.trashArrayF {
        enemy.isPaused = false
      }
      
      for enemy in self.char.trashArrayM{
        enemy.isPaused = false
      }
    }
    
    func afastarEnemysCampfire(campfire : Campfire){
      for enemy in self.char.arrayTotal{
        enemy.constraintCampfire = SKConstraint.distance(SKRange(lowerLimit: 400), to: campfire.position)
        enemy.constraints?.append(enemy.constraintCampfire)
      }
    }
    
    func voltarEnemysTrap(){
      for enemy in self.char.arrayTotal{
        enemy.constraintTrap.enabled = false
      }
    }
    
    func aproximouCampfire() -> Campfire?{
      if (self.char.chickenFather.position.distanceTo(self.char.campfire1.position) < 250){
        return self.char.campfire1
      }else if (self.char.chickenFather.position.distanceTo(self.char.campfire2.position) < 250){
        return self.char.campfire2
      }else if (self.char.chickenFather.position.distanceTo(self.char.campfire3.position) < 250){
        return self.char.campfire3
      }else if (self.char.chickenFather.position.distanceTo(self.char.campfire4.position) < 250){
        return self.char.campfire4
      }else{
        return nil
      }
      
    }
    
    func aproximouTrap() -> Trap?{
      
      for trap in arrayTraps{
        if (trap.position.distanceTo(self.char.chickenFather.position) < 150){
          return trap
        }
      }
      return nil
    }
    
    func afastarEnemysTrap(trap : Trap){
      for enemy in self.char.arrayTotal{
        enemy.constraintTrap = SKConstraint.distance(SKRange(lowerLimit: 400), to: trap.position)
        enemy.constraints?.append(enemy.constraintTrap)
      }
    }
    
    
    var timerCaminhoPlayer: Timer?
    var posicaoY:CGFloat = 0
    var posicaoX:CGFloat = 0
    
    func cancelAlert(){
      timerCaminhoPlayer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
        if (self.char.chickenFather.position.distanceTo(self.char.chickenSon.position) < 300 && self.auxiliarAlerta == false){
          self.layerAlert.emmiterAlert1?.isHidden = true
          self.layerAlert.emmiterAlert2?.isHidden = true
          self.layerAlert.emmiterAlert3?.isHidden = true
          self.layerAlert.emmiterAlert4?.isHidden = true
          self.tutorial.labelAlerta.removeFromParent()
          self.setUpTimer()
          self.setUpTimer2()
          self.tutorialAlerta = false
          self.hud.attackButton.isUserInteractionEnabled = false
          self.playAll() //Despausa
          self.char.chickenFather.turnOff()//Remove constraint com o player\
          for trap in self.arrayTraps{
            trap.physicsBody?.isDynamic = true
          }
          self.auxiliarAlerta = true
          self.timerCaminhoPlayer?.invalidate()
          self.char.chickenFather.physicsBody?.categoryBitMask = CategoryMask.player.rawValue
        }
      })
    }
  
  func cleanScene() {
    self.gameViewController = nil
    self.hud.delegate3 = nil
    self.hud.delegate2 = nil
    self.hud.delegate = nil
    if let s = self.view?.scene {

      NotificationCenter.default.removeObserver(self)
      self.children
        .forEach {
          $0.removeAllActions()
          $0.removeAllChildren()
          $0.removeFromParent()
      }
      s.removeAllActions()
      s.removeAllChildren()
      s.removeFromParent()
    }
  }
  
  deinit {
    print("saiu cena")
  }
    
    
}

