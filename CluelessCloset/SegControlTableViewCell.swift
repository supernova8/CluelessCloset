//
//  SegControlTableViewCell.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/6/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit

class SegControlTableViewCell: UITableViewCell {

    
    @IBOutlet var cellLabel     :UILabel!
    @IBOutlet var cellSegControl    :UISegmentedControl!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
