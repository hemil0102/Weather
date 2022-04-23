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
    @IBOutlet weak var homeViewBackground: UIView!
    @IBOutlet weak var placeNameBackView: UIView!
    @IBOutlet weak var placeNameLabel: UIButton!
    
    //현재 날씨 뷰
    @IBOutlet weak var currWeatherBackground: UIImageView!
    @IBOutlet weak var currWeatehrIcon: UIImageView!
    @IBOutlet weak var currStateLabel: UILabel!
    @IBOutlet weak var currWeatherLabel: UILabel!
    
    //아침 8시 날씨 뷰
    @IBOutlet weak var at8Icon: UIImageView!
    @IBOutlet weak var at8StateLabel: UILabel!
    
    //오후 12시 30분 날씨 뷰
    @IBOutlet weak var at1230Icon: UIImageView!
    @IBOutlet weak var at1230StateLabel: UILabel!
    
    //저녁 6시 날씨 뷰
    @IBOutlet weak var at18Icon: UIImageView!
    @IBOutlet weak var at18StateLabel: UILabel!
    
    //알람 뷰
    @IBOutlet weak var alarmBacground: UIImageView!
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
    
    //상수
    let cornerRadius:CGFloat = 15           //백그라운드 모서리 라운드값
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        setupBannerViewToBottom()           //[Walter] 하단 적응형 광고 띄우기
        configureGradientAtBackground()     //[Walter] 전체 배경에 그라데이션 설정
        configureCurrWeatherViews()         //[Walter] View 모양 설정
        
        self.locationManager.delegate = self        //[Walter] 현재 위치 델리게이트
        self.weatherManager.delegate = self         //[Walter] 날씨 정보 델리게이트
        self.searchAreaModalVC.delegate = self      //[Walter] 지역 검색 델리게이트
        
        //UserDefualt의 값을 먼저 셋팅
        
        
        
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
//        checkRealmData()
    }
    
//    func checkRealmData() {
//        guard let savedData = realm else { return }
//        let data = savedData.objects(RealmTest.self)
//        print("Realm Data \(data), \(Realm.Configuration.defaultConfiguration.fileURL)")
//    }
    
    //[Walter] 백그라운드 전체에 그라데이션 주기
    func configureGradientAtBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.homeViewBackground.bounds
        
        let colors:[CGColor] = [
            UIColor.systemTeal.cgColor,
            UIColor.white.cgColor
        ]
        
        gradientLayer.colors = colors
//        gradientLayer.locations = [0.55]
        self.homeViewBackground.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //날씨 배경 모서리 둥글게
    func configureCurrWeatherViews() {
        self.currWeatherBackground.layer.cornerRadius = self.cornerRadius
        self.currWeatherBackground.alpha = 0.5
//        self.currWeatherBackground.backgroundColor = .clear
        self.currWeatherBackground.backgroundColor = .systemTeal
        self.currWeatherBackground.layer.borderWidth = 1
        self.currWeatherBackground.layer.borderColor = UIColor.white.cgColor
        
        self.alarmMemoLabelBackground.layer.cornerRadius = self.cornerRadius
        
        self.placeNameBackView.layer.cornerRadius = self.cornerRadius
        
        self.alarmBacground.layer.cornerRadius = self.cornerRadius
        self.alarmBacground.alpha = 0.5
//        self.alarmBacground.backgroundColor = .clear
        self.alarmBacground.backgroundColor = .systemTeal
        self.alarmBacground.layer.borderWidth = 1
        self.alarmBacground.layer.borderColor = UIColor.white.cgColor
    }
    
    //현재 위치 좌표 가져오기 호출
    @IBAction func currLocationWeatherBtnAct(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    //지역 검색 모달 호출
    @IBAction func callSearchAreaModalBtnAct(_ sender: UIButton) {
        performSegue(withIdentifier: Keys.searchArea.segueId, sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Keys.homeToSearchAreaModal {
//            guard let searchAreaModal = storyboard?.instantiateViewController(withIdentifier: Keys.searchArea.storyboardId) else { return }
//        }
//    }
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
            let cTemp = Int(trunc(weather.currWeather.temp))        //소수점 밑으로 버림
            let cHumidity = weather.currWeather.humidity
//            let cWind_speed = weather.currWeather.wind_speed
            let cCloud = weather.currWeather.clouds
            let cIcon = weather.currWeather.iconWithId
            let cDescription = weather.currWeather.descriptionKor
            
            self.placeNameLabel.setTitle("\(si) \(dong)", for: .normal)
            self.currWeatehrIcon.image = UIImage(systemName: cIcon)
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
//            weatherManager.getWeatherWithName(name: "수원시")        //지역명으로 날씨 가져오기
            locationManager.requestLocation()
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
            
            //네트워크 체크
            //현재 위치 정보를 기반으로 지역 검색
            weatherManager.getWeatherWithCoordinate(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("현재 위치 가져오기 오류 : \(error)")
    }
}
