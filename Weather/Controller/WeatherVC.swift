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
    
    //[jongmin] 일일 날씨 상세 정보용 스크롤 뷰/페이지 컨트롤
    @IBOutlet weak var infoDetailScrollView: UIScrollView!
    @IBOutlet weak var infoDetailPageControl: UIPageControl!
    
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
        
        //[jongmin] 스크롤 뷰 델리게이트
        infoDetailScrollView.delegate = self
        addContentScrollView()
        setPageControl()
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


//[jongmin] 가로 스크롤뷰+페이지뷰 구현 익스텐션
extension WeatherVC: UIScrollViewDelegate {
    
    //[jongmin] 스크롤뷰에 이미지 서브뷰 삽입
    func addContentScrollView() {
        for i in 0 ..< tempImage.count {
            let imageView = UIImageView()
            let xPos = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: infoDetailScrollView.bounds.width, height: infoDetailScrollView.bounds.height)
            imageView.image = tempImage[i] //[jongmin] 이부위 나중에 뷰로 대체해서 넣을 예정
            infoDetailScrollView.addSubview(imageView) //[jongmin] 스크롤 뷰에 이미지 서브뷰 삽입
            infoDetailScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1) //스크롤 뷰 폭 정의
        }
    }
    
    //[jongmin] 페이지 컨트롤 초기 설정
    func setPageControl() {
        //[jongmin] 페이지 컨트롤 개수
        infoDetailPageControl.numberOfPages = tempImage.count
        //[jongmin] 페이지 뷰 도트 색
        infoDetailPageControl.pageIndicatorTintColor = .lightGray
        //[jongmin] 현재 페이지 도트 색
        infoDetailPageControl.currentPageIndicatorTintColor = .black
    }
    
    //[jongmin] 스크롤 뷰 세팅
    func setPageControlSelectedPage(currentPage: Int) {
        infoDetailPageControl.currentPage = currentPage
    }
    
    //[jongmin] 스크롤뷰 오프셋/폭 사이즈 비율에 따라서 페이지 컨트롤 현재 페이지 결정
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = infoDetailScrollView.contentOffset.x/infoDetailScrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}



    /*
     [Jongmin]
     Weather 탭에서 보여줘야 할 정보 정리하기
     (일출 시간, 일몰 시간, 미세먼지, 기압, 습도, 가시거리, 풍속, 풍향), 아이콘/라벨 조합으로 뷰에서 내용만 보여주기 설명 불필요.
     
     Slider Collection View 활용[?]
     
     상세정보 뷰 코드로 작성하는것 시도
     
     */
