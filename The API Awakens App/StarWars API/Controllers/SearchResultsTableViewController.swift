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
  
  // clients
  lazy var characterClient = StarWarsAPIClient<Character>()
  lazy var starshipClient = StarWarsAPIClient<Starship>()
  lazy var vehicleClient = StarWarsAPIClient<Vehicle>()
  
  // MARK: - Viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SearchResultsTableViewController.dismissSearchResultsController))
    
    setupTableView()
    fetchAllData() // populate search results
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = datasource
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
  }
  
  func fetchAllData() {
    characterClient.fetchAll(with: .people) { (result) in
      switch result {
      case .success(let characters):
        characters.forEach { (character) in
          self.characterClient.fetchPlanet(with: character.homeWorld) { (result) in
            switch result {
            case .success(let planet):
              character.homeWorldString = planet.name
            case .failure(let error):
              print(error)
              self.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: self)
            }
          }
          
          // fetch piloted starships
          self.characterClient.fetchStarships(with: character.starships) { (result) in
            switch result {
            case .success(let starship):
              character.starshipsStrings.insert(starship.name)
            case .failure(let error):
              print(error)
              self.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: self)
            }
          }
          
          // fetch piloted vehicles
          self.characterClient.fetchVehicles(with: character.vehicles) { (result) in
            switch result {
            case .success(let vehicle):
              character.vehiclesStrings.insert(vehicle.name)
            case .failure(let error):
              print(error)
              self.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: self)
            }
          }
        }
        self.searchResults.append(contentsOf: characters)
        self.tableView.reloadData()
      case .failure(let error):
        print(error)
        self.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: self)
      }
    }
    
    starshipClient.fetchAll(with: .starships) { (result) in
      switch result {
      case .success(let starships):
        self.searchResults.append(contentsOf: starships)
        self.tableView.reloadData()
      case .failure(let error):
        print(error)
        self.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: self)
      }
    }
    
    vehicleClient.fetchAll(with: .vehicles) { (result) in
      switch result {
      case .success(let vehicles):
        self.searchResults.append(contentsOf: vehicles)
        self.tableView.reloadData()
      case .failure(let error):
        print(error)
        self.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: self)
      }
    }
    
  }
  
  @objc func dismissSearchResultsController() {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailVC = DetailsViewController()
    let selection = self.datasource.object(with: indexPath)
    
    switch selection!.type {
    case .character:
      DispatchQueue.main.async {
        self.characterClient.fetchAll(with: .people) { (result) in
          switch result {
          case .success(let characters):
            detailVC.selection = selection
            
            detailVC.smallestTitleLabel.text = "Shortest:"
            detailVC.smallestDescriptionLabel.text = self.findShortestAndTallestCharacter(characters).0?.name
            detailVC.largestTitleLabel.text = "Tallest:"
            detailVC.largestDescriptionLabel.text = self.findShortestAndTallestCharacter(characters).1?.name

            detailVC.detailsTableView.reloadData()

            detailVC.updatePickerData(with: characters)
            detailVC.pickerView.reloadAllComponents()
          case .failure(let error):
            print(error)
          }
        }
      }
    case .starship:
      DispatchQueue.main.async {
        self.starshipClient.fetchAll(with: .starships) { (result) in
          switch result {
          case .success(let starships):
            detailVC.selection = selection
            
            detailVC.smallestTitleLabel.text = "Smallest:"
            detailVC.smallestDescriptionLabel.text = self.findSmallestAndLargestStarship(starships).0?.name
            detailVC.largestTitleLabel.text = "Largest:"
            detailVC.largestDescriptionLabel.text = self.findSmallestAndLargestStarship(starships).1?.name

            detailVC.detailsTableView.reloadData()

            detailVC.updatePickerData(with: starships)
            detailVC.pickerView.reloadAllComponents()
          case .failure(let error):
            print(error)
          }
        }
      }
    case.vehicle:
      DispatchQueue.main.async {
        self.vehicleClient.fetchAll(with: .vehicles) { (result) in
          switch result {
          case .success(let vehicles):
            detailVC.selection = selection

            detailVC.smallestTitleLabel.text = "Smallest:"
            detailVC.smallestDescriptionLabel.text = self.findSmallestAndLargestVehicle(vehicles).0?.name
            detailVC.largestTitleLabel.text = "Largest:"
            detailVC.largestDescriptionLabel.text = self.findSmallestAndLargestVehicle(vehicles).1?.name

            detailVC.detailsTableView.reloadData()

            detailVC.updatePickerData(with: vehicles)
            detailVC.pickerView.reloadAllComponents()
          case .failure(let error):
            print(error)
          }
        }
      }
    }

    self.navigationController?.pushViewController(detailVC, animated: true)
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

