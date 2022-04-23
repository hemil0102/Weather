//
//  ParsingCSV.swift
//  Weather
//
//  Created by Walter J on 2022/04/07.
//

import Foundation
import CoreLocation

protocol ParsingCsvDelegate {
    func getCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees)
}

struct ParsingCSV {
    var koreaLocation:[[String]] = []
    var koreaLocalGoverment:[[String]] = []
    var delegate: ParsingCsvDelegate?
    
    /*
     [walter] 어떻게 해야하나...
     1. 동 검색을 korea.csv 파일에서 찾는다. [✌️]
     2. 검색된 동의 코드를 가져온다. [✌️]
     3. 코드를 앞 5자리만 자른다. [✌️]
     4. 5자리의 코드로 korea_local_goverment.csv 파일에서 찾는다. [✌️]
     5. 일치하는 칼럼의 lat, lon 을 가져온다. [✌️]
     6. 좌표를 WeatherManger 로 전달한다. [✌️]
     */
    mutating func getDataCsvAt() {
        //[Walter] .csv 파일을 Bundle 객체로 가져옴
        let koreaPath = Bundle.main.path(forResource: "korea", ofType: "csv")!
        self.koreaLocation = self.parseCSVAt(url: URL(fileURLWithPath: koreaPath))
        
        let koreaLocalGovermentPath = Bundle.main.path(forResource: "korea_local_goverment", ofType: "csv")!
        self.koreaLocalGoverment = self.parseCSVAt(url: URL(fileURLWithPath: koreaLocalGovermentPath))
    }
    
    //[Walter] Bundle 객체를 넘겨 ,(쉼표)로 구분한 내용을 배열에 담는다.
    private func parseCSVAt(url:URL) -> [[String]] {
        var locations:[[String]] = []
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                for item in dataArr {
                    locations.append(item)
                }
            }
        } catch  {
            print("Error reading CSV file")
            
        }
        
        return locations
    }
    
    //[Walter] Step1.사용자 검색을 korea.csv 파일에서 찾는다.
    func searchUserKeyword(place: String) {
        var codeStr:String?
        var isNotFound = true
        var idx = 0
        
        while isNotFound {
            for locations in koreaLocation {
                let si_dong_gu = locations[idx].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if si_dong_gu.contains(place) {
                    codeStr = locations[0]
                    print("찾은 지역 이름 \(si_dong_gu), code \(codeStr)")
                    isNotFound = false
                    break
                }
            }
            
            if idx < 3 {
                idx += 1
            } else {
                isNotFound = false
            }
        }
        
        for locations in koreaLocation {
            let dong = locations[3].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if dong == place {
                print("검색된 동명 \(place), code \(locations[0])")
                codeStr = locations[0]
            }
        }

        print("코오오오오오오오드 \(place), \(codeStr)")
        
        //[Walter] Step2. 코드를 앞 5자리만 자른다.
        if let code = codeStr {
            let index = code.index(code.startIndex, offsetBy: 5)
            let final_code = code.substring(to: index)         //[Water] 시간 남을 때 해결하자..
            
            self.searchCoordinateByCodeInKoreaLocalGoverment(code: final_code)
        } else {
            print("찾을 수 없는 지역명....")
        }
    }
    
    //[Walter] Step3. 5자리의 코드로 korea_local_goverment.csv 파일에서 찾는다.
    func searchCoordinateByCodeInKoreaLocalGoverment(code: String) {
//        print("최종 코드 \(code)")
        var lat = ""
        var lon = ""
        
        for coordinates in koreaLocalGoverment {
            let sig_cd = coordinates[2].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if sig_cd == code {
                lat = coordinates[1]
                lon = coordinates[0]
            }
        }
        
        print("위도 \(lat) 경도 \(lon)")
        let coordi = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
        self.delegate?.getCoordinate(lat: coordi.latitude, lon: coordi.longitude)
    }
}
