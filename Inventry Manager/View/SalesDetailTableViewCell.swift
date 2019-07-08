//
//  SalesDetailTableViewCell.swift
//  Inventry Manager
//
//  Created by Kashif Rizwan on 7/8/19.
//  Copyright © 2019 Kashif Rizwan. All rights reserved.
//

import UIKit

class SalesDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeLocation: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var saleVolume: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
