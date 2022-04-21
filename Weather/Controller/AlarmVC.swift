//
//  AlarmVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import UIKit

/* [Harry - 알람 할일]
   1. 테이블 뷰 구현 []
   2. 테이블 뷰 레이아웃 지정 []
   3. 테이블 뷰 삭제 구현 []
   4. 테이블 뷰 추가 구현 []
   5. 테이블 뷰 수정 구현 []
 
*/

class AlarmVC: GADBaseVC {

    //[Harry] 변수 정의 부분
    var sectionOneCounter = 0 //섹션1에 띄울 셀을 카운트
    var sectionTwoCounter = 0 //섹션2에 띄울 셀을 카운트
    @IBOutlet weak var alarmTableView: UITableView!
    //[Harry] 목업 데이터
    let mockupData = [
        AlarmModel(alarmLocation: "수원시", alarmTime: "07:08", alarmMeridiem: "PM", alarmDayType: "매일", alarmWeekDay: ["월","화","수","목","금","토","일"], alarmIsEnable: true, alarmToDo: "작작 놀고 코딩해라.", alarmIsRepeat: true),
        AlarmModel(alarmLocation: "울산시", alarmTime: "02:00", alarmMeridiem: "PM", alarmDayType: "주말", alarmWeekDay: ["토"], alarmIsEnable: true, alarmToDo: "울산 바다 일광욕~", alarmIsRepeat: false),
        AlarmModel(alarmLocation: "서울시", alarmTime: "06:00", alarmMeridiem: "PM", alarmDayType: "평일", alarmWeekDay: ["수", "목"], alarmIsEnable: false, alarmToDo: "수원에서 자전거 타고 한강가기", alarmIsRepeat: true)
    ]
    
    var repeatedMockupData: [ AlarmModel ] = []
    var dailyMockupData: [ AlarmModel ] = []
    //[Harry] 함수 정의 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        //[Harry] 데이터를 처리하기 위해 위임을 받는다.
        alarmTableView.dataSource = self
        //[Harry] AlarmCell.xib 등록하기
        alarmTableView.register(UINib(nibName: Keys.alarmCellOneNibName, bundle: nil), forCellReuseIdentifier: Keys.alarmCellOneIdentifier)
        alarmTableView.register(UINib(nibName: Keys.alarmCellTwoNibName, bundle: nil), forCellReuseIdentifier: Keys.alarmCellTwoIdentifier)
        //[Harry] 알람 반복 여부에 따라 섹션에 띄울 셀 숫자를 알아내고 데이터를 분류하는 함수.
        sectionCounter()
        //[Walter] 하단 적응형 광고 띄우기
        setupBannerViewToBottom()
    }
    
    //[Harry] 알람 반복 여부에 따라 섹션에 띄울 셀 숫자를 알아내고 데이터를 분류하는 함수.
    func sectionCounter() {
        for i in 0..<mockupData.count {
            if mockupData[i].alarmIsRepeat == true {
                repeatedMockupData.append(mockupData[i])
                print("1번" + "\(repeatedMockupData)")
                sectionOneCounter += 1
            } else {
                dailyMockupData.append(mockupData[i])
                print("2번" + "\(dailyMockupData)")
                sectionTwoCounter += 1
            }
        }
    }
}

//[Harry] 테이블뷰의 데이터를 얻는 부분
extension AlarmVC: UITableViewDataSource {
    
    // ⭐️ Mark: - Section
    //[Harry] 테이블뷰 섹션 나누기
    func numberOfSections(in tableView: UITableView) -> Int {
        return alarmSectionHeader.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alarmSectionHeader[section]
    }

    // ⭐️ Mark: - Row Cell
    //[Harry] protocol stubs - 얼마나 많은 Raw와 Cell을 테이블뷰에 추가할 것인가?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //[Harry] sectionCounter()에서 계산된 셀 숫자에 맞게 띄우기
        if section == 0 {
            return sectionOneCounter
        } else {
            return sectionTwoCounter
        }
    }
    
    //[Harry] protocol stubs - indexPath(테이블뷰 상의 위치)에 어떤 것을 보여줄 것인가?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alarmTableView.dequeueReusableCell(withIdentifier: Keys.alarmCellOneIdentifier, for: indexPath) as! AlarmCell
        let cell2 = alarmTableView.dequeueReusableCell(withIdentifier: Keys.alarmCellTwoIdentifier, for: indexPath) as! AlarmCell2
        
        if indexPath.section == 0 {
            cell.alarmCellLocation.text = repeatedMockupData[indexPath.row].alarmLocation
            cell.alarmCellTime.text = repeatedMockupData[indexPath.row].alarmTime
            cell.alarmCellMeridiem.text = repeatedMockupData[indexPath.row].alarmMeridiem
            cell.alarmCellDayType.text = repeatedMockupData[indexPath.row].alarmDayType
            cell.alarmCellWeekday.text = ""
            for i in 0..<(repeatedMockupData[indexPath.row].alarmWeekDay?.count ?? 1) {
                cell.alarmCellWeekday.text! += ((repeatedMockupData[indexPath.row].alarmWeekDay?[i] ?? "월 화 수 목 금 토 일") + " ")
            }
            cell.alarmCellSwitch.isOn = repeatedMockupData[indexPath.row].alarmIsEnable ?? true
            cell.alarmCellToDo.text = "할일: " + (repeatedMockupData[indexPath.row].alarmToDo ?? "계획과 실천!")
            return cell
            
        } else {
            cell2.alarmCellLocation.text = dailyMockupData[indexPath.row].alarmLocation
            cell2.alarmCellTime.text = dailyMockupData[indexPath.row].alarmTime
            cell2.alarmCellMeridiem.text = dailyMockupData[indexPath.row].alarmMeridiem
            cell2.alarmCellDayType.text = dailyMockupData[indexPath.row].alarmDayType
            cell2.alarmCellWeekday.text = ""
            for i in 0..<(dailyMockupData[indexPath.row].alarmWeekDay?.count ?? 1) {
                cell2.alarmCellWeekday.text! += ((dailyMockupData[indexPath.row].alarmWeekDay?[i] ?? "월 화 수 목 금 토 일") + " ")
            }
            cell2.alarmCellSwitch.isOn = dailyMockupData[indexPath.row].alarmIsEnable ?? true
            cell2.alarmCellToDo.text = "*할일: " + (dailyMockupData[indexPath.row].alarmToDo ?? "계획과 실천!")
            return cell2
        }
        
    }
}
