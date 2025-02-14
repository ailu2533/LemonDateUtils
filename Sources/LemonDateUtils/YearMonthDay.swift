//
//  Date+.swift
//  MyHabit
//
//  Created by ailu on 2024/4/1.
//

import DateHelper
import Foundation

// MARK: - YearMonthDay

// import HorizonCalendar

public struct YearMonthDay: Hashable, Equatable, Sendable {
    // 1. 添加日期格式化器
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: Lifecycle

    //    public let weekday: Int

    public init(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.year = components.year ?? 1970
        self.month = components.month ?? 1
        self.day = components.day ?? 1
    }

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    // MARK: Public

    public let year: Int
    public let month: Int
    public let day: Int

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
    }

    // 添加格式化选项枚举
    public enum DateFormat {
        case iso8601        // 2024-04-01
        case compact        // 20240401
        case slash         // 2024/04/01
        case chinese       // 2024年04月01日
        case custom(String) // 自定义格式
    }

    // 替换原有的 toString 方法
    public func formatted(_ format: DateFormat = .iso8601) -> String {
        switch format {
        case .iso8601:
            return String(format: "%04d-%02d-%02d", year, month, day)
        case .compact:
            return String(format: "%04d%02d%02d", year, month, day)
        case .slash:
            return String(format: "%04d/%02d/%02d", year, month, day)
        case .chinese:
            return String(format: "%04d年%02d月%02d日", year, month, day)
        case .custom(let pattern):
            return pattern
                .replacingOccurrences(of: "yyyy", with: String(format: "%04d", year))
                .replacingOccurrences(of: "MM", with: String(format: "%02d", month))
                .replacingOccurrences(of: "dd", with: String(format: "%02d", day))
        }
    }

    // 保留 toString 作为兼容方法
    @available(*, deprecated, renamed: "formatted()")
    public func toString() -> String {
        formatted()
    }
}

// MARK: Comparable

extension YearMonthDay: Comparable {
    public static func < (lhs: YearMonthDay, rhs: YearMonthDay) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
}

// MARK: Identifiable

extension YearMonthDay: Identifiable {
    public var id: String {
        return "\(year)-\(month)-\(day)"
    }
}

extension YearMonthDay {
    public static func fromDate(_ date: Date) -> YearMonthDay {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return .init(year: components.year!, month: components.month!, day: components.day!)
    }

    public func date() -> Date? {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)
    }

    public init?(string: String) {
        guard let date = Self.formatter.date(from: string) else { return nil }
        self.init(date: date)
    }

    public var isToday: Bool {
        self == Self(date: Date())
    }

    public func adding(days: Int) -> YearMonthDay? {
        guard let newDate = Calendar.current.date(byAdding: .day, value: days, to: date() ?? Date()) else {
            return nil
        }
        return YearMonthDay(date: newDate)
    }
}
