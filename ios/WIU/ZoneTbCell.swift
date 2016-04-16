//
//  ZoneTbCell.swift
//  WIU
//
//  Created by Luis Conde Rodríguez on 16/04/16.
//  Copyright © 2016 Luis Conde Rodríguez. All rights reserved.
//

import UIKit

class ZoneTbCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var radio: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
