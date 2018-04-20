//
//  HackController.swift
//  NotYourBusiness
//
//  Created by Melissa Liau [sc14ml] on 20/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

class HackController: UIViewController {
    
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func pushButtonPressed(_ button: PushButton)
    {
        if button.isAddButton
        {
            counterView.counter += 1
        }
        else
        {
            if counterView.counter > 0
            {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
    }

}
