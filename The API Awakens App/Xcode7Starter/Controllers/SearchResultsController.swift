//
//  SearchResultsController.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 11/8/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import UIKit

class SearchResultsController: UITableViewController {

  // MARK: - Properties
  var searchResults = [Type]()
  var filteredResults = [Type]()
  let dataSource = SearchResultsDataSource()
  
  var smallestCharacter: Character?
  var largestCharacter: Character?
  
  var smallestVehicle: Vehicle?
  var largestVehicle: Vehicle?
  
  var smallestStarship: Starship?
  var largestStarship: Starship?

  // MARK: - Viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SearchResultsController.dismissSearchResultsController))
    
    setupTableView()
    fetchAllData()
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = dataSource
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
  }

  func fetchAllData() {
    let characterClient = StarWarsAPIClient<Character>()
    characterClient.fetchAllItems(with: .people) { [weak self] (characterResults) in
      switch characterResults {
      case .success(let characters):
        
        characters.forEach { (character) in
          // fetch planet name
          characterClient.fetchPlanetFromURL(character.homeWorld) { (results) in
            switch results {
            case .success(let planet):
              character.homeWorldString = planet.name
            case .failure(let error):
              print(error)
            }
          }
          
          // fetch starships names
          characterClient.fetchStarshipsFromURL(character.starships) { (results) in
            switch results {
            case .success(let starships):
              starships?.forEach({ (starship) in
                character.starshipsStrings.append(starship.name)
              })
            case .failure(let error):
              print(error)
            }
          }
          
          // fetch vehicles names
          characterClient.fetchVehiclesFromURL(character.vehicles) { (results) in
            switch results {
            case .success(let vehicles):
              vehicles?.forEach({ (vehicle) in
                character.vehiclesStrings.append(vehicle.name)
              })
            case .failure(let error):
              print(error)
            }
          }
        }
      
        self?.searchResults.append(contentsOf: characters)
        self?.tableView.reloadData()
        
        self?.smallestCharacter = self?.findShortestAndTallestCharacter(characters).0
        self?.largestCharacter = self?.findShortestAndTallestCharacter(characters).1
      case .failure(let error):
        print(error)
      }
    }

    let vehicleClient = StarWarsAPIClient<Vehicle>()
    vehicleClient.fetchAllItems(with: .vehicles) { [weak self] (vehicleResults) in
      switch vehicleResults {
      case .success(let vehicles):
        self?.searchResults.append(contentsOf: vehicles)
        self?.tableView.reloadData()
        
        self?.smallestVehicle = self?.findSmallestAndLargestVehicle(vehicles).0
        self?.largestVehicle = self?.findSmallestAndLargestVehicle(vehicles).1
      case .failure(let error):
        print(error)
      }
    }

    let starshipClient = StarWarsAPIClient<Starship>()
    starshipClient.fetchAllItems(with: .starships) { [weak self] (starshipResults) in
      switch starshipResults {
      case .success(let starships):
        self?.searchResults.append(contentsOf: starships)
        self?.tableView.reloadData()
        
        self?.smallestStarship = self?.findSmallestAndLargestStarship(starships).0
        self?.largestStarship = self?.findSmallestAndLargestStarship(starships).1
      case .failure(let error):
        print(error)
      }
    }
  }
  
  @objc func dismissSearchResultsController() {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailController = DetailController()
    
    if filteredResults.isEmpty {
      print("\(searchResults[indexPath.row].name)")
      present(detailController, with: searchResults[indexPath.row])
    } else {
      print("\(filteredResults[indexPath.row].name)")
      present(detailController, with: filteredResults[indexPath.row])
    }
  }
  
  func present(_ detailController: DetailController, with selection: Type) {
    detailController.selection = selection
    
    switch selection.type {
    case .character:
      detailController.smallest = smallestCharacter
      detailController.largest = largestCharacter
    case .starship:
      detailController.smallest = smallestStarship
      detailController.largest = largestStarship
    case .vehicle:
      detailController.smallest = smallestVehicle
      detailController.largest = largestVehicle
    }
    
    present(detailController, animated: true, completion: nil)
  }
}

extension SearchResultsController {
  
  // MARK: - Methods for comparing characters/vehicles/starships
  func findShortestAndTallestCharacter(_ characters: [Character]) -> (Character?, Character?) {
    let filteredHeights = characters.filter { $0.height != "unknown" } // removes all unknown strings from array
    
    let sortedCharactersBasedOnHeight = filteredHeights.sorted { (h, y) -> Bool in
      let smallestInt = Int(h.height)
      let largestInt = Int(y.height)
      var unwrappedS = Int()
      var unwrappedT = Int()
      
      if let shortest = smallestInt, let tallest = largestInt {
        unwrappedS = shortest
        unwrappedT = tallest
      } else {
        print("smallest/largest is non existent!")
      }
      return unwrappedS < unwrappedT
    }
    
    let shortestCharacter = sortedCharactersBasedOnHeight.first
    let tallestCharacter = sortedCharactersBasedOnHeight.last
    
    return (shortestCharacter, tallestCharacter)
  }
  
  func findSmallestAndLargestVehicle(_ vehicles: [Vehicle]) -> (Vehicle?, Vehicle?) {
    let filteredLengths = vehicles.filter { $0.length != "unknown" } // removes all unknown strings from array
    
    let sortedVehiclesBasedOnLength = filteredLengths.sorted { (x, y) -> Bool in
      let smallestInt = Int(x.length)
      let largestInt = Int(y.length)
      var unwrappedS = Int()
      var unwrappedT = Int()
      
      if let smallest = smallestInt, let largest = largestInt {
        unwrappedS = smallest
        unwrappedT = largest
      } else {
        print("smallest/largest is non existent!")
      }
      return unwrappedS < unwrappedT
    }
    
    let smallestVehicle = sortedVehiclesBasedOnLength.first
    let largestVehicle = sortedVehiclesBasedOnLength.last
    
    return (smallestVehicle, largestVehicle)
  }
  
  func findSmallestAndLargestStarship(_ starships: [Starship]) -> (Starship?, Starship?) {
    let filteredLengths = starships.filter { $0.length != "unknown" } // removes all unknown strings from array
    
    let sortedStarshipsBasedOnLength = filteredLengths.sorted { (x, y) -> Bool in
      let smallestInt = Int(x.length)
      let largestInt = Int(y.length)
      var unwrappedS = Int()
      var unwrappedT = Int()
      
      if let smallest = smallestInt, let largest = largestInt {
        unwrappedS = smallest
        unwrappedT = largest
      } else {
        print("smallest/largest is non existent!")
      }
      return unwrappedS < unwrappedT
    }
    
    let smallestStarship = sortedStarshipsBasedOnLength.first
    let largestStarship = sortedStarshipsBasedOnLength.last
    
    return (smallestStarship, largestStarship)
  }
}

