//
//  ItemOfOrderTableViewCell.swift
//  groceryApp
//
//  Created by youssef on 4/11/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class ItemOfOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configaration(item : Item){
        nameLb.text = item.name
        countLbl.text = "\(item.count ?? 0)"
    }
    
}
