//
//  UsrTbCell.swift
//  WIU
//
//  Created by Luis Conde Rodríguez on 16/04/16.
//  Copyright © 2016 Luis Conde Rodríguez. All rights reserved.
//

import UIKit

class UsrTbCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    
    var number: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func callPhone(sender: AnyObject) {
        
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(self.number)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    

}
