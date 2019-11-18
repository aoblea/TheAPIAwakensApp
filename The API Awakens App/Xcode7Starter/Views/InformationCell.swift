//
//  InformationCell.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/8/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {
  
  // MARK: - Properties
  static let reuseIdentifier = "InformationCell"
  
  let rowLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.Theme.blue
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let inputLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = UIFont.systemFont(ofSize: 15)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let convertButton = UIButton()
  
  let rateTextField: UITextField = {
    let textfield = UITextField()
    textfield.backgroundColor = UIColor.white
    textfield.placeholder = "Enter rate ..."
    textfield.font = UIFont.systemFont(ofSize: 12)
    textfield.translatesAutoresizingMaskIntoConstraints = false
    return textfield
  }()
  var rate: Double?
  
  var rowText: String?
  var inputText: String?
  var convertedInputText: String?
  
  var buttonPressed: Bool = false
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    backgroundColor = UIColor.Theme.dark

    convertButton.setTitle("Convert", for: .normal)
    convertButton.backgroundColor = UIColor.Theme.blue
    convertButton.isHidden = true
    convertButton.translatesAutoresizingMaskIntoConstraints = false

    addSubview(rowLabel)
    addSubview(inputLabel)
    addSubview(convertButton)
    addSubview(rateTextField)

    rowLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    rowLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    rowLabel.widthAnchor.constraint(equalToConstant: 75).isActive = true

    inputLabel.leadingAnchor.constraint(equalTo: rowLabel.trailingAnchor).isActive = true
    inputLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    inputLabel.trailingAnchor.constraint(equalTo: convertButton.leadingAnchor, constant: -10).isActive = true
    
    convertButton.leadingAnchor.constraint(equalTo: inputLabel.trailingAnchor, constant: 10).isActive = true
    convertButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    convertButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    convertButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    convertButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    rateTextField.leadingAnchor.constraint(equalTo: inputLabel.trailingAnchor, constant: 10).isActive = true
    rateTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    rateTextField.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 5).isActive = true
    rateTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    rateTextField.widthAnchor.constraint(equalToConstant: 80).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
    
  }
  
  func configure(with feature: Featurable) {
    self.rowText = feature.name
    self.inputText = feature.description
    self.convertedInputText = feature.convertedDescription
    
    rowLabel.text = feature.name
    
    if feature.name == "Cost" && feature.description != "unknown" {
      inputLabel.text = feature.description + " Galactic Credits"
    } else {
      inputLabel.text = feature.description
    }
    
    self.convertButton.isHidden = true
    self.rateTextField.isHidden = true
    
    if feature.name == "Height" || feature.name == "Length" {
      self.convertButton.isHidden = false
      self.convertButton.addTarget(self, action: #selector(convertValue), for: .touchUpInside)
    } else if feature.name == "Cost" {
      self.convertButton.isHidden = false
      self.convertButton.addTarget(self, action: #selector(userConvertValue), for: .touchUpInside)
      
      self.rateTextField.isHidden = false
    }
  }
  
  @objc func convertValue() {
    print("button pressed")
    if buttonPressed == false {
      inputLabel.text = convertedInputText
      buttonPressed = true
    } else if buttonPressed == true {
      inputLabel.text = inputText
      buttonPressed = false
    }
  }
  
  @objc func userConvertValue() {
    print("button pressed")
    if buttonPressed == false {
      // set inputlabel.text to conversion rate
      do {
        try convertCurrency()
      } catch {
        print("error happened")
      }
      guard let converted = convertedInputText else { return }
      inputLabel.text = "\(converted) USD"
      
      buttonPressed = true
    } else if buttonPressed == true {
      guard let input = inputText else { return }
      inputLabel.text = "\(input) Galactic Credits"
      
      buttonPressed = false
    }
  }
  
  func convertCurrency() throws {
    // use inputtext for conversion
    // assign result to convertedInputText
    
    if let rate = rateTextField.text, let credits = inputText {
      guard let numberRate = Int(rate) else {
        print("Not a number")
        return
      }
      guard let numberCredits = Int(credits) else {
        return
      }

      let conversion = numberRate * numberCredits
        
      convertedInputText = String(conversion)
    } else {
      return // nothing happens
    }
  }

}
