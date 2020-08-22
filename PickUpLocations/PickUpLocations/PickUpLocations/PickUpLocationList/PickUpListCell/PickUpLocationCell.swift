//
//  PickUpLocationCell.swift
//  PickUpLocations
//
//  Created by Ravi Vora on 19/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import UIKit

protocol SelectButtonDelegate: class {
    func selectButtonClicked(isSelected: Bool, tag: Int)
}

class PickUpLocationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    weak var delegate: SelectButtonDelegate?
    private var isCheckMarkSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareCell(with viewModel: PickUpListModel.ViewModel) {
        self.nameLabel.text = viewModel.name
        self.cityLabel.text = viewModel.city
        self.addressLabel.text = viewModel.address
        
        let distanceString:String = String(format: "%.2f km", viewModel.distanceValue)
        self.distanceLabel.text = distanceString
        isCheckMarkSelected = viewModel.isSelected
        
        if viewModel.isSelected == true {
            self.checkButton.setImage(UIImage(named: UIConstant.Images.correctfilledIcon), for: .normal)
        } else {
            self.checkButton.setImage(UIImage(named: UIConstant.Images.correctunfilledIcon), for: .normal)
        }
    }
    
    @IBAction func checkButtonClicked(_ sender: UIButton) {
        self.delegate?.selectButtonClicked(isSelected: isCheckMarkSelected, tag: self.checkButton.tag)
    }
}
