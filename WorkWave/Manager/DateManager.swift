//
//  DateManager.swift
//  WorkWave
//
//  Created by 조규연 on 12/6/24.
//

import Foundation

final class DateManager {
    private init() { }
    static let shared = DateManager()
    
    private let isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    func format(createdAt: String) -> String {
        guard let date = isoDateFormatter.date(from: createdAt) else {
            return "toAgoError"
        }
        return displayDateFormatter.string(from: date)
    }
}
