//
//  PickerDataSource.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 11/15/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class PickerDataSource: NSObject, UIPickerViewDataSource {
  
  // MARK: - Properties
  var pickerData = [Type]()
  
  // MARK: - Picker Data Source Methods
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // MARK: - Helper Methods
  func add(with types: [Type]) {
    self.pickerData.append(contentsOf: types)
  }
  
  func deleteAll() {
    self.pickerData = []
  }
  
}
