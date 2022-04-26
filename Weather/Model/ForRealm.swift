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
    
    //[Harry] index
    @objc dynamic var idx: Int = 0
    
    //[Harry] Time
    @objc dynamic var time: String = ""
    @objc dynamic var meridiem: String = ""
    
    //[Harry] Todo
    @objc dynamic var toDo: String = ""
    
    //[Harry] Date
    @objc dynamic var date: String = ""
    
    //[Harry] settings
    @objc dynamic var isEnable: Bool = true
    @objc dynamic var isRepeat: Bool = true

    //[Harry] primaryKey 지정
    override static func primaryKey() -> String? {
        return "idx"
    }
}
