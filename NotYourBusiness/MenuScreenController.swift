//
//  MenuScreenController.swift
//  NotYourBusiness
//
//  Created by Panagiotis Penloglou [sc14pp] on 28/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

class MenuScreenController: UIViewController {

    @IBOutlet weak var movingLettersView: HackBackground!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movingLettersView.startBackground()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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

}
