//
//  Model.swift
//  Raman
//
//  Created by Denis Ricard on 2016-04-04.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    var spectro = Raman()
    
    static let sharedInstance = Model()
    fileprivate override init() {} // this prevents others from using the default init
}
