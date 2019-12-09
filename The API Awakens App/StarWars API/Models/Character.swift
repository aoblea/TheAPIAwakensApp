//
//  Character.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

class Character: Decodable, Type {
  var type: SelectionType {
    return .character
  }
  
  let name: String
  let height: String
  let hairColor: String
  let eyeColor: String
  let birthYear: String
  let homeWorld: URL
  let vehicles: [URL]
  let starships: [URL]
  
  var homeWorldString: String?
  var vehiclesStrings = Set<String>()
  var starshipsStrings = Set<String>()
  
  private enum CharacterCodingKeys: String, CodingKey {
    case name
    case height
    case hairColor
    case eyeColor
    case birthYear
    case homeworld
    case vehicles
    case starships
  }
  
  init(name: String, height: String, hairColor: String, eyeColor: String, birthYear: String, homeWorld: URL, vehicles: [URL], starships: [URL]) {
    self.name = name
    self.height = height
    self.hairColor = hairColor
    self.eyeColor = eyeColor
    self.birthYear = birthYear
    self.homeWorld = homeWorld
    self.vehicles = vehicles
    self.starships = starships
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CharacterCodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.height = try container.decode(String.self, forKey: .height)
    self.hairColor = try container.decode(String.self, forKey: .hairColor)
    self.eyeColor = try container.decode(String.self, forKey: .eyeColor)
    self.birthYear = try container.decode(String.self, forKey: .birthYear)
    self.homeWorld = try container.decode(URL.self, forKey: .homeworld)
    self.vehicles = try container.decode([URL].self, forKey: .vehicles)
    self.starships = try container.decode([URL].self, forKey: .starships)
  }
}

