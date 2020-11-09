//
//  MapPopUpViewController.swift
//  Split
//
//  Created by najin on 2020/11/07.
//

import UIKit

class MapPopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIImageView!
    @IBOutlet weak var cancelImageView: UIImageView!
    
    static var popUpImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchImageView(_:)))
        self.popUpView.addGestureRecognizer(pinch)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panImageView(_:)))
        self.popUpView.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapCancelImageView(_:)))
        self.cancelImageView.addGestureRecognizer(tap)
        
        guard let url = URL(string: "\(Common().baseURL)/\(MapPopUpViewController.popUpImageURL!)") else {
            self.present(Common().errorAlert(), animated: false, completion: nil)
            return
        }
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                popUpView.image = image
            }
        }
    }
    
    //MARK: 이미지 확대
    @objc func pinchImageView(_ pinch: UIPinchGestureRecognizer) {
        popUpView.transform = popUpView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    
    //MARK: 이미지 이동
    @objc func panImageView(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view)
        guard let popUpView = pan.view else {
            return
        }
        popUpView.center = CGPoint(x: popUpView.center.x + translation.x, y: popUpView.center.y + translation.y)
        pan.setTranslation(.zero, in: view)
    }
    
    //MARK: 이미지 뷰어 화면 끄기
    @objc func tapCancelImageView(_ tap: UITapGestureRecognizer) {
        print("aa")
        self.dismiss(animated: false, completion: nil)
    }
}
