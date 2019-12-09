//
//  CharacterViewModel.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

class CharacterViewModel: ViewModelType {
  var features: [Featurable]
  
  init(character: Character) {
    var height: String {
      guard let heightAsDouble = Double(character.height) else { return "Unknown" }
      let heightInCM = Measurement(value: heightAsDouble, unit: UnitLength.centimeters)
      return heightInCM.description
    }
    
    var convertedHeight: String {
      guard let heightAsDouble = Double(character.height) else { return "Unknown" }
      
      let formatter = MeasurementFormatter()
      formatter.unitStyle = .medium
      formatter.unitOptions = .naturalScale
      let heightInCM = Measurement(value: heightAsDouble, unit: UnitLength.centimeters)
      let heightInInches = heightInCM.converted(to: .inches)
      
      return heightInInches.description // If it goes over 200cm it converts to feet instead
    }
    
    var vehicleList: String {
      if character.vehiclesStrings.isEmpty {
        return "\(character.name) has not driven any vehicles."
      } else {
        return character.vehiclesStrings.joined(separator: ", ")
      }
    }
    
    var starshipList: String {
      if character.starshipsStrings.isEmpty {
        return "\(character.name) has not piloted any starships."
      } else {
        return character.starshipsStrings.joined(separator: ", ")
      }
    }
    
    self.features = [
      Feature(title: "Born:", description: character.birthYear),
      Feature(title: "Home:", description: character.homeWorldString ?? "No info available."),
      MeasurementFeature(title: "Height:", description: height, convertedValue: convertedHeight),
      Feature(title: "Eyes:", description: character.eyeColor),
      Feature(title: "Hair:", description: character.hairColor),
      Feature(title: "Vehicles:", description: vehicleList),
      Feature(title: "Starships:", description: starshipList)
    ]
  }
  
  var type: SelectionType {
    return .character
  }
}
