//
//  textPostTableViewCell.swift
//  Koa
//
//  Created by Siddhant Gupta on 11/6/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit

class textPostTableViewCell: UITableViewCell {

    @IBOutlet weak var postText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     //   postText.layer.cornerRadius = 5
      //  postText.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
