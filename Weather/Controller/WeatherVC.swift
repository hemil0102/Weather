//
//  WeatherVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import UIKit
import CoreLocation

class WeatherVC: GADBaseVC {
    
    @IBOutlet weak var weatherViewBackground: UIImageView!       //[Walter] 웨더뷰 백그라운드 전체
    //[jongmin] 이미지 뷰
    @IBOutlet weak var detailView: UIView!
    
    //[jongmin] 이미지 뷰
    @IBOutlet weak var sunRiseImageView: UIImageView!
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var airIndexImageView: UIImageView!
    
    
    //[jongmin] 주간 날씨 표시용 테이블 뷰
    @IBOutlet weak var weatherDetailTableView: UITableView!
    
    //[jongmin] TEST 용
    @IBOutlet weak var testLabel: UILabel!
    
    

    //[jongmin] 임시 뷰 백그라운드 컬러
    var tempImage = [UIImage(systemName: "sunrise"), UIImage(systemName: "cloud.drizzle"), UIImage(systemName: "moon.stars")]
    var imageViews = [UIImageView]()
    
    //[jongmin] 날씨 api 인스턴스
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[Walter] 모양 설정
        configureGradientAtBackground()     //[Walter] 전체 배경에 그라데이션 설정
        configureWeatherDetailsViews()         //[Walter] View 모양 설정
        
        //[jongmin] 테이블 뷰 델리게이트
        weatherDetailTableView.delegate = self
        weatherDetailTableView.dataSource = self
        
        //[jongmin] 날씨 데이터 델리게이트
        weatherManager.delegate = self
        locationManager.delegate = self
    
        //[jongmin] 테이블 뷰 연결
        setTableViewXIBCell()
        
        //[Walter] 하단 적응형 광고 띄우기
        setupBannerViewToBottom()
    
        //[jongmin] 임시 대기정보 인스턴스 생성
        let tempInstance = AirPolutionManager()
        
        //[jongmin] 아이콘 이미지 세팅
        setImageView()
    
    }
    
    //[Walter] 백그라운드 전체에 그라데이션 주기
    func configureGradientAtBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.weatherViewBackground.bounds
        
        let colors:[CGColor] = [
            UIColor.systemTeal.cgColor,
            UIColor.white.cgColor
        ]
        
        gradientLayer.colors = colors
        self.weatherViewBackground.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //[Walter] 현재 날씨 상세화면 뷰들 설정
    func configureWeatherDetailsViews() {
        self.weatherViewBackground.layer.cornerRadius = 15
        self.weatherViewBackground.alpha = 0.5
        self.weatherViewBackground.backgroundColor = .systemTeal
        self.weatherViewBackground.layer.borderWidth = 1
        self.weatherViewBackground.layer.borderColor = UIColor.white.cgColor
    }
    
    func setTableViewXIBCell() {
        self.weatherDetailTableView.register(UINib(nibName: ViewIdentifier.weatherDetailCellIdentifier, bundle: nil), forCellReuseIdentifier: ViewIdentifier.weatherDetailCell)
    }
    
    func setImageView() {
        
        //[jongmin] 상세 뷰 백그라운드 설정
//        detailView.backgroundColor = UIColor(red: 243/255, green: 229/255, blue: 171/225, alpha: 0.8)
//        detailView.layer.cornerRadius = 10
        
        
        //[jongmin] 상세 뷰 아이콘 설정
        sunRiseImageView.image = UIImage(systemName: "sunrise.fill")
//        sunSetImageView.image = UIImage(systemName: "sunset.fill")
        humidityImageView.image = UIImage(systemName: "humidity.fill")
//        rainImageView.image = UIImage(systemName: "cloud.heavyrain")
//        cloudinessImageView.image = UIImage(systemName: "cloud.fill")
        airIndexImageView.image = UIImage(systemName: "aqi.medium")
    }
}

//[Walter] 이건 여기 왜 필요한가요?
extension WeatherVC: CLLocationManagerDelegate {
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

extension WeatherVC: WeatherManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel) {
        print("didUpdateWeatherViews")
        DispatchQueue.main.async {
            //Update Views
            let si = weather.si
            let dong = weather.dong
            let cTemp = weather.currWeather.temp
            let cHumidity = weather.currWeather.humidity
//            let cWind_speed = weather.currWeather.wind_speed
            let cCloud = weather.currWeather.clouds
            let cDescription = weather.currWeather.descriptionKor
            
            self.testLabel.text = "\(si), \(dong), \(cHumidity)"
            print("시...시...\(si)")
            print("동...동...\(dong)")
        }
    }
    
    func didFailWithError(error: Error) {
        print("날씨 못들고왔읍니다.. \(error)")
    }
}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //[jongmin] 테이블 뷰 개수 함수(프로토콜 필수 구현)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 //데이터 개수... 주간 데이터 개수 10개정도 스크롤뷰로 구현
    }
    
    //[jongmin] 테이블 뷰 데이터 세팅(프로토콜 필수 구현)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherDetailTableView.dequeueReusableCell(withIdentifier: ViewIdentifier.weatherDetailCellIdentifier) as! WeatherDetailCell
        
        //Cell 안의 View에 데이터 세팅하기
        let row = indexPath.row
        
        
        return cell
    }

}


