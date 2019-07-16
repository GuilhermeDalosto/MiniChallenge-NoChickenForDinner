//
//  UserDefaults.swift
//
//
//  Created by Daniel Leal on 29/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation

class UserData {
  
  let dados = UserDefaults.standard
  
  var arrayScore = [Int]()

  var musica = true
  var sons = true
  var second = Bool() //Primeira vez no jogo
  var second2 = Bool() //Primeira vez na comic view
  var second3 = Bool() //Primeira vez no menu
  
  init() {
    
  }
  
  func guardarDadosPlayer(score: Int){
    if let array = dados.array(forKey: "Scores") {
      self.arrayScore = array as! [Int]
      arrayScore.append(score)
      let newArraySort = arrayScore.sorted(by: >)
      dados.set(newArraySort, forKey: "Scores")
    }else{
      arrayScore.append(score)
      dados.set(arrayScore, forKey: "Scores")
    }
  }
  
  func guardarSettings(musica: Bool, sons: Bool){
    dados.set(musica, forKey: "Musica")
    dados.set(sons, forKey: "Sons")
  }
  
  func carregarDadosPlayer(){
    if let array = dados.array(forKey: "Scores") {
      self.arrayScore = array as! [Int]
    }
  }
  
  func setupSecond(second: Bool){
    dados.set(second, forKey: "Second")
  }
  
  func setupSecond2(second: Bool){
    dados.set(second, forKey: "Second2")
  }
  
  func setupSecond3(second: Bool){
    dados.set(second, forKey: "Second3")
  }
  
  func carregarSecond3 (){
    self.second3 = dados.bool(forKey: "Second3")
  }
  
  func carregarSecond2 (){
    self.second2 = dados.bool(forKey: "Second2")
  }
  
  
  func carregarDadosSettings(){
   
    self.musica = dados.bool(forKey: "Musica")
    self.sons = dados.bool(forKey: "Sons")
    self.second = dados.bool(forKey: "Second")
  }
  
  
  
  //Dados p/ tutorial
  
  var campfire = false
  var inimigo = false
  var alerta = false
  var filho = false
  var combo = false
  var trap = false
  var attention = false
  
  func carregarDadosTutorial(){
    self.campfire = dados.bool(forKey: "sawCampfire")
    self.inimigo = dados.bool(forKey: "sawEnemy")
    self.alerta = dados.bool(forKey: "sawAlert")
    self.filho = dados.bool(forKey: "sawSon")
    self.combo = dados.bool(forKey: "sawCombo")
    self.trap = dados.bool(forKey: "sawTrap")
    self.attention = dados.bool(forKey: "sawAttention")
  }
  
  func setupSawCampfire(saw: Bool){
    self.dados.set(saw, forKey: "sawCampfire")
  }
  
  func setupSawEnemy(saw: Bool){
    self.dados.set(saw, forKey: "sawEnemy")
  }
  
  func setupSawAlert(saw: Bool){
    self.dados.set(saw, forKey: "sawAlert")
  }
  
  func setupSawSon(saw: Bool){
    self.dados.set(saw, forKey: "sawSon")
  }
  
  func setupSawCombo(saw: Bool){
    self.dados.set(saw, forKey: "sawCombo")
  }
  
  func setupSawTrap(saw: Bool){
    self.dados.set(saw, forKey: "sawTrap")
  }
  
  func setupSawAttention (saw: Bool){
    self.dados.set(saw, forKey: "sawAttention")
  }
  
}
