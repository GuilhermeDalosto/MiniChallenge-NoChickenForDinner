//
//  AlertLayer.swift
//  PestControl
//
//  Created by Daniel Leal on 03/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class AlertLayer: SKNode {
  
  var alertaAtual = 0
  
  
  let emmiterAlert1 = SKEmitterNode(fileNamed: "alert4.sks")
  let emmiterAlert2 = SKEmitterNode(fileNamed: "alert2.sks")
  let emmiterAlert3 = SKEmitterNode(fileNamed: "alert3.sks")
  let emmiterAlert4 = SKEmitterNode(fileNamed: "alert1.sks")

  func setupAlerts(){
    
    self.addChild(emmiterAlert1!)
    self.addChild(emmiterAlert2!)
    self.addChild(emmiterAlert3!)
    self.addChild(emmiterAlert4!)
    
    self.emmiterAlert1?.isHidden = true
    self.emmiterAlert2?.isHidden = true
    self.emmiterAlert3?.isHidden = true
    self.emmiterAlert4?.isHidden = true
    
    self.emmiterAlert1?.setScale(0.2)
    self.emmiterAlert2?.setScale(0.2)
    self.emmiterAlert3?.setScale(0.2)
    self.emmiterAlert4?.setScale(0.2)
    
    self.emmiterAlert1?.position = CGPoint (x : -(Utils.Size.screenSize.width/6), y: (Utils.Size.screenSize.height/3.2))
    self.emmiterAlert2?.position = CGPoint (x : (Utils.Size.screenSize.width/6), y: (Utils.Size.screenSize.height/3.2))
    self.emmiterAlert3?.position = CGPoint (x : -(Utils.Size.screenSize.width/6), y: -(Utils.Size.screenSize.height/3.2))
    self.emmiterAlert4?.position = CGPoint (x : (Utils.Size.screenSize.width/6), y: -(Utils.Size.screenSize.height/3.2))
  }
  
  var positionAnterior = Int()
  func setarAlerta(position: Int){

    if (position != positionAnterior){
      switch(position){
      case 1: //Esquerda alto
        self.emmiterAlert1?.isHidden = false
        self.emmiterAlert2?.isHidden = true
        self.emmiterAlert3?.isHidden = true
        self.emmiterAlert4?.isHidden = true
        break
      case 2: //Direita Alto
        self.emmiterAlert1?.isHidden = true
        self.emmiterAlert2?.isHidden = false
        self.emmiterAlert3?.isHidden = true
        self.emmiterAlert4?.isHidden = true
        break
      case 3: //Esquerda Baixo
        self.emmiterAlert1?.isHidden = true
        self.emmiterAlert2?.isHidden = true
        self.emmiterAlert3?.isHidden = false
        self.emmiterAlert4?.isHidden = true
        break
      case 4: //Direita Baixo
        self.emmiterAlert1?.isHidden = true
        self.emmiterAlert2?.isHidden = true
        self.emmiterAlert3?.isHidden = true
        self.emmiterAlert4?.isHidden = false
        break
      default:
        break
      }
      positionAnterior = position
    }
  }

}
