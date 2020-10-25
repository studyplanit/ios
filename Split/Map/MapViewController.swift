//
//  MapViewController.swift
//  Split
//
//  Created by najin on 2020/10/19.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController,CLLocationManagerDelegate {

//    var locationManager: CLLocationManager!
//    var latitude = 37.45210429999999
//    var longitude = 126.6572889
    
    let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.45210429999999, lng: 126.6572889), zoom: 17, tilt: 0, heading: 0)
    let primaryColor = UIColor(red: 25.0/255.0, green: 192.0/255.0, blue: 46.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //사용자의 현재 위치(위도,경도) 불러오기
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//
//        let coor = locationManager.location?.coordinate
//        latitude = coor!.latitude
//        longitude = coor!.longitude
        
        //네이버 지도 활성화
        let mapView = NMFMapView(frame: view.frame)
        mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
        
//        let cameraPosition = mapView.cameraPosition
//        mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
//        let projection = mapView.projection
//        mapView.showLocationButton = true
        
        
//        let point = projection.point(from: NMGLatLng(lat: 37.4500221, lng: 126.653488)
//        mapView.positionMode = .compass
//
        let locationOverlay = mapView.locationOverlay
        locationOverlay.hidden = true
        locationOverlay.location = NMGLatLng(lat: 37.4500221, lng: 126.653488)
        locationOverlay.heading = 90
        locationOverlay.circleRadius = 50

        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.451819, lng: 126.654972)
        marker.iconImage = NMFOverlayImage(name: "zone")
        marker.width = 25
        marker.height = 40
        marker.iconPerspectiveEnabled = true
        marker.captionAligns = [NMFAlignType.top]
        marker.captionText = "스플릿존"
        marker.subCaptionText = "100명"
        marker.mapView = mapView
        
        view.addSubview(mapView)
    }
    
    
}



//class MapViewController: UIViewController {
//    @IBOutlet weak var naverMapView: NMFNaverMapView!
//    var mapView: NMFMapView {
//        return naverMapView.mapView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 211/255, blue: 83/255, alpha: 1.0)
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
//    }
// }
//
//extension NMGLatLng {
//    func positionString() -> String {
//        return String(format: "(%.5f, %.5f)", lat, lng)
//    }
//}
