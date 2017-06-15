//
//  BWCell.swift
//  Raman
//
//  Created by Denis Ricard on 2016-05-27.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class BWCell: UITableViewCell {
    
    @objc static let reuseIdentifier: String? = "cellBW"
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var exponentLabel: UILabel!
    @IBOutlet weak var dataImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the look with theme
        backgroundColor = Theme.color(for: .foreground, with: .darkMode)
        valueLabel.font = Theme.Fonts.titleFont.font
        valueLabel.textColor = Theme.color(for: .cellTextColor, with: .darkMode)
        dataLabel.font = Theme.Fonts.detailTextFont.font
        dataLabel.textColor = Theme.color(for: .cellTextColor, with: .darkMode)
        unitsLabel.textColor = Theme.color(for: .cellTextColor, with: .darkMode)
        unitsLabel.font = Theme.Fonts.detailTextFont.font
        exponentLabel.textColor = Theme.color(for: .cellTextColor, with: .darkMode)
        exponentLabel.font = Theme.Fonts.detailTextFont.font
        
        // make the separator go all the way to the left edge
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
    }
    

}
