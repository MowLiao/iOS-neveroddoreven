//
//  IndicateLabel.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 23/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

/**
 A class for indicators to show what level the user is on. Inherits UILabel and is intended to show a single character.
 This class has the following functions:
 - customInit() -> Void
 - jumble() -> Void
 - flash() -> Void
 - done(String, Bool) -> Void
 - fail() -> Void
 */

class IndicateLabel: UILabel {
    
    // Array of characters to jumble() through.
    let letters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)
    var timer: Timer!
    
    
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
    
    
    /**
     Called in override init(). Starts the timer to call jumble() per tick, and sets appearance.
     */
    func customInit()
    {
        // Set own timer which calls jumble() per tick (every 100ms)
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
    
    
    /**
     Each time this function is called, a random letter from letters array is set as the label text.
     */
    @objc func jumble()
    {
        let rand = arc4random_uniform(UInt32(letters.count))
        self.text = String(letters[Int(rand)])
    }
    
    
    /**
     Animation function to make the button flash in transparency.
     */
    func flash()
    {
        // Flashes 3 times, 250 ms each
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.25
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
    }
    
    
    /**
     Sequence of events when the user fails the interaction: Button flashes red once before returning to old colour.
     */
    func fail()
    {
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.backgroundColor = UIColor.red.cgColor
        UIView.animate(withDuration: 0.75, delay:0, options: UIViewAnimationOptions.allowUserInteraction, animations:
            {
                () -> Void in
                self.layer.backgroundColor = #colorLiteral(red: 0, green: 0.3752856255, blue: 0, alpha: 1).cgColor
                self.layer.borderColor = UIColor.green.cgColor
        } )
        
    }
    
    /**
     Sequence of events when the user interacts: changes depending on whether user is successful or not. If user is successful, flashes and set background to be bright green. If user is not successful, flashes before calling fail().
     - argument inString: Final string to be displayed
     - argument success: Bool representation of whether user is successful
     */
    func done(inString: String, success: Bool)
    {
        self.flash()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25)
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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
