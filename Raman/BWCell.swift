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
    
    @IBOutlet weak var leftDataAvailableImageView: UIImageView!
    @IBOutlet weak var rightDataAvailableImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the look with theme
        
        valueLabel.font = Theme.Fonts.titleFont.font
        dataLabel.font = Theme.Fonts.detailTextFont.font
        unitsLabel.font = Theme.Fonts.detailTextFont.font
        exponentLabel.font = Theme.Fonts.detailTextFont.font
        
        // make the separator go all the way to the left edge
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
    }
    

}
