//
//  DetailCell.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell, Alertable {
  // MARK: - IBOutlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel! 
  @IBOutlet weak var inputTextField: UITextField!
  @IBOutlet weak var convertButton: UIButton!
  
  // MARK: - Properties
  var title: String?
  var value: String?
  var convertedValue: String?
  
  var isValueConverted: Bool = false // for length/height conversion
  var isPriceConverted: Bool = false // for currency conversion
  
  var delegate: DetailsViewController? // for alert messages
  
  // Helper method
  func configure(with feature: Featurable) {
    title = feature.title
    value = feature.description
    convertedValue = feature.convertedValue
    
    self.titleLabel.text = title
    self.descriptionLabel.text = value
    
    if title == "Height:" || title == "Length:" {
      convertButton.addTarget(self, action: #selector(convertValue), for: .touchUpInside)
    } else if title == "Cost:" && value != "unknown" {
      guard let value = value else { return }
      self.descriptionLabel.text = value + "\nGalactic Credits"
      convertButton.addTarget(self, action: #selector(convertPrice), for: .touchUpInside)
    }
    
  }
  
  // FIXME: Reminder to refactor toggle isValueConverted when button is pressed
  @objc func convertValue() {
    if isValueConverted == false {
      self.descriptionLabel.text = convertedValue
      isValueConverted = true
    } else if isValueConverted == true {
      self.descriptionLabel.text = value
      isValueConverted = false
    }
  }
  
  @objc func convertPrice() {
    print("convert price")
    if isPriceConverted == false {
      // convert price
      // TODO: Make a throwing error to send out alert message to user.
      if let rate = inputTextField.text, let credits = value {
        if rate == "0" || rate.contains("-") {
          self.showAlert(title: "Unable to convert with 0 or a negative number", message: "Please enter a number over 0", viewController: self.delegate!)
        } else {
          guard let rateInt = Int(rate) else { return self.showAlert(title: "Not a number", message: "Please enter a number over 0", viewController: self.delegate!) }
          guard let creditsInt = Int(credits) else { return }
          
          let result = rateInt * creditsInt
          convertedValue = result.description
        }
        
      } else {
        self.showAlert(title: "Internal Error", message: "An error occurred with textfield/value", viewController: self.delegate!)
      }
      
      guard let convertedValue = convertedValue else { return }
      self.descriptionLabel.text = convertedValue + "\nUSD"
      isPriceConverted = true
    } else if isPriceConverted == true {
      
      guard let value = value else { return }
      self.descriptionLabel.text = value + "\nGalactic Credits"
      isPriceConverted = false
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    hide()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = UIColor.Theme.dark
    selectionStyle = .none
    
    hide()
    setupLabels()
  }
  
  func hide() {
    convertButton.isHidden = true
    inputTextField.isHidden = true
  }
  
  func setupLabels() {
    self.titleLabel.textColor = UIColor.Theme.blue
    self.descriptionLabel.textColor = UIColor.white
    self.descriptionLabel.numberOfLines = 0
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
