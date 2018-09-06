//
//  OpenLoansTableViewCell.swift
//  eCash
//
//  Created by Terence Williams on 8/13/18.
//  Copyright © 2018 Terence Williams. All rights reserved.
//

import UIKit

class OpenLoansTableViewCell: UITableViewCell {

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var loanType: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var principleBalance: UILabel!
    @IBOutlet weak var amountDue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
