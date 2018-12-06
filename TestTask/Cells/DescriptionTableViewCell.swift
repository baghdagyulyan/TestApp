//
//  DescriptionTableViewCell.swift
//  TestTask
//
//  Created by Davit Baghdagyulyan on 12/6/18.
//  Copyright © 2018 Davit Baghdagyulyan. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
