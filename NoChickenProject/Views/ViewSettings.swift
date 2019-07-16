//
//  ViewSettings.swift
//
//  Created by Daniel Leal on 02/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol SpyDelegate {
  func musicIsOn(music : Bool)
}

class ViewSettings: UIViewController{
  
  var dados = UserData()
  var delegate: SpyDelegate?
  var audio = AVAudioPlayer()
  var isMusic = Bool()
  var isSound = Bool()
  var entrouSom = false
    
    @IBOutlet weak var musica: UISwitch!
    @IBOutlet weak var sons: UISwitch!
    
    override func viewDidLoad() {
    dados.carregarDadosSettings()
    self.isSound = dados.sons
    self.isMusic = dados.musica
    loadSettings()
  }
    
    
    @IBAction func back(_ sender: Any) {
        if(isSound){
            emitirSom()
        }
      self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func trocouSom(_ sender: Any) {
      if(isSound){
        emitirSom()
      }
      if (sons.isOn){
        isSound = true
      }else{
        isSound = false
      }
      dados.guardarSettings(musica: self.musica.isOn, sons: self.sons.isOn)
    }
    
    
    @IBAction func trocouMusica(_ sender: Any) {
      if(isSound){
        emitirSom()
      }
      if delegate != nil {
        if (self.musica.isOn == true && entrouSom == false){
          delegate?.musicIsOn(music: true)
        }else if (self.musica.isOn == false && entrouSom == true){
          delegate?.musicIsOn(music: false)
        }
      }
      if (musica.isOn){
        isMusic = true
      }else{
        isMusic = false
      }
      dados.guardarSettings( musica: self.musica.isOn, sons: self.sons.isOn)

    }

  func loadSettings(){
    musica.isOn = dados.musica
    sons.isOn = dados.sons
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
  

    @IBAction func resetTutorial(_ sender: Any) {
        self.dados.setupSawSon(saw: false)
        self.dados.setupSawCombo(saw: false)
        self.dados.setupSawTrap(saw: false)
        self.dados.setupSawAlert(saw: false)
        self.dados.setupSawEnemy(saw: false)
        self.dados.setupSawCampfire(saw: false)
        self.dados.setupSawAttention(saw: false)
    }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.view.removeFromSuperview()
    self.view = nil
    self.delegate = nil
  }
  
  deinit {
    print("saiu settings")
  }
  
  
}
