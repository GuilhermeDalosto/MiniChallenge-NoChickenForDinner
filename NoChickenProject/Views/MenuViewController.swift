//
//  MenuViewController.swift
//  PestControl
//
//  Created by Fábio França on 06/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import GameKit



class MenuViewController: UIViewController, SpyDelegate, GKGameCenterControllerDelegate {
  
  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
  }
  
  @IBOutlet weak var playButtom: UIButton!
  @IBOutlet weak var scoreButtom: UIButton!
  @IBOutlet weak var settingsButtom: UIButton!
  
  var dados = UserData()
  var isMusic = Bool()
  var isSound = Bool()
  var audio = AVAudioPlayer()
  var playerSound = AVAudioPlayer()
  var secondMenu = Bool()
  var entrouSom = true
  var carregouSprites = false
  
  var gcEnabled = Bool()
  var gcDefaultLeader = String()
  let LeaderID = "leaderboard.nochicken.highscore"
    
    
    @IBAction func apertarSettings(_ sender: Any) {
        emitirSom()
    }
    
    @IBAction func apertarPlay(_ sender: Any) {
        emitirSom()
    }
    
    @IBAction func apertarScore(_ sender: Any) {
        emitirSom()
    }
  
    func setarButoes(){
 
        self.playButtom.titleLabel?.adjustsFontSizeToFitWidth = true
        self.settingsButtom.titleLabel?.adjustsFontSizeToFitWidth = true
        self.scoreButtom.titleLabel?.adjustsFontSizeToFitWidth = true
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    authenticateLocalPlayer()
    
    if (!carregouSprites){
      Utils.Atlas.sprites.preload {
        print("sprites loaded")
      }
      carregouSprites = true
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    setarButoes()
    dados.carregarSecond3()
    self.secondMenu = dados.second3
    if (dados.second3 == false){ //Se for a primeira vez no menu
      dados.guardarSettings(musica: true, sons: true)
    }
    dados.carregarDadosSettings()  //Primeira vez em que os dados serão carregados do user defaults
    self.isMusic = dados.musica
    self.isSound = dados.sons
    let audioPath = Bundle.main.path(forResource: "MenuTrack", ofType: "mp3")!
    do {
      try playerSound = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath) as URL)
    } catch {
      print("no file sound")
    }
    if (isMusic == true){
        self.playMusic()
    }
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {

    dados.setupSecond3(second: true)
  }
 
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "MenuToGame"{
      self.stopMusic()
    }
    if segue.identifier == "MenuToSettings"{
      let vc : ViewSettings = segue.destination as! ViewSettings
      vc.entrouSom = self.entrouSom
      vc.delegate = self
    }
  }
  
  func authenticateLocalPlayer() {
    let localPlayer: GKLocalPlayer = GKLocalPlayer.local
    
    localPlayer.authenticateHandler = {(ViewController, error) -> Void in
      if((ViewController) != nil) {
        self.present(ViewController!, animated: false, completion: nil)
      } else if (localPlayer.isAuthenticated) {
        self.gcEnabled = true
        localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
          if error != nil { print(error!)
          } else { self.gcDefaultLeader = self.LeaderID }
        })
        
      } else {
        self.gcEnabled = false
        print("Local player could not be authenticated!")
        print(error as Any)
      }
    }
  }
  
  func addScoreAndSubmitToGC(score: Int){
    let bestScoreInt = GKScore(leaderboardIdentifier: LeaderID)
    bestScoreInt.value = Int64(score)
    GKScore.report([bestScoreInt]) { (error) in
      if error != nil {
        print(error!.localizedDescription)
      } else {
        print("Best Score submitted to your Leaderboard!")
      }
    }
  }
  
  func musicIsOn(music: Bool) {
    if music{
      self.playMusic()
      entrouSom = true
    }else {
      self.stopMusic()
      entrouSom = false
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
  
  func playMusic(){
    playerSound.play()
    playerSound.numberOfLoops = -1
  }
  
  func stopMusic(){
    playerSound.stop()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.view.removeFromSuperview()
    self.view = nil
  }
  
  deinit {
    print("saiu menu")
  }

}



