//
//  UserViewCell.swift
//  Cogether
//
//  Created by tongho on 2017/6/3.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit

class UserViewCell: UITableViewCell {
    
    var userId: Int?

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var signature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
