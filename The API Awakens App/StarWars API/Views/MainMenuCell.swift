//
//  MainMenuCell.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class MainMenuCell: UITableViewCell {
  // MARK: - IBOutlets
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = UIColor.Theme.dark
    selectionStyle = .none
    
    self.artworkImageView.backgroundColor = UIColor.Theme.dark
    self.nameLabel.textColor = UIColor.Theme.blue
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
