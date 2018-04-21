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
    var timer: Timer!
    var pointerPosition: Float = 0
    let duration: Float = 20
    var positionIncrement: Float = 1
    var leftoright: Int = 1
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        animateBar.drawShape()
        positionIncrement = 1.0/duration
        timer = Timer.scheduledTimer(
            timeInterval: 0.05,
            target: self,
            selector: #selector(self.showAnimate),
            userInfo: nil,
            repeats: true)
        // Do any additional setup after loading the view.
        // counterLabel.text = String(counterView.counter)
    }
    
    @objc func showAnimate()
    {
        if (leftoright == 1)
        {   if (pointerPosition < 1.0)
            {   pointerPosition += positionIncrement }
            else
            {   pointerPosition -= positionIncrement
                leftoright = 0 }
        }
        else
        {   if (pointerPosition <= 0)
            {   pointerPosition += positionIncrement
                leftoright = 1 }
            else
            {   pointerPosition -= positionIncrement }
        }

        animateBar.animate = pointerPosition
        //animateBar.setNeedsDisplay()
    }
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    @IBAction func pushButtonPressed(_ button: PushButton)
//    {
//        if button.isAddButton
//        {
//            counterView.counter += 1
//        }
//        else
//        {
//            if counterView.counter > 0
//            {
//                counterView.counter -= 1
//            }
//        }
//        counterLabel.text = String(counterView.counter)
//    }

}
