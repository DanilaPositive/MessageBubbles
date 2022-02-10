//
//  DateHelper.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 09.02.2022.
//

import Foundation

enum DateTimeFormat {
    case hhmm_Colon

    func make() -> String {
        switch self {
        case .hhmm_Colon:
            return "HH:mm"
        }
    }
}

class DateHelper {
    func string(fromDate date: Date?, format: DateTimeFormat) -> String {
        guard let date = date else { return "" }
        let dateFormatter = dateFormatter(timeZone: TimeZone.current)
        dateFormatter.dateFormat = format.make()
        return dateFormatter.string(from: date)
    }

    private func dateFormatter(timeZone: TimeZone = TimeZone.current) -> DateFormatter {
        let df = DateFormatter()
        df.timeZone = timeZone
        return df
    }
}
