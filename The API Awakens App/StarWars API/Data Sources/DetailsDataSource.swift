//
//  DetailsDataSource.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class DetailsDataSource: NSObject, UITableViewDataSource {
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
  var delegate: DetailsViewController?
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let model = model else { return 0 }
    return model.features.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
    detailCell.delegate = self.delegate // for sending alerts from detail cells
    
    if let model = model {
      let feature = model.features[indexPath.row]
      detailCell.configure(with: feature)
      
      if feature.type == .normal {
        detailCell.convertButton.isHidden = true
        detailCell.inputTextField.isHidden = true
      } else if feature.type == .currency {
        detailCell.convertButton.isHidden = false
        detailCell.inputTextField.isHidden = false
      } else if feature.type == .measurement {
        detailCell.convertButton.isHidden = false
        detailCell.inputTextField.isHidden = true
      }

    }
    
    return detailCell
  }

  // MARK: - Helper Methods
  func update(with selection: Type) {
    self.data = selection
  }

}
