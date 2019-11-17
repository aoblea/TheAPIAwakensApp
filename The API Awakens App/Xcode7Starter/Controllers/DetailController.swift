//
//  DetailController.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/7/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class DetailController: UIViewController, UITableViewDelegate {
  
  // MARK: - Properties
  var selection: Type? {
    didSet {
      guard let selection = selection else { return }
      self.titleLabel.text = selection.name
      infoDataSource.update(with: selection)
      self.infoTableView.reloadData()
    }
  }
  
  let pickerView: UIPickerView = {
    let view = UIPickerView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  let pickerDataSource = PickerDataSource()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 25)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let sizeView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.Theme.dark
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let infoTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(InformationCell.self, forCellReuseIdentifier: InformationCell.reuseIdentifier)
    tableView.backgroundColor = UIColor.Theme.dark
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    tableView.separatorColor = UIColor.Theme.lightGray
    tableView.rowHeight = 100
    tableView.estimatedRowHeight = 600
    tableView.isScrollEnabled = true
    tableView.allowsSelection = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
  let infoDataSource = DetailDataSource()
  
  var smallest: Type?
  var largest: Type?

  // MARK: - Viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let selection = selection {
      switch selection.type {
      case .character:
        let client = StarWarsAPIClient<Character>()
        client.fetchAllItems(with: .people) { (results) in
          switch results {
          case .success(let characters):
            
            characters.forEach { (character) in
              // fetch planet name
              client.fetchPlanetFromURL(character.homeWorld) { (results) in
                switch results {
                case .success(let planet):
                  character.homeWorldString = planet.name
                case .failure(let error):
                  print(error)
                }
              }
              
              // fetch starships names
              client.fetchStarshipsFromURL(character.starships) { (results) in
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
              client.fetchVehiclesFromURL(character.vehicles) { (results) in
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
            
            self.pickerDataSource.add(with: characters)
            self.pickerView.reloadAllComponents()
          case .failure(let error):
            print(error)
          }
        }
      case .starship:
        let client = StarWarsAPIClient<Starship>()
        client.fetchAllItems(with: .starships) { (results) in
          switch results {
          case .success(let starships):
            self.pickerDataSource.add(with: starships)
            self.pickerView.reloadAllComponents()
          case .failure(let error):
            print(error)
          }
        }
      case .vehicle:
        let client = StarWarsAPIClient<Vehicle>()
        client.fetchAllItems(with: .vehicles) { (results) in
          switch results {
          case .success(let vehicles):
            self.pickerDataSource.add(with: vehicles)
            self.pickerView.reloadAllComponents()
          case .failure(let error):
            print(error)
          }
        }
      }
    }
    
    setupView()
    
    setupPickerView()
    setupInfoTableView()
    setupSizeView()
  }
  
  // empties out pickerdata for next selection
  override func viewDidDisappear(_ animated: Bool) {
    self.pickerDataSource.deleteAll()
    
  }

  func setupPickerView() {
    self.pickerView.dataSource = pickerDataSource
    self.pickerView.delegate = self
  }
  
  func setupInfoTableView() {
    infoTableView.dataSource = infoDataSource
    infoTableView.delegate = self
  }
  
  func setupView() {
    view.backgroundColor = UIColor.Theme.dark
    edgesForExtendedLayout = UIRectEdge.bottom // pushes content underneath nav bar
    
    view.addSubview(titleLabel)
    view.addSubview(infoTableView)
    view.addSubview(pickerView)
    view.addSubview(sizeView)

    titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    infoTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    infoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    infoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    infoTableView.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true

    pickerView.topAnchor.constraint(equalTo: infoTableView.bottomAnchor).isActive = true
    pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    pickerView.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
    
    sizeView.topAnchor.constraint(equalTo: pickerView.bottomAnchor).isActive = true
    sizeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    sizeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    sizeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    sizeView.heightAnchor.constraint(equalToConstant: 60).isActive = true
  }
  
  // MARK: - Size View Setup
  func setupSizeView() {
    let smallestLabel = UILabel()
    smallestLabel.textColor = UIColor.Theme.blue
  
    let largestLabel = UILabel()
    largestLabel.textColor = UIColor.Theme.blue

    let smallestResultLabel = UILabel()
    smallestResultLabel.textColor = .white
    
    let largestResultLabel = UILabel()
    largestResultLabel.textColor = .white
    
    guard let selection = selection else { return }
    if selection.type == .character {
      smallestLabel.text = "Shortest"
      largestLabel.text = "Tallest"
    } else {
      smallestLabel.text = "Smallest"
      largestLabel.text = "Largest"
    }
    
    if let smallest = smallest, let largest = largest {
      smallestResultLabel.text = "\(smallest.name)"
      largestResultLabel.text = "\(largest.name)"
    } else {
      smallestResultLabel.text = "Nil"
      largestResultLabel.text = "Nil"
    }
    
    let labelStack = UIStackView(arrangedSubviews: [smallestLabel, largestLabel])
    labelStack.axis = .vertical
    labelStack.alignment = .leading
    labelStack.distribution = .fill
    labelStack.spacing = 5
    labelStack.translatesAutoresizingMaskIntoConstraints = false
    sizeView.addSubview(labelStack)
    
    let resultStack = UIStackView(arrangedSubviews: [smallestResultLabel, largestResultLabel])
    resultStack.axis = .vertical
    resultStack.alignment = .leading
    resultStack.distribution = .fill
    resultStack.spacing = 5
    resultStack.translatesAutoresizingMaskIntoConstraints = false
    sizeView.addSubview(resultStack)
    
    labelStack.leadingAnchor.constraint(equalTo: sizeView.leadingAnchor, constant: 20).isActive = true
    labelStack.centerYAnchor.constraint(equalTo: sizeView.centerYAnchor).isActive = true
    
    resultStack.leadingAnchor.constraint(equalTo: labelStack.trailingAnchor, constant: 8).isActive = true
    resultStack.centerYAnchor.constraint(equalTo: sizeView.centerYAnchor).isActive = true
  }
  
}

// MARK: - Detail Controller Extension
extension DetailController: UIPickerViewDelegate {
  
  // MARK: - Picker Delegate Methods
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    // change selection by picker selection
    selection = pickerDataSource.pickerData[row]
    self.titleLabel.text = pickerDataSource.pickerData[row].name
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerDataSource.pickerData[row].name
  }
}
