//
//  HomeController.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 9/26/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class HomeController: UITableViewController {
  
  // MARK: - Properties
  let titles = ["Characters", "Vehicles", "Starships"]
  let images = [UIImage(named: "icon-characters"), UIImage(named: "icon-vehicles"), UIImage(named: "icon-starships")]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "The API Awakens"
    let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
    navigationController?.navigationBar.barTintColor = UIColor(red: 27/255, green: 32/255, blue: 36/255, alpha: 1)
   
    // pushes tableview under navbar
    navigationController?.navigationBar.isTranslucent = false
    
    // makes status bar white color
    navigationController?.navigationBar.barStyle = .black
    
    tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.cellID)
    tableView.isScrollEnabled = false
    
    tableView.separatorColor = UIColor(red: 66/255, green: 69/255, blue: 71/255, alpha: 1)
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titles.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // need to handle this
    let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.cellID, for: indexPath) as! HomeCell
    
    cell.artworkImageView.image = images[indexPath.row]
    cell.titleLabel.text = titles[indexPath.row]
      
    return cell
  }
  
  // MARK: - Table view delegate
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return tableView.frame.height/CGFloat(titles.count)
  }
  

}
