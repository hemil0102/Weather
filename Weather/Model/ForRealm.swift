//
//  ForRealm.swift
//  Weather
//
//  Created by Walter J on 2022/04/21.
//

import Foundation
import RealmSwift

//[Harry] local-only Realm Database 정의
class RealmForAlarm: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var time: String = ""
    @objc dynamic var meridiem: String = ""
    @objc dynamic var dayType: String = ""
    @objc dynamic var toDo: String = ""
    @objc dynamic var isEnable: Bool = true
    @objc dynamic var isRepeat: Bool = true
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
