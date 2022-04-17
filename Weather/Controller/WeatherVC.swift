//
//  WeatherVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import UIKit

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
    

    //[jongmin] 임시 뷰 백그라운드 컬러
    var tempImage = [UIImage(systemName: "sunrise"), UIImage(systemName: "cloud.drizzle"), UIImage(systemName: "moon.stars")]
    var imageViews = [UIImageView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //[jongmin] 테이블 뷰 델리게이트
        weatherDetailTableView.delegate = self
        weatherDetailTableView.dataSource = self
    
        
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

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
    
    //[jongmin] 테이블 뷰 개수 함수(프로토콜 필수 구현)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 //데이터 개수... 주간 데이터 개수 10개정도 스크롤뷰로 구현
    }
    //[jongmin] 테이블 뷰 데이터 세팅(프로토콜 필수 구현)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherDetailTableView.dequeueReusableCell(withIdentifier: ViewIdentifier.weatherDetailCellIdentifier) as! WeatherDetailCell
        
        //Cell 안의 View에 데이터 세팅하기
        let row = indexPath.row
        
        cell.weatherDetailData1.text = "data1"
        cell.weatherDetailData2.text = "data2"
        
        return cell
    }

}

