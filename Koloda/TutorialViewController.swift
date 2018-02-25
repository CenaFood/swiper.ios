//
//  TutorialViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 19.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop
import TransitionButton
import Kingfisher
import CoreLocation
import CloudKit
import Instructions

private let numberOfStartingCards: Int = 10
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


class TutorialViewController: CustomTransitionViewController {
    var userID: String = ""
    
    
    @IBOutlet weak var kolodaView: KolodaView!
    var coachMarksController = CoachMarksController()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        
        
        // so that you cannot drag the picture over the edge of the view (e.g. over the buttons below or the title above
        kolodaView.clipsToBounds = true
        //print("We have \(dataSource.count) number of images")
        
        
        // add images to array
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.coachMarksController.start(on: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
    
    
    //MARK: IBActions
    @IBAction func dislikeButtonTapped() {
        //updateAnnotation(index: kolodaView.currentCardIndex, answer: "No")
        kolodaView?.swipe(.left)
        //print("I am at index \(kolodaView.currentCardIndex)")
    }
    
    @IBAction func likeButtonTapped() {
        //updateAnnotation(index: kolodaView.currentCardIndex, answer: "Yes")
        kolodaView?.swipe(.right)
        //print("I am at index \(kolodaView.currentCardIndex)")
    }
    
    @IBAction func noFoodButtonTapped() {
        //updateAnnotation(index: kolodaView.currentCardIndex, answer: "Yes")
        kolodaView?.swipe(.up)
        //print("I am at index \(kolodaView.currentCardIndex)")
    }
}


//MARK: KolodaViewDelegate
extension TutorialViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up]
    }
    
}

// MARK: KolodaViewDataSource
extension TutorialViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return numberOfStartingCards
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view: UIImageView = UIImageView()
        view.image = UIImage(named: "startMeal1")
        view.contentMode = .scaleAspectFill // TODO: Check if this is necessary with the 1:1 aspect ratio constraint
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

extension TutorialViewController: CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = "This here is the swiping area."
        coachViews.bodyView.nextLabel.text = "Try it"
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: self.kolodaView)
    }


    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
}

extension TutorialViewController: CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willShow coachMark: inout CoachMark,
                              afterSizeTransition: Bool, at index: Int) {
        if index == 0 && !afterSizeTransition {
            // We'll need to play an animation before showing up the coach mark.
            // To be able to play the animation and then show the coach mark and not stall
            // the UI (i. e. keep the asynchronicity), we'll pause the controller.
            coachMarksController.flow.pause()
            
            // Then we run the animation.
            
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.kolodaView.swipe(.right)
            }, completion: { (finished: Bool) -> Void in
                
                // Once the animation is completed, we update the coach mark,
                // and start the display again.
                coachMarksController.helper.updateCurrentCoachMark(usingView: self.kolodaView, pointOfInterest: nil) {
                    (frame: CGRect) -> UIBezierPath in
                    return UIBezierPath(ovalIn: frame.insetBy(dx: -4, dy: -4))
                }
                
                coachMarksController.flow.resume()
            })
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willHide coachMark: CoachMark, at index: Int) {
        if index == 1 {
            UIView.animate(withDuration: 1, animations: { () -> Void in
            })
        }
}
}


