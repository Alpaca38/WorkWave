//
//  Date+Extension.swift
//  WorkWave
//
//  Created by 조규연 on 1/12/25.
//

import Foundation

enum DateFormat: String {
    case todayChat = "hh:mm a"
    case pastChat = "yyyy년 MM월 dd일"
}

extension Date {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        return dateFormatter
    }()
    
    func toString(_ dateFormat: DateFormat) -> String {
        Self.dateFormatter.dateFormat = dateFormat.rawValue
        return Self.dateFormatter.string(from: self)
    }
    
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
}
