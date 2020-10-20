//
//  MapViewController.swift
//  Split
//
//  Created by najin on 2020/10/19.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("aa")
        let mapView = NMFMapView(frame: view.frame)
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
//
//        let marker = NMFMarker()
//        marker.position = NMGLatLng(lat: 37.35, lng: 127.1089)
//        marker.iconImage = NMFOverlayImage(name: "zone")
//        marker.width = 25
//        marker.height = 40
//        marker.iconPerspectiveEnabled = true
//        marker.captionAligns = [NMFAlignType.top]
//        marker.captionText = "스플릿존"
//        marker.subCaptionText = "100명"
//        marker.mapView = mapView
        view.addSubview(mapView)
    }
    
}
