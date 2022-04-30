//
//  AlarmVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import UIKit
import RealmSwift

/* [Harry - 알람 할일]
   1. 테이블 뷰 구현 []
   2. 테이블 뷰 레이아웃 지정 []
   3. 테이블 뷰 삭제 구현 []
   4. 테이블 뷰 추가 구현 []
   5. 테이블 뷰 수정 구현 []
 
*/

class AlarmVC: GADBaseVC {

    //[Harry] Realm
    lazy var realm : Realm = {
        return try! Realm()
    }()
    
    //[Harry] 변수 정의 부분
    var sectionOneCounter = 0 //섹션1에 띄울 셀을 카운트
    var sectionTwoCounter = 0 //섹션2에 띄울 셀을 카운트
    @IBOutlet weak var alarmTableView: UITableView!
    
    //[Harry] 목업 데이터
    let mockupData = [
        AlarmModel( alarmTime: "07:08", alarmMeridiem: "PM", alarmWeekDay: ["월","화","수","목","금","토","일"], alarmIsEnable: true, alarmToDo: "작작 놀고 코딩해라.", alarmIsRepeat: true),
        AlarmModel( alarmTime: "02:00", alarmMeridiem: "PM", alarmWeekDay: ["토"], alarmIsEnable: true, alarmToDo: "울산 바다 일광욕~", alarmIsRepeat: false),
        AlarmModel( alarmTime: "06:00", alarmMeridiem: "PM", alarmWeekDay: ["수", "목"], alarmIsEnable: false, alarmToDo: "수원에서 자전거 타고 한강가기", alarmIsRepeat: true)
    ]
    
    
    var repeatedMockupData: [ RealmForAlarm ] = []
    var dailyMockupData: [ RealmForAlarm ] = []
    //[Harry] 함수 정의 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        //[Harry] 데이터를 처리하기 위해 위임을 받는다.
        alarmTableView.dataSource = self
        //[Harry] AlarmCell.xib 등록하기
        alarmTableView.register(UINib(nibName: Keys.alarmCellOneNibName, bundle: nil), forCellReuseIdentifier: Keys.alarmCellOneIdentifier)
        alarmTableView.register(UINib(nibName: Keys.alarmCellTwoNibName, bundle: nil), forCellReuseIdentifier: Keys.alarmCellTwoIdentifier)
        //[Walter] 하단 적응형 광고 띄우기
        setupBannerViewToBottom()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //[Harry] 알람 반복 여부에 따라 섹션에 띄울 셀 숫자를 알아내고 데이터를 분류하는 함수.
        sectionCounter()
        alarmTableView.reloadData()
        //sectionCounter()
        //[Harry] 렐름 데이터 불러오기
        //realmData = checkRealmData()
        //print("@!@!@!\(realmData.count)")
    }

    
    //[Harry] 알람 반복 여부에 따라 섹션에 띄울 셀 숫자를 알아내고 데이터를 분류하는 함수.
    /* func sectionCounter() {
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
    } */
    
    //[Harry] 알람 반복 여부에 따라 섹션에 띄울 셀 숫자를 알아내고 데이터를 분류하는 함수.
    func sectionCounter() {
        let realmData: [RealmForAlarm] = Array(realm.objects(RealmForAlarm.self))
        sectionOneCounter = 0 // 리로드될 때 초기화
        sectionTwoCounter = 0 // 리로드될 때 초기화
        repeatedMockupData = []
        dailyMockupData = []
        
        for i in 0..<realmData.count {
            if realmData[i].isRepeat == true {
                repeatedMockupData.append(realmData[i])
                print("1번" + "\(repeatedMockupData)")
                sectionOneCounter += 1
            } else {
                dailyMockupData.append(realmData[i])
                print("2번" + "\(dailyMockupData)")
                sectionTwoCounter += 1
            }
        }
    }
    
    //[Harry] 렐름 데이터 불러오기
    func checkRealmData() -> [RealmForAlarm] {
        let realmData = realm.objects(RealmForAlarm.self)
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@\(realmData)")
    
    //[Harry] list to array 구현
        let array = Array(realmData)
        print("!!!!!!!!\(array[0].isEnable)")
    /*
    //[Harry] 알람(반복) 데이터 가져오기
        let repeatedTrueData = realmData.filter("isRepeat == 1")
        print("@@@@@@\(repeatedTrueData.count)")
    
    //[Harry] 알람(1회성) 데이터 가져오기
        let repeatedFalseData = realmData.filter("isRepeat == 0")
        print("@@@@@@\(repeatedFalseData.count)")
    */
        return array
        
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
            cell.alarmCellTime.text = repeatedMockupData[indexPath.row].time
            cell.alarmCellMeridiem.text = repeatedMockupData[indexPath.row].meridiem
            cell.alarmCellWeekday.text = repeatedMockupData[indexPath.row].date
            cell.alarmCellSwitch.isOn = repeatedMockupData[indexPath.row].isEnable
            cell.alarmCellToDo.text = "할일: " + (repeatedMockupData[indexPath.row].toDo)
            return cell
            
        } else {
            cell2.alarmCellTime.text = dailyMockupData[indexPath.row].time
            cell2.alarmCellMeridiem.text = dailyMockupData[indexPath.row].meridiem
            cell2.alarmCellWeekday.text = dailyMockupData[indexPath.row].date
            cell2.alarmCellSwitch.isOn = dailyMockupData[indexPath.row].isEnable
            cell2.alarmCellToDo.text = "할일: " + (dailyMockupData[indexPath.row].toDo)
            return cell2
        }
        
    }
    
/*
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
             cell.alarmCellTime.text = repeatedMockupData[indexPath.row].alarmTime
             cell.alarmCellMeridiem.text = repeatedMockupData[indexPath.row].alarmMeridiem
             cell.alarmCellWeekday.text = ""
             for i in 0..<(repeatedMockupData[indexPath.row].alarmWeekDay?.count ?? 1) {
                 cell.alarmCellWeekday.text! += ((repeatedMockupData[indexPath.row].alarmWeekDay?[i] ?? "월 화 수 목 금 토 일") + " ")
             }
             cell.alarmCellSwitch.isOn = repeatedMockupData[indexPath.row].alarmIsEnable ?? true
             cell.alarmCellToDo.text = "할일: " + (repeatedMockupData[indexPath.row].alarmToDo ?? "계획과 실천!")
             return cell
             
         } else {
             cell2.alarmCellTime.text = dailyMockupData[indexPath.row].alarmTime
             cell2.alarmCellMeridiem.text = dailyMockupData[indexPath.row].alarmMeridiem
             cell2.alarmCellWeekday.text = ""
             for i in 0..<(dailyMockupData[indexPath.row].alarmWeekDay?.count ?? 1) {
                 cell2.alarmCellWeekday.text! += ((dailyMockupData[indexPath.row].alarmWeekDay?[i] ?? "월 화 수 목 금 토 일") + " ")
             }
             cell2.alarmCellSwitch.isOn = dailyMockupData[indexPath.row].alarmIsEnable ?? true
             cell2.alarmCellToDo.text = "할일: " + (dailyMockupData[indexPath.row].alarmToDo ?? "계획과 실천!")
             return cell2
         }
         
     }
 */
}
