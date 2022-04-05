//
//  ViewController.swift
//  Weather
//
//  Created by Walter J on 2022/04/01.
//

import UIKit
import GoogleMobileAds

class HomeVC: GADBaseVC {
    //Views
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var conditionIdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //Model
    var weather = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[Walter] 하단 적응형 광고 띄우기
        setupBannerViewToBottom()
        
        weather.delegate = self
        weather.getCurrWeather(cityName: "suwon")       //[Walter] 입력샘플
    }
}

// MARK: - WeatherManager Delegate
extension HomeVC: WeatherManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel) {
        DispatchQueue.main.async {
            //Update Views
            self.cityNameLabel.text = weather.name
            self.currTempLabel.text = "\(weather.temp)"
            self.minTempLabel.text = "\(weather.temp_min)"
            self.maxTempLabel.text = "\(weather.temp_max)"
            self.humidityLabel.text = "\(weather.humidity)"
            self.conditionIdLabel.text = "\(weather.conditionId)"
            self.descriptionLabel.text = weather.description
        }
    }
    
    func didFailWithError(error: Error) {
        print("오류!!! \(error)")
    }
    
    
}
