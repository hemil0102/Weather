//
//  WeatherVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import UIKit

class WeatherVC: GADBaseVC {

    //[jongmin] 주간 날씨 표시용 테이블 뷰
    @IBOutlet weak var weatherDetailTableView: UITableView!
    
    @IBOutlet weak var sunRiseImageView: UIImageView!
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
    }
    
    func setTableViewXIBCell() {
        self.weatherDetailTableView.register(UINib(nibName: ViewIdentifier.weatherDetailCellIdentifier, bundle: nil), forCellReuseIdentifier: ViewIdentifier.weatherDetailCell)
    }
}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
    
    //[종민] 테이블 뷰 개수 함수(프로토콜 필수 구현)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 //데이터 개수... 주간 데이터 개수 10개정도 스크롤뷰로 구현
    }
    //[종민] 테이블 뷰 데이터 세팅(프로토콜 필수 구현)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherDetailTableView.dequeueReusableCell(withIdentifier: ViewIdentifier.weatherDetailCellIdentifier) as! WeatherDetailCell
        
        //Cell 안의 View에 데이터 세팅하기
        let row = indexPath.row
        
        cell.weatherDetailData1.text = "data1"
        cell.weatherDetailData2.text = "data2"
        
        return cell
    }
}


    /*
     [Jongmin]
     Weather 탭에서 보여줘야 할 정보 정리하기
     (일출 시간, 일몰 시간, 미세먼지, 기압, 습도, 가시거리, 풍속, 풍향), 아이콘/라벨 조합으로 뷰에서 내용만 보여주기 설명 불필요.
     
     Slider Collection View 활용[?]
     
     상세정보 뷰 코드로 작성하는것 시도
     
     [jongmin] 220410
     상세화면 있는 이유는 홈에 없는 추가 정보를 제공하기 위해 있는것.
     
     1. 상단에는 진짜 유용한 정보만 보여주고, 더 상세한 정보는 버튼으로 만들어서 팝업뷰로(이건 여력이 된다면..)
        (일출시간, 일몰시간, 습도, 강우확률, 운량, 미세먼지 지수)
     
     2. 주간 테이블뷰
     
     */
