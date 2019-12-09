//
//  SearchResultsTableViewController.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, Alertable {
  // MARK: - Properties
  var searchResults = [Type]()
  var filteredResults = [Type]()
  
  let datasource = SearchResultsDataSource()
  
  var smallestCharacter: Character?
  var largestCharacter: Character?
  
  var smallestStarship: Starship?
  var largestStarship: Starship?
  
  var smallestVehicle: Vehicle?
  var largestVehicle: Vehicle?
  
  // MARK: - Viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SearchResultsTableViewController.dismissSearchResultsController))
    
    setupTableView()
    fetchAllData()
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = datasource
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
  }

  func fetchAllData() {
    let characterClient = StarWarsAPIClient<Character>()
    characterClient.fetchAll(with: .people) { [weak self] (result) in
      guard let searchResultVC = self else { return }
      switch result {
      case .success(let characters):
        characters.forEach { (character) in
          // fetch planet
          characterClient.fetchPlanet(with: character.homeWorld) { (result) in
            switch result {
            case .success(let planet):
              print(planet)
            case .failure(let error):
              print(error)
              searchResultVC.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: searchResultVC)
            }
          }
          // fetch piloted starships
          characterClient.fetchStarships(with: character.starships) { (result) in
            switch result {
            case .success(let starship):
              print(starship)
            case .failure(let error):
              print(error)
              searchResultVC.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: searchResultVC)
            }
          }
          // fetch piloted vehicles
          characterClient.fetchVehicles(with: character.vehicles) { (result) in
            switch result {
            case .success(let vehicle):
              print(vehicle)
            case .failure(let error):
              print(error)
              searchResultVC.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: searchResultVC)
            }
          }
        }

        searchResultVC.searchResults.append(contentsOf: characters)
        searchResultVC.tableView.reloadData()
        
        searchResultVC.smallestCharacter = searchResultVC.findShortestAndTallestCharacter(characters).0
        searchResultVC.largestCharacter = searchResultVC.findShortestAndTallestCharacter(characters).1
      case .failure(let error):
        print(error)
        searchResultVC.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: searchResultVC)
      }
    }
    
    let starshipClient = StarWarsAPIClient<Starship>()
    starshipClient.fetchAll(with: .starships) { [weak self] (result) in
      guard let searchResultVC = self else { return }
      switch result {
      case .success(let starships):
        searchResultVC.searchResults.append(contentsOf: starships)
        searchResultVC.tableView.reloadData()
        
        searchResultVC.smallestStarship = searchResultVC.findSmallestAndLargestStarship(starships).0
        searchResultVC.largestStarship = searchResultVC.findSmallestAndLargestStarship(starships).1
      case .failure(let error):
        print(error)
        searchResultVC.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: searchResultVC)
      }
    }

    let vehicleClient = StarWarsAPIClient<Vehicle>()
    vehicleClient.fetchAll(with: .vehicles) { [weak self] (result) in
      guard let searchResultVC = self else { return }
      switch result {
      case .success(let vehicles):
        searchResultVC.searchResults.append(contentsOf: vehicles)
        searchResultVC.tableView.reloadData()
        
        searchResultVC.smallestVehicle = searchResultVC.findSmallestAndLargestVehicle(vehicles).0
        searchResultVC.largestVehicle = searchResultVC.findSmallestAndLargestVehicle(vehicles).1
      case .failure(let error):
        print(error)
        searchResultVC.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: searchResultVC)
      }
    }
  }
  
  @objc func dismissSearchResultsController() {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailController = DetailsViewController()
    
    if filteredResults.isEmpty {
      print("\(searchResults[indexPath.row].name)")
      present(detailController, with: searchResults[indexPath.row])
    } else {
      print("\(filteredResults[indexPath.row].name)")
      present(detailController, with: filteredResults[indexPath.row])
    }
  }
  
  func present(_ detailController: DetailsViewController, with selection: Type) {
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

extension SearchResultsTableViewController {
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

