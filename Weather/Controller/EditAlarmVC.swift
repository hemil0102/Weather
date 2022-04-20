//
//  EditAlarmVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/10.
//

import UIKit

class EditAlarmVC: UIViewController {
    
    //MARK: - [Harry] 변수 선언 및 정의 ⭐️
    var EditAlarmBrain = AlarmBrain()

    
    @IBOutlet weak var repeatingDayOfWeekSwitch: UISwitch!
    @IBOutlet var DayOfWeekBtns: [UIButton]!
    @IBOutlet weak var inputALineMemoTextField: UITextField!
    @IBOutlet var TodayMarks: [UILabel]!
    @IBOutlet weak var timeTitle: UIButton!
    @IBOutlet var mainHeightConstraint: NSLayoutConstraint! //피커뷰 동적 높이 컨트롤
    @IBOutlet weak var alarmPickerView: UIPickerView!
    
    //MARK: - [Harry] 함수 선언 및 정의 ⭐️
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //[Harry] today 문구를 오늘 요일에 표시
        letTodayMarkAt()
        
        //[Harry] 피커뷰 세팅
        configPickerView()

        //[Harry] 피커뷰 초기값 세팅
        setInitialValuePV()
    }
    
    
    @IBAction func saveBtnAct(_ sender: UIButton) {
        //[Walter] 상태 저장
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnAct(_ sender: UIButton) {
        //[Walter] 취소
        dismiss(animated: true, completion: nil)
    }
    
    
    //[Harry] 알람 시간 설정
    @IBAction func selectedTimeTitle(_ sender: UIButton) {
        if timeTitle.isSelected == false {
            timeTitle.isSelected = true
            timeTitle.backgroundColor = UIColor(named: "MovelEmerald")
            timeTitle.setTitleColor(.white, for: .normal)
            mainHeightConstraint.constant = CGFloat(100)
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        } else if timeTitle.isSelected == true {
            timeTitle.isSelected = false
            timeTitle.backgroundColor = .white
            timeTitle.setTitleColor(.darkGray, for: .normal)
            mainHeightConstraint.constant = CGFloat(0)
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //[Harry] 요일 선택
    @IBAction func selectedDayOfWeek(_ sender: UIButton) {
        
        for Btn in self.DayOfWeekBtns {
            if Btn == sender && Btn.isSelected == false {
                Btn.isSelected = true
                Btn.backgroundColor = UIColor(named: "MovelEmerald")
                Btn.setTitleColor(.white, for: .normal)
            } else if Btn == sender && Btn.isSelected == true {
                Btn.isSelected = false
                Btn.backgroundColor = .white
                Btn.setTitleColor(UIColor(named: "MovelEmerald"), for: .normal)
            }
        }
    }
    
    //[Harry] 현재 요일에 today 마크를 표시하기
    func letTodayMarkAt() {
        
        let weekDayChecker = EditAlarmBrain.getWeekDayIndex()
        
        for i in 0..<TodayMarks.count {
            
            if i == weekDayChecker {
                TodayMarks[i].textColor = .black
            } else {
                TodayMarks[i].textColor = .white
            }
        }
    }
    
    //[Harry] 알람 설정 시간 버튼에 현재 시간 및 피커뷰 선택 시간 반영 함수
    
}

//MARK: - [Harry] 알람 시간 설정 피커뷰 ⭐️
extension EditAlarmVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //[Harry] 피커뷰 위임 받기 함수
    func configPickerView() {
        alarmPickerView.delegate = self
        alarmPickerView.dataSource = self
    }
    //1. [Harry] 피커뷰 컬럼수 [시간]:[분],[Meridiem]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //2. [Harry] 피커뷰의 선택지를 데이터의 개수만큼 세팅
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.EditAlarmBrain.myPikcerView.alarmPickerViewHours.count
        case 1:
            return self.EditAlarmBrain.myPikcerView.alarmPickerViewMinutes.count
        case 2:
            return self.EditAlarmBrain.myPikcerView.alarmPickerViewMeridiems.count
        default:
            return 0
        }
    }
    
    //3. [Harry] 선택지의 값 채워주기
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(self.EditAlarmBrain.myPikcerView.alarmPickerViewHours[row])
        case 1:
            return String(self.EditAlarmBrain.myPikcerView.alarmPickerViewMinutes[row])
        case 2:
            return self.EditAlarmBrain.myPikcerView.alarmPickerViewMeridiems[row]
        default:
            return "Data is missing"
        }
    }
    
    //4. [Harry] 피커뷰 초기값 설정
    func setInitialValuePV() {
        
        let currentHour = EditAlarmBrain.getCurrentHour12()
        let currentMinute = EditAlarmBrain.getCurrentMinute()
        let currentMeridiem = EditAlarmBrain.getCurrentMeridiem()
        
        let hourIndex = EditAlarmBrain.getArrayIndexInt(arr: EditAlarmBrain.myPikcerView.alarmPickerViewHours, value: Int(currentHour) ?? 0 )
        let minuteIndex = EditAlarmBrain.getArrayIndexInt(arr: EditAlarmBrain.myPikcerView.alarmPickerViewMinutes, value: Int(currentMinute) ?? 0 )
        let meridiemIndex = EditAlarmBrain.getArrayIndexString(arr: EditAlarmBrain.myPikcerView.alarmPickerViewMeridiems, value: currentMeridiem )
        
        alarmPickerView.selectRow(hourIndex ?? 0, inComponent: 0, animated: false)
        alarmPickerView.selectRow(minuteIndex ?? 0, inComponent: 1, animated: false)
        alarmPickerView.selectRow(meridiemIndex ?? 0, inComponent: 2, animated: false)
        
    }
    
}
