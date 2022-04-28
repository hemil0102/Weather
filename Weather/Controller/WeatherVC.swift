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
    
    //[jongmin] 주간 날씨 표시용 테이블 뷰
    @IBOutlet weak var weatherDetailTableView: UITableView!
    
    //[jongmin] TEST 용
    @IBOutlet weak var testLabel: UILabel!
    
    //[jongmin] Model
    private var weather: WeatherModel?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[Walter] 모양 설정
        configureGradientAtBackground()     //[Walter] 전체 배경에 그라데이션 설정
        
        //[jongmin] 테이블 뷰 델리게이트
        weatherDetailTableView.delegate = self
        weatherDetailTableView.dataSource = self
    
        //[jongmin] 테이블 뷰 연결
        setTableViewXIBCell()
        
        //[Walter] 하단 적응형 광고 띄우기
        setupBannerViewToBottom()
        
        //[jongmin] 불러온 api 데이터 저장
        configureWeatherAndAirData()
    }
    
    //[Walter] 백그라운드 전체에 그라데이션 주기
    func configureGradientAtBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.detailView.bounds
        
        let colors:[CGColor] = [
            UIColor.systemTeal.cgColor,
            UIColor.white.cgColor
        ]
        
        gradientLayer.colors = colors
        self.detailView.layer.insertSublayer(gradientLayer, at: 0)
    }


    
    func setTableViewXIBCell() {
        self.weatherDetailTableView.register(UINib(nibName: ViewIdentifier.weatherDetailCellIdentifier, bundle: nil), forCellReuseIdentifier: ViewIdentifier.weatherDetailCell)
    }
    
    //전역 변수로 데이터 옮기기
    func configureWeatherAndAirData() {
        guard let data = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let weather = data.weather else { print("no Api data"); return }
        //guard let air = data.air else { return }
        
        self.weather = weather
        //self.air = air
    }
    
}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //[jongmin] 테이블 뷰 개수 함수(프로토콜 필수 구현)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.daily.count ?? 0
    }
    
    //[jongmin] 테이블 뷰 데이터 세팅(프로토콜 필수 구현)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherDetailTableView.dequeueReusableCell(withIdentifier: ViewIdentifier.weatherDetailCellIdentifier) as! WeatherDetailCell
        
        //Cell 안의 View에 데이터 세팅하기
        let row = indexPath.row //인덱스
        
        cell.minTemp.text = String(weather?.daily[row].min ?? -1)
        cell.maxTemp.text = String(weather?.daily[row].max ?? -1)
        
        return cell
    }
}


