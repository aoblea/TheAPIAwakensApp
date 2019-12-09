//
//  DetailsViewController.swift
//  StarWars API
//
//  Created by Arwin Oblea on 12/2/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var smallestTitleLabel: UILabel!
  @IBOutlet weak var largestTitleLabel: UILabel!
  @IBOutlet weak var smallestDescriptionLabel: UILabel!
  @IBOutlet weak var largestDescriptionLabel: UILabel!
  @IBOutlet weak var pickerView: UIPickerView!
  @IBOutlet weak var detailsTableView: UITableView!
  
  // MARK: - Properties
  var selection: Type? {
    didSet {
      guard let selection = selection else { return }
      self.title = selection.name
      detailsDataSource.update(with: selection)
      detailsTableView.reloadData()
    }
  }
  
  // for results controller
  var smallest: Type?
  var largest: Type?
  
  let detailsDataSource = DetailsDataSource()
  
  private var pickerData = [Type]()
  
  // MARK: - Viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
  
    setupView()
    setupTableView()
    setupPickerView()
    detailsDataSource.delegate = self // for sending alerts from detail cells
  }
  
  func setupView() {
    view.backgroundColor = UIColor.Theme.dark
    edgesForExtendedLayout = UIRectEdge.bottom // pushes content underneath nav bar

    self.smallestTitleLabel.textColor = UIColor.Theme.blue
    self.largestTitleLabel.textColor = UIColor.Theme.blue
    self.smallestDescriptionLabel.textColor = UIColor.white
    self.largestDescriptionLabel.textColor = UIColor.white
  }
    
  func setupTableView() {
    detailsTableView.backgroundColor = UIColor.Theme.dark
    detailsTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    detailsTableView.separatorColor = UIColor.Theme.lightGray
    detailsTableView.rowHeight = 90
    detailsTableView.estimatedRowHeight = 100
    detailsTableView.isScrollEnabled = true
    detailsTableView.dataSource = detailsDataSource
  }
  
  func setupPickerView() {
    pickerView.backgroundColor = .white
    pickerView.delegate = self
    pickerView.dataSource = self
  }
  
  // empties out pickerdata for next selection
  override func viewDidDisappear(_ animated: Bool) {
    self.pickerData = []
  }

}

// MARK: - Picker data source and delegate
extension DetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    // change selection by picker selection
    selection = pickerData[row]
    self.title = pickerData[row].name
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    pickerView.reloadInputViews()
    return pickerData[row].name
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // Helper method
  func updatePickerData(with data: [Type]) {
    self.pickerData = data
  }
}
