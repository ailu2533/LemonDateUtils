//
//  File.swift
//
//
//  Created by ailu on 2024/5/1.
//

import DateHelper
import Foundation
import SwiftUI

// MARK: - RecurrenceType

// 重复类型
public enum RecurrenceType: Int, Codable {
    case singleCycle = 1 // 周期性重复，一个周期只重复一次
    case customWeekly = 2 // 自定义每周重复，一周可以重复多次
}

// MARK: - RepeatPeriod

public enum RepeatPeriod: Int, CaseIterable, Identifiable, Codable {
    case daily = 0
    case weekly = 1
    case monthly = 2
    case yearly = 3

    // MARK: Public

    public var id: Int {
        rawValue
    }

    public var text: String {
        switch self {
        case .daily:
            return String(localized: "day", bundle: .main)
        case .weekly:
            return String(localized: "week", bundle: .main)
        case .monthly:
            return String(localized: "month", bundle: .main)
        case .yearly:
            return String(localized: "year", bundle: .main)
        }
    }
}

public func calculateNearestRepeatDate(
    startDate: Date, currentDate: Date, repeatPeriod: RepeatPeriod, interval: Int,
    recurrenceType: RecurrenceType, customWeek: UInt8
) -> Int {
    switch recurrenceType {
    case .customWeekly:
        return calculateCustomWeeklyRepeatDate(currentDate: currentDate, customWeek: customWeek)
    default:
        return calculateStandardRepeatDate(
            startDate: startDate, currentDate: currentDate, repeatPeriod: repeatPeriod, interval: interval
        )
    }
}

// 计算自定义周重复的日期
private func calculateCustomWeeklyRepeatDate(currentDate: Date, customWeek: UInt8) -> Int {
    var customCalendar = Calendar(identifier: .gregorian)
    customCalendar.firstWeekday = 2 // 设置周一为一周的第一天

    let weekday = customCalendar.component(.weekday, from: currentDate)
    let adjustedWeekday = (weekday + 5) % 7 + 1 // 调整weekday的值，使周一为1，周日为7

    var todayPattern = UInt8(1 << (adjustedWeekday - 1))
    var daysUntilNextRepeat = 0
    var crossWeek = 0

    while daysUntilNextRepeat <= 7 {
        if todayPattern & customWeek != 0 {
            break
        }
        daysUntilNextRepeat += 1
        todayPattern = UInt8(todayPattern << 1)
        if todayPattern == 0 {
            crossWeek = 1
            todayPattern = UInt8(1) // 重置为周日
        }
    }

    return daysUntilNextRepeat - crossWeek
}

// 计算标准周期重复的日期
private func calculateStandardRepeatDate(
    startDate: Date, currentDate: Date, repeatPeriod: RepeatPeriod, interval: Int
) -> Int {
    let calendar = Calendar.current
    let startOfDay = startDate.adjust(for: .startOfDay)!
    let currentDateStartOfDay = currentDate.adjust(for: .startOfDay)!

    switch repeatPeriod {
    case .daily:
        return calculateDaysDifference(startDate: startOfDay, currentDate: currentDateStartOfDay, periodDays: interval)
    case .weekly:
        return calculateDaysDifference(startDate: startOfDay, currentDate: currentDateStartOfDay, periodDays: interval * 7)
    case .monthly:
        return calculateMonthsDifference(startDate: startOfDay, currentDate: currentDateStartOfDay, interval: interval, calendar: calendar)
    case .yearly:
        return calculateYearsDifference(startDate: startOfDay, currentDate: currentDateStartOfDay, interval: interval, calendar: calendar)
    }
}

// 计算天数差
private func calculateDaysDifference(startDate: Date, currentDate: Date, periodDays: Int) -> Int {
    let days = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day!
    return days % periodDays == 0 ? 0 : periodDays - days % periodDays
}

// 计算月份差
private func calculateMonthsDifference(startDate: Date, currentDate: Date, interval: Int, calendar: Calendar) -> Int {
    // 获取开始日期和当前日期之间的月份和天数差异
    let components = calendar.dateComponents([.month, .day], from: startDate, to: currentDate)
    let days = components.day! // 从开始日期到当前日期的天数差
    let months = components.month! // 从开始日期到当前日期的月份差

    // 如果当前日期正好是周期的结束日，并且月份差是周期数的整数倍，则返回0
    if days == 0 && months % interval == 0 {
        return 0
    }

    // 计算下一个周期的目标月份
    // 如果月份差不是周期数的整数倍，计算下一个周期的开始月份
    let targetMonth = interval * ((months / interval) + 1)

    // 计算目标月份的具体日期
    let nextDate = calendar.date(byAdding: .month, value: targetMonth, to: startDate)!

    // 返回当前日期到下一个周期开始日期的天数差
    return calendar.dateComponents([.day], from: currentDate, to: nextDate).day!
}

// 计算年份差
private func calculateYearsDifference(startDate: Date, currentDate: Date, interval: Int, calendar: Calendar) -> Int {
    let components = calendar.dateComponents([.year, .day], from: startDate, to: currentDate)
    let days = components.day!
    let years = components.year!
    if days == 0 && years % interval == 0 {
        return 0
    }
    let targetYear = interval * ((years / interval) + 1)
    let nextDate = calendar.date(byAdding: .year, value: targetYear, to: startDate)!
    return calendar.dateComponents([.day], from: currentDate, to: nextDate).day!
}
