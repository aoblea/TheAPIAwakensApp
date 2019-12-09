//
//  MainMenuTableViewController.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class MainMenuTableViewController: UITableViewController, Alertable {
  // MARK: - Properties
  let searchResultsController = SearchResultsTableViewController()
  
  lazy var searchController: UISearchController = { [unowned self] in
    let search = UISearchController(searchResultsController: searchResultsController)
    search.searchBar.searchBarStyle = .minimal
    search.hidesNavigationBarDuringPresentation = true
    search.searchBar.placeholder = "Search for characters, etc."
    search.searchResultsUpdater = self
    return search
  }()

  let datasource = MainMenuDataSource()
  
  // clients
  lazy var characterClient = StarWarsAPIClient<Character>()
  lazy var starshipClient = StarWarsAPIClient<Starship>()
  lazy var vehicleClient = StarWarsAPIClient<Vehicle>()
  
  var planetDownloaded: Bool?
  var starshipsDownloaded: Bool?
  var vehiclesDownloaded: Bool?
  
  // MARK: - Viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupTableView()
  }
  
  func setupView() {
    self.title = "StarWars API"
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Theme.blue]
    navigationController?.navigationBar.barTintColor = UIColor.Theme.dark
    view.backgroundColor = UIColor.Theme.dark
    definesPresentationContext = true
  }
  
  func setupTableView() {
    tableView.dataSource = datasource
    tableView.separatorColor = UIColor.Theme.lightGray
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    tableView.tableHeaderView = searchController.searchBar
  }
}

extension MainMenuTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchText = searchController.searchBar.text ?? ""

    searchResultsController.filteredResults = searchResultsController.searchResults.filter({ (result) -> Bool in
      return result.name.lowercased().contains(searchText.lowercased())
    })
    
    if searchResultsController.filteredResults.isEmpty {
      searchResultsController.datasource.update(with: searchResultsController.searchResults)
      searchResultsController.tableView.reloadData()
    } else {
      searchResultsController.datasource.update(with: searchResultsController.filteredResults)
      searchResultsController.tableView.reloadData()
    }
  }
}

extension MainMenuTableViewController {
  // MARK: - Table view delegate
  // constant height for rows
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  // MARK: - Helper method for fetching urls
  func getDetails(using character: Character) {
    // fetch planet
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

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetails" {
      guard let indexPath = tableView.indexPathForSelectedRow else { return }
      let detailsViewController = segue.destination as? DetailsViewController
      guard let detailsVC = detailsViewController else { return }
        
      let selection = datasource.selection(at: indexPath)
      switch selection {
      case .character:
        DispatchQueue.main.async {
          self.characterClient.fetchAll(with: .people) { [weak self] (result) in
            guard let main = self else { return } // check if self exists
            switch result {
            case .success(let characters):
              characters.forEach { (character) in
                main.getDetails(using: character)
              }
              
              detailsVC.selection = characters.first
            
              detailsVC.smallestTitleLabel.text = "Shortest:"
              detailsVC.smallestDescriptionLabel.text = main.findShortestAndTallestCharacter(characters).0?.name
              detailsVC.largestTitleLabel.text = "Tallest:"
              detailsVC.largestDescriptionLabel.text = main.findShortestAndTallestCharacter(characters).1?.name
              
              detailsVC.detailsTableView.reloadData()
              
              detailsVC.updatePickerData(with: characters)
              detailsVC.pickerView.reloadAllComponents()
            case .failure(let error):
              print(error)
              main.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: main)
            }
          }
        }
      case .starship:
        DispatchQueue.main.async {
          self.starshipClient.fetchAll(with: .starships) { [weak self] (result) in
            guard let main = self else { return }
            switch result {
            case .success(let starships):
              detailsVC.selection = starships.first
              
              detailsVC.smallestTitleLabel.text = "Smallest:"
              detailsVC.smallestDescriptionLabel.text = main.findSmallestAndLargestStarship(starships).0?.name
              detailsVC.largestTitleLabel.text = "Largest:"
              detailsVC.largestDescriptionLabel.text = main.findSmallestAndLargestStarship(starships).1?.name

              detailsVC.detailsTableView.reloadData()
              
              detailsVC.updatePickerData(with: starships)
              detailsVC.pickerView.reloadAllComponents()
            case .failure(let error):
              print(error)
              main.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: main)
            }
          }
        }
      case .vehicle:
        DispatchQueue.main.async {
          self.vehicleClient.fetchAll(with: .vehicles) { [weak self] (result) in
            guard let main = self else { return }
            switch result {
            case .success(let vehicles):
              detailsVC.selection = vehicles.first
              
              detailsVC.smallestTitleLabel.text = "Smallest:"
              detailsVC.smallestDescriptionLabel.text = main.findSmallestAndLargestVehicle(vehicles).0?.name
              detailsVC.largestTitleLabel.text = "Largest:"
              detailsVC.largestDescriptionLabel.text = main.findSmallestAndLargestVehicle(vehicles).1?.name
                
              detailsVC.detailsTableView.reloadData()
              
              detailsVC.updatePickerData(with: vehicles)
              detailsVC.pickerView.reloadAllComponents()
            case .failure(let error):
              print(error)
              main.showAlert(title: "JSON error has occurred.", message: "Error: \(error)", viewController: main)
            }
          }
        }
      }
    }
  }
  
}
