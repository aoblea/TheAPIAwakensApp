//
//  StarWarsEndpoint.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/14/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

protocol StarWarsEndpoint {
  var scheme: String { get }
  var host: String { get }
  var path: String { get }
  var queryItems: [URLQueryItem]? { get }
}

extension StarWarsEndpoint {
  var urlComponents: URLComponents {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = path
    components.queryItems = queryItems
    
    return components
  }
  
  var request: URLRequest {
    let url = urlComponents.url!
    return URLRequest(url: url)
  }
}

enum StarWars {
  case people
  case vehicles
  case starships
}

extension StarWars: StarWarsEndpoint {
  var scheme: String {
    return "https"
  }
  
  var host: String {
    return "swapi.co"
  }
  
  var path: String {
    switch self {
    case .people: return "/api/people/"
    case .vehicles: return "/api/vehicles/"
    case .starships: return "/api/starships/"
    }
  }
  
  var queryItems: [URLQueryItem]? {
    return nil
  }
}
