//
//  EditAlarmVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/10.
//

import UIKit

class EditAlarmVC: UIViewController {

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
}
