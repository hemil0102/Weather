//
//  SearchModalVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/05.
//

import UIKit

class SearchModalVC: UIViewController {

    @IBOutlet weak var areaTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.areaTableView.delegate = self
        self.areaTableView.dataSource = self
        self.areaTableView.register(UINib(nibName: Keys.searchArea.cellName, bundle: nil), forCellReuseIdentifier: Keys.searchArea.cellId)
    }
}

//MARK: - TableViewDelegate
extension SearchModalVC: UITableViewDelegate {
    
}

//MARK: - TableViewDataSource
extension SearchModalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.searchArea.cellId) as! SearchAreaCell
        
        cell.weatherIconImageView.image = UIImage(named: "cloud.bolt.rain")
        cell.showCurrLocationLabel.isHidden = true
        cell.areaNameLabel.text = "수원시 구운동"
        cell.currTempLabel.text = "17℃"
        cell.currCloudLabel.text = "강우량 0%"
        
        return cell
    }
}
