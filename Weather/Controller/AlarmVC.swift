//
//  AlarmVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import UIKit

/* [Harry - 알람 할일]
   1. 테이블 뷰 구현 및 레이아웃 지정 [   ]
   2. 변수지정, 알람이 추가되거나 삭제될 때 어떤 
 
*/

class AlarmVC: GADBaseVC {

    @IBOutlet weak var alarmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //[Harry] 데이터를 처리하기 위해 위임을 받는다.
        alarmTableView.dataSource = self
        //[Harry] AlarmCell.xib 등록하기
        alarmTableView.register(UINib(nibName: Keys.alarmCellNibName, bundle: nil), forCellReuseIdentifier: Keys.alarmCellIdentifier)
        //[Walter] 하단 적응형 광고 띄우기
        setupBannerViewToBottom()
    }
}

//[Harry] 테이블뷰의 데이터를 얻는 부분
extension AlarmVC: UITableViewDataSource {
    //[Harry] protocol stubs - 얼마나 많은 Raw와 Cell을 테이블뷰에 추가할 것인가?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //[Harry] protocol stubs - indexPath(테이블뷰 상의 위치)에 어떤 것을 보여줄 것인가?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alarmTableView.dequeueReusableCell(withIdentifier: Keys.alarmCellIdentifier, for: indexPath)
        cell.textLabel?.text = "This is a cell"
        return cell
    }
    
    
}
