//
//  Character.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 9/27/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

class Character {
  let name: String
  let birthYear: String
  let homeWorld: String
  let height: String
  let eyeColor: String
  let hairColor: String
  
  init(name: String, birthYear: String, homeWorld: String, height: String, eyeColor: String, hairColor: String) {
    self.name = name
    self.birthYear = birthYear
    self.homeWorld = homeWorld
    self.height = height
    self.eyeColor = eyeColor
    self.hairColor = hairColor
  }
  
}
