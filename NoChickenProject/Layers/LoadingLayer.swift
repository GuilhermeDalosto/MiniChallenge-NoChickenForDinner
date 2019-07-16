
//
//  LoadingLayer.swift
//  No Chicken for Dinner
//
//  Created by Guilherme Martins Dalosto de Oliveira on 14/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//
import UIKit
import SpriteKit


class LoadingLayer: SKNode {
  let backg = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("LOADING"))
  let frangoLoading = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("frangoLoading"))
  let ponto = SKSpriteNode(texture: Utils.Atlas.sprites.textureNamed("ponto"))
  let actionPonto1 = SKAction.move(to: CGPoint(x: 90, y: -180), duration: 0)
  let actionPonto2 = SKAction.move(to: CGPoint(x: 100, y: -180), duration: 0)
  let actionPonto3 = SKAction.move(to: CGPoint(x: 80, y: -180), duration: 0)
  let waitPonto = SKAction.wait(forDuration: 0.5)
  let breath = SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.6, duration: 0.5), SKAction.scale(to: 0.5, duration: 0.5)]))
  
  func setupLoading(){
    let width = backg.size.width
    let height = backg.size.height
    backg.size = CGSize(width: backg.size.width/UIScreen.main.bounds.size.width * Utils.Size.screenSize.width/1.7, height:backg.size.height/UIScreen.main.bounds.size.height * Utils.Size.screenSize.height/1.7)
    backg.zPosition = 100
    self.addChild(backg)
    frangoLoading.run(breath)
    frangoLoading.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
    frangoLoading.zPosition = 101
    frangoLoading.setScale(0.6)
    frangoLoading.size = CGSize(width: frangoLoading.size.width/UIScreen.main.bounds.size.width * Utils.Size.screenSize.width, height:frangoLoading.size.height/UIScreen.main.bounds.size.height * Utils.Size.screenSize.height)
    backg.addChild(frangoLoading)
    ponto.setScale(1.5)
    ponto.zPosition = 102
    ponto.position = CGPoint(x: 70, y: -180)
    ponto.run(SKAction.repeatForever(SKAction.sequence([waitPonto,actionPonto1,waitPonto,actionPonto2,waitPonto,actionPonto3])))
    addChild(ponto)
  }
}
