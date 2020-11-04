//
//  NaverMapViewController.swift
//  Split
//
//  Created by najin on 2020/10/26.
//

import UIKit
import NMapsMap
import Alamofire

class MapViewController: UIViewController, NMFMapViewTouchDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var splitMapView: NMFNaverMapView!
    @IBOutlet weak var locationView: NMFLocationButton!
    @IBOutlet weak var splitInfoView: UIView!
    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var planetAdressLabel: UILabel!
    @IBOutlet weak var planetTimeLabel: UILabel!
    @IBOutlet weak var splitInfoMenuButton: UIButton!
    @IBOutlet weak var splitInfoSplitButton: UIButton!
    
    var maps: [MapVO] = []
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
        locationView.mapView = splitMapView.mapView;
        splitMapView.mapView.positionMode = .direction
        splitMapView.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
        splitMapView.showLocationButton = false
        splitMapView.showScaleBar = false
        splitMapView.showZoomControls = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let URL = Common().baseURL+"/split/get.do"
        let alamo = AF.request(URL, method: .get).validate(statusCode: 200..<300)
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: today)
        dateFormatter.dateFormat = "eeee"
        let holidayString = dateFormatter.string(from: today)
        print(timeString)
        print(holidayString)
        
        alamo.response { response in
            switch response.result {
            case .success(let value):
                let jsonDecoder = JSONDecoder()
                do {
                    self.maps = try jsonDecoder.decode([MapVO].self, from: value!)
                    for map in self.maps {
                        //스플릿존 마커 표시하기
                        let marker = NMFMarker()
                        marker.position = NMGLatLng(lat: map.lat, lng: map.lng)
                        marker.iconImage = NMFOverlayImage(name: "map_marker_purple")
                        marker.width = 45
                        marker.height = 50
                        marker.iconPerspectiveEnabled = true
                        marker.captionAligns = [NMFAlignType.center]
                        marker.captionText = "\n\(map.allVisit)"
                        marker.captionColor = .white
                        marker.captionHaloColor = Common().purple
                        marker.captionTextSize = 18
                        marker.subCaptionText = "\n\(map.planetName)"
                        marker.mapView = self.splitMapView.mapView
                        //마커 클릭했을때 실행
                        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                            marker.iconImage = NMFOverlayImage(name: "map_marker_active")
                            marker.captionColor = Common().purple
                            marker.captionHaloColor = .white
                            self.planetNameLabel.text = map.planetName
                            self.planetAdressLabel.text = map.address
                            self.planetTimeLabel.text = "\(map.startTime) ~ \(map.endTime) \(map.holiday) 정기휴무"
                            self.splitInfoView.isHidden = false
                            self.splitMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 170, right: 0)
                            return true
                        }
                        marker.iconImage = NMFOverlayImage(name: "map_marker_purple")
                    }
                } catch {
                    print("json_decoder_error")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //지도 탭했을 때 실행
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        self.splitInfoView.isHidden = true
        self.splitMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

