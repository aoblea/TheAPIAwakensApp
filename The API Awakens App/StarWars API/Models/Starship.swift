//
//  Starship.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

class Starship: Decodable, Type {
  var type: SelectionType {
    return .starship
  }
  
  let name: String
  let manufacturer: String
  let costInCredits: String
  let length: String
  let starshipClass: String
  let crew: String
  
  private enum StarshipCodingKeys: String, CodingKey {
    case name
    case manufacturer
    case costInCredits
    case length
    case starshipClass
    case crew
  }
  
  init(name: String, manufacturer: String, costInCredits: String, length: String, starshipClass: String, crew: String) {
    self.name = name
    self.manufacturer = manufacturer
    self.costInCredits = costInCredits
    self.length = length
    self.starshipClass = starshipClass
    self.crew = crew
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: StarshipCodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.manufacturer = try container.decode(String.self, forKey: .manufacturer)
    self.costInCredits = try container.decode(String.self, forKey: .costInCredits)
    self.length = try container.decode(String.self, forKey: .length)
    self.starshipClass = try container.decode(String.self, forKey: .starshipClass)
    self.crew = try container.decode(String.self, forKey: .crew)
  }
}
