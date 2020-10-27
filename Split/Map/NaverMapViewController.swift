//
//  NaverMapViewController.swift
//  Split
//
//  Created by najin on 2020/10/26.
//

import UIKit
import NMapsMap

class NaverMapViewController: MapViewController {

//    @IBOutlet weak var splitMapView: NMFNaverMapView!
//    @IBOutlet weak var locationView: NMFLocationButton!
//
//    let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.450605, lng: 126.659339), zoom: 15, tilt: 0, heading: 0)
//    var locationManager: CLLocationManager!
//    var latitude = 37.45210429999999
//    var longitude = 126.6572889
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let param = NMFCameraUpdateParams()
//        param.scroll(to: DEFAULT_CAMERA_POSITION.target)
//        param.zoom(to: DEFAULT_CAMERA_POSITION.zoom)
//        param.tilt(to: 30)
//        param.rotate(to: 45)
//        splitMapView.mapView.moveCamera(NMFCameraUpdate(params: param))

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
//        //스플릿존 마커 표시하기
//        let marker = NMFMarker()
//        marker.position = NMGLatLng(lat: 37.451819, lng: 126.654972)
////        marker.iconImage = NMFOverlayImage(name: "zone")
//        marker.width = 40
//        marker.height = 40
//        marker.iconPerspectiveEnabled = true
//        marker.captionAligns = [NMFAlignType.center]
//        marker.captionText = "\nS"
//        marker.captionColor = .white
//        marker.captionTextSize = 18
//        marker.subCaptionText = "\n스플릿존"
//        marker.mapView = splitMapView.mapView
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let param = NMFCameraUpdateParams()
        param.scroll(to: DEFAULT_CAMERA_POSITION.target)
        param.zoom(to: DEFAULT_CAMERA_POSITION.zoom)
        param.tilt(to: 30)
        param.rotate(to: 45)
        mapView.moveCamera(NMFCameraUpdate(params: param))

        let marker = NMFMarker(position: NMGLatLng(lat: 37.5666102, lng: 126.9783881))
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.mapView = mapView
        
        let markerWithCustomIcon = NMFMarker(position: NMGLatLng(lat: 37.57000, lng: 126.97618))
        markerWithCustomIcon.iconImage = NMF_MARKER_IMAGE_GRAY
        markerWithCustomIcon.angle = 315
        markerWithCustomIcon.mapView = mapView
        
        let flatMarker = NMFMarker(position: NMGLatLng(lat: 37.57145, lng: 126.98191))
        flatMarker.iconImage = NMF_MARKER_IMAGE_BLUE
        flatMarker.isFlat = true
        flatMarker.angle = 90
        flatMarker.mapView = mapView
        
        let markerWithAnchor = NMFMarker(position: NMGLatLng(lat: 37.56768, lng: 126.98602))
        markerWithAnchor.iconImage = NMFOverlayImage(name: "imgInfowindow22XWhite", in: Bundle.naverMapFramework())
        markerWithAnchor.anchor = CGPoint(x: 1, y: 1)
        markerWithAnchor.angle = 90
        markerWithAnchor.mapView = mapView
        
        let markerWithCaption = NMFMarker(position: NMGLatLng(lat: 37.56436, lng: 126.97499))
        markerWithCaption.iconImage = NMF_MARKER_IMAGE_YELLOW
        markerWithCaption.captionMinZoom = 12.0
        markerWithCaption.captionAligns = [NMFAlignType.left]
        markerWithCaption.captionText = "☀캡션이 있는 마커🎉"
        markerWithCaption.mapView = mapView
        
        let markerWithSubCaption = NMFMarker(position: NMGLatLng(lat: 37.56138, lng: 126.97970))
        markerWithSubCaption.iconImage = NMF_MARKER_IMAGE_PINK
        markerWithSubCaption.captionTextSize = 14
        markerWithSubCaption.captionText = "서브 캡션이 있는 마커"
        markerWithSubCaption.captionMinZoom = 12.0
        markerWithSubCaption.subCaptionTextSize = 10
        markerWithSubCaption.subCaptionColor = UIColor.gray
        markerWithSubCaption.subCaptionText = "🇰🇷서브 캡션👩🏿‍🍳"
        markerWithSubCaption.subCaptionMinZoom = 13.0
        markerWithSubCaption.mapView = mapView

        let tintColorMarker = NMFMarker(position: NMGLatLng(lat: 37.56500, lng: 126.9783881))
        tintColorMarker.iconImage = NMF_MARKER_IMAGE_BLACK
        tintColorMarker.iconTintColor = UIColor.red
        tintColorMarker.alpha = 0.5
        tintColorMarker.mapView = mapView
    }
}

