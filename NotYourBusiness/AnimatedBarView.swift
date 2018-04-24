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
    var bgColor: UIColor = UIColor(red: 0, green: 0.698, blue: 0, alpha: 1.0)
    
    var BGWidth: CGFloat = 60
    var padding: CGFloat = 10
    var pointerWidth: CGFloat = 5
    var progressPercent: CGFloat = 0
    var pointerPad: CGFloat = 5
    var totalHeight: CGFloat = 0
    
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
        let startY = CGFloat(0.0) + padding
        let endX = bounds.width/2
        let endY = bounds.height - padding
        totalHeight = endY - startY
        
        bgPath.move(to: CGPoint(x: startX, y: startY))
        bgPath.addLine(to: CGPoint(x: endX, y: endY))
        
        //bgPath.close()
    }
    
    func drawBG()
    {
        createBgPath()
        
        bgLayer.path = bgPath.cgPath
        bgLayer.lineWidth = BGWidth
        bgLayer.fillColor = nil
        bgLayer.strokeColor = bgColor.cgColor
        
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
        highlightLayer.lineWidth = BGWidth - pointerPad
        highlightLayer.fillColor = UIColor.green.cgColor
        highlightLayer.strokeColor = UIColor.green.cgColor
        
        self.layer.addSublayer(highlightLayer)
    }
    
    
    // POINTER CODE
    private func createPointerPath()//xIn: CGFloat)
    {
        let startX = (bounds.width/2)
        let startY = CGFloat(0.0) + padding
        let endX = startX
        let endY = startY + pointerWidth
        
        pointerPath.move(to: CGPoint(x: startX, y: startY))
        pointerPath.addLine(to: CGPoint(x: endX, y: endY))
    }
    
    func drawPointer()
    {
        createPointerPath()//xIn: CGFloat(0.3))
        
        pointerLayer.path = pointerPath.cgPath
        pointerLayer.lineWidth = BGWidth - pointerPad
        pointerLayer.fillColor = nil
        pointerLayer.strokeColor = #colorLiteral(red: 0.1980366409, green: 0.1980422437, blue: 0.1980392635, alpha: 1).cgColor
        
        self.layer.addSublayer(pointerLayer)
    }
    
    var animate: Double = 0
    {
        willSet(yTranslate)
        {
            pointerYTrans = CGFloat(yTranslate) * (totalHeight - 2*padding)
            pointerLayer.transform = CATransform3DMakeTranslation(0, pointerYTrans, 0)
            //print("Translating by:", yTranslate, pointerYTrans)
        }
    }
    
    
//    override func draw(_ rect:CGRect)
//    {
//    }

    
}
