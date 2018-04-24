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
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(self.jumble),
            userInfo: nil,
            repeats: true )
    }
    
    @objc func jumble()
    {
        let rand = arc4random_uniform(UInt32(letters.count))
        self.text = String(letters[Int(rand)])
    }
    
    func done(inString: String)
    {
        timer.invalidate()
        self.backgroundColor = UIColor.green
        self.text = inString
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
