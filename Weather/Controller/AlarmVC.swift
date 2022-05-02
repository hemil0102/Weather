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
    var realmData: [RealmForAlarm] = [] // 렐름 전체 데이터를 불러올 배열형으로 저장할 변수
    var repeatedData: [ RealmForAlarm ] = [] // 불러온 렐름 데이터에서 반복 알람만 저장
    var dailyData: [ RealmForAlarm ] = [] // 불러온 렐름 데이터에서 1회성 알람만 저장
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    //[Harry] 함수 정의 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        //[Harry] 데이터를 처리하기 위해 위임을 받는다.
        alarmTableView.dataSource = self
        
        //[Harry] AlarmCell.xib 등록하기
        alarmTableView.register(UINib(nibName: Keys.alarmCellOneNibName, bundle: nil), forCellReuseIdentifier: Keys.alarmCellOneIdentifier)
        alarmTableView.register(UINib(nibName: Keys.alarmCellTwoNibName, bundle: nil), forCellReuseIdentifier: Keys.alarmCellTwoIdentifier)
        
        //[Harry] 테이블뷰 셀 높이 지정
        alarmTableView.rowHeight = 90
        
        //[Walter] 하단 적응형 광고 띄우기
        setupBannerViewToBottom()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //[Harry] 렐름 데이터를 불러오고, 알람 반복 여부에 따라 섹션에 띄울 셀 숫자를 알아내고 데이터를 분류하는 함수.
        sectionCounter()
        
        //[Harry] 셀 추가 이후 테이블뷰을 리로드하여 새로고침하여 추가된 데이터 표기
        alarmTableView.reloadData()
    }

    //[Harry] 알람 반복 여부에 따라 섹션에 띄울 셀 숫자를 알아내고 데이터를 분류하는 함수.
    func sectionCounter() {
        //[Harry] 렐름 데이터를 리스트(렐름)에서 배열(Swift)형식으로 불러옴.
        realmData = Array(realm.objects(RealmForAlarm.self))
        
        sectionOneCounter = 0 // 리로드될 때 초기화
        sectionTwoCounter = 0 // 리로드될 때 초기화
        repeatedData = [] //리로드될 때 초기화
        dailyData = [] //리로드될 때 초기화
        
        for i in 0..<realmData.count {
            if realmData[i].isRepeat == true {
                repeatedData.append(realmData[i])
                print("1번" + "\(repeatedData)")
                sectionOneCounter += 1
            } else {
                dailyData.append(realmData[i])
                print("2번" + "\(dailyData)")
                sectionTwoCounter += 1
            }
        }
    }
    
    func deleteRealmData(index: Int) {
        do{
            try self.realm.write {
                self.realm.delete(self.realmData[index])
            }
        } catch {
            print("error!")
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
            cell.alarmCellTime.text = repeatedData[indexPath.row].time
            cell.alarmCellMeridiem.text = repeatedData[indexPath.row].meridiem
            cell.alarmCellWeekday.text = repeatedData[indexPath.row].date
            cell.alarmCellSwitch.isOn = repeatedData[indexPath.row].isEnable
            if repeatedData[indexPath.row].toDo == "" {
                cell.alarmCellToDo.text = ""
            } else {
                cell.alarmCellToDo.text = "할일: " + (repeatedData[indexPath.row].toDo)
            }
            print("!\(repeatedData[indexPath.row].toDo)!")
            return cell
            
        } else {
            cell2.alarmCellTime.text = dailyData[indexPath.row].time
            cell2.alarmCellMeridiem.text = dailyData[indexPath.row].meridiem
            cell2.alarmCellWeekday.text = dailyData[indexPath.row].date
            cell2.alarmCellSwitch.isOn = dailyData[indexPath.row].isEnable
            if dailyData[indexPath.row].toDo == "" {
                cell2.alarmCellToDo.text = ""
            } else {
                cell2.alarmCellToDo.text = "할일: " + (dailyData[indexPath.row].toDo)
            }
            print("!\(dailyData[indexPath.row].toDo)!")
            return cell2
        }
    }
    
    //[Harry] 테이블뷰 삭제 구현 부
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("@@@@@@@deleted11111111")
            tableView.beginUpdates()
            print("@@@@@@@deleted22222222")
        // cell 데이터를 담은 배열 이름을 적고 .remove()
            if indexPath.section == 0 {
                print(indexPath.row)
                print(repeatedData[indexPath.row].idx)
                deleteRealmData(index: repeatedData[indexPath.row].idx)
                repeatedData.remove(at: indexPath.row)
                print("@@@@@@@deleted33333333")
            } else {
                print(indexPath.row)
                print(dailyData[indexPath.row].idx)
                deleteRealmData(index: dailyData[indexPath.row].idx)
                dailyData.remove(at: indexPath.row)
                print("@@@@@@@deleted44444444")
            }
            print("@@@@@@@deleted55555555")
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("@@@@@@@deleted66666666")
            tableView.endUpdates()
            print("@@@@@@@deleted77777777")
            
        }
    }
}
