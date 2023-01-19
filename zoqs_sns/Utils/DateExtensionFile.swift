//
//　Date型の拡張を行なってる
//
//
//  Created by 島田将太郎 on 2022/12/20.
//

import Foundation

extension Date{
    
    func firstDayOfTheMounth() -> Date{
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    mutating func plusOneDay() {
        self = Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    func changeMonth(diff: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: diff, to: self)!
    }
    
    func getAllDays() -> [Date] {
        var day1st = firstDayOfTheMounth()

        // Dataの空の配列
        var days = [Date]()

        // 配列に要素を一つ追加する
        days.append(day1st)

        let range = Calendar.current.range(of: .day, in: .month, for: day1st)!

        for _ in 0..<range.count - 1 {
            day1st.plusOneDay()
            days.append(day1st)
        }
        
        return days
    }
    
    // 曜日を数値で返す（0が日曜、6が土曜）
    func getWeekDay() -> Int {
        return Calendar.current.component(.weekday, from: self) - 1
    }
    
    func DateToString(format:String) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone.current
        df.dateFormat = format
        
        return df.string(from: self)
    }
    
}
