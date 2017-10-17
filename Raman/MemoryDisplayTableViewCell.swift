//
//  MemoryDisplayTableViewCell.swift
//  Raman
//
//  Created by Denis Ricard on 2017-07-21.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

class MemoryDisplayTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var memorySlotLabel: UILabel!
    @IBOutlet weak var memoryValueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 0
        layer.masksToBounds = true
        layer.borderWidth = 0
        isSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
