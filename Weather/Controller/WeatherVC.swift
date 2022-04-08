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
    
    
    @IBOutlet weak var infoDetailScrollView: UIScrollView!
    @IBOutlet weak var infoDetailPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[종민] 테이블 뷰 델리게이트
        weatherDetailTableView.delegate = self
        weatherDetailTableView.dataSource = self
        
        //[종민] 테이블 뷰 연결
        setTableViewXIBCell()
        
        //[Walter] 하단 적응형 광고 띄우기
        setupBannerViewToBottom()
    }
    
    func setTableViewXIBCell() {
        self.weatherDetailTableView.register(UINib(nibName: ViewIdentifier.weatherDetailCellIdentifier, bundle: nil), forCellReuseIdentifier: ViewIdentifier.weatherDetailCell)
    }
}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
    
    //[종민] 테이블 뷰 개수 함수(프로토콜 필수 구현)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //데이터 개수... 주간 데이터 개수 10개정도 스크롤뷰로 구현
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

//[jongmin] 상세정보 페이지 컨트롤 익스텐션


    /*
     [종민]
     Weather 탭에서 보여줘야 할 정보 정리하기
     (일출 시간, 일몰 시간, 미세먼지, 기압, 습도, 가시거리, 풍속, 풍향), 아이콘/라벨 조합으로 뷰에서 내용만 보여주기 설명 불필요.
     
     Slider Collection View 활용
     
     */
