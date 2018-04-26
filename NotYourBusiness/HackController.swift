//
//  HackController.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 20/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

/**
 Controller class defining the behaviour of the Hack screen attached to the Map View. Utilises AnimatedBarView.swift, IndicateLabel.swift and PushButton.swift()
 This class has the following functions:
 - activateLevel(Int) -> Void
 - clearLevel(Bool) -> Void
 - setIndicate(Int, Bool) -> Void
 - showAnimate() -> Void
 - pushButtonPressed(PushButton) -> Void
 - back(Any) -> Void
 */
class HackController: UIViewController {
    
    // Linked interface variables
    @IBOutlet weak var animateBar: AnimatedBarView!
    @IBOutlet weak var hackButton: PushButton!
    @IBOutlet weak var cancelButton: PushButton!
    @IBOutlet weak var indicate1: IndicateLabel!
    @IBOutlet weak var indicate2: IndicateLabel!
    @IBOutlet weak var indicate3: IndicateLabel!
    @IBOutlet weak var thisBG: HackBackground!
    
    // Preset class variables
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
    
    
    /**
     Overrides viewDidLoad(): draws background bar and highlight region of animateBar. Also calls activateLevel()
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        thisBG.startBackground()
        animateBar.drawBG()
        animateBar.drawHighlight()
        activateLevel(pointerSpeed: difficultyLevel)
    }
    
    
    /**
     Creates a set of components (timer, pointer, pointer direction) according to the current level and resets the class variables for a new level.
     - argument pointerSpeed: Int to pass to drawing the highlight region. Currently commented out due to weird... bugs?
     */
    func activateLevel(pointerSpeed: Int)
    {
        // (P)reset values for pointer
        pointerPosition = 0.0
        toptobottom = 1.0
        totalTime = 4.0 - Double(pointerSpeed)
        
        let totalIncrements: Double = totalTime * 10    // Number of steps
        positionIncrement = 1.0/totalIncrements         // Increment fraction
        
        animateBar.drawPointer()
        
        tickTimer = Timer.scheduledTimer(               // Init timer
            timeInterval: totalTime/totalIncrements,
            target: self,
            selector: #selector(self.showAnimate),  // calls showAnimate per tick
            userInfo: nil,
            repeats: true)
        
        //animateBar.pointerLayer.opacity = 1.0
        
        //animateBar.drawHighlight()//diffIn: CGFloat(pointerSpeed))
    }
    
    
    /**
     Function to clear current pointer and stop timer. If clearAll is true, also clears highlight region
     */
    func clearLevel(clearAll: Bool)
    {
        print("clearing level")
        //animateBar.pointerLayer.opacity = 0.0
        animateBar.pointerLayer.removeFromSuperlayer()
        tickTimer.invalidate()
        if clearAll
        {
            animateBar.highlightLayer.removeFromSuperlayer()
            thisBG.stopBackground()
        }
    }
    
    
    /**
     Function to send a success state to the specific level indicator. Calls done() method of indicator to display relevant animation depending on sucess state.
     - argument indicator: Int representation of the indicator to be used in an if statement. Could've probaby used a pointer here but eh.
     - argument successIn: Bool representation of the success state.
     */
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
    
    
    /**
     Called each time the pointer timer ticks: calculates next position of the pointer and sets it.
     */
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
        // Set the calculated pointer position
        animateBar.animate = pointerPosition
    }
    
    
    /**
     Logic for when the Hack button is pressed: calculates whether pointer is in the highlight region, then tells relevant indicator the result and resets/sets the level depending on whether the user is successful. Clears whole level and calls back() if it is the last level.
     */
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
                // Delay for 1.5 seconds to show result -> same level
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
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     Overrides prepare(). Sends self.filterToSet to MapController
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        // Set filter of map view
        let vc = segue.destination as! MapController
        vc.currentFilter = self.filterToSet
    }
    
    
    /**
     Perform unwinding segue to map screen
     */
    func back(_ sender: Any)
    {
        self.performSegue(withIdentifier: "MapSegue", sender: self)
    }

}
