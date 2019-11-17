//
//  Planet.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 11/3/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
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
