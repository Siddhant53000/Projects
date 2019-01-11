//
//  memoriesTableViewCell.swift
//  Koa
//
//  Created by Siddhant Gupta on 10/18/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit

class memoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var day1Img: UIImageView!
    @IBOutlet weak var day2Img: UIImageView!
    @IBOutlet weak var day3Img: UIImageView!
    @IBOutlet weak var day4Img: UIImageView!
    @IBOutlet weak var day5Img: UIImageView!
    @IBOutlet weak var day6Img: UIImageView!
    @IBOutlet weak var day7Img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
