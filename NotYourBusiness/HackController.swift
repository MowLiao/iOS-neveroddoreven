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
    
    // On difficulty variable change, maximum of 3
    var difficultyLevel: Int = 1
    {
        didSet
        {
            clearLevel()
            activateLevel(pointerSpeed: difficultyLevel)
            setIndicate(indicator: difficultyLevel-1)
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
        
        animateBar.drawHighlight(diffIn: CGFloat(pointerSpeed))
        animateBar.drawPointer()
    }
    
    
    // Clear current pointer and highlight region, stops timer
    func clearLevel()
    {
        tickTimer.invalidate()
        animateBar.pointerLayer.removeFromSuperlayer()
        animateBar.highlightLayer.removeFromSuperlayer()
    }
    
    
    // On screen load
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        indicate1.layer.borderWidth = 2
        indicate1.layer.borderColor = UIColor.green.cgColor
        indicate2.layer.borderWidth = 2
        indicate2.layer.borderColor = UIColor.green.cgColor
        indicate3.layer.borderWidth = 2
        indicate3.layer.borderColor = UIColor.green.cgColor
        
        animateBar.drawBG()
        activateLevel(pointerSpeed: difficultyLevel)
        
        // counterLabel.text = String(counterView.counter)
    }
    
    
    // Stops each indicator and sets as the following string
    func setIndicate(indicator: Int)
    {
        if indicator==1
        {
            indicate1.done(inString: "1")
        }
        if indicator==2
        {
            indicate2.done(inString: "2")
        }
        if indicator==3
        {
            indicate3.done(inString: "3")
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
        {   if (pointerPosition <= 0.0005)
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
        if button.isHackButton
        {
            if difficultyLevel < 3
            {
                difficultyLevel += 1
                print("clearing level")
            }
            else
            {
                tickTimer.invalidate()
                clearLevel()
                setIndicate(indicator: 3)
                // 3 second delay after all three are done
                DispatchQueue.main.asyncAfter(deadline: .now() + 3)
                {
                    self.filterToSet += 1
                    self.back(self)
                }
            }
        }
        else
        {
            self.back(self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        let vc = segue.destination as! MapController
        vc.currentFilter = self.filterToSet
    }
    
    
    func back(_ sender: Any)
    {
        self.performSegue(withIdentifier: "MapSegue", sender: self)
    }

}
