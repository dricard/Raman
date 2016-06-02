//
//  BWCell.swift
//  Raman
//
//  Created by Denis Ricard on 2016-05-27.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class BWCell: UITableViewCell {
    
    static let reuseIdentifier: String? = "cellBW"
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the look with theme
        backgroundColor = Theme.Colors.Foreground.color
        valueLabel.font = Theme.Fonts.TitleFont.font
        valueLabel.textColor = Theme.Colors.LightTextColor.color
        dataLabel.font = Theme.Fonts.DetailTextFont.font
        dataLabel.textColor = Theme.Colors.LightTextColor.color
        
        // make the separator go all the way to the left edge
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        
    }
    

}
