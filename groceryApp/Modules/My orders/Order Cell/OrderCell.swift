//
//  OrderCell.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var NumberOfItems: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var timeOrderlbl: UILabel!
    @IBOutlet weak var orderStatusBtn: UIButton!
      
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellConfigration(OrderModel item : OrdersModelElement){
        timeOrderlbl.text = item.timeToDeliver
        orderStatus.text = "finished"
        orderName.text = item.name
        NumberOfItems.text = "\(item.items?.count ?? 0) Items"
        orderStatusBtn.setTitle("Shipped", for: .normal)
        orderStatusBtn.backgroundColor = #colorLiteral(red: 0.05824901909, green: 0.3847238421, blue: 0.412258476, alpha: 1)
        orderId.text = "# \(item.id ?? 0)"
    }
    
}
