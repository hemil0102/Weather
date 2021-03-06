//
//  EditAlarmVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/10.
//

import UIKit
import RealmSwift

class EditAlarmVC: UIViewController {
    
    
    //MARK: - [Harry] 변수 선언 및 정의 ⭐️
    var editAlarmBrain = AlarmBrain()
    var selectedDate: String = ""
    var selectedHour: String = ""
    var selectedMinute: String = ""
    var selectedMeridiem: String = ""
    var repeatingAlarm: Bool = true
    var textToDo: String = "한줄 메모를 지정해보세요 :)"

    
    @IBOutlet weak var repeatingDayOfWeekSwitch: UISwitch!
    @IBOutlet var dayOfWeekBtns: [UIButton]!
    @IBOutlet weak var inputALineMemoTextField: UITextField!
    @IBOutlet var todayMarks: [UILabel]!
    @IBOutlet weak var timeTitle: UIButton!
    @IBOutlet var mainHeightConstraint: NSLayoutConstraint! //피커뷰 동적 높이 컨트롤
    @IBOutlet weak var alarmPickerView: UIPickerView!
    
    //[Harry] 릴름 마이그레이션
    lazy var realm : Realm = {
        return try! Realm()
    }()
    
    //MARK: - [Harry] 함수 선언 및 정의 ⭐️
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //[Harry] 알람 설정 초기값, 유저가 설정 변경 없이 저장을 누를 경우 반영되는 값
        selectedHour = String(format: "%02d", editAlarmBrain.getCurrentHour12())
        selectedMinute = String(format: "%02d", editAlarmBrain.getCurrentMinute())
        selectedMeridiem = editAlarmBrain.getCurrentMeridiem()
        
        //[Harry] 시간 설정 버튼 초기 값
        timeTitle.setTitle("\(selectedHour):\(selectedMinute) \(selectedMeridiem)", for: .normal)
        
        //[Harry] today 문구를 오늘 요일에 표시
        letTodayMarkAt()
        
        //[Harry] 알람 반복 스위치
        repeatingDayOfWeekSwitch.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
        
        //[Harry] 피커뷰 세팅, 프로토콜 채택
        configPickerView()
        
        //[Harry] 피커뷰 초기값 세팅
        setInitialValuePV()

        //[Harry] 텍스트 필드 세팅, 프로토콜 채택
        configTextField()

        //[Harry] 텍스트 필드 placeholder
        inputALineMemoTextField.placeholder = textToDo
        
