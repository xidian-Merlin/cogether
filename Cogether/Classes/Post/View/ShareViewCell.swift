//
//  ShareViewCell.swift
//  Cogether
//
//  Created by tongho on 2017/5/28.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit

class ShareViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var reply: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.content.font = UIFont.systemFont(ofSize: 15)
        self.reply.font = UIFont.systemFont(ofSize: 15)
        
       
        // Initialization code
    }

    //对文本内容的长度进行处理
    func setContentString(){
    
       //将超过三行的部分使用省略号代替
        
       //将最终生成的字符串付给content.text
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
