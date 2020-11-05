//
//  ChallengeContentTableViewCell.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit

class ChallengeContentTableViewCell: UITableViewCell {
    
    // MARK:- Properties
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        barView.layer.cornerRadius = 0.5 * barView.bounds.size.height
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
