//
//  StarshipViewModel.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

struct StarshipViewModel: ViewModelType {
  var features: [Featurable]
  
  init(starship: Starship) {
    var length: String {
      guard let lengthAsDouble = Double(starship.length) else { return "Unknown" }
      let lengthInMeters = Measurement(value: lengthAsDouble, unit: UnitLength.meters)
      return lengthInMeters.description
    }
    
    var convertedLength: String {
      guard let lengthAsDouble = Double(starship.length) else { return "Unknown" }
      
      let formatter = MeasurementFormatter()
      formatter.unitStyle = .medium
      formatter.unitOptions = .naturalScale
      
      let lengthInMeters = Measurement(value: lengthAsDouble, unit: UnitLength.meters)
      let lengthInFeet = lengthInMeters.converted(to: .feet)
      return lengthInFeet.description
    }
    
    var galacticValue: String {
      return starship.costInCredits
    }
    
    var usdValue: String {
      return starship.costInCredits
    }
    
    self.features = [
      Feature(title: "Make:", description: starship.manufacturer),
      CurrencyFeature(title: "Cost:", description: galacticValue, convertedValue: usdValue),
      MeasurementFeature(title: "Length:", description: length, convertedValue: convertedLength),
      Feature(title: "Class:", description: starship.starshipClass),
      Feature(title: "Crew:", description: starship.crew)
    ]
  }
  
  var type: SelectionType {
    return .starship
  }
  
}
