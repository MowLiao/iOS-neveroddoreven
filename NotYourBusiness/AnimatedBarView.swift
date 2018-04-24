//
//  AnimatedBarView.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 21/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

/**
 Custom UIView class to display a drawn background rectangle with a highlighted region and a pointer/bar that translates across the length of the background rect. Each of these are drawn in the same metho: define a UIBezierPath, convert to CGPath, add as a sublayer to self.layer. The animation of the pointer is done by translating the bar from 0 -> 1, where 0 is the inital point and 1 is the end point.
 This class has the following functions:
 - createBgPath()
 - drawBG()
 - createHighlightPath()
 - drawHighlight()
 - createPointerPath()
 - drawPointer()
 */

//@IBDesignable
class AnimatedBarView: UIView
{
    // Struct of class constants.
    private struct constants
    {
        static let bgColor: UIColor = UIColor(red: 0, green: 0.698, blue: 0, alpha: 1.0)
        static let BGWidth: CGFloat = 60
        static let padding: CGFloat = 10
        static let pointerWidth: CGFloat = 5
        static let pointerPad: CGFloat = 5
    }
    
    // Initialise class variables
    var progressPercent: CGFloat = 0
    var totalHeight: CGFloat = 0
    
    // Drawing variables
    var bgPath = UIBezierPath()
    var bgLayer = CAShapeLayer()
    var pointerPath = UIBezierPath()
    var pointerLayer = CAShapeLayer()
    var highlightPath = UIBezierPath()
    var highlightLayer = CAShapeLayer()
    
    var pointerYTrans: CGFloat = 0
    
    // BACKGROUND CODE
    private func createBgPath()
    {
        let startX = bounds.width/2
        let startY = CGFloat(0.0) + constants.padding
        let endX = bounds.width/2
        let endY = bounds.height - constants.padding
        totalHeight = endY - startY
        
        bgPath.move(to: CGPoint(x: startX, y: startY))
        bgPath.addLine(to: CGPoint(x: endX, y: endY))
    }
   
    func drawBG()
    {
        createBgPath()
        
        bgLayer.path = bgPath.cgPath
        bgLayer.lineWidth = constants.BGWidth
        bgLayer.fillColor = nil
        bgLayer.strokeColor = constants.bgColor.cgColor
        
        self.layer.addSublayer(bgLayer)
    }
    
    
    // HIGHLIGHT CODE
    private func createHighlightPath()//diffIn: CGFloat)
    {
        let diffSection =  totalHeight / 8//(2+diffIn) / 2
        let startX = bounds.width/2
        let startY = (bounds.height/2) - diffSection
        let endX = startX
        let endY = (bounds.height/2) + diffSection
        
        highlightPath.move(to: CGPoint(x: startX, y: startY))
        highlightPath.addLine(to: CGPoint(x: endX, y: endY))
    }
    
    func drawHighlight()//diffIn: CGFloat)
    {
        createHighlightPath()//diffIn: diffIn)
        
        highlightLayer.path = highlightPath.cgPath
        highlightLayer.lineWidth = constants.BGWidth - constants.pointerPad
        highlightLayer.fillColor = UIColor.green.cgColor
        highlightLayer.strokeColor = UIColor.green.cgColor
        
        self.layer.addSublayer(highlightLayer)
    }
    
    
    // POINTER CODE
    private func createPointerPath()//xIn: CGFloat)
    {
        let startX = (bounds.width/2)
        let startY = CGFloat(0.0) + constants.padding
        let endX = startX
        let endY = startY + constants.pointerWidth
        
        pointerPath.move(to: CGPoint(x: startX, y: startY))
        pointerPath.addLine(to: CGPoint(x: endX, y: endY))
    }
    
    func drawPointer()
    {
        createPointerPath()//xIn: CGFloat(0.3))
        
        pointerLayer.path = pointerPath.cgPath
        pointerLayer.lineWidth = constants.BGWidth - constants.pointerPad
        pointerLayer.fillColor = nil
        pointerLayer.strokeColor = #colorLiteral(red: 0.1980366409, green: 0.1980422437, blue: 0.1980392635, alpha: 1).cgColor
        
        self.layer.addSublayer(pointerLayer)
    }
    
    
    var animate: Double = 0
    {
        willSet(yTranslate)
        {
            pointerYTrans = CGFloat(yTranslate) * (totalHeight - 2*constants.padding)
            pointerLayer.transform = CATransform3DMakeTranslation(0, pointerYTrans, 0)
            //print("Translating by:", yTranslate, pointerYTrans)
        }
    }
    
    
//    override func draw(_ rect:CGRect)
//    {
//    }

    
}
