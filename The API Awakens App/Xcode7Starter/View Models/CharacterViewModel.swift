//
//  CharacterViewModel.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 11/12/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

struct CharacterViewModel: ViewModelType {
  var type: CategoryType {
    return .character
  }
  
  // MARK: - Properties
  var features = [Featurable]()
  
  // MARK: - Init method
  init(character: Character) {
    var vehicles: String {
      if character.vehiclesStrings.isEmpty {
        return "\(character.name) have not driven any vehicles."
      } else {
        let vehicles = Set(character.vehiclesStrings) // removes duplicates
        return vehicles.joined(separator: ", ")
      }
    }
    
    var starships: String {
      if character.starshipsStrings.isEmpty {
        return "\(character.name) have not piloted any starships."
      } else {
        let starships = Set(character.starshipsStrings) // removes duplicates
        return starships.joined(separator: ", ")
      }
    }
    
    var convertedHeight: String {
      if #available(iOS 10.0, *) {
        guard let height = Double(character.height) else {
          return "Unknown"
        }

        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        
        let heightInCM = Measurement(value: height, unit: UnitLength.centimeters)
        let heightInInches = heightInCM.converted(to: .inches)
        let heightInInchesStringForm = formatter.string(from: heightInInches)

        return heightInInchesStringForm // if characters height is over 200cm it converts to feet
      } else {
        // Fallback on earlier versions
        guard let doubleHeight = Double(character.height) else {
          return "Unknown"
        }
        
        let inches = doubleHeight / 2.54 // conversion formula from cm to inches
        return String(inches)
      }
    }
      
    var height: String {
      guard let height = Double(character.height) else {
        return "Unknown"
      }
        
      if #available(iOS 10.0, *) {
        let heightInCM = Measurement(value: height, unit: UnitLength.centimeters)
        return heightInCM.description
      } else {
          // Fallback on earlier versions
        return character.height
      }
    }
    
    self.features = [CharacteristicFeature(name: "Born", description: character.birthYear),
                     CharacteristicFeature(name: "Home", description: character.homeWorldString),
                     MeasurementFeature(name: "Height", description: height, convertedDescription: convertedHeight),
                     CharacteristicFeature(name: "Eyes", description: character.eyeColor),
                     CharacteristicFeature(name: "Hair", description: character.hairColor),
                     CharacteristicFeature(name: "Vehicles", description: vehicles),
                     CharacteristicFeature(name: "Starships", description: starships)
    ]
  }
}
