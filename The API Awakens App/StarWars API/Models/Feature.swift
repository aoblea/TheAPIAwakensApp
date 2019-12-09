//
//  Feature.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/6/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

struct Feature: Featurable {
  var title: String
  var description: String
  var convertedValue: String?
  
  var type: FeatureType {
    return .normal
  }
}

struct CurrencyFeature: Featurable {
  var title: String
  var description: String
  var convertedValue: String?
  
  var type: FeatureType {
    return .currency
  }
}

struct MeasurementFeature: Featurable {
  var title: String
  var description: String
  var convertedValue: String?
  
  var type: FeatureType {
    return .measurement
  }
}
