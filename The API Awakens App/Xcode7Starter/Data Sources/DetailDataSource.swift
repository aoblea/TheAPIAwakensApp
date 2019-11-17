//
//  DetailDataSource.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 11/12/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class DetailDataSource: NSObject, UITableViewDataSource {
    
  // MARK: - Properties
  private var data: Type? {
    didSet {
      guard let data = self.data else { return }
      switch data.type {
      case .character:
        model = CharacterViewModel(character: data as! Character)
      case .starship:
        model = StarshipViewModel(starship: data as! Starship)
      case .vehicle:
        model = VehicleViewModel(vehicle: data as! Vehicle)
      }
    }
  }
  
  var model: ViewModelType?
  
  // MARK: - Data Source Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let model = model {
      return model.features.count
    } else {
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let infoCell = tableView.dequeueReusableCell(withIdentifier: InformationCell.reuseIdentifier, for: indexPath) as! InformationCell
    
    if let model = model {
      let feature = model.features[indexPath.row]
      infoCell.configure(with: feature)
    } else {
      print("model is non existent")
    }
    
    return infoCell
  }
  
  // MARK: - Helper Methods
  func update(with type: Type) {
    self.data = type
  }
  
}
