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

private let numberOfStartingCards: Int = 12
private let numberOfDifferentCards: Int = 3
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


class TutorialViewController: CustomTransitionViewController {
    var userID: String = ""
    fileprivate var startImages: [UIImage] = []
    
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var noFoodButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var coachMarksController = CoachMarksController()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartImages()
        setupStartImages()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        self.coachMarksController.overlay.allowTap = true
        
        
        
        // so that you cannot drag the picture over the edge of the view (e.g. over the buttons below or the title above
        kolodaView.clipsToBounds = true
        setupContinueButton()
        //print("We have \(dataSource.count) number of images")
        
    }
    
    func setupContinueButton() {
        continueButton.layer.cornerRadius = 8
        let size = UIFont.buttonFontSize
        let font = UIFont.systemFont(ofSize: size)
        continueButton.titleLabel?.font = font
    }
    
    func setupStartImages() {
        print("Setting up images")
        for i in 1...numberOfDifferentCards {
            self.startImages.append(UIImage(named: "startMeal" + "\(i)")!)
            self.startImages.append(UIImage(named: "startMeal" + "\(i)")!)

        }
        //self.startImages.append(UIImage(named: "startMeal1")!)
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
//        switch index {
//        case 0:
//            return [.right]
//        case 1:
//            return [.left]
//        case 2:
//            return [.up]
//        default:
//            return [.left, .right, .up]
//        }
        return [.left, .right, .up]
    }
        
    
}

// MARK: KolodaViewDataSource
extension TutorialViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .moderate
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.startImages.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view: UIImageView = UIImageView()
        view.image = self.startImages[index]
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
        print("We are at index: \(index)")
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "Swipe right if you like to eat this here and now."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 1:
            coachViews.bodyView.hintLabel.text = "Or press the green like button."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 2:
            coachViews.bodyView.hintLabel.text = "Swipe left if you don't like to eat this here and now."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 3:
            coachViews.bodyView.hintLabel.text = "Or press the red dislike button."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 4:
            coachViews.bodyView.hintLabel.text = "Swipe up if there is no food on the picture."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 5:
            coachViews.bodyView.hintLabel.text = "Or press the blue no food button."
            coachViews.bodyView.nextLabel.text = "Ok"
        case 6:
            coachViews.bodyView.hintLabel.text = "Now it's your turn. Try it out!"
            coachViews.bodyView.nextLabel.text = "Ok"
        default:
            break
        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }


    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 7
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0, 2, 4, 6:
            return coachMarksController.helper.makeCoachMark(for: self.kolodaView)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.likeButton)
        case 3:
            return coachMarksController.helper.makeCoachMark(for: self.dislikeButton)
        case 5:
            return coachMarksController.helper.makeCoachMark(for: self.noFoodButton)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
}

extension TutorialViewController: CoachMarksControllerDelegate {
//    func coachMarksController(_ coachMarksController: CoachMarksController,
//                              willShow coachMark: inout CoachMark, at index: Int) {
//        switch index {
//        case 1:
//            coachMarksController.flow.pause()
//            UIView.animate(withDuration: 1, animations: { () -> Void in
//                self.kolodaView.swipe(.right)
//            }, completion: { (finished: Bool) -> Void in
//                coachMarksController.helper.updateCurrentCoachMark(usingView: self.kolodaView, pointOfInterest: nil) {
//                    (frame: CGRect) -> UIBezierPath in
//                    return UIBezierPath(ovalIn: frame.insetBy(dx: -4, dy: -4))
//                }
//                coachMarksController.flow.resume()
//            })
//        case 3:
//            coachMarksController.flow.pause()
//            UIView.animate(withDuration: 1, animations: { () -> Void in
//                self.kolodaView.swipe(.left)
//            }, completion: { (finished: Bool) -> Void in
//                coachMarksController.flow.resume()
//            })
//        case 5:
//            coachMarksController.flow.pause()
//            UIView.animate(withDuration: 1, animations: { () -> Void in
//                self.kolodaView.swipe(.up)
//            }, completion: { (finished: Bool) -> Void in
//                coachMarksController.flow.resume()
//            })
//        default:
//            break
//        }
//        if index == 0 {
//            // We'll need to play an animation before showing up the coach mark.
//            // To be able to play the animation and then show the coach mark and not stall
//            // the UI (i. e. keep the asynchronicity), we'll pause the controller.
//            coachMarksController.flow.pause()
//
//            // Then we run the animation.
//
//            UIView.animate(withDuration: 1, animations: { () -> Void in
//                self.kolodaView.swipe(.right)
//            }, completion: { (finished: Bool) -> Void in
//
//                // Once the animation is completed, we update the coach mark,
//                // and start the display again.
//                coachMarksController.helper.updateCurrentCoachMark(usingView: self.kolodaView, pointOfInterest: nil, cutoutPathMaker: nil)
//                coachMarksController.flow.resume()
//            })
//        }
//    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willHide coachMark: CoachMark, at index: Int) {
        switch index {
        case 0, 1:
            self.kolodaView.swipe(.right)
        case 2, 3:
            self.kolodaView.swipe(.left)
        case 4, 5:
            self.kolodaView.swipe(.up)
            
//            coachMarksController.flow.pause()
//            UIView.animate(withDuration: 1, animations: { () -> Void in
//            }, completion: { (finished: Bool) -> Void in
//                coachMarksController.flow.resume()
//            })
        default:
            break
        }
    }
}


