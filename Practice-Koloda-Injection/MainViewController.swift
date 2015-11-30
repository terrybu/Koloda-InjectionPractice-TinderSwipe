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
private let frameAnimationSpringBounciness:CGFloat = 9
private let frameAnimationSpringSpeed:CGFloat = 16

class MainViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate  {

    @IBOutlet weak var kolodaView: KolodaView!
    var imageNamesArray: [String] = ["pestoPasta", "burger", "wineTasting", "dragonRoll", "billGates", "jdFace"]
    
    var draggableCardIsExpanded: Bool = false
    var originalFrame: CGRect?
    var originalCardFrame: CGRect?
    var bottomUpView: UIView?
    var closeXButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        bottomUpView = UIView(frame:CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-self.kolodaView.frame.height))
        bottomUpView!.frame = CGRectOffset(bottomUpView!.frame, 0, view.frame.height)
        bottomUpView!.backgroundColor = UIColor.whiteColor()
        
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        textView.text = "Harpo's Bar & Grill \n\n Served during lunch & dinner \n\n 4 oz lean beef burger topped with avocado, onions, tomato and cheese \n\n $9.50"
        textView.font = UIFont.systemFontOfSize(15.0)
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRect(x: 0, y: 100, width: 100, height: 30)
        bottomUpView?.addSubview(textView)
        
        let closeXButtonImage = UIImage(named: "close")
        closeXButton = UIButton(type: UIButtonType.System)
        closeXButton.setBackgroundImage(closeXButtonImage, forState: UIControlState.Normal)
        closeXButton.frame.origin = CGPoint(x: 10, y: 20)
        closeXButton.frame.size = CGSize(width: 30, height: 30)
        kolodaView.addSubview(closeXButton)
        closeXButton.alpha = 0.0
        closeXButton.addTarget(self, action: "collapseExpandedCardView", forControlEvents: UIControlEvents.TouchUpInside)
        
        let locationIconImage = UIImage(named:"locationIcon")
        let locationButton = UIButton(type: UIButtonType.System)
        locationButton.setImage(locationIconImage, forState: UIControlState.Normal)
        locationButton.frame.size = CGSize(width: 50,height: 50)
        locationButton.frame.origin = CGPoint(x: view.frame.width/2-25, y: 200)
        locationButton.addTarget(self, action: "locationIconButtonWasPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        let phoneButtonImage = UIImage(named:"phoneIcon")
        let phoneButton = UIButton(type: UIButtonType.System)
        phoneButton.setBackgroundImage(phoneButtonImage, forState: UIControlState.Normal)
        phoneButton.frame.size = CGSize(width: 50,height: 50)
        phoneButton.frame.origin = CGPoint(x: locationButton.frame.origin.x-100, y: locationButton.frame.origin.y)
        
        let menuButtonImage = UIImage(named:"menuIcon")
        let menuButton = UIButton(type: UIButtonType.System)
        menuButton.setBackgroundImage(menuButtonImage, forState: UIControlState.Normal)
        menuButton.frame.size = CGSize(width: 50,height: 50)
        menuButton.frame.origin = CGPoint(x: locationButton.frame.origin.x+100, y: locationButton.frame.origin.y)
        
        bottomUpView?.addSubview(locationButton)
        bottomUpView?.addSubview(phoneButton)
        bottomUpView?.addSubview(menuButton)

        view.addSubview(bottomUpView!)
    }
    
    @objc
    private func locationIconButtonWasPressed() {
        print("location button press")
        let modalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalVC")
        presentViewController(modalVC, animated: true, completion: nil)
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
        if draggableCardIsExpanded == false {
            originalFrame = kolodaView.frame
            originalCardFrame = kolodaView.viewForCardAtIndex(kolodaView.currentCardNumber)!.frame
            self.showExpandedCardViewUponCardTap()
        } else if draggableCardIsExpanded == true{
            self.collapseExpandedCardView()
        }
    }
    
    private func showExpandedCardViewUponCardTap() {
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.kolodaView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.width)
            self.kolodaView.viewForCardAtIndex(self.kolodaView.currentCardNumber)!.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.width)
            self.bottomUpView!.frame = CGRectMake(0, self.kolodaView.frame.height, self.view.frame.width, self.view.frame.height - self.kolodaView.frame.height)
            self.closeXButton.alpha = 1.0
            }) { (finished) -> Void in
                self.draggableCardIsExpanded = true
                self.kolodaView.disablePanSwipeOnAllCardsForExpandedView()
        }
    }
    @objc
    private func collapseExpandedCardView() {
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.kolodaView.frame = self.originalFrame!
            self.kolodaView.viewForCardAtIndex(self.kolodaView.currentCardNumber)!.frame = self.originalCardFrame!
            self.bottomUpView!.frame = CGRectOffset(self.bottomUpView!.frame, 0, self.view.frame.height - self.kolodaView.frame.height)
            self.closeXButton.alpha = 0.0
            }) { (finished) -> Void in
                self.draggableCardIsExpanded = false
                self.kolodaView.reEnablePanSwipeOnAllCards()
        }
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return false
    }
    

    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

