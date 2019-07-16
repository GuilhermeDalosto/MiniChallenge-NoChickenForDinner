//
//  TableViewController.swift
//  PestControl
//
//  Created by Daniel Leal on 01/06/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class TableView: UITableView{
  
  
  var arrayScore = [Int]()
  
  func loadScore(array: [Int]){
    self.arrayScore = array
    print(arrayScore)
  }
  
  override func numberOfRows(inSection section: Int) -> Int {
    return 2
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return arrayScore.count
  }
  
  override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
    let cell = dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = String(arrayScore[indexPath.row])
    return cell
  }

}
