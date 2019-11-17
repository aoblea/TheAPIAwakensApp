//
//  SearchResultsDataSource.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 11/11/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class SearchResultsDataSource: NSObject, UITableViewDataSource {
  
  // MARK: - Properties
  private var data = [Type]()
  
  // MARK: - Data Source Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
    cell.textLabel?.text = data[indexPath.row].name
    
    return cell
  }
  
  // MARK: - Helper Methods
  func update(with results: [Type]) {
    self.data = results
  }
  
}
