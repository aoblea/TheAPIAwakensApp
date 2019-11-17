//
//  StarWarsAPIClient.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/11/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

class StarWarsAPIClient<T> where T: Decodable {
  
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

  typealias PlanetCompletionHandler = (Result<Planet, StarWarsError>) -> Void
  func fetchPlanetFromURL(_ url: URL, completion: @escaping PlanetCompletionHandler) {
    
    let request = URLRequest(url: url)
    performRequest(with: request) { (results) in
      switch results {
      case .success(let data):
        do {
          let planet = try self.decoder.decode(Planet.self, from: data)
          
          completion(.success(planet))
        } catch {
          completion(.failure(.decodingFailure))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  typealias StarshipsCompletionHandler = (Result<[Starship]?, StarWarsError>) -> Void
  func fetchStarshipsFromURL(_ urls: [URL], completion: @escaping StarshipsCompletionHandler) {
    var starships = [Starship]()
    
    urls.forEach { (url) in
      let request = URLRequest(url: url)
      performRequest(with: request) { (results) in
        switch results {
        case .success(let data):
          do {
            let starship = try self.decoder.decode(Starship.self, from: data)
            starships.append(starship)
            completion(.success(starships))
          } catch {
            completion(.failure(.decodingFailure))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
    
  }

  typealias VehiclesCompletionHandler = (Result<[Vehicle]?, StarWarsError>) -> Void
  func fetchVehiclesFromURL(_ urls: [URL], completion: @escaping VehiclesCompletionHandler) {
    var vehicles = [Vehicle]()
    
    urls.forEach { (url) in
      let request = URLRequest(url: url)
      performRequest(with: request) { (results) in
        switch results {
        case .success(let data):
          do {
            let vehicle = try self.decoder.decode(Vehicle.self, from: data)
            vehicles.append(vehicle)
            completion(.success(vehicles))
          } catch {
            completion(.failure(.decodingFailure))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
    
  }
  
  typealias ItemsCompletionHandler = (Result<[T], StarWarsError>) -> Void
  func fetchAllItems(with endpoint: StarWars, completion: @escaping ItemsCompletionHandler) {
    var fetchedItems = [T]()
    
    DispatchQueue.main.async {
      self.fetchPage(with: endpoint.request) { (results) in
        switch results {
        case .success(let page):
          fetchedItems.append(contentsOf: page.results)
          
          if page.count == fetchedItems.count {
            completion(.success(fetchedItems))
          }
          
          self.fetchNext(page) { (nextResults) in
            switch nextResults {
            case .success(let pages):
              pages.forEach { (page) in
                fetchedItems.append(contentsOf: page.results)
              }
              if page.count == fetchedItems.count {
                completion(.success(fetchedItems))
              }
              
            case .failure(let error):
              completion(.failure(error))
            }
          }
          
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
    
  }
  
  typealias PagesCompletionHandler = (Result<[Page<T>], StarWarsError>) -> Void
  private func fetchNext(_ page: Page<T>, completion: @escaping PagesCompletionHandler) {
    var pageURL = page.next
    
    var fetchedPages = [Page<T>]()
    
    if let nextURL = pageURL {
      
      let request = URLRequest(url: nextURL)
      fetchPage(with: request) { (results) in
        switch results {
        case .success(let nextPage):
          fetchedPages.append(nextPage)
      
          completion(.success(fetchedPages))
          pageURL = nextPage.next
          self.fetchNext(nextPage, completion: completion) // recursion
        case .failure(let error):
          print(error)
        }
      }
      
    } else {
      print("No more urls to fetch.")
    }
  
  }
  
  // fetch a page based on request
  typealias PageCompletionHandler = (Result<Page<T>, StarWarsError>) -> Void
  private func fetchPage(with request: URLRequest, completion: @escaping PageCompletionHandler) {
    print("Fetching: \(request)")
    performRequest(with: request) { (result) in
      
      switch result {
      case .success(let data):
        do {
          let page = try self.decoder.decode(Page<T>.self, from: data)
          completion(.success(page))
        } catch {
          completion(.failure(.decodingFailure))
        }
      case .failure(let error):
        completion(.failure(error))
      }
      
    }
  }

  // Method to perform a data request
  typealias DataCompletionHandler = (Result<Data, StarWarsError>) -> Void
  private func performRequest(with request: URLRequest, completion: @escaping DataCompletionHandler) {
    let task = session.dataTask(with: request) { data, response, error in
      
      DispatchQueue.main.async {
        if let data = data {
          guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.requestFailed))
            return
          }
          
          if httpResponse.statusCode == 200 {
            completion(.success(data))
          } else {
            completion(.failure(.responseUnsuccessful(statusCode: httpResponse.statusCode)))
          }
          
        } else {
          completion(.failure(.invalidData))
        }
      }
      
    }
    task.resume()
  }
  
}
