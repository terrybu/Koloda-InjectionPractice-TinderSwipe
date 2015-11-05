//
//  MainViewController.swift
//  Practice-Koloda-Injection
//
//  Created by Terry Bu on 10/20/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit
import Koloda
import pop

private var numberOfCards: UInt = 5

class MainViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate  {

    @IBOutlet weak var kolodaView: KolodaView!
    var imageNamesArray: [String] = ["pestoPasta", "burger", "wineTasting", "dragonRoll", "billGates", "jdFace"]
    
    var expandedClick: Bool = false
    var originalFrame: CGRect?
    var originalCardFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    //MARK: KolodaViewDataSource
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return numberOfCards
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        if Int(index) <= imageNamesArray.count {
            return UIImageView(image: UIImage(named: imageNamesArray[Int(index)]))
        } else {
            return UIImageView(image: UIImage(named: "dragonRoll"))
        }
    }
    
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
            owner: self, options: nil)[0] as? CustomOverlayView
    }
    
    //MARK: KolodaViewDelegate
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        //Example: loading more cards
        if index >= 3 {
            numberOfCards = 6
            kolodaView.reloadData()
        }
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
        kolodaView.resetCurrentCardNumber()
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        print("card tapped at index \(index)")
//        
//        let modalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalVC")
//        presentViewController(modalVC, animated: true, completion: nil)
        
        
        if expandedClick == false {
            originalFrame = self.kolodaView.frame
            originalCardFrame = self.kolodaView.viewForCardAtIndex(0)!.frame
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.kolodaView.frame = CGRectMake(0, 0, self.view.frame.width, self.kolodaView.frame.height)
                self.kolodaView.viewForCardAtIndex(0)!.frame = CGRectMake(0, 0, self.view.frame.width, self.kolodaView.frame.height)
                
                }) { (finished) -> Void in
                    //finish
                    self.expandedClick = true
            }
        } else if expandedClick == true{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.kolodaView.frame = self.originalFrame!
                self.kolodaView.viewForCardAtIndex(0)!.frame = self.originalCardFrame!
                }) { (finished) -> Void in
                    self.expandedClick = false
            }
        }
    
        
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
        return nil
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

