//
//  PlanViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit

class PlanViewController: UIViewController {
    
    // MARK:- Properties
    private let challengeButton = UIButton()
    private let eventButton = UIButton()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawCategory()
    }
    
}
// MARk:- Configure UI
extension PlanViewController {
    
    func drawCategory() {
        challengeButton.translatesAutoresizingMaskIntoConstraints = false
        challengeButton.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        challengeButton.setTitle("Challenge", for: .normal)
        challengeButton.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        challengeButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .highlighted)
        challengeButton.addTarget(
            self,
            action: #selector(touchUpChallengeButton),
            for: .touchUpInside)
        view.addSubview(challengeButton)
        challengeButton.heightAnchor.constraint(
            equalToConstant: 40).isActive = true
        challengeButton.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 0).isActive = true
        challengeButton.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 0).isActive = true
        challengeButton.trailingAnchor.constraint(
            equalTo: view.centerXAnchor,
            constant: 0).isActive = true
        
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        eventButton.setTitle("Event", for: .normal)
        eventButton.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        eventButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .highlighted)
        eventButton.addTarget(
            self,
            action: #selector(touchUpEventButton),
            for: .touchUpInside)
        view.addSubview(eventButton)
        eventButton.heightAnchor.constraint(
            equalToConstant: 40).isActive = true
        eventButton.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 0).isActive = true
        eventButton.leadingAnchor.constraint(
            equalTo: view.centerXAnchor,
            constant: 0).isActive = true
        eventButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: 0).isActive = true
    }
    
}

// MARk:- Methods
extension PlanViewController {
    
    @objc func touchUpChallengeButton() {
        print("challenge button clicked")
    }
    
    @objc func touchUpEventButton() {
        print("event button clicked")
    }
}
