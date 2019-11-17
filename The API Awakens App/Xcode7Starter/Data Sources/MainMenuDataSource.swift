//
//  MainMenuDataSource.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 11/11/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class MainMenuDataSource: NSObject, UITableViewDataSource {
  
  // MARK: - Table View Data Source Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let mainMenuCell = tableView.dequeueReusableCell(withIdentifier: MainMenuCell.reuseIdentifier, for: indexPath) as! MainMenuCell

    switch indexPath.row {
    case 0:
      mainMenuCell.artworkImage.image = UIImage(named: "icon-characters")
      mainMenuCell.titleLabel.text = "Characters"
    case 1:
      mainMenuCell.artworkImage.image = UIImage(named: "icon-starships")
      mainMenuCell.titleLabel.text = "Starships"
    case 2:
      mainMenuCell.artworkImage.image = UIImage(named: "icon-vehicles")
      mainMenuCell.titleLabel.text = "Vehicles"
    default:
      print("Something went wrong at main menu.")
    }

    return mainMenuCell
  }
}
