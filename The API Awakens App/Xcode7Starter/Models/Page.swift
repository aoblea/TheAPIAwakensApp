//
//  Page.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/22/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

struct Page<T: Decodable>: Decodable {
  let count: Int
  let next: URL?
  let previous: URL?
  let results: [T]
  
  private enum PageCodingKeys: String, CodingKey {
    case count
    case next
    case previous
    case results
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: PageCodingKeys.self)
    self.count = try container.decode(Int.self, forKey: .count)
    self.next = try container.decode(URL?.self, forKey: .next)
    self.previous = try container.decode(URL?.self, forKey: .previous)
    self.results = try container.decode([T].self, forKey: .results)
  }
}

