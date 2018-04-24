//
//  HackController.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 20/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

class HackController: UIViewController {
    
    @IBOutlet weak var animateBar: AnimatedBarView!
    @IBOutlet weak var hackButton: PushButton!
    @IBOutlet weak var cancelButton: PushButton!
    @IBOutlet weak var indicate1: IndicateLabel!
    @IBOutlet weak var indicate2: IndicateLabel!
    @IBOutlet weak var indicate3: IndicateLabel!
    
    var filterToSet: Int = 0
    var tickTimer: Timer!                   // Overall Timer
    var pointerPosition: Double = 0         // Start position, default 0
    var positionIncrement: Double = 1       // Increment of position: default 1
    var toptobottom: Double = 1.0            // Direction of animation "bool"
    var totalTime: Double = 3.0             // Total time to get across
    var progress: Int = 1
    
    
    // On difficulty variable change, reset level, maximum of 3
    var difficultyLevel: Int = 1
    {
        didSet
        {
            self.clearLevel(clearAll: false)
            self.pointerPosition = 0
            self.activateLevel(pointerSpeed: self.difficultyLevel)
            //animateBar.setNeedsDisplay()
        }
    }
    
    
    // Create a new pointer and highlight region
    func activateLevel(pointerSpeed: Int)
    {
        // (P)reset values for pointer
        pointerPosition = 0.0
        toptobottom = 1.0
        totalTime = 4.0 - Double(pointerSpeed)
        
        let totalIncrements: Double = totalTime * 10    // Number of steps
        positionIncrement = 1.0/totalIncrements         // Increment fraction
        
        tickTimer = Timer.scheduledTimer(               // Init timer
            timeInterval: totalTime/totalIncrements,
            target: self,
            selector: #selector(self.showAnimate),  // calls showAnimate per tick
            userInfo: nil,
            repeats: true)
        
        //animateBar.drawHighlight()//diffIn: CGFloat(pointerSpeed))
        animateBar.drawPointer()
    }
    
    
    // Clear current pointer and highlight region, stops timer
    func clearLevel(clearAll: Bool)
    {
        print("clearing level")
        animateBar.pointerLayer.removeFromSuperlayer()
        if clearAll
        {
            tickTimer.invalidate()
            animateBar.highlightLayer.removeFromSuperlayer()
        }
    }
    
    
    // On screen load
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        animateBar.drawBG()
        animateBar.drawHighlight()
        activateLevel(pointerSpeed: difficultyLevel)
        
    }
    
    
    // Stops each indicator and sets as the following string
    func setIndicate(indicator: Int, successIn: Bool)
    {
        if indicator==1
        {
            indicate1.done(inString: "1", success: successIn)
        }
        if indicator==2
        {
            indicate2.done(inString: "2", success: successIn)
        }
        if indicator==3
        {
            indicate3.done(inString: "3", success: successIn)
        }
    }
    
    
    // Animation calculation for the black bar position
    @objc func showAnimate()
    {
        if (toptobottom == 1)
        {   if (pointerPosition < 1.0)
            {   pointerPosition += positionIncrement}
            else
            {   pointerPosition -= positionIncrement
                toptobottom = -1 }
        }
        else
        {   if (pointerPosition <= 0.0005)          // Not 0 due to Swift rounding error
            {   pointerPosition += positionIncrement
                toptobottom = 1 }
            else
            {   pointerPosition -= positionIncrement }
        }
        animateBar.animate = pointerPosition
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Called when buttons are pressed
    @IBAction func pushButtonPressed(_ button: PushButton)
    {
        // Hack button logic
        if button.isHackButton
        {
            self.tickTimer.invalidate()
            // Logic for whether pointer is in highlighted region
            if (self.pointerPosition < 0.625) && (self.pointerPosition > 0.375)
            {
                self.setIndicate(indicator: self.difficultyLevel, successIn: true)
                // Check if last button (different logic needed)
                if self.difficultyLevel < 3
                {
                    // Delay for 1 second to show result -> next level
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
                    {
                        self.difficultyLevel += 1
                    }
                }
                // If last button, clear whole level
                else
                {
                    tickTimer.invalidate()
                    clearLevel(clearAll: true)
                    self.setIndicate(indicator: self.difficultyLevel, successIn: true)
                    // 2 second delay after all three are done
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                    {
                        self.filterToSet += 1
                        self.back(self)
                    }
                }
            }
            // If fail to get region
            else
            {
                // Trigger indicator button (in false mode)
                self.setIndicate(indicator: self.difficultyLevel, successIn: false)
                // Delay for 1 second to show result -> same level
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
                {
                    // Manually restart level
                    self.pointerPosition = 0
                    self.clearLevel(clearAll: false)
                    self.activateLevel(pointerSpeed: self.difficultyLevel)
                }
            }
        }
        // Cancel button logic
        else
        {
            self.back(self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        // Set filter of map view
        let vc = segue.destination as! MapController
        vc.currentFilter = self.filterToSet
    }
    
    
    // Perform unwinding segue to map screen
    func back(_ sender: Any)
    {
        self.performSegue(withIdentifier: "MapSegue", sender: self)
    }

}
