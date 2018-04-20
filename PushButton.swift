//
//  PushButton.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 20/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

@IBDesignable
class PushButton: UIButton
{
    
    private struct Constants
    {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat
    {
        return bounds.size.width / 2
    }
    
    private var halfHeight: CGFloat
    {
        return bounds.size.height / 2
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Drawing code
        let path = UIBezierPath(ovalIn: rect)
        UIColor.blue.setFill()
        path.fill()
    
        let plusWidth: CGFloat = min(bounds.size.width, bounds.size.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        let plusPath = UIBezierPath()
        
        plusPath.lineWidth = Constants.plusLineWidth
        plusPath.move(to: CGPoint (x: halfWidth-halfPlusWidth, y: halfHeight))
        plusPath.addLine(to: CGPoint (x: halfWidth+halfPlusWidth, y:halfHeight))
        UIColor.white.setStroke()
        
        plusPath.stroke()
        
    }
    
}
