//
//  NaverMapViewController.swift
//  Split
//
//  Created by najin on 2020/10/26.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController, NMFMapViewTouchDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var splitMapView: NMFNaverMapView!
    @IBOutlet weak var locationView: NMFLocationButton!
    @IBOutlet weak var splitInfoView: UIView!
    @IBOutlet weak var splitInfoMenuButton: UIButton!
    @IBOutlet weak var splitInfoSplitButton: UIButton!
    var locationManager: CLLocationManager!
    let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.450605, lng: 126.659339), zoom: 15, tilt: 0, heading: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        splitMapView.mapView.touchDelegate = self
        
        //하위 뷰 셋팅하기
        self.view.bringSubviewToFront(locationView)
        self.view.bringSubviewToFront(splitInfoView)
        splitInfoView.isHidden = true
        splitMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        splitInfoMenuButton.backgroundColor = Common().purple
        splitInfoSplitButton.backgroundColor = Common().purple
        splitInfoMenuButton.layer.cornerRadius = 12
        splitInfoSplitButton.layer.cornerRadius = 12

        //사용자의 현재 위치(위도,경도) 불러오기
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        //네이버지도 초기화하기
        splitMapView.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
        splitMapView.showLocationButton = false
        splitMapView.showScaleBar = true
        splitMapView.showZoomControls = true
        locationView.mapView = splitMapView.mapView;
        splitMapView.mapView.positionMode = .direction

        //스플릿존 마커 표시하기
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.451819, lng: 126.654972)
        marker.iconImage = NMFOverlayImage(name: "map_marker_purple")
        marker.width = 45
        marker.height = 50
        marker.iconPerspectiveEnabled = true
        marker.captionAligns = [NMFAlignType.center]
        marker.captionText = "\nS"
        marker.captionColor = .white
        marker.captionHaloColor = Common().purple
        marker.captionTextSize = 18
        marker.subCaptionText = "\n스플릿존"
        marker.mapView = splitMapView.mapView
        //마커 클릭했을때 실행
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            self.splitInfoView.isHidden = false
            self.splitMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
            return true
        }
        
        let marker2 = NMFMarker()
        marker2.position = NMGLatLng(lat: 37.451955, lng: 126.655995)
        marker2.iconImage = NMFOverlayImage(name: "map_marker_purple")
        marker2.width = 45
        marker2.height = 50
        marker2.iconPerspectiveEnabled = true
        marker2.captionAligns = [NMFAlignType.center]
        marker2.captionText = "\n10"
        marker2.captionColor = .white
        marker2.captionHaloColor = Common().purple
        marker2.captionTextSize = 18
        marker2.subCaptionText = "\n스플릿존2"
        marker2.mapView = splitMapView.mapView
        marker2.touchHandler = { (overlay: NMFOverlay) -> Bool in
            self.splitInfoView.isHidden = false
            self.splitMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
            return true
        }
    }
    
    //지도 탭했을 때 실행
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        self.splitInfoView.isHidden = true
        self.splitMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

