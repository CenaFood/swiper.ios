//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop
import TransitionButton
import Kingfisher
import CoreLocation
import CloudKit

private let numberOfStartingCards: Int = 10
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

//private let dataSource: [Resource] = []


class BackgroundAnimationViewController: CustomTransitionViewController {
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var userID: String = ""
    

    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var questionLabel: UILabel!
    
    
    fileprivate var challenges: [Challenge] = []
    fileprivate var annotations: [Annotation] = []
    //fileprivate var answerDict: [Challenge : Annotation] = [:]
    fileprivate var dataSource: [URL] = []
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        setupQuestionLabel()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        
        #if IOS
            getCloudKitIdentifier()
        #endif
        
        // so that you cannot drag the picture over the edge of the view (e.g. over the buttons below or the title above
        kolodaView.clipsToBounds = true
        fetchImages()
        //print("We have \(dataSource.count) number of images")
        
        
        // add images to array
    }
    
    func getCloudKitIdentifier() {
        let container = CKContainer.default()
        container.fetchUserRecordID {(recordID, error) in
            guard let recordID = recordID else {
                NSLog("Error: \(String(describing: error))")
                return
            }
            self.userID = recordID.recordName
            print(self.userID)
            
        }
        
    }
    
    
    func setupQuestionLabel() {
        questionLabel.text = "Would you eat this here and now?"
        let size = UIFont.labelFontSize
        let font = UIFont.systemFont(ofSize: size)
        questionLabel.font = font
    }
    
    
    func fetchImages() {
        CenaAPI().prefetchImages() { challenges, urls in
            self.challenges = challenges
            // print("We have \(challenges.count) challenges")
            self.dataSource = urls
            self.setupAnnotations()
            self.locationManager?.requestLocation()
            self.kolodaView.resetCurrentCardIndex()
        }
        
    }
    
    func setupAnnotations() {
        for challenge in challenges {
            let annotation: Annotation = Annotation(challengeID: challenge.id, userID: "6A1BA20A-8D25-4E71-8BD8-E6872FD53ADA", answer: "", location: nil, localTime: nil)
            annotations.append(annotation)
        }
    }
    
    func updateAnnotations() {
        for annotation in annotations {
            CenaAPI().postAnnotations(annotation: annotation)
        }
    }
    
    func updateAnnotation(index: Int, answer: String) {
        let location = Location(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        annotations[index].answer = answer
        annotations[index].latitude = location.latitude
        annotations[index].longitude = location.longitude
        annotations[index].localTime = currentLocation?.timestamp
        //print(annotations[index])
        CenaAPI().postAnnotations(annotation: annotations[index])
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
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //updateAnnotations()
        fetchImages()
        //kolodaView.resetCurrentCardIndex()
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
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == SwipeResultDirection.right {
            updateAnnotation(index: kolodaView.currentCardIndex - 1, answer: "Yes")
        } else if direction == SwipeResultDirection.left {
            updateAnnotation(index: kolodaView.currentCardIndex - 1, answer: "No")
        } else if direction == SwipeResultDirection.up {
            updateAnnotation(index: kolodaView.currentCardIndex - 1, answer: "No Food")
        }
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .up]
    }
    
}

// MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view: UIImageView = UIImageView()
        view.kf.setImage(with: dataSource[index])
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

extension BackgroundAnimationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
        
    }
}

