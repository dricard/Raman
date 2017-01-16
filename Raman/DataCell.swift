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
    @IBOutlet weak var dataImageView: UIImageView!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var exponentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the look with theme
        backgroundColor = Theme.Colors.foreground.color
        valueLabel.font = Theme.Fonts.titleFont.font
        valueLabel.textColor = Theme.Colors.lightTextColor.color
        dataLabel.font = Theme.Fonts.detailTextFont.font
        unitsLabel.textColor = Theme.Colors.lightTextColor.color
        unitsLabel.font = Theme.Fonts.detailTextFont.font
        exponentsLabel.textColor = Theme.Colors.lightTextColor.color
        exponentsLabel.font = Theme.Fonts.detailTextFont.font
        
        dataLabel.textColor = Theme.Colors.lightTextColor.color

        // make the separator go all the way to the left edge
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
                
    }
}
