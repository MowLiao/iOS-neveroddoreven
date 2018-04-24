//
//  IndicateLabel.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 23/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

class IndicateLabel: UILabel {

    let letters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.customInit()
    }
    
    override init (frame: CGRect)
    {
        super.init(frame: frame)
        self.customInit()
    }
    
    var timer: Timer!
    
    func customInit()
    {
        // Set own timer
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(self.jumble),
            userInfo: nil,
            repeats: true )
        // Set own appearance
        self.layer.backgroundColor = #colorLiteral(red: 0, green: 0.3752856255, blue: 0, alpha: 1).cgColor
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.green.cgColor
    }
    
    @objc func jumble()
    {
        let rand = arc4random_uniform(UInt32(letters.count))
        self.text = String(letters[Int(rand)])
    }
    
    // Flash function when Hack button is pressed
    func flash()
    {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.25
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
    }
    
    // Animation for whether user succeeded or not
    func done(inString: String, success: Bool)
    {
        self.flash()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            if success
            {
                self.timer.invalidate()
                self.backgroundColor = UIColor.green
                self.text = inString
            }
            else
            {
                self.fail()
            }
        }
    }
    
    func fail()
    {
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.backgroundColor = UIColor.red.cgColor
        UIView.animate(withDuration: 0.5, delay:0, options: UIViewAnimationOptions.allowUserInteraction, animations:
            {
                () -> Void in
                self.layer.backgroundColor = #colorLiteral(red: 0, green: 0.3752856255, blue: 0, alpha: 1).cgColor
                self.layer.borderColor = UIColor.green.cgColor
            } )
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
