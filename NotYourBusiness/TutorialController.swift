//
//  TutorialController.swift
//  NotYourBusiness
//
//  Created by Panagiotis Penloglou [sc14pp] on 21/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

class TutorialController: UIViewController {

    @IBOutlet weak var storyPt1TextView: UITextView!
    @IBOutlet weak var storyPt2TextView: UITextView!
    @IBOutlet weak var storyPt3TextView: UITextView!
    @IBOutlet weak var missionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyPt1TextView.alpha = 0
        storyPt2TextView.alpha = 0
        storyPt3TextView.alpha = 0
        missionTextView.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showStoryPt1()
    }
    
    func showStoryPt1() {
        UIView.animate(withDuration: 2, animations: {
            self.storyPt1TextView.alpha = 1
        }) { (true) in
            self.showStoryPt2()
        }
    }
    
    func showStoryPt2(){
        UIView.animate(withDuration: 2, animations: {
            self.storyPt2TextView.alpha = 1
        }) { (true) in
            self.showStoryPt3()
        }
    }
    
    
    func showStoryPt3(){
        UIView.animate(withDuration: 2, animations: {
            self.storyPt3TextView.alpha = 1
        }) { (true) in
            self.showMission()
        }
    }
    
    func showMission(){
        UIView.animate(withDuration: 1) {
            self.missionTextView.alpha = 1
        }
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
