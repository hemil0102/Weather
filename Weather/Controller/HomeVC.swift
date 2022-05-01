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
    @IBOutlet weak var currWeatherBackground: UIView!
    @IBOutlet weak var areaNameLabel: UILabel!
    
    //현재 큰 아이콘, 날씨 상태, 온도 뷰
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
    @IBOutlet weak var alarmBackground: UIView!
    @IBOutlet weak var alarmClockImageView: UIImageView!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var dayOfWeekToRepeatLabel: UILabel!
    @IBOutlet weak var alarmMemoLabel: UILabel!
    @IBOutlet weak var addNewAlarmBtn: UIButton!
    
    //Model
    private var parseCSV = ParsingCSV()
    private var weather: WeatherModel?
    private var air: AirPolutionModel?
    
    //시간별 날씨 리스트를 위한 매니저
    private var hourlyListManager: HourlyListManager?
    
    //Realm [Harry] 마이그레이션을 위한 코드 추가
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //모양 설정
        setupBannerViewToBottom()           //[Walter] 하단 적응형 광고 띄우기
        configureGradientAtBackground()     //[Walter] 전체 배경에 그라데이션 설정
        configureCurrWeatherViews()         //[Walter] View 모양 설정
        
        //WeatherModel의 현재 날씨를 뷰에 셋팅
        configureWeatherAndAirData()            //[Walter] 전역 변수에 데이터 셋팅
        settingWeatherToViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //알람 체크
        checkAndLoadAlarm()
    }
    
//    func checkRealmData() {
//        guard let savedData = realm else { return }
//        let data = savedData.objects(RealmForAlarm.self)
//        print("Realm Data \(data), \(Realm.Configuration.defaultConfiguration.fileURL)")
//    }
    
    //[Walter] 백그라운드 전체에 그라데이션 주기
    private func configureGradientAtBackground() {
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
    private func configureCurrWeatherViews() {
        setCornerToBackground(view: self.currWeatherBackground)     //현재 날씨 배경 모양 설정
        setCornerToBackground(view: self.alarmBackground)       //알람 배경 모양 설정
    }
    
    private func setCornerToBackground(view: UIView) {
        let cornerRadius:CGFloat = 15   //백그라운드 모서리 라운드값
        view.layer.cornerRadius = cornerRadius
    }
    
    //전역 변수로 데이터 옮기기
    private func configureWeatherAndAirData() {
        guard let data = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let weather = data.weather else { return }
        guard let air = data.air else { return }
        
        self.weather = weather
        self.hourlyListManager = HourlyListManager(model: weather.hourly)
        self.air = air
    }
    
    //뷰에 데이터 셋팅
    private func settingWeatherToViews() {
        guard let weather = self.weather else { return }
        guard let air = self.air else { return }

        print("현재 날씨, 미세먼지 수준 : \(weather) \n \(air)")
        
        self.areaNameLabel.text = "\(weather.si) \(weather.dong)"
        
        self.currWeatehrIcon.image = UIImage(systemName: weather.currWeather.iconWithId)
        self.currStateLabel.text = weather.currWeather.descriptionKor
        self.currTempLabel.text = "\(weather.currWeather.tempStr)˚"
        self.currHumidityLabel.text = "\(weather.currWeather.humidity)%"
        self.currRainLabel.text = "\(weather.currWeather.rain)%"
        self.currAirConditionLabel.text = "\(air.cPM2_5)"
    }
    
    //알람 확인 및 알람 뷰 셋팅
    private func checkAndLoadAlarm() {
//        print("\(Realm.Configuration.defaultConfiguration.fileURL)")
        
        let realmData = realm.objects(RealmForAlarm.self).sorted(byKeyPath: "idx")
        let last = realmData.count-1
//        let last = 0
        if realmData.count == 0 {
            self.addNewAlarmBtn.isHidden = false
        } else {
            self.addNewAlarmBtn.isHidden = true
       
//            let predicateQuery = NSPredicate(format: "name = %@", "kim") // 쿼리
//            let result = savedShifts.books(predicateQuery)
            
            self.alarmTimeLabel.text = "\(realmData[last].meridiem) \(realmData[last].time)"
            self.alarmMemoLabel.text = realmData[last].toDo
            self.dayOfWeekToRepeatLabel.text = realmData[last].date
        }
    }
    
    //지역 검색 모달 호출
    @IBAction func callSearchAreaModalBtnAct(_ sender: UIButton) {
        performSegue(withIdentifier: Keys.SearchArea.segueId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.SearchArea.segueId {
            guard let searchAreaModal = storyboard?.instantiateViewController(withIdentifier: Keys.SearchArea.storyboardId) as? SearchModalVC else { return }
            searchAreaModal.delegate = self
        }
    }
    
    @IBAction func goToAddNewAlarm(_ sender: UIButton) {
        //알람 설정 탭으로 가기
        performSegue(withIdentifier: Keys.EditAlarm.segueId, sender: self)
    }
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

            var finalTime = ""
            if indexPath.row == 0 {
                finalTime = "지금"
            } else {
                finalTime = convertDtToTime.dtToTimeString(dateWithUTC: TimeInterval(hourly.dt))
            }
            
            cell.timeLabel.text = finalTime
            cell.weatherIcon.image = UIImage(systemName: hourly.iconWithId)
        
            if Int(hourly.pop*100) == 0 {
                cell.tempLabel.text = "\(hourly.tempStr)˚"
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
