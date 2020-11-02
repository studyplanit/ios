//
//  PlanViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit

class PlanViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    private lazy var challengeViewController: ChallengeViewController = {
        let storyboard = UIStoryboard(name: "Plan", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "challengeViewController") as! ChallengeViewController
        self.addView(asChildViewController: viewController)
        return viewController
    }()
    private lazy var eventViewController: EventViewController = {
        let storyboard = UIStoryboard(name: "Plan", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "eventViewController") as! EventViewController
        self.addView(asChildViewController: viewController)
        return viewController
    }()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapBar()
        configureContentView()
    }
    
}
// MARK:- Configure
extension PlanViewController {
    
    func configureTapBar() {
        navigationItem.title = "플랜"
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BM DoHyeon OTF", size: 12)!]

    }
    
    func configureSegementedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Challenge", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Event", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func configureContentView() {
        configureSegementedControl()
        updateView()
    }
    
}

// MARK:- Methods
extension PlanViewController {
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func addView(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.view.frame = contentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func removeView(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
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
