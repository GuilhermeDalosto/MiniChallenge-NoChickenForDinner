//
//  AdsViewController.swift
//  No Chicken for Dinner
//
//  Created by Daniel Leal on 24/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import UnityAds
import StoreKit


class AdsViewController: UIViewController, UnityAdsDelegate{
  var placement = "GameOver"
  var requestRate = false
  var firstTime = 0

  override func viewDidLoad() {
    if (firstTime % 2 == 0){
      self.showAds()
      firstTime += 1
    }
    else{
      dismiss(animated: false, completion: nil)
    }
  }
  
  // Controle se os ads ja sao disponiveis para visualizacao
  
  func iniatilizeAds(){
    UnityAds.initialize("3177671", delegate: self, testMode: true)
  }
  
  func unityAdsReady(_ placementId: String) {
    
  }
  
  func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
    
  }
  
  
  func unityAdsDidStart(_ placementId: String) {
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func showAds(){
    if (UnityAds.isReady(placement)){
      UnityAds.show(self,placementId: placement)
    }
  }
  
  func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
    if #available(iOS 10.3, *) {
      if (requestRate == false){
        SKStoreReviewController.requestReview()
        requestRate = true
      }
    }
    self.dismiss(animated: false, completion: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.view.removeFromSuperview()
    self.view = nil
  }
  
  deinit {
    print("saiu ads")
  }
}
