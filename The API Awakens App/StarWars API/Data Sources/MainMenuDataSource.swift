//
//  MainMenuDataSource.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class MainMenuDataSource: NSObject, UITableViewDataSource {
  // MARK: - Properties
  private var data: [SelectionType] = [.character, .starship, .vehicle]
  
  // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let mainMenuCell = tableView.dequeueReusableCell(withIdentifier: "MainMenuCell", for: indexPath) as! MainMenuCell
    
    let selection = data[indexPath.row]
    
    mainMenuCell.artworkImageView.image = selection.image
    mainMenuCell.nameLabel.text = selection.name

    return mainMenuCell
  }
  
  // MARK: - Helper methods
  func selection(at indexPath: IndexPath) -> SelectionType {
    return data[indexPath.row]
  }
}
