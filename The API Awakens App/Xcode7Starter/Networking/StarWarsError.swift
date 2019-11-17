//
//  StarWarsError.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/11/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import Foundation

enum StarWarsError: Error {
  case decodingFailure
  case invalidData
  case invalidURL
  case jsonConversionFailure
  case jsonParsingFailure(message: String)
  case requestFailed
  case responseUnsuccessful(statusCode: Int)
}
