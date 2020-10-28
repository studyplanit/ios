//
//  PlanViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit

class PlanViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    private lazy var challengeViewController: ChallengeViewController = {
        let storyboard = UIStoryboard(name: "Plan", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "challengeViewController") as! ChallengeViewController
        // Add View Controller as Child View Controller
        self.addView(asChildViewController: viewController)
        return viewController
    }()
    private lazy var eventViewController: EventViewController = {
        let storyboard = UIStoryboard(name: "Plan", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "eventViewController") as! EventViewController
        // Add View Controller as Child View Controller
        self.addView(asChildViewController: viewController)
        return viewController
    }()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapBar()
        configureContentView()
    }
    
}
// MARk:- Configure
extension PlanViewController {
    
    func configureTapBar() {
        navigationItem.title = "플랜"
    }
    
    func configureSegementedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Challenge", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Event", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)

        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func configureContentView() {
        configureSegementedControl()
        updateView()
    }
    
}

// MARk:- Methods
extension PlanViewController {
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func addView(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        contentView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = contentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func removeView(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            removeView(asChildViewController: eventViewController)
            addView(asChildViewController: challengeViewController)
        } else {
            removeView(asChildViewController: challengeViewController)
            addView(asChildViewController: eventViewController)
        }
    }
    
    
}
