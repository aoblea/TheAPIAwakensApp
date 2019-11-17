//
//  Feature.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 11/16/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

enum FeatureType {
  case characteristic
  case measurement
  case currency
}

protocol Featurable {
  var name: String { get }
  var description: String { get }
  var convertedDescription: String? { get }
  var type: FeatureType { get }
}

struct CharacteristicFeature: Featurable {
  var name: String
  var description: String
  var convertedDescription: String?
  var type: FeatureType {
    return .characteristic
  }
}

struct MeasurementFeature: Featurable {
  var name: String
  var description: String
  var convertedDescription: String?
  var type: FeatureType {
    return .measurement
  }
}

struct CurrencyFeature: Featurable {
  var name: String
  var description: String
  var convertedDescription: String?
  var type: FeatureType {
    return .currency
  }
}
