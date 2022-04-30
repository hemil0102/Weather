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
    
    //현재 큰 아이콘, 날씨 상태, 온도 뷰
    @IBOutlet weak var currWeatherBackground: UIImageView!
    @IBOutlet weak var currWeatehrIcon: UIImageView!
    @IBOutlet weak var currStateLabel: UILabel!
    @IBOutlet weak var currTempLabel: UILabel!
    
    //습도, 강우량, 미세먼지 뷰
    @IBOutlet weak var currHumidityLabel: UILabel!
    @IBOutlet weak var currRainLabel: UILabel!
    @IBOutlet weak var currAirConditionLabel: UILabel!
    
    //시간별 날씨 뷰
    @IBOutlet weak var hourlyWeatherList: UICollectionView!
    
    //알람 뷰
    @IBOutlet weak var alarmBackground: UIImageView!
    @IBOutlet weak var alarmMemoLabelBackground: UIView!
    @IBOutlet weak var alarmMemoLabel: UILabel!
    
    //Model
    private var parseCSV = ParsingCSV()
    private var weather: WeatherModel?
    private var air: AirPolutionModel?
    
    //시간별 날씨 리스트를 위한 매니저
    private var hourlyListManager: HourlyListManager?
    
    //delegate
    private let searchAreaModalVC = SearchModalVC()
    
    //Realm [Harry] 마이그레이션을 위한 코드 추가
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    //상수
    let cornerRadius:CGFloat = 15           //백그라운드 모서리 라운드값
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //realm = try! Realm()
        
        setupBannerViewToBottom()           //[Walter] 하단 적응형 광고 띄우기
//        configureGradientAtBackground()     //[Walter] 전체 배경에 그라데이션 설정
        configureCurrWeatherViews()         //[Walter] View 모양 설정
        
        self.searchAreaModalVC.delegate = self      //[Walter] 지역 검색 델리게이트
        
        //WeatherModel의 현재 날씨를 뷰에 셋팅
        configureWeatherAndAirData()            //[Walter] 전역 변수에 데이터 셋팅
        settingWeatherToViews()
        
//        print("\(Realm.Configuration.defaultConfiguration.fileURL)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Realm 데이터 확인
//        checkRealmData()
    }
    
//    func checkRealmData() {
//        guard let savedData = realm else { return }
//        let data = savedData.objects(RealmForAlarm.self)
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
        //지역명 배경 모양 설정
        self.placeNameBackView.layer.cornerRadius = self.cornerRadius
        
        //현재 날씨 배경 모양 설정
        self.currWeatherBackground.layer.cornerRadius = self.cornerRadius
        self.currWeatherBackground.backgroundColor = .clear
        self.currWeatherBackground.layer.borderWidth = 1
        self.currWeatherBackground.layer.borderColor = UIColor.white.cgColor
        
        //알람 배경 모양 설정
        self.alarmBackground.layer.cornerRadius = self.cornerRadius
        self.alarmBackground.backgroundColor = .clear
        self.alarmBackground.layer.borderWidth = 1
        self.alarmBackground.layer.borderColor = UIColor.white.cgColor
        
        //알람.한줄메모 배경 모양 설정
        self.alarmMemoLabelBackground.layer.cornerRadius = self.cornerRadius
        
        //시간별 날씨 리스트 배경 모양 설정
        self.hourlyWeatherList.layer.cornerRadius = self.cornerRadius
        self.hourlyWeatherList.backgroundColor = .clear
        self.hourlyWeatherList.layer.borderWidth = 1
        self.hourlyWeatherList.layer.borderColor = UIColor.white.cgColor
    }
    
    //전역 변수로 데이터 옮기기
    func configureWeatherAndAirData() {
        guard let data = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let weather = data.weather else { return }
        guard let air = data.air else { return }
        
        self.weather = weather
        self.hourlyListManager = HourlyListManager(model: weather.hourly)
        self.air = air
    }
    
    //뷰에 데이터 셋팅
    func settingWeatherToViews() {
        guard let weather = self.weather else { return }
        guard let air = self.air else { return }

        print("현재 날씨, 미세먼지 수준 : \(weather) \n \(air)")
        
        self.placeNameLabel.setTitle("\(weather.si) \(weather.dong)", for: .normal)
        
        self.currWeatehrIcon.image = UIImage(systemName: weather.currWeather.iconWithId)
        self.currStateLabel.text = weather.currWeather.descriptionKor
        self.currTempLabel.text = "\(weather.currWeather.tempStr)℃"
        self.currHumidityLabel.text = "\(weather.currWeather.humidity)%"
        self.currRainLabel.text = "\(weather.currWeather.rain)%"
        self.currAirConditionLabel.text = "\(air.cPM2_5)"
    }
    
    //현재 위치 좌표 가져오기 호출
    @IBAction func currLocationWeatherBtnAct(_ sender: UIButton) {
//        locationManager.requestLocation()
    }
    
    //지역 검색 모달 호출
    @IBAction func callSearchAreaModalBtnAct(_ sender: UIButton) {
        performSegue(withIdentifier: Keys.SearchArea.segueId, sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Keys.homeToSearchAreaModal {
//            guard let searchAreaModal = storyboard?.instantiateViewController(withIdentifier: Keys.searchArea.storyboardId) else { return }
//        }
//    }
}

//MARK: - 시간별 날씨 예측 Delegate
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hourlyListManager?.getCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Keys.HourlyCell.cellId, for: indexPath) as? HourlyWeatherListCell else { return UICollectionViewCell() }
        
        let convertDtToTime = ConvertDateFormat()
        if let hourlyData = self.hourlyListManager {
            let hourly = hourlyData.getHoulyWeatherAt(at: indexPath.row)
            let time = convertDtToTime.dtToTimeString(dateWithUTC: TimeInterval(hourly.dt))
            cell.timeLabel.text = time
            cell.weatherIcon.image = UIImage(systemName: hourly.iconWithId)
        
            if Int(hourly.pop*100) == 0 {
                cell.tempLabel.text = "\(hourly.tempStr)℃"
            } else {
                cell.tempLabel.text = "\(Int(hourly.pop * 100))%"
            }
        }
        
        return cell
    }
}

//MARK: - 지역 검색 모달 뷰에서 좌표를 얻어오는 Delegate
extension HomeVC: SearchAreaModalDelegate {
    func searchedArea(coordinate: CLLocationCoordinate2D) {
        print("전달 받은 좌표 \(coordinate)")
    }
}
