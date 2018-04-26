//
//  HackBackground.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 26/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

/**
 Custom UIView class to show the background: creates a set of labels (depending on screen width) every 1.5 seconds in random positions. Custom label class is at the bottom of this code.
 This class has the following functions:
 - startBackground() -> Void
 - createLabel() -> Void
 */

class HackBackground: UIView
{

    let labelWidth: CGFloat = 30
    let labelHeight: CGFloat = 30
    
    //private var labels = [backgroundLetters]()
    var backgroundTick: Timer!
    var numLabels: Int = 0
    var numHeight: Int = 0
    //let letters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)
    let letters: CharacterSet = CharacterSet.newlines.inverted
    
    
    /**
     Calculates spawn positions for labels, calls an initial set of labels, then initialises a timers to spawn labels every 1.5 seconds
     */
    func startBackground()
    {
        // Calculates number of horizontal and vertical label spawn spaces
        self.numLabels = Int(bounds.width) / Int(self.labelWidth)
        self.numHeight = Int(bounds.height) / Int(self.labelHeight)
        // Create the first set of labels
        self.createLabel()
        
        // Timer for label spawning
        self.backgroundTick = Timer.scheduledTimer(
            timeInterval:0.5,
            target:self,
            selector: #selector(self.createLabel),
            userInfo: nil,
            repeats: true )
    }
    
    
    /**
     Stops backround animation by stopping the timer (and therefore its triggered actions).
     */
    func stopBackground()
    {
        self.backgroundTick.invalidate()
    }
    
    
    /**
     Handles creation of a set of labels and their deletion after 2.5 seconds
     */
    @objc func createLabel()
    {
        // Initialise empty array of backgroundLetters: set as optional to allow nil later
        var labels = [backgroundLetters?]()
        // Iterate through all x spawn points and create label at random y
        for i in 1 ... numLabels
        {
            var label: UILabel?
            // Calculate random Y
            let randY = arc4random_uniform(UInt32(self.numHeight))
            // Create label at width and height
            label = backgroundLetters(frame: CGRect(x: 0, y:0, width: self.labelWidth, height: self.labelHeight))
            // Place label at x and y
            label?.center = CGPoint(x:Int(self.labelWidth) * i, y:Int(Int(randY)*Int(self.labelHeight)))
            // Show label
            self.addSubview(label!)
            // Add to array
            labels.append(label as? backgroundLetters)
        }
        
        // After 2.5 seconds (after animation is done), clear all labels from view and set to nil to prevent memory usage
        DispatchQueue.main.asyncAfter(deadline: .now() + CFTimeInterval(2.5))
        {
            for i in 0 ..< labels.count
            {
                labels[i]?.removeFromSuperview()
                labels[i]?.stop()
                labels[i] = nil
            }
        }
    }
}



/**
 A custom UILabel class to create the background effect of random jumbling letters slowly moving down the background.
 This class has the followin functions:
 - customInit() -> Void
 - fade() -> Void
 - jumble() -> Void
 - move() -> Void
 */
class backgroundLetters: UILabel
{
    // Array of characters to jumble() through.
    let letters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)
    let colour: UIColor = #colorLiteral(red: 0.2897774279, green: 0.5621102452, blue: 0.3008053303, alpha: 1)
    var yPos: CGFloat = 0.0
    var jumbleTimer: Timer!
    var moveTimer: Timer!
    
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
     Called in override init(). Starts two timers: to call jumble() per tick, and to call move() per tick. Also sets appearance and calls fade() on create.
     */
    func customInit()
    {
        //print("creating label")
        let rand = arc4random_uniform(UInt32(letters.count))
        self.text = String(letters[Int(rand)])
        self.textColor = self.colour
        self.font = UIFont.preferredFont(forTextStyle: .footnote)
        self.textAlignment = .center
        // Start off with opacity 0
        self.alpha = 0.0
        self.fade()
        // Set own timer which calls jumble() per tick (every 100ms)
        jumbleTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(self.jumble),
            userInfo: nil,
            repeats: true )
        
        moveTimer = Timer.scheduledTimer(
            timeInterval: 0.05,
            target: self,
            selector: #selector(self.move),
            userInfo: nil,
            repeats: true )
    }
    
    
    /**
     Animation function to make the label slowly appear + disappear.
     */
    private func fade()
    {
        let duration: CGFloat = 0.5
        
        // Fades in and fades out
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.duration = CFTimeInterval(duration)
        fade.fromValue = 0.0
        fade.toValue = 1.0
        fade.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        fade.autoreverses = true
        fade.repeatCount = 1
        layer.add(fade, forKey: nil)
    }
    
    
    /**
     Called by view to stop timers and reduce memory load
     */
    func stop()
    {
        jumbleTimer.invalidate()
        moveTimer.invalidate()
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
     Moves label down by one point each time this is called
     */
    @objc func move()
    {
        yPos+=2.0
        self.transform = CGAffineTransform.init(translationX: 0, y: yPos)
    }
}
