//
//  greg.swift
//
//
//  Created by Michael Radwin on 8/17/21.
//

import Foundation

/// Days in each Gregorian month of a non-leap year, indexed 1 (January) through 12.
private let monthLengths = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

public func isGregLeapYear(year: Int) -> Bool {
    return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0)
}

/// The day number within the year, e.g. 1 for January 1, 1987 and 366 for
/// December 31, 1980. `dateComponents` must have `year`, `month` and `day`.
public func dayOfYear(dateComponents: DateComponents) -> Int {
    return dayOfYear(year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!)
}

func dayOfYear(year: Int, month: Int, day: Int) -> Int {
    var days = day + 31 * (month - 1)
    if month > 2 {
        days -= (4 * month + 23) / 10
        if isGregLeapYear(year: year) {
            days += 1
        }
    }
    return days
}

/// The absolute (R.D.) day number of the day `date` falls on in the current calendar.
public func greg2abs(date: Date) -> Int64 {
    return greg2abs(date: date, calendar: .current)
}

/// The absolute (R.D.) day number of the day `date` falls on in `calendar`: the
/// number of days elapsed since the (imaginary) Gregorian date Sunday,
/// December 31, 1 BC.
public func greg2abs(date: Date, calendar: Calendar) -> Int64 {
    let ymd = calendar.dateComponents([.year, .month, .day], from: date)
    return greg2abs(year: ymd.year!, month: ymd.month!, day: ymd.day!)
}

/// The absolute (R.D.) day number of a proleptic Gregorian date.
func greg2abs(year: Int, month: Int, day: Int) -> Int64 {
    let priorYears = Int64(year - 1)
    return Int64(dayOfYear(year: year, month: month, day: day)) +
        365 * priorYears +      // days in prior years
        priorYears / 4 -        // + Julian leap years
        priorYears / 100 +      // - century years
        priorYears / 400        // + Gregorian leap years
}

func daysInMonth(month: Int, year: Int) -> Int {
    if month == 2 && isGregLeapYear(year: year) {
        return 29
    }
    return monthLengths[month]
}

/// Converts an absolute (R.D.) day number to a `Date` at midnight in `calendar`.
///
/// See the footnote on page 384 of "Calendrical Calculations, Part II: Three
/// Historical Calendars" by E. M. Reingold, N. Dershowitz, and S. M. Clamen,
/// Software--Practice and Experience, Volume 23, Number 4 (April, 1993),
/// pages 383-404 for an explanation.
public func abs2greg(absdate: Int64, calendar: Calendar) -> Date {
    let d0 = absdate - 1
    let n400 = d0 / 146097
    let d1 = d0 % 146097
    let n100 = d1 / 36524
    let d2 = d1 % 36524
    let n4 = d2 / 1461
    let d3 = d2 % 1461
    let n1 = d3 / 365

    let year = Int(400 * n400 + 100 * n100 + 4 * n4 + n1)
    if n100 == 4 || n1 == 4 {
        // Last day of a leap year
        return DateComponents(calendar: calendar, year: year, month: 12, day: 31).date!
    }

    var day = Int(d3 % 365) + 1
    var month = 1
    while day > daysInMonth(month: month, year: year + 1) {
        day -= daysInMonth(month: month, year: year + 1)
        month += 1
    }
    return DateComponents(calendar: calendar, year: year + 1, month: month, day: day).date!
}
