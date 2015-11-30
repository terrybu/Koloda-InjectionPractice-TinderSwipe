//
//  ModalViewController.swift
//  Practice-Koloda-Injection
//
//  Created by Terry Bu on 10/20/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

//this was just in case we wanted to pop up a modal instead of doing it a fancy way like we are doing currently in master in MainVC 
class ModalViewController: UIViewController {
    
    @IBAction func closeButtonPress() {
        dismissViewControllerAnimated(false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
