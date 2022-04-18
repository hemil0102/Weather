//
//  EditAlarmVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/10.
//

import UIKit

class EditAlarmVC: UIViewController {
    
    //[Harry] 변수 선언 및 정의
    let EditAlarmBrain = AlarmBrain()
    @IBOutlet weak var repeatingDayOfWeekSwitch: UISwitch!
    @IBOutlet var DayOfWeekBtns: [UIButton]!
    @IBOutlet weak var inputALineMemoTextField: UITextField!
    @IBOutlet var TodayMarks: [UILabel]!
    
    
    //[Harry] 함수 선언 및 정의
    override func viewDidLoad() {
        super.viewDidLoad()
        //[Harry] 현재 날짜 및 시간 정보를 제대로 가져오는지 확인
        EditAlarmBrain.getCurrentDT()
        //[Harry] 요일 인덱스 확인
        EditAlarmBrain.getWeekDayIndex()
        //[Harry] today 문구를 오늘 요일에 표시
        letTodayMarkAt()
    }
    
    
    @IBAction func saveBtnAct(_ sender: UIButton) {
        //[Walter] 상태 저장
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnAct(_ sender: UIButton) {
        //[Walter] 취소
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectedDayOfWeek(_ sender: UIButton) {
        
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
}
