//
//  ViewControllers.swift
//  PestControl
//
//  Created by Daniel Leal on 31/05/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import GameKit

class ViewScores: UIViewController, UITableViewDelegate, UITableViewDataSource, GKGameCenterControllerDelegate{
  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    self.dismiss(animated: false, completion: nil)
  }
  
  @IBOutlet weak var tableView: UITableView!
    
  var arrayScore:[Int] = [5]
  var dados = UserData()
  var audio = AVAudioPlayer()
  var array5 = [Int]()
  var isMusic = Bool()
  var isSound = Bool()
  
  override func viewDidLoad() {
    tableView.delegate = self
    tableView.dataSource = self
    dados.carregarDadosPlayer()
    self.isSound = dados.sons
    self.isMusic = dados.musica
    arrayScore = dados.arrayScore
    array5 = Array(arrayScore.prefix(5))
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return array5.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
    @IBAction func back(_ sender: Any) {
        if(isSound){
            emitirSom()
        }
      
      self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
    cell.labelText.text = String(array5[indexPath.row])
    cell.layer.backgroundColor = UIColor.clear.cgColor
    return cell
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
  

  @IBAction func viewGame(_ sender: Any) {
    checkGCLeaderboard()
  }
  
  let LeaderID = "leaderboard.nochicken.highscore"
  let gcVC = GKGameCenterViewController()
  
  func checkGCLeaderboard() {
    gcVC.gameCenterDelegate = self
    gcVC.viewState = .leaderboards
    gcVC.leaderboardIdentifier = LeaderID
    present(gcVC, animated: false, completion: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.view.removeFromSuperview()
    self.view = nil
    self.gcVC.delegate = nil
  }
  
  deinit {
    print("sair scores")
  }
  

}
