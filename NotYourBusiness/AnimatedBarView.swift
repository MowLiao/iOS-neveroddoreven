//
//  AnimatedBarView.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 21/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

//@IBDesignable
class AnimatedBarView: UIView
{
    
    @IBInspectable var BGHeight: CGFloat = 60
    @IBInspectable var padding: CGFloat = 10
    @IBInspectable var pointerWidth: CGFloat = 5
    @IBInspectable var progressPercent: CGFloat = 0
    @IBInspectable var pointerPad: CGFloat = 5
    
    var bgPath = UIBezierPath()
    var bgLayer = CAShapeLayer()
    
    var pointerPath = UIBezierPath()
    var pointerLayer = CAShapeLayer()
    
    
    private func createBgPath()
    {
        let startX = BGHeight/2
        let startY = bounds.height/2
        let endX = bounds.width
        let endY = bounds.height/2
        
        bgPath.move(to: CGPoint(x: startX, y: startY))
        bgPath.addLine(to: CGPoint(x: endX, y: endY))
        
        //bgPath.close()
    }
    
    private func createPointerPath()//xIn: CGFloat)
    {
        //let totalWidth = bounds.width - (2 * padding) - pointerWidth
        let startX = BGHeight/2
        let startY = bounds.height/2
        let endX = bounds.width
        let endY = bounds.height/2
        
        pointerPath.move(to: CGPoint(x: startX, y: startY))
        pointerPath.addLine(to: CGPoint(x: endX, y: endY))
        
        //pointerPath.close()
    }

    func drawShape()
    {
        createBgPath()
        createPointerPath()//xIn: CGFloat(0.3))
        
        bgLayer.path = bgPath.cgPath
        bgLayer.lineWidth = BGHeight
        bgLayer.fillColor = nil
        bgLayer.strokeColor = UIColor.green.cgColor
        
        pointerLayer.path = pointerPath.cgPath
        pointerLayer.lineWidth = BGHeight - pointerPad
        pointerLayer.fillColor = nil
        pointerLayer.strokeColor = UIColor.black.cgColor
        pointerLayer.strokeStart = 0.0
        pointerLayer.strokeEnd = 0.01
        
        self.layer.addSublayer(bgLayer)
        self.layer.addSublayer(pointerLayer)
    }

    var animate: Float = 0
    {
        willSet(newValue)
        {
            pointerLayer.strokeStart = CGFloat(newValue)
            pointerLayer.strokeEnd = CGFloat(newValue + 0.01)
            print(newValue)
        }
    }
    
    
    //self.thisShape()
    
}