        //[Harry] 릴름 저장 주소 가져오기
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    
    @IBAction func saveBtnAct(_ sender: UIButton) {

        //[Walter] 상태 저장, [Harry] 저장할 데이터 생성
        let realmForAlarm = RealmForAlarm()
        
        realmForAlarm.idx = incrementID() //인덱스 증가
        realmForAlarm.time = "\(selectedHour):\(selectedMinute)" //시간
        realmForAlarm.meridiem = selectedMeridiem //오전, 오후
        realmForAlarm.toDo = inputALineMemoTextField.text ?? "" // 할일
        realmForAlarm.isRepeat = repeatingAlarm //알람 반복 여부
        
        //요일
        for btn in self.dayOfWeekBtns {
            if btn.isSelected == true {
                selectedDate += "\(btn.titleLabel?.text ?? "") "
            }
        }
        
        realmForAlarm.date = selectedDate
        
        do {
            try realm.write {
                realm.add(realmForAlarm)
            }
        } catch {
            print("Realm 데이터 저장 못함")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //[Harry] index auto increment
    func incrementID() -> Int {
            return (realm.objects(RealmForAlarm.self).max(ofProperty: "idx") as Int? ?? 0) + 1
    }
    
    @IBAction func cancelBtnAct(_ sender: UIButton) {
        //[Walter] 취소
        dismiss(animated: true, completion: nil)
    }
    
    //[Harry] 요일 선택
    @IBAction func selectedDayOfWeek(_ sender: UIButton) {
        
        for btn in self.dayOfWeekBtns {
            if btn == sender && btn.isSelected == false {
                btn.isSelected = true
                btn.backgroundColor = UIColor(named: "MovelEmerald")
                btn.setTitleColor(.white, for: .normal)
            } else if btn == sender && btn.isSelected == true {
                btn.isSelected = false
                btn.backgroundColor = .white
                btn.setTitleColor(UIColor(named: "MovelEmerald"), for: .normal)
            }
        }
    }
    
    //[Harry] 알람 시간 설정
    @IBAction func selectedTimeTitle(_ sender: UIButton) {
        if timeTitle.isSelected == false {
            timeTitle.isSelected = true
            timeTitle.backgroundColor = UIColor(named: "MovelEmerald")
            timeTitle.setTitleColor(.white, for: .normal)
            mainHeightConstraint.constant = CGFloat(100)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else if timeTitle.isSelected == true {
            timeTitle.isSelected = false
            timeTitle.backgroundColor = .white
            timeTitle.setTitleColor(.darkGray, for: .normal)
            mainHeightConstraint.constant = CGFloat(0)
        }
    }
    
    //[Harry] 반복 체크 스위치
    @IBAction func repeatingSwitch(_ sender: UISwitch) {
        if sender.isOn {
            repeatingAlarm = true
        } else {
            repeatingAlarm = false
        }
    }
    
    //[Harry] 현재 요일에 today 마크를 표시하기
    func letTodayMarkAt() {
        
        let weekDayChecker = editAlarmBrain.getWeekDayIndex()
        for i in 0..<todayMarks.count {
            //[Walter] 코드 수정
            self.todayMarks[i].alpha = i == weekDayChecker ? 1 : 0
//            self.todayMarks[i].textColor = i == weekDayChecker ? .black : .white
            
//            if i == weekDayChecker {
//                todayMarks[i].textColor = .black
//            } else {
//                todayMarks[i].textColor = .white
//            }
        }
    }
    
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
            return self.editAlarmBrain.myPikcerView.alarmPickerViewHours.count
        case 1:
            return self.editAlarmBrain.myPikcerView.alarmPickerViewMinutes.count
        case 2:
            return self.editAlarmBrain.myPikcerView.alarmPickerViewMeridiems.count
        default:
            return 0
        }
    }
    
    //3. [Harry] 선택지의 값 채워주기
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(self.editAlarmBrain.myPikcerView.alarmPickerViewHours[row])
        case 1:
            return String(self.editAlarmBrain.myPikcerView.alarmPickerViewMinutes[row])
        case 2:
            return self.editAlarmBrain.myPikcerView.alarmPickerViewMeridiems[row]
        default:
            return "Data is missing"
        }
    }
    
    //4. [Harry] 피커뷰 초기값 설정
    func setInitialValuePV() {
        

        let hourIndex = editAlarmBrain.getArrayIndexInt(arr: editAlarmBrain.myPikcerView.alarmPickerViewHours, value: Int(selectedHour) ?? 0 )
        let minuteIndex = editAlarmBrain.getArrayIndexInt(arr: editAlarmBrain.myPikcerView.alarmPickerViewMinutes, value: Int(selectedMinute) ?? 0 )
        let meridiemIndex = editAlarmBrain.getArrayIndexString(arr: editAlarmBrain.myPikcerView.alarmPickerViewMeridiems, value: selectedMeridiem )
        
        alarmPickerView.selectRow(hourIndex ?? 0, inComponent: 0, animated: false)
        alarmPickerView.selectRow(minuteIndex ?? 0, inComponent: 1, animated: false)
        alarmPickerView.selectRow(meridiemIndex ?? 0, inComponent: 2, animated: false)

    }
    
    //5. [Harry] 피커뷰 값 변경시 실행되는 함수
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedHour = String(format: "%02d", editAlarmBrain.myPikcerView.alarmPickerViewHours[row])
            let changeTitleHour = "\(selectedHour):\(selectedMinute) \(selectedMeridiem)"
            timeTitle.setTitle(changeTitleHour, for: .normal)
            print("@@@@: " + "\(selectedHour)")
        case 1:
            selectedMinute = String(format: "%02d", editAlarmBrain.myPikcerView.alarmPickerViewMinutes[row])
            let changeTitleMinute = "\(selectedHour):\(selectedMinute) \(selectedMeridiem)"
            timeTitle.setTitle(changeTitleMinute, for: .normal)
            print("@@@@: " + "\(selectedMinute)")
        case 2:
            selectedMeridiem = editAlarmBrain.myPikcerView.alarmPickerViewMeridiems[row]
            let changeTitleMeridiem = "\(selectedHour):\(selectedMinute) \(selectedMeridiem)"
            timeTitle.setTitle(changeTitleMeridiem, for: .normal)
            print("@@@@: " + selectedMeridiem)
        
        default:
            break
        }
    }
}

//MARK: - [Harry] 텍스트 필드
extension EditAlarmVC: UITextFieldDelegate {
    
    func configTextField() {
        inputALineMemoTextField.delegate = self
    }

    //[Harry] 텍스트 필드 글자 수 입력 제한, 이해가 더 필요하다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
     
        return updatedText.count <= 21
    }
    
}

