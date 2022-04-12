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

    //[Harry] 변수 정의 부분
    @IBOutlet weak var alarmTableView: UITableView!
    //[Harry] 목업 데이터
    let MockupData = [
        AlarmModel(alarmLocation: "수원시", alarmTime: "07:08", alarmMeridiem: "PM", alarmDayType: "매일", alarmWeekDay: ["월","화","수","목","금","토","일"], alarmIsEnable: true, alarmToDo: "작작 놀고 코딩해라.", alarmIsRepeat: true),
        AlarmModel(alarmLocation: "울산시", alarmTime: "02:00", alarmMeridiem: "PM", alarmDayType: "주말", alarmWeekDay: ["토"], alarmIsEnable: true, alarmToDo: "울산 바다 일광욕~", alarmIsRepeat: false),
        AlarmModel(alarmLocation: "서울시", alarmTime: "06:00", alarmMeridiem: "PM", alarmDayType: "평일", alarmWeekDay: ["수", "목"], alarmIsEnable: false, alarmToDo: "수원에서 자전거 타고 한강가기", alarmIsRepeat: true)
    ]
    
    //[Harry] 함수 정의 부분
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
    
    // Mark: - Section
    //[Harry] 테이블뷰 섹션 나누기
    func numberOfSections(in tableView: UITableView) -> Int {
        return alarmSectionHeader.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alarmSectionHeader[section]
    }

    // Mark: - Row Cell
    
    //[Harry] protocol stubs - 얼마나 많은 Raw와 Cell을 테이블뷰에 추가할 것인가?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MockupData.count
    }
    
    //[Harry] protocol stubs - indexPath(테이블뷰 상의 위치)에 어떤 것을 보여줄 것인가?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alarmTableView.dequeueReusableCell(withIdentifier: Keys.alarmCellIdentifier, for: indexPath) as! AlarmCell
        

            cell.alarmCellLocation.text = MockupData[indexPath.row].alarmLocation
            cell.alarmCellTime.text = MockupData[indexPath.row].alarmTime
            cell.alarmCellMeridiem.text = MockupData[indexPath.row].alarmMeridiem
            cell.alarmCellDayType.text = MockupData[indexPath.row].alarmDayType
            cell.alarmCellWeekday.text = ""
            for i in 0..<MockupData[indexPath.row].alarmWeekDay.count {
                cell.alarmCellWeekday.text! += (MockupData[indexPath.row].alarmWeekDay[i] + " ")
            }
            cell.alarmCellSwitch.isOn = MockupData[indexPath.row].alarmIsEnable
            cell.alarmCellToDo.text = "할일: " + MockupData[indexPath.row].alarmToDo
            
        return cell
    }
}
