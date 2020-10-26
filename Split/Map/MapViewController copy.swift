//
//  MapViewController.swift
//  Split
//
//  Created by najin on 2020/10/19.
//

import UIKit
import NMapsMap

class NaverMapViewController: MapViewController {
    
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    @IBOutlet weak var locationView: NMFLocationButton!
//
    let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.450605, lng: 126.659339), zoom: 15, tilt: 0, heading: 0)
//    var locationManager: CLLocationManager!
//    var latitude = 37.45210429999999
//    var longitude = 126.6572889
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let param = NMFCameraUpdateParams()
        param.scroll(to: DEFAULT_CAMERA_POSITION.target)
        param.zoom(to: DEFAULT_CAMERA_POSITION.zoom)
        param.tilt(to: 30)
        param.rotate(to: 45)
        naverMapView.mapView.moveCamera(NMFCameraUpdate(params: param))

//        //네비게이션 바 설정
//
//        //사용자의 현재 위치(위도,경도) 불러오기
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//
//        let coor = locationManager.location?.coordinate
//        latitude = coor!.latitude
//        longitude = coor!.longitude
//        print(latitude)
//        print(longitude)
//
//        //네이버 지도 활성화
////        let naverMapView = NMFNaverMapView(frame: view.frame)
//        naverMapView.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
//        naverMapView.showLocationButton = true
//        naverMapView.showScaleBar = false
//        naverMapView.showZoomControls = false
////        locationView.mapView = naverMapView.mapView;
//        naverMapView.mapView.positionMode = .direction
//
////        let cameraPosition = naverMapView.mapView.cameraPosition
////        naverMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
////        let projection = naverMapView.mapView.projection
//
//
////        let point = projection.point(from: NMGLatLng(lat: 37.4500221, lng: 126.653488))
//
//        //현재위치 표시하기
//        let locationOverlay = naverMapView.mapView.locationOverlay
//        locationOverlay.hidden = true
//        locationOverlay.location = NMGLatLng(lat: 37.450605, lng: 126.659339)
//        locationOverlay.heading = 90
//        locationOverlay.circleRadius = 50
//
        //스플릿존 마커 표시하기
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.451819, lng: 126.654972)
//        marker.iconImage = NMFOverlayImage(name: "zone")
        marker.width = 40
        marker.height = 40
        marker.iconPerspectiveEnabled = true
        marker.captionAligns = [NMFAlignType.center]
        marker.captionText = "\nS"
        marker.captionColor = .white
        marker.captionTextSize = 18
        marker.subCaptionText = "\n스플릿존"
        marker.mapView = naverMapView.mapView

    }
}



    
