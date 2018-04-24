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
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isHackButton: Bool = true

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Drawing code
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
    }
    
}
