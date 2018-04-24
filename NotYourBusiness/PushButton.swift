//
//  PushButton.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 20/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

/**
 Custom UIButton to create a round button, using the draw method. There're other methods of doing this, but I figured it'd be nice to experiment with the draw method.
 */

@IBDesignable
class PushButton: UIButton
{
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isHackButton: Bool = true

    // Creates a round button
    override func draw(_ rect: CGRect)
    {
        // Drawing code
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
    }
    
}
