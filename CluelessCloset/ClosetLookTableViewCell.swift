//
//  ClosetLookTableViewCell.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/12/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit

class ClosetLookTableViewCell: UITableViewCell {

    @IBOutlet var lookNumberLabel :UILabel!
    @IBOutlet var lookNameLabel :UILabel!
    @IBOutlet var seasonLabel :UILabel!
    @IBOutlet var lastWornLabel :UILabel!
    @IBOutlet var timesWornLabel :UILabel!
    @IBOutlet var lookImageView :UIImageView!
    @IBOutlet var faveImageView :UIImageView!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
