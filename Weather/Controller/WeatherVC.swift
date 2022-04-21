//
//  WeatherVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import UIKit
import CoreLocation

class WeatherVC: GADBaseVC {
    
    //[jongmin] 이미지 뷰
    @IBOutlet weak var detailView: UIView!
    
    //[jongmin] 이미지 뷰
    @IBOutlet weak var sunRiseImageView: UIImageView!
    @IBOutlet weak var sunSetImageView: UIImageView!
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var rainImageView: UIImageView!
    @IBOutlet weak var cloudinessImageView: UIImageView!
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
    
    func setTableViewXIBCell() {
        self.weatherDetailTableView.register(UINib(nibName: ViewIdentifier.weatherDetailCellIdentifier, bundle: nil), forCellReuseIdentifier: ViewIdentifier.weatherDetailCell)
    }
    
    func setImageView() {
        
        //[jongmin] 상세 뷰 백그라운드 설정
        detailView.backgroundColor = UIColor(red: 243/255, green: 229/255, blue: 171/225, alpha: 0.8)
        detailView.layer.cornerRadius = 10
        
        
        //[jongmin] 상세 뷰 아이콘 설정
        sunRiseImageView.image = UIImage(systemName: "sunrise.fill")
        sunSetImageView.image = UIImage(systemName: "sunset.fill")
        humidityImageView.image = UIImage(systemName: "humidity.fill")
        rainImageView.image = UIImage(systemName: "cloud.heavyrain")
        cloudinessImageView.image = UIImage(systemName: "cloud.fill")
        airIndexImageView.image = UIImage(systemName: "aqi.medium")
    }

}
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


