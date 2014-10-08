//
//  MenuCell.swift
//  TwitterRedux
//
//  Created by Faith Cox on 10/7/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var displayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String!){
        println(name)
        displayLabel.text = name
    }
}
