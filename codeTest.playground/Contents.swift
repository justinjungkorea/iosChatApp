import UIKit

//func getReqNo() -> String {
//    var reqNo = ""
//
//    for _ in 0..<7 {
//        reqNo = reqNo + String(Int.random(in: 0...9))
//    }
//
//    return reqNo
//}
//
//print(getReqNo())

let today = Date()
let formatter = DateFormatter()
formatter.locale = Locale(identifier: "ko_KR")
formatter.dateFormat = "yyyyMMddHHmmss"
let dateString = formatter.string(from: today)

print(dateString)
