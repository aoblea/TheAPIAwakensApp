//
//  APIClient.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

protocol APIClient {
  var session: URLSession { get }
  var decoder: JSONDecoder { get }
  
  func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void)
  func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<[T], APIError>) -> Void)
}

extension APIClient {
  typealias DataTaskCompletionHandler = (Result<Data, APIError>) -> Void
    func dataTask(with request: URLRequest, completionHandler completion: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
      let task = session.dataTask(with: request) { data, response, error in
        
        guard let httpResponse = response as? HTTPURLResponse else {
          completion(.failure(.requestFailed))
          return
        }
        
        if httpResponse.statusCode == 200 {
          if let data = data {
  //          print(data.count)
            completion(.success(data))
          } else {
            completion(.failure(.invalidData))
          }
        } else {
          completion(.failure(.responseUnsuccessful))
        }
      }
      
      return task
    }
    
    // fetches a single object
    func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
      let task = dataTask(with: request) { (result) in
        
        DispatchQueue.main.async {
          switch result {
          case .success(let data):
            do {
              let object = try self.decoder.decode(T.self, from: data)
              completion(.success(object))
            } catch let DecodingError.dataCorrupted(context) {
              print(context)
            } catch let DecodingError.keyNotFound(key, context) {
              print(key, context)
            } catch let DecodingError.typeMismatch(type, context) {
              print(type, context)
            } catch {
              print(error)
            }
          case .failure(let error):
            completion(.failure(error))

          }
        }

      }
      
      task.resume()
    }
    
    // fetches a collection
    func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<[T], APIError>) -> Void) {
      let task = dataTask(with: request) { (result) in
          
        DispatchQueue.main.async {
          switch result {
          case .success(let data):
            do {
              let objects = try self.decoder.decode([T].self, from: data)
              completion(.success(objects))
            } catch let DecodingError.dataCorrupted(context) {
              print(context)
            } catch let DecodingError.keyNotFound(key, context) {
              print(key, context)
            } catch let DecodingError.typeMismatch(type, context) {
              print(type, context)
            } catch {
              print(error)
            }
          case .failure(let error):
            completion(.failure(error))
          }
        }
        
      }
      
      task.resume()
    }
    
    // fetch data
    private func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
      let task = dataTask(with: request) { (result) in
        
        DispatchQueue.main.async {
          switch result {
          case .success(let data):
            completion(.success(data))
          case .failure(let error):
            completion(.failure(error))
          }
        }
      }
      
      task.resume()
    }
}
