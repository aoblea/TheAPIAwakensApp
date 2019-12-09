//
//  StarWars.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

enum StarWars {
  case people
  case vehicles
  case starships
}

extension StarWars: Endpoint {
  var base: String {
    return "https://swapi.co"
  }
  
  var path: String {
    switch self {
    case .people: return "/api/people/"
    case .vehicles: return "/api/vehicles/"
    case .starships: return "/api/starships/"
    }
  }

  var queryItems: [URLQueryItem] {
    return []
  }
}
