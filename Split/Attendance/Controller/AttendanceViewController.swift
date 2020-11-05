//
//  AttendanceViewController.swift
//  Split
//
//  Created by uno on 2020/10/31.
//

import UIKit
import AVFoundation
import QRCodeReader

class AttendanceViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var planView1: UIView!
    @IBOutlet weak var planView2: UIView!
    @IBOutlet weak var planView3: UIView!
    
    
    // MARK:- Properties
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        return QRCodeReaderViewController(builder: builder)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapBar()
        configureUI()
        configureTapGesture()
    }
    
}

// MARK:- Configure
extension AttendanceViewController {
    
    func configureTapBar() {
        navigationItem.title = "QR"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "KoPubDotumBold", size: 20)!]
    }
    
    func configureUI() {
        planView1.layer.cornerRadius = 10
        planView2.layer.cornerRadius = 10
        planView3.layer.cornerRadius = 10
    }
    
    func configureTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showScanner))
        planView1.addGestureRecognizer(gesture)
        planView1.isUserInteractionEnabled = true
    }
    
}

// MARK:- Methods
extension AttendanceViewController {
    
    @objc func showScanner() {
        print("MainViewController - showScanner() called ")
        readerVC.delegate = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print("QRCodeScanner succeded in closure")
            guard let result = result else { return }
            print(result)
            let scannedUrlString = result.value
            print("scannedUrlString : \(scannedUrlString)")
//            guard let scannedUrl = URL(string: scannedUrlString) else { return }
//            self.webView.load(URLRequest(url: scannedUrl))
        }
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }

}

// MARK:- QR Code Reader View Controller Delegate
extension AttendanceViewController: QRCodeReaderViewControllerDelegate {
    
    // QR코드 리더가 성공했을 때 동작 정의
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print("QRCodeScanner succeded in delegate")
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Attendance", bundle: Bundle.main)
        guard let attendanceCompletionViewController = storyboard.instantiateViewController(withIdentifier: "attendanceCompletionViewController") as? AttendanceCompletionViewController else { return }
        attendanceCompletionViewController.url = result.value
        navigationController?.pushViewController(attendanceCompletionViewController, animated: true)
    }
    
    // QR코드 리더가 취소 됬을때 정의
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("QRCodeScanner stoped")
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
}
