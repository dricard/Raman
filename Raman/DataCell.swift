//
//  DataCell.swift
//  Raman
//
//  Created by Denis Ricard on 2016-05-27.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {
    
    static let reuseIdentifier: String? = "cell"
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataImage: UIImage!
    @IBOutlet weak var dataUnitsLabel: UILabel!
    @IBOutlet weak var dataUnitsExponent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the look with theme
        
        
    }
}
