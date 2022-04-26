//
//  SearchModalVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/05.
//

import UIKit
import MapKit

protocol SearchAreaModalDelegate {
    func searchedArea(coordinate: CLLocationCoordinate2D)
}

class SearchModalVC: UIViewController {
    //Views
    @IBOutlet weak var textFieldBackground: UIView!
    @IBOutlet weak var searchViewBackground: UIView!
    @IBOutlet weak var currAreaStackView: UIStackView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var areaTableView: UITableView!
    
    //Model
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    var completerResults: [MKLocalSearchCompletion]?
    
    //delegate
    var delegate: SearchAreaModalDelegate?
    
    private var places: MKMapItem? {
        didSet {
            areaTableView.reloadData()
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[Walter] 모양잡기
        configureBackground()
        
        //[Walter] 지역 자동 검색에 필요한 정의 및 델리게이트 선언
        self.searchCompleter = MKLocalSearchCompleter()
        self.searchTextField.delegate = self
        self.searchCompleter?.delegate = self
        self.searchCompleter?.resultTypes = .address
        self.searchCompleter?.region = searchRegion
        
        self.searchTextField.becomeFirstResponder()
        
        //[Walter] 테이블 뷰 델리게이트 선언
        self.areaTableView.delegate = self
        self.areaTableView.dataSource = self
        self.areaTableView.register(UINib(nibName: Keys.SearchArea.cellName, bundle: nil), forCellReuseIdentifier: Keys.SearchArea.cellId)
    }
    
    func configureBackground() {
        self.textFieldBackground.layer.cornerRadius = 15
    }
    
    @IBAction func closeBtnAct(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Completer는 수명이 긴 객체이기에 해제해줘야 함
        super.viewDidDisappear(animated)
        searchCompleter = nil
    }
    
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    private func search(using searchRequest: MKLocalSearch.Request) {
        // 검색 지역 설정
        searchRequest.region = searchRegion
        
        // 검색 유형 설정
        searchRequest.resultTypes = .pointOfInterest
        // MKLocalSearch 생성
        localSearch = MKLocalSearch(request: searchRequest)
        // 비동기로 검색 실행
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                return
            }
            // 검색한 결과 : reponse의 mapItems 값을 가져온다.
            self.places = response?.mapItems[0]
            
            print("검색된 위치의 위경도 : \(places?.placemark.coordinate)") // 위경도 가져옴
            if let coordinate = places?.placemark.coordinate {
                self.delegate?.searchedArea(coordinate: coordinate)
                dismiss(animated: true, completion: nil)
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension SearchModalVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("textFieldDidChangeSelection()")
//        if textField.text == "" {
//            completerResults = nil
//        }
        
        if let text = textField.text {
            searchCompleter?.queryFragment = text
        }
    }
}

//MARK: - SearchBarDelegate
extension SearchModalVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        areaTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
}

//MARK: - TableViewDelegate
extension SearchModalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.searchTextField.resignFirstResponder()
//        dismiss(animated: true, completion: nil)
        
        if let suggestion = completerResults?[indexPath.row] {
            self.search(for: suggestion)
//            print("선택된 지역 \(suggestion)")
        }
    }
}

//MARK: - TableViewDataSource
extension SearchModalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.SearchArea.cellId) as! SearchAreaCell
        
//        cell.weatherIconImageView.image = UIImage(named: "cloud.bolt.rain")
//        cell.showCurrLocationLabel.isHidden = true
//        cell.areaNameLabel.text = "수원시 구운동"
        //        cell.currTempLabel.text = "17℃"
        //        cell.currCloudLabel.text = "강우량 0%"
        
        if let suggestion = completerResults?[indexPath.row] {
            cell.showCurrLocationLabel.isHidden = true
            cell.showCurrLocationIcon.isHidden = true
            cell.searchedAreaNameLabel.text = suggestion.title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }
}
