//
//  FinishController.swift
//  NotYourBusiness
//
//  Created by Martin Tsenov [sc14mtt] on 26/04/2018.
//  Copyright © 2018 Martin Tsenov [sc14mtt]. All rights reserved.
//

import UIKit

class FinishController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var transBrainEnd: UIImageView!
    @IBOutlet weak var transBrain: UIImageView!
    @IBOutlet weak var restartButton: UIButton!
    
    @IBAction func restartAction(_ sender: UIButton) {
        let file = "levelState.txt" //this is the file. we will write to and read from it
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            do{
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("FILE TO BE DELETED - NOT FOUND")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restartButton.alpha = 0
        transBrainEnd.alpha = 0

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateScreen()
    }

    func animateScreen(){
        UIView.animate(withDuration: 5, animations: {
            self.backgroundView.backgroundColor = UIColor.white
            self.transBrain.alpha = 0
            self.transBrainEnd.alpha = 1
        }) { (true) in
            self.showRestart()
        }

    }
    
    func showRestart(){
        UIView.animate(withDuration: 1, animations : {
            self.restartButton.alpha = 1
        })
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
