//
//  QuestTableViewCell.swift
//  QRQ
//
//  Created by Yura Tronyak on 5/6/16.
//  Copyright © 2016 Yura Tronyak. All rights reserved.
//

import UIKit

class QuestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var short_quest_image: UIImageView!
    
    @IBOutlet weak var short_quest_title: UILabel!
    @IBOutlet weak var short_quest_description: UILabel!
    @IBOutlet weak var short_quest_count_poi: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}