//
//  SelectionType.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/4/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation
import UIKit

enum SelectionType {
  case character
  case starship
  case vehicle
}

extension SelectionType {
  var name: String {
    switch self {
    case .character:
      return "Character"
    case .starship:
      return "Starship"
    case .vehicle:
      return "Vehicle"
    }
  }
  
  var image: UIImage {
    switch self {
    case .character:
      return UIImage(named: "icon-characters")!
    case .starship:
      return UIImage(named: "icon-starships")!
    case .vehicle:
      return UIImage(named: "icon-vehicles")!
    }
  }
}
