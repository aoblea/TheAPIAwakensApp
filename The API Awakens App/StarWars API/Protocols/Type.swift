//
//  Type.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation
import UIKit

// for character/vehicle/starship type
protocol Type {
  var name: String { get }
  var type: SelectionType { get }
}

protocol ViewModelType {
  var features: [Featurable] { get }
  var type: SelectionType { get }
}

enum FeatureType {
  case normal
  case currency
  case measurement
}

protocol Featurable {
  var title: String { get }
  var description: String { get }
  var convertedValue: String? { get }
  var type: FeatureType { get }
}



