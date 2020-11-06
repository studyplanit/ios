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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var planColorBarView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayLabelView: UIView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var successLabelView: UIView!

    // MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK:- Configure
extension CalendarTableViewCell {
    
    func configureUI() {
        dayLabelView.layer.cornerRadius = 0.5 * dayLabelView.bounds.size.height
        successLabelView.layer.cornerRadius = 0.5 * successLabelView.bounds.size.height
    }
    
}
