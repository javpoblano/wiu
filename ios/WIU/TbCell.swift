//
//  TbCell.swift
//  WIU
//
//  Created by Luis Conde Rodríguez on 15/04/16.
//  Copyright © 2016 Luis Conde Rodríguez. All rights reserved.
//

import UIKit

class TbCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
