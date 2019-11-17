//
//  MainMenuController.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/6/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class MainMenuController: UITableViewController {

  // MARK: - Properties
  private struct Constants {
    static let MainMenuCellHeight: CGFloat = 200
  }
  
  let searchResultsController = SearchResultsController()
  let dataSource = MainMenuDataSource()
  
  var characterData = [Character]()
  var vehicleData = [Vehicle]()
  var starshipData = [Starship]()
  
  var smallestCharacter: Character?
  var largestCharacter: Character?
  
  var smallestVehicle: Vehicle?
  var largestVehicle: Vehicle?
  
  var smallestStarship: Starship?
  var largestStarship: Starship?
  
  var finishedDownloadingCharacters: Bool?
  var finishedDownloadingVehicles: Bool?
  var finishedDownloadingStarships: Bool?
  
  lazy var searchController: UISearchController = { [unowned self] in
    let search = UISearchController(searchResultsController: searchResultsController)
    search.searchBar.searchBarStyle = .minimal
    search.hidesNavigationBarDuringPresentation = true
    search.dimsBackgroundDuringPresentation = true
    search.searchBar.placeholder = "Search for characters, etc."
    search.searchResultsUpdater = self
    return search
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.Theme.dark
    definesPresentationContext = true
    setupTableView()
    
    fetchAllData()
  }
  
  func setupTableView() {
    tableView.separatorColor = UIColor.Theme.lightGray
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    tableView.register(MainMenuCell.self, forCellReuseIdentifier: MainMenuCell.reuseIdentifier)
    tableView.tableHeaderView = searchController.searchBar
    tableView.dataSource = dataSource
  }
  
  // MARK: - Table view delegate
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.MainMenuCellHeight
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      print("Characters selected")
      if finishedDownloadingCharacters == true {
        let detailController = DetailController()
        detailController.selection = characterData.first
        detailController.smallest = smallestCharacter
        detailController.largest = largestCharacter
        present(detailController, animated: true, completion: nil)
      }
      
    case 1:
      print("Starships selected")
      if finishedDownloadingStarships == true {
        let detailController = DetailController()
        detailController.selection = starshipData.first
        detailController.smallest = smallestStarship
        detailController.largest = largestStarship
        present(detailController, animated: true, completion: nil)
      }
      
    case 2:
      print("Vehicles selected")
      if finishedDownloadingVehicles == true {
        let detailController = DetailController()
        detailController.selection = vehicleData.first
        detailController.smallest = smallestVehicle
        detailController.largest = largestVehicle
        present(detailController, animated: true, completion: nil)
      }

    default:
      print("Selection error")
    }
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
      
        self?.characterData.append(contentsOf: characters)
        
        self?.smallestCharacter = self?.findShortestAndTallestCharacter(characters).0
        self?.largestCharacter = self?.findShortestAndTallestCharacter(characters).1
        
        if self?.characterData.count == characters.count {
          self?.finishedDownloadingCharacters = true
        }
      case .failure(let error):
        print(error)
      }
    }

    let vehicleClient = StarWarsAPIClient<Vehicle>()
    vehicleClient.fetchAllItems(with: .vehicles) { [weak self] (vehicleResults) in
      switch vehicleResults {
      case .success(let vehicles):
        self?.vehicleData.append(contentsOf: vehicles)
        
        self?.smallestVehicle = self?.findSmallestAndLargestVehicle(vehicles).0
        self?.largestVehicle = self?.findSmallestAndLargestVehicle(vehicles).1
        
        if self?.vehicleData.count == vehicles.count {
          self?.finishedDownloadingVehicles = true
        }
      case .failure(let error):
        print(error)
      }
    }

    let starshipClient = StarWarsAPIClient<Starship>()
    starshipClient.fetchAllItems(with: .starships) { [weak self] (starshipResults) in
      switch starshipResults {
      case .success(let starships):
        self?.starshipData.append(contentsOf: starships)
        
        self?.smallestStarship = self?.findSmallestAndLargestStarship(starships).0
        self?.largestStarship = self?.findSmallestAndLargestStarship(starships).1
        
        if self?.starshipData.count == starships.count {
          self?.finishedDownloadingStarships = true
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
}

extension MainMenuController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchText = searchController.searchBar.text ?? ""
    
    searchResultsController.filteredResults = searchResultsController.searchResults.filter({ (result) -> Bool in
      return result.name.lowercased().contains(searchText.lowercased())
    })
    
    if searchResultsController.filteredResults.isEmpty {
      searchResultsController.dataSource.update(with: searchResultsController.searchResults)
    } else {
      searchResultsController.dataSource.update(with: searchResultsController.filteredResults)
    }
    
    searchResultsController.tableView.reloadData()
  }
  
  func findShortestAndTallestCharacter(_ characters: [Character]) -> (Character?, Character?) {
    let filteredHeights = characters.filter { $0.height != "Unknown" } // removes all unknown strings from array
    
    let sortedCharactersBasedOnHeight = filteredHeights.sorted { (h, y) -> Bool in
      let smallestInt = Int(h.height)
      let largestInt = Int(y.height)
      var unwrappedS = Int()
      var unwrappedT = Int()
      
      if let shortest = smallestInt, let tallest = largestInt {
        unwrappedS = shortest
        unwrappedT = tallest
      }
      return unwrappedS < unwrappedT
    }
    
    let shortestCharacter = sortedCharactersBasedOnHeight.first
    let tallestCharacter = sortedCharactersBasedOnHeight.last
    
    return (shortestCharacter, tallestCharacter)
  }
  
  func findSmallestAndLargestVehicle(_ vehicles: [Vehicle]) -> (Vehicle?, Vehicle?) {
    let filteredLengths = vehicles.filter { $0.length != "Unknown" } // removes all unknown strings from array
    
    let sortedVehiclesBasedOnLength = filteredLengths.sorted { (x, y) -> Bool in
      let smallestInt = Int(x.length)
      let largestInt = Int(y.length)
      var unwrappedS = Int()
      var unwrappedT = Int()
      
      if let smallest = smallestInt, let largest = largestInt {
        unwrappedS = smallest
        unwrappedT = largest
      }
      return unwrappedS < unwrappedT
    }
    
    let smallestVehicle = sortedVehiclesBasedOnLength.first
    let largestVehicle = sortedVehiclesBasedOnLength.last
    
    return (smallestVehicle, largestVehicle)
  }
  
  func findSmallestAndLargestStarship(_ starships: [Starship]) -> (Starship?, Starship?) {
    let filteredLengths = starships.filter { $0.length != "Unknown" } // removes all unknown strings from array
    
    let sortedStarshipsBasedOnLength = filteredLengths.sorted { (x, y) -> Bool in
      let smallestInt = Int(x.length)
      let largestInt = Int(y.length)
      var unwrappedS = Int()
      var unwrappedT = Int()
      
      if let smallest = smallestInt, let largest = largestInt {
        unwrappedS = smallest
        unwrappedT = largest
      } 
      return unwrappedS < unwrappedT
    }
    
    let smallestStarship = sortedStarshipsBasedOnLength.first
    let largestStarship = sortedStarshipsBasedOnLength.last
    
    return (smallestStarship, largestStarship)
  }
}


