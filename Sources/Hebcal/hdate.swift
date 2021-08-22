//
//  hdate.swift
//  
//
//  Created by Michael Radwin on 8/17/21.
//

import Foundation

public enum HebrewMonth: Int {
    case NISAN = 1, IYYAR, SIVAN, TAMUZ, AV, ELUL,
         TISHREI, CHESHVAN, KISLEV, TEVET, SHVAT, ADAR_I, ADAR_II
}

public enum DayOfWeek: Int {
    case SUN = 0, MON, TUE, WED, THU, FRI, SAT
}

let EPOCH: Int64 = -1373428

/**
 * Returns true if Hebrew year is a leap year
 * @param {number} year Hebrew year
 * @return {boolean}
 */
public func isLeapYear(year: Int) -> Bool {
    return (1 + year * 7) % 19 < 7
}

/**
 * Number of months in this Hebrew year (either 12 or 13 depending on leap year)
 * @param {number} year Hebrew year
 * @return {number}
 */
public func monthsInYear(year: Int) -> Int {
    let extra = isLeapYear(year: year) ? 1 : 0
    return 12 + extra
}

/**
 * Days from sunday prior to start of Hebrew calendar to mean
 * conjunction of Tishrei in Hebrew YEAR
 * @private
 * @param {number} year Hebrew year
 * @return {number}
 */
func elapsedDays(year: Int) -> Int64 {
    let prevYear = year - 1
    
    let mElapsedMonths = 235 * (prevYear / 19)
    let mElapsedRegularMonths = 12 * (prevYear % 19)
    let mElapsedLeapMonths = ((prevYear % 19) * 7 + 1) / 19
    
    let mElapsed: Int64 = Int64(mElapsedMonths + mElapsedRegularMonths + mElapsedLeapMonths)
    
    let pElapsed: Int64 = 204 + 793 * (mElapsed % 1080)
    
    let hElapsed: Int64 = 5 +
        12 * mElapsed +
        793 * (mElapsed / 1080) +
        (pElapsed / 1080)
    
    let parts: Int64 = (pElapsed % 1080) + 1080 * (hElapsed % 24)
    
    let day: Int64 = 1 + 29 * mElapsed + (hElapsed / 24)
    
    var altDay = day
    
    if (parts >= 19440) ||
            ((2 == (day % 7)) && (parts >= 9924) && !(isLeapYear(year: year))) ||
            ((1 == (day % 7)) && (parts >= 16789) && isLeapYear(year: prevYear)) {
        altDay = day + 1
    }
    
    if altDay % 7 == 0 || altDay % 7 == 3 || altDay % 7 == 5 {
        return altDay + 1
    } else {
        return altDay
    }
}

/**
 * Number of days in the hebrew YEAR
 * @param {number} year Hebrew year
 * @return {number}
 */
public func daysInYear(year: Int) -> Int {
    return Int(elapsedDays(year: year + 1) - elapsedDays(year: year))
}

/**
 * true if Cheshvan is long in Hebrew year
 * @param {number} year Hebrew year
 * @return {boolean}
 */
public func longCheshvan(year: Int) -> Bool {
    return daysInYear(year: year) % 10 == 5
}

/**
 * true if Kislev is short in Hebrew year
 * @param {number} year Hebrew year
 * @return {boolean}
 */
public func shortKislev(year: Int) -> Bool {
    return daysInYear(year: year) % 10 == 3
}

/**
 * Number of days in Hebrew month in a given year (29 or 30)
 * @param {number} month Hebrew month (e.g. months.TISHREI)
 * @param {number} year Hebrew year
 * @return {number}
 */
public func daysInMonth(month: HebrewMonth, year: Int) -> Int {
    switch month {
    case .IYYAR, .TAMUZ, .ELUL, .TEVET, .ADAR_II:
        return 29
    case .ADAR_I:
        return isLeapYear(year: year) ? 30 : 29
    case .CHESHVAN:
        return longCheshvan(year: year) ? 30: 29
    case .KISLEV:
        return shortKislev(year: year) ? 29 : 30
    default:
        return 30
    }
}

public func hebrew2abs(year: Int, month: HebrewMonth, day: Int) -> Int64 {
    var tempabs: Int64 = Int64(day)
    let imonth: Int = month.rawValue
    if imonth < HebrewMonth.TISHREI.rawValue {
        for m in HebrewMonth.TISHREI.rawValue...monthsInYear(year: year) {
            tempabs += Int64(daysInMonth(month: HebrewMonth(rawValue: m)!, year: year))
        }
        for m in HebrewMonth.NISAN.rawValue..<imonth {
            tempabs += Int64(daysInMonth(month: HebrewMonth(rawValue: m)!, year: year))
        }
    } else {
        for m in HebrewMonth.TISHREI.rawValue..<imonth {
            tempabs += Int64(daysInMonth(month: HebrewMonth(rawValue: m)!, year: year))
        }
    }
    return EPOCH + elapsedDays(year: year) + tempabs - 1
}

func newYearDelay(year: Int) -> Int {
    let ny1 = elapsedDays(year: year)
    let ny2 = elapsedDays(year: year + 1)
    if ny2 - ny1 == 356 {
        return 2
    } else {
        let ny0 = elapsedDays(year: year - 1)
        return ny1 - ny0 == 382 ? 1 : 0
    }
}

func newYear(year: Int) -> Int64 {
    return EPOCH + elapsedDays(year: year) + Int64(newYearDelay(year: year))
}

public struct HDate {
    var yy: Int
    var mm: HebrewMonth
    var dd: Int

    public init(yy: Int, mm: HebrewMonth, dd: Int) {
        self.yy = yy
        self.mm = mm
        self.dd = dd
    }

    public init(date: Date) {
        self.init(absdate: greg2abs(date: date))
    }

    public init(absdate: Int64) {
        let approx = 1 + Int(Double(absdate - EPOCH) / 365.24682220597794)
        var year = approx - 1
        while (newYear(year: year) <= absdate) {
            year = year + 1
        }
        year = year - 1
        var month = absdate < hebrew2abs(year: year, month: HebrewMonth.NISAN, day: 1) ? HebrewMonth.TISHREI : HebrewMonth.NISAN
        while (absdate > hebrew2abs(year: year, month: month, day: daysInMonth(month: month, year: year))) {
            month = HebrewMonth(rawValue: month.rawValue + 1)!
        }
        let day = Int(1 + absdate - hebrew2abs(year: year, month: month, day: 1))
        self.yy = year
        self.mm = month
        self.dd = day
    }

    public func abs() -> Int64 {
        return hebrew2abs(year: self.yy, month: self.mm, day: self.dd)
    }

    public func greg() -> Date {
        return abs2greg(absdate: self.abs())
    }

    public func dow() -> DayOfWeek {
        let day = Int(self.abs() % 7)
        return DayOfWeek(rawValue: day)!
    }
}

/**
 * Note: Applying this function to d+6 gives us the DAYNAME on or after an
 * absolute day d. Similarly, applying it to d+3 gives the DAYNAME nearest to
 * absolute date d, applying it to d-1 gives the DAYNAME previous to absolute
 * date d, and applying it to d+7 gives the DAYNAME following absolute date d.
 * @param {number} dayOfWeek
 * @param {number} absdate
 * @return {number}
 */
public func dayOnOrBefore(dayOfWeek: DayOfWeek, absdate: Int64) -> Int64 {
    return absdate - ((absdate - Int64(dayOfWeek.rawValue)) % 7)
}
