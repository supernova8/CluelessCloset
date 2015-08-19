//
//  SelfieHeaderCell.swift
//  CluelessCloset
//
//  Created by Sonova Middleton on 8/19/15.
//  Copyright (c) 2015 supernova8productions. All rights reserved.
//

import UIKit

class SelfieHeaderCell: UITableViewCell {
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var headerImageView :UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
