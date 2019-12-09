//
//  Planet.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

struct Planet: Decodable {
  let name: String
  
  private enum PlanetCodingKeys: String, CodingKey {
    case name
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: PlanetCodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
  }
}
