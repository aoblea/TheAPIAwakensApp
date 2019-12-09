//
//  Vehicle.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

class Vehicle: Decodable, Type {
  var type: SelectionType {
    return .vehicle
  }
  
  let name: String
  let manufacturer: String
  let costInCredits: String
  let length: String
  let vehicleClass: String
  let crew: String
  
  private enum VehicleCodingKeys: String, CodingKey {
    case name
    case manufacturer
    case costInCredits
    case length
    case vehicleClass
    case crew
  }
  
  init(name: String, manufacturer: String, costInCredits: String, length: String, vehicleClass: String, crew: String) {
    self.name = name
    self.manufacturer = manufacturer
    self.costInCredits = costInCredits
    self.length = length
    self.vehicleClass = vehicleClass
    self.crew = crew
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: VehicleCodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.manufacturer = try container.decode(String.self, forKey: .manufacturer)
    self.costInCredits = try container.decode(String.self, forKey: .costInCredits)
    self.length = try container.decode(String.self, forKey: .length)
    self.vehicleClass = try container.decode(String.self, forKey: .vehicleClass)
    self.crew = try container.decode(String.self, forKey: .crew)
  }
}
