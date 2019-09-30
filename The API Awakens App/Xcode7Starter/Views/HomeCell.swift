//
//  HomeCell.swift
//  Xcode7Starter
//
//  Created by Arwin Oblea on 9/26/19.
//  Copyright © 2019 Treehouse Island, Inc. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

  // MARK: - Properties
  static let cellID = "HomeCell"
  
  let artworkImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 122/255, green: 205/255, blue: 252/255, alpha: 1)
    label.font = .boldSystemFont(ofSize: 20)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: HomeCell.cellID)
    
    backgroundColor = UIColor(red: 27/255, green: 32/255, blue: 36/255, alpha: 1)
    
    let cellStackView = UIStackView(arrangedSubviews: [artworkImageView, titleLabel])
    cellStackView.axis = .vertical
    cellStackView.alignment = .center
    cellStackView.distribution = .fill
    cellStackView.spacing = 15
    cellStackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(cellStackView)
    
    cellStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    cellStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
