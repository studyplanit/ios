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
    @IBOutlet weak var planetImageView: UIImageView!
    @IBOutlet weak var planetAddressLabel: UILabel!
    @IBOutlet weak var planetTimeLabel: UILabel!
    @IBOutlet weak var planetMenuButton: UIButton!
    @IBOutlet weak var planetReviewButton: UIButton!
    @IBOutlet weak var planetRatingLabel: UILabel!
    @IBOutlet weak var planetCallImageView: UIImageView!
    @IBOutlet weak var planetCodeButton: UIButton!
    @IBOutlet weak var planetTotalVisitButton: UIButton!
    
    let tapPlanetImageViewGestureRecognizer = UITapGestureRecognizer()
    let tapPlanetCallImageViewGestureRecognizer = UITapGestureRecognizer()
    let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.450605, lng: 126.659339), zoom: 15, tilt: 0, heading: 0)
    var maps: [MapVO] = []
    var locationManager: CLLocationManager!
    var beforeMarker: NMFMarker?
    var planetImageURL: String?
    var planetMenuImageURL: String?
    var planetCallNumber: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        splitMapView.mapView.touchDelegate = self
        //탭 이벤트 지정
        planetImageView.isUserInteractionEnabled = true
        planetImageView.addGestureRecognizer(tapPlanetImageViewGestureRecognizer)
        tapPlanetImageViewGestureRecognizer.addTarget(self, action: #selector(planetImageViewTap))
        
        planetCallImageView.isUserInteractionEnabled = true
        planetCallImageView.addGestureRecognizer(tapPlanetCallImageViewGestureRecognizer)
        tapPlanetCallImageViewGestureRecognizer.addTarget(self, action: #selector(planetCallImageViewTap))
        
        //하위 뷰 셋팅하기
        self.view.bringSubviewToFront(locationView)
        self.view.bringSubviewToFront(splitInfoView)
        splitInfoView.isHidden = true
        splitMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        planetNameLabel.font = Common().fontStyle(name: "KoPubDotumBold", size: 18)
        planetAddressLabel.font = Common().fontStyle(name: "KoPubDotumBold", size: 14)
        planetTimeLabel.font = Common().fontStyle(name: "KoPubDotumBold", size: 14)
        planetMenuButton.setTitle("   메뉴판 이미지로 보기   ", for: .normal)
        planetReviewButton.setTitle("   리뷰 준비중   ", for: .normal)
        planetMenuButton.titleLabel!.font = Common().fontStyle(name: "KoPubDotumBold", size: 14)
        planetMenuButton.backgroundColor = Common().purple
        planetMenuButton.layer.cornerRadius = 12
        planetReviewButton.titleLabel!.font = Common().fontStyle(name: "KoPubDotumBold", size: 14)
        planetReviewButton.backgroundColor = Common().purple
        planetReviewButton.layer.cornerRadius = 12
        planetRatingLabel.font = Common().fontStyle(name: "KoPubDotumBold", size: 14)
        planetCodeButton.titleLabel!.font = Common().fontStyle(name: "KoPubDotumBold", size: 14)
        planetCodeButton.layer.cornerRadius = 12
        planetCodeButton.backgroundColor = Common().coralblue
        planetTotalVisitButton.titleLabel!.font = Common().fontStyle(name: "KoPubDotumBold", size: 14)
        planetTotalVisitButton.layer.cornerRadius = 12
        planetTotalVisitButton.backgroundColor = Common().coralblue
        
        //네이버지도 초기화하기
        locationView.mapView = splitMapView.mapView;
        splitMapView.mapView.positionMode = .direction
        splitMapView.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
        splitMapView.showLocationButton = false
        splitMapView.showScaleBar = false
        splitMapView.showZoomControls = false
        
        //사용자의 현재 위치(위도,경도) 불러오기
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = Common().baseURL+"/split/get.do"
        let alamo = AF.request(url, method: .get).validate(statusCode: 200..<300)
        
        alamo.response { response in
            switch response.result {
            case .success(let value):
                let jsonDecoder = JSONDecoder()
                do {
                    self.maps = try jsonDecoder.decode([MapVO].self, from: value!)
                    for map in self.maps {
                        //현재시간
//                        let nowTimeString:String = Date
//                        let nowTimeFormatter = DateFormatter()
//                        nowTimeFormatter.dateFormat = "HH:mm"
//                        nowTimeFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//                        let nowTime = nowTimeFormatter.date(from: nowTimeString)!
//                        //플래닛 시작시간
//                        let startTimeString:String = map.startTime
//                        let startTimeFormatter = DateFormatter()
//                        startTimeFormatter.dateFormat = "HH:mm"
//                        startTimeFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//                        let startTime = startTimeFormatter.date(from: startTimeString)!
//                        //플래닛 마감시간
//                        let endTimeString:String = map.endTime
//                        let endTimeFormatter = DateFormatter()
//                        endTimeFormatter.dateFormat = "HH:mm"
//                        endTimeFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//                        let endTime = endTimeFormatter.date(from: endTimeString)!
//                        print(startTime)
                        //스플릿존 마커
                        let marker = NMFMarker()
                        //마커 셋팅
                        marker.position = NMGLatLng(lat: map.lat, lng: map.lng)
                        marker.iconImage = NMFOverlayImage(name: "map_marker_purple")
                        marker.width = 45
                        marker.height = 50
                        marker.iconPerspectiveEnabled = true
                        marker.captionAligns = [NMFAlignType.center]
                        marker.captionText = "\n\(map.todayVisit)"
                        marker.captionColor = .white
                        marker.captionHaloColor = Common().purple
                        marker.captionTextSize = 18
                        marker.subCaptionText = "\n\(map.planetName)"
                        marker.mapView = self.splitMapView.mapView
                        //마커 클릭했을때 실행
                        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                            //지도 가운데에 마커가 위치
                            self.splitMapView.mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(lat: map.lat, lng: map.lng), zoom: self.splitMapView.mapView.zoomLevel, tilt: 0, heading: 0)))
                            
                            //클릭시 마커 모양 지정
                            marker.iconImage = NMFOverlayImage(name: "map_marker_active")
                            if self.beforeMarker != nil && self.beforeMarker != marker {
                                self.beforeMarker?.iconImage = NMFOverlayImage(name: "map_marker_purple")
                                self.beforeMarker?.captionHaloColor = Common().purple
                                self.beforeMarker?.captionColor = .white
                            }
                            self.beforeMarker = marker
                            marker.captionColor = Common().purple
                            marker.captionHaloColor = .white
                            
                            //팝업 뷰 셋팅
                            self.planetCodeButton.setTitle("   행성 \(map.planetCode)   ", for: .normal)
                            self.planetTotalVisitButton.setTitle("   누적방문자 \(map.allVisit)명   ", for: .normal)
                            self.planetNameLabel.text = map.planetName
                            self.planetAddressLabel.text = map.address
                            self.planetTimeLabel.text = "\(map.startTime) ~ \(map.endTime) 정기휴무 \(map.holiday)"
                            self.splitInfoView.isHidden = false
                            self.splitMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 170, right: 0)
                            self.planetImageURL = map.cafeInImage
                            self.planetMenuImageURL = map.menuList
                            self.planetCallNumber = map.phoneNumber
                            
                            //동기 방식으로 이미지 로드(마커 클릭 속도가 느림)
                            let url = URL(string: "\(Common().baseURL)/\(map.cafeInImage)")
                            if let data = try? Data(contentsOf: url!) {
                                if let image = UIImage(data: data) {
                                    self.planetImageView.image = image
                                }
                            }
                            //비동기 방식으로 이미지 로드(이미지만 로드 속도만 느림)
//                            DispatchQueue.global().async { [weak self] in
//                                let url = URL(string: "\(Common().baseURL)/\(map.cafeImage)")
//                                if let data = try? Data(contentsOf: url!) {
//                                    if let image = UIImage(data: data) {
//                                        DispatchQueue.main.async {
//                                            self!.planetImageView.image = image
//                                        }
//                                    }
//                                }
//                            }
                            return true
                        }
                    }
                } catch {
                    print("json_decoder_error")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //팝업뷰의 스플릿존 이미지 클릭했을 때
    @objc func planetImageViewTap(sender: UITapGestureRecognizer) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "mapPopUpView")
        MapPopUpViewController.popUpImageURL = self.planetImageURL
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    //팝업뷰의 전화걸기 이미지 클릭했을 때
    @objc func planetCallImageViewTap(sender: UITapGestureRecognizer) {
        guard let phoneCallURL = NSURL(string: "tel://\(self.planetCallNumber!)") else {
            return
        }
        if UIApplication.shared.canOpenURL(phoneCallURL as URL) {
            UIApplication.shared.open(phoneCallURL as URL)
        }
    }
    
    //팝업뷰의 메뉴판 이미지 클릭했을 때
    @IBAction func planetMenuButtonClick(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "mapPopUpView")
        MapPopUpViewController.popUpImageURL = self.planetMenuImageURL
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    //지도 탭했을 때 실행
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if self.beforeMarker != nil {
            self.beforeMarker?.iconImage = NMFOverlayImage(name: "map_marker_purple")
            self.beforeMarker?.captionHaloColor = Common().purple
            self.beforeMarker?.captionColor = .white
            self.beforeMarker = nil
        }
        self.splitInfoView.isHidden = true
        self.splitMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
