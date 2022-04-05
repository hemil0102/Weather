//
//  WeatherVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import UIKit

class WeatherVC: GADBaseVC {
    
    //임시 데이터 생성
    var weatherDetailDataArr: [WeatherDetailData] = [] //나중에 긁어온 데이터로..
    let weatherData1: WeatherDetailData = WeatherDetailData(data1: "data11", data2: "data21")
    let weatherData2: WeatherDetailData = WeatherDetailData(data1: "data21", data2: "data22")

    @IBOutlet weak var weatherDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[종민] 임시 데이터 생성
        weatherDetailDataArr.append(weatherData1)
        weatherDetailDataArr.append(weatherData2)
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDetailDataArr.count //테이블 뷰 개수
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherDetailTableView.dequeueReusableCell(withIdentifier: ViewIdentifier.weatherDetailCellIdentifier) as! WeatherDetailCell
        
        //Cell 안의 View에 데이터 세팅하기
        let row = indexPath.row
        
        cell.weatherDetailData1.text = weatherDetailDataArr[row].data1
        cell.weatherDetailData2.text = weatherDetailDataArr[row].data2
        
        return cell
    }
    
    
    
}

