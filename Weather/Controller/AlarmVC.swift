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

    override func viewDidLoad() {
        super.viewDidLoad()

        //[Walter] 하단 적응형 광고 띄우기
        setupBannerViewToBottom()
    }
    
    @IBOutlet weak var alarmTableView: UITableView!

}
