//
//  PlanViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit
import Alamofire

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
        navigationItem.title = "PLAN"
    }
    
    func configureSegementedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "챌린지", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "이벤트", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "KoPubDotumBold", size: 16)!], for: .normal)
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
