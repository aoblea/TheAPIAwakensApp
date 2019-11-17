//
//  Pages.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/11/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

struct Page<T>: Decodable {
  let count: Int
  let next: URL?
  let previous: URL?
  let results: [T]?
  
  enum PageCodingKeys: String, CodingKey {
    case count
    case next
    case previous
    case results
  }
}




