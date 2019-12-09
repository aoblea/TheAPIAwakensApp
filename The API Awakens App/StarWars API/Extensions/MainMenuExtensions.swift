//
//  MainMenuExtensions.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation

extension MainMenuTableViewController {
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
