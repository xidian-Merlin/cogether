//
//  TagsTableViewCell.swift
//  Cogether
//
//  Created by tongho on 2017/5/22.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class TagsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lable: UILabel!
    
    @IBOutlet weak var tagView: TTGTextTagCollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Alifmnent
        tagView?.alignment = TTGTagCollectionAlignment.fillByExpandingWidth
        // Initialization code
        
        //Use manul calculate height
        tagView?.manualCalculateHeight = true
        
        tagView?.scrollView.isScrollEnabled = false
        
    }
    
    func setTags(tags: [String]) {
        tagView.removeAllTags()
        tagView .addTags(tags)
        
        // Use manual height, update preferredMaxLayoutWidt
        tagView.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width-10
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
