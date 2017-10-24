//
//  CalculatorButton.swift
//  Raman
//
//  Created by Denis Ricard on 2017-07-14.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Could not get context for \(String(describing: self.titleLabel?.text))")
            return }
        context.saveGState()
        // outer border for light theme
        let rect = self.bounds.insetBy(dx: 2, dy: 2)
        let roundedRect: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
        context.addPath(roundedRect)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.setLineWidth(1)
        context.closePath()
        context.strokePath()
        // inner border for dark theme
        let rect2 = self.bounds.insetBy(dx: 3, dy: 3)
        let roundedRect2: CGPath = UIBezierPath(roundedRect: rect2, cornerRadius: 6).cgPath
        context.addPath(roundedRect2)
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1)
        context.closePath()
        context.strokePath()
        context.restoreGState()
    }
}

