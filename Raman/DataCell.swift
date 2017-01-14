//
//  DataCell.swift
//  Raman
//
//  Created by Denis Ricard on 2016-05-27.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {
    
    static let reuseIdentifier = "cell"
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the look with theme
        backgroundColor = Theme.Colors.foreground.color
        valueLabel.font = Theme.Fonts.titleFont.font
        valueLabel.textColor = Theme.Colors.lightTextColor.color
        dataLabel.font = Theme.Fonts.detailTextFont.font
        
        dataLabel.textColor = Theme.Colors.lightTextColor.color

        // make the separator go all the way to the left edge
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        
        
    }
}
