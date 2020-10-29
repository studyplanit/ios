//
//  CalendarTableViewCell.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    // MARK:- Properties
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
