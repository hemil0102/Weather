//
//  EditAlarmVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/10.
//

import UIKit

class EditAlarmVC: UIViewController {
    
    @IBOutlet weak var repeatingDayOfWeekSwitch: UISwitch!
    @IBOutlet var DayOfWeekBtns: [UIButton]!
    @IBOutlet weak var settingPlaceSwitch: UISwitch!
    @IBOutlet weak var inputPlaceTextField: UITextField!
    @IBOutlet weak var inputALineMemoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveBtnAct(_ sender: UIButton) {
        //[Walter] 상태 저장
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnAct(_ sender: UIButton) {
        //[Walter] 취소
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchingActivationDayOfWeekBtns(_ sender: UISwitch) {
        self.activationBtns(isOn: sender.isOn)
    }
    
    func activationBtns(isOn: Bool) {
        for btns in self.DayOfWeekBtns {
            btns.isEnabled = isOn
        }
    }
    
    @IBAction func switchingActivationSettingPlace(_ sender: UISwitch) {
        //[Walter] inputPlaceTextField 활성화/비활성화
        self.inputPlaceTextField.isEnabled = sender.isOn
    }
    
    @IBAction func selectedDayOfWeek(_ sender: UIButton) {
        
    }
}
