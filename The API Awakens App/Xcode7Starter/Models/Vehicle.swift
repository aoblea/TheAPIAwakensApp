//
//  Vehicle.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 9/27/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

class Vehicle {
  let name: String
  let manufacturer: String
  let costInCredits: String
  let length: String
  let vehicleClass: String
  let crew: String
  
  init(name: String, manufacturer: String, costInCredits: String, length: String, vehicleClass: String, crew: String) {
    self.name = name
    self.manufacturer = manufacturer
    self.costInCredits = costInCredits
    self.length = length
    self.vehicleClass = vehicleClass
    self.crew = crew
  }
  
}
