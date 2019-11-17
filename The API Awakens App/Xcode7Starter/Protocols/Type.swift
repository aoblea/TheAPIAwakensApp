//
//  Type.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/30/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

// for character/vehicle/starship
protocol Type {
  var name: String { get }
  var type: CategoryType { get }
}

// for viewmodels
protocol ViewModelType {
  var type: CategoryType { get }
  var features: [Featurable] { get }
}

enum CategoryType {
  case character
  case vehicle
  case starship
}

extension CategoryType {
  var name: String {
    switch self {
    case .character:
      return "Character"
    case .vehicle:
      return "Vehicle"
    case .starship:
      return "Starship"
    }
  }
}



