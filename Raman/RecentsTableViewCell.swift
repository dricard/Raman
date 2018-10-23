//
//  RecentsTableViewCell.swift
//  Raman
//
//  Created by Denis Ricard on 2018-07-05.
//  Copyright © 2018 Hexaedre. All rights reserved.
//

import UIKit

class RecentsTableViewCell: UITableViewCell {

    // MARK: - properties
    
    @objc static let reuseIdentifier: String? = "RecentsTableViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var exponentLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // customize the look with theme
        valueLabel.font = Theme.Fonts.subTitleFont.font
        unitsLabel.font = Theme.Fonts.detailTextFont.font
        exponentLabel.font = Theme.Fonts.exponentFont.font
        
        // make the separator go all the way to the left edge
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }

}
