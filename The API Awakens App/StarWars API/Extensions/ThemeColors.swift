//
//  ThemeColors.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  struct Theme {
    static var blue: UIColor {
      return UIColor(red: 126/255, green: 210/255, blue: 252/255, alpha: 1.0)
    }
    static var dark: UIColor {
      return UIColor(red: 27/255, green: 31/255, blue: 35/255, alpha: 1.0)
    }
    static var lightGray: UIColor {
      return UIColor(red: 66/255, green: 69/255, blue: 71/255, alpha: 1.0)
    }
    static var gray: UIColor {
      return UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1.0)
    }
  }
}
