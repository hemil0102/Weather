//
//  ViewController.swift
//  Weather
//
//  Created by Walter J on 2022/04/01.
//

import UIKit
import GoogleMobileAds
import CoreLocation
import RealmSwift

class HomeVC: GADBaseVC {
    //Views
    //현재 날씨 정보 뷰들
    @IBOutlet weak var placeNameBackView: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var currStateLabel: UILabel!
    @IBOutlet weak var currWeatherBackground: UIImageView!
    @IBOutlet weak var currWeatherLabel: UILabel!
    @IBOutlet weak var alarmMemoLabelBackground: UIView!
    @IBOutlet weak var alarmMemoLabel: UILabel!
    @IBOutlet weak var BottomBannerView: UIView!
    
    //Model
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    private var parseCSV = ParsingCSV()
    private var model: WeatherModel?
    
    //delegate
    private let searchAreaModalVC = SearchModalVC()
    
    //Realm
    private var realm:Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        setupBannerViewToBottom()       //[Walter] 하단 적응형 광고 띄우기
        configureCurrWeatherViews()         //[Walter] View 모양 설정
        
        self.locationManager.delegate = self
        self.weatherManager.delegate = self
        
        self.searchAreaModalVC.delegate = self
        
        //날짜 표시
        
        
        // 날짜를 Date로
//        let dateStr = "2022-04-14 05:52"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
//        if let date:Date = dateFormatter.date(from: dateStr) {
//            print("날짜를 데이터 포맷으로 변경 : \(date)")
//        } else {
//            print("날짜를 데이터 포맷으로 변경하기 실패")
//        }
        
        // Date를 날짜로
//        let dateFormatter2 = DateFormatter()
//        let date = Date(timeIntervalSinceReferenceDate: 1649925797)
//
//        dateFormatter2.locale = Locale(identifier: "ko_KR")
//        dateFormatter2.setLocalizedDateFormatFromTemplate("yyyy-MM-dd hh:mm") // set template after setting locale
//        print("데이터 포맷을 날짜로 변경 : \(dateFormatter2.string(from: date))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Realm 데이터 확인
        checkRealmData()
    }
    
    func checkRealmData() {
        guard let savedData = realm else { return }
        let data = savedData.objects(RealmTest.self)
        print("Realm Data \(data), \(Realm.Configuration.defaultConfiguration.fileURL)")
    }
    
    //날씨 배경 모서리 둥글게
    func configureCurrWeatherViews() {
        self.currWeatherBackground.layer.cornerRadius = 15
        self.alarmMemoLabelBackground.layer.cornerRadius = 15
        self.placeNameBackView.layer.cornerRadius = 15
    }
    
    //현재 위치 좌표 가져오기 호출
    @IBAction func currLocationWeatherBtnAct(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    //지역 검색 모달 호출
    @IBAction func callSearchAreaModalBtnAct(_ sender: UIButton) {
        performSegue(withIdentifier: Keys.searchArea.segueId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Keys.homeToSearchAreaModal {
//            guard let searchAreaModal = storyboard?.instantiateViewController(withIdentifier: Keys.searchArea.storyboardId) else { return }
//        }
    }
}

//MARK: - SearchModalDelegate
extension HomeVC: SearchAreaModalDelegate {
    func searchedArea(coordinate: CLLocationCoordinate2D) {
        print("전달 받은 좌표 \(coordinate)")
    }
}

// MARK: - WeatherManager Delegate
extension HomeVC: WeatherManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel) {
        self.model = weather
        self.progressStop()
        DispatchQueue.main.async {
            //Update Views
            let si = weather.si
            let dong = weather.dong
            let cTemp = weather.currWeather.temp
            let cHumidity = weather.currWeather.humidity
//            let cWind_speed = weather.currWeather.wind_speed
            let cCloud = weather.currWeather.clouds
            let cDescription = weather.currWeather.descriptionKor
            
            self.placeNameLabel.text = "\(si) \(dong)"
            self.currStateLabel.text = "\(cDescription)"
            self.currWeatherLabel.text = "온도 \(cTemp)℃/ 습도 \(cHumidity)%/ 강우량 \(cCloud)%"
        }
    }
    
    func didFailWithError(error: Error) {
        print("오류!!! \(error)")
    }
}

// MARK: - CLLocation Delegate 현재 위치 날씨 가져올 때 사용
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted:
            //GPS 권한을 받지 못함
            print("권한을 받지 못한 상태")
            locationManager.requestWhenInUseAuthorization()
        case .denied, .authorized:
            //GPS 권한 요청을 거부함
            print("권한 요청을 거부함")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            //GPS 권한 요청을 수락
            print("권한 얻음")
            self.progressStart(onView: self.view)
            weatherManager.getWeatherWithName(name: "구운동")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
//            print("위치 정보 : 경도\(lat), 위도\(lon)")
            
            //현재 위치 정보를 기반으로 지역 검색
            weatherManager.getWeatherWithCoordinate(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("현재 위치 가져오기 오류 : \(error)")
    }
}
