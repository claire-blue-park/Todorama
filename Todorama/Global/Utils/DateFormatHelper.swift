//
//  DateFormatHelper.swift
//  Todorama
//
//  Created by Claire on 3/21/25.
//

import Foundation

final class DateFormatHelper {
    static let shared = DateFormatHelper()
    private let dateFormatter = DateFormatter()
    private init() { }
    
    func getFormattedDate(_ date: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let toDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "yy. MM. dd"
            let temp = dateFormatter.string(from: toDate)
            return temp
        }
        return "-"
    }

}
