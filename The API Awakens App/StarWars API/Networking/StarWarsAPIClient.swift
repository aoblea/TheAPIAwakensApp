//
//  StarWarsAPIClient.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

class StarWarsAPIClient<T: Decodable>: APIClient {
  // MARK: - Properties
  let session: URLSession
  var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
  
  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }

  convenience init() {
    self.init(configuration: .default)
  }
  
  // fetch Planet
  func fetchPlanet(with url: URL, completion: @escaping (Result<Planet, APIError>) -> Void) {
    let request = URLRequest(url: url)
    fetch(with: request, completion: completion)
  }
  
  // fetch Vehicles
  func fetchVehicles(with urls: [URL], completion: @escaping (Result<Vehicle, APIError>) -> Void) {
    urls.forEach { (url) in
      let request = URLRequest(url: url)
      fetch(with: request, completion: completion)
    }
  }
  
  // fetch Starships
  func fetchStarships(with urls: [URL], completion: @escaping (Result<Starship, APIError>) -> Void) {
    urls.forEach { (url) in
      let request = URLRequest(url: url)
      fetch(with: request, completion: completion)
    }
  }
  
  // fetch All
  func fetchAll(with endpoint: StarWars, completion: @escaping (Result<[T], APIError>) -> Void) {
    var items = [T]()
    
    DispatchQueue.main.async {
      self.fetchPage(with: endpoint.request) { (result) in
        switch result {
        case .success(let page):
          items.append(contentsOf: page.results)
          
          if page.count == items.count {
            completion(.success(items))
          }
          
          self.fetchNext(with: page) { (nextResult) in
            switch nextResult {
            case .success(let pages):
              pages.forEach { page in
                items.append(contentsOf: page.results)
              }
              if page.count == items.count {
                completion(.success(items))
              }
            case .failure(let error):
              print(error)
            }
          }
        case .failure(let error):
          print(error)
        }
      }
    }
  }
  
  // fetch next page
  private func fetchNext(with page: Page<T>, completion: @escaping (Result<[Page<T>], APIError>) -> Void) {
    var pageURL = page.next
    var pages = [Page<T>]()
    
    if let nextURL = pageURL {
      let request = URLRequest(url: nextURL)
      fetchPage(with: request) { (result) in
        switch result {
        case .success(let nextPage):
          pages.append(nextPage)
          completion(.success(pages))
          pageURL = nextPage.next
          self.fetchNext(with: nextPage, completion: completion)
        case .failure(let error):
          print(error)
        }
      }
    } else {
      print("No more urls to fetch.")
    }
  }
  
  // fetch page
  private func fetchPage(with request: URLRequest, completion: @escaping (Result<Page<T>, APIError>) -> Void) {
    print("Fetching: \(request)")
    fetch(with: request, completion: completion)
  }
}
