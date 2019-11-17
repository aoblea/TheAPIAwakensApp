//
//  MainMenuCell.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 10/6/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class MainMenuCell: UITableViewCell {

  // MARK: - Properties
  static let reuseIdentifier = "MainMenuCell"
  
  let artworkImage = UIImageView()
  let titleLabel = UILabel()
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: MainMenuCell.reuseIdentifier)
    
    setupCell()
  }
  
  func setupCell() {
    backgroundColor = UIColor.Theme.dark
    
    titleLabel.textColor = UIColor.Theme.blue
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    artworkImage.translatesAutoresizingMaskIntoConstraints = false
    
    let stack = UIStackView(arrangedSubviews: [artworkImage, titleLabel])
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 5
    stack.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stack)
    
    stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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

}
