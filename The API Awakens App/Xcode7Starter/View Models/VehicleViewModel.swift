//
//  VehicleViewModel.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 11/12/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

struct VehicleViewModel: ViewModelType {
  var type: CategoryType {
    return .vehicle
  }
  
  // MARK: - Properties
  var features = [Featurable]()
  
  // MARK: - Init method
  init(vehicle: Vehicle) {
    var length: String {
      guard let length = Double(vehicle.length) else {
        return "Unknown"
      }
        
      if #available(iOS 10.0, *) {
        let lengthInMeters = Measurement(value: length, unit: UnitLength.meters)
        return lengthInMeters.description
      } else {
          // Fallback on earlier versions
        return vehicle.length
      }
    }
    
    var convertedLength: String {
      guard let length = Double(vehicle.length) else {
        return "Unknown"
      }
      
      if #available(iOS 10.0, *) {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        
        let lengthInMeters = Measurement(value: length, unit: UnitLength.meters)
        let lengthInFeet = lengthInMeters.converted(to: .feet)
        let lengthInFeetStringForm = formatter.string(from: lengthInFeet)

        return lengthInFeetStringForm
      } else {
        // Fallback on earlier versions
        guard let doubleLength = Double(vehicle.length) else {
          return "Unknown"
        }

        let feet = doubleLength * 3.281 // convert from meters to feet
        return String(feet)
      }
    }

    self.features = [CharacteristicFeature(name: "Make", description: vehicle.manufacturer),
                     CurrencyFeature(name: "Cost", description: vehicle.costInCredits),
                     MeasurementFeature(name: "Length", description: length, convertedDescription: convertedLength),
                     CharacteristicFeature(name: "Class", description: vehicle.vehicleClass),
                     CharacteristicFeature(name: "Crew", description: vehicle.crew)
    ]
  }
}
