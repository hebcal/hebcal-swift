//
//  hdate.swift
//  
//
//  Created by Michael Radwin on 8/17/21.
//

import Foundation

public enum HebrewMonth: Int, CaseIterable, Codable {
    case NISAN = 1, IYYAR, SIVAN, TAMUZ, AV, ELUL,
         TISHREI, CHESHVAN, KISLEV, TEVET, SHVAT, ADAR_I, ADAR_II
}

public enum DayOfWeek: Int, CaseIterable, Codable {
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

var edCache: [Int:Int64] = [:]

func elapsedDays(year: Int) -> Int64 {
    if let ed = edCache[year] {
        return ed
    }
    let ed = elapsedDays0(year: year)
    edCache[year] = ed
    return ed
}

/**
 * Days from sunday prior to start of Hebrew calendar to mean
 * conjunction of Tishrei in Hebrew YEAR
 * @private
 * @param {number} year Hebrew year
 * @return {number}
 */
func elapsedDays0(year: Int) -> Int64 {
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

let TISHREI = HebrewMonth.TISHREI.rawValue

public func hebrew2abs(year: Int, month: HebrewMonth, day: Int) -> Int64 {
    var tempabs: Int64 = Int64(day)
    let imonth: Int = month.rawValue
    if imonth < TISHREI {
        for m in TISHREI...monthsInYear(year: year) {
            tempabs += Int64(daysInMonth(month: HebrewMonth(rawValue: m)!, year: year))
        }
        for m in HebrewMonth.NISAN.rawValue..<imonth {
            tempabs += Int64(daysInMonth(month: HebrewMonth(rawValue: m)!, year: year))
        }
    } else {
        for m in TISHREI..<imonth {
            tempabs += Int64(daysInMonth(month: HebrewMonth(rawValue: m)!, year: year))
        }
    }
    return EPOCH + elapsedDays(year: year) + tempabs - 1
}

func newYear(year: Int) -> Int64 {
    return EPOCH + elapsedDays(year: year)
}

public class HDate: Comparable, Hashable, Codable, Identifiable {
    public static func < (lhs: HDate, rhs: HDate) -> Bool {
        if lhs.yy != rhs.yy {
            return lhs.yy < rhs.yy
        } else {
            return lhs.abs() < rhs.abs()
        }
    }

    public static func == (lhs: HDate, rhs: HDate) -> Bool {
        return lhs.yy == rhs.yy && lhs.mm == rhs.mm && lhs.dd == rhs.dd
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(yy)
        hasher.combine(mm)
        hasher.combine(dd)
    }

    public let yy: Int
    public let mm: HebrewMonth
    public let dd: Int
    private var absdate: Int64?

    public init(yy: Int, mm: HebrewMonth, dd: Int) {
        self.yy = yy
        self.mm = (mm == .ADAR_II && !isLeapYear(year: yy)) ? .ADAR_I : mm
        self.dd = dd
    }

    public convenience init(date: Date, calendar: Calendar) {
        self.init(absdate: greg2abs(date: date, calendar: calendar))
    }

    public init(absdate: Int64) {
        self.absdate = absdate
        let approx = Int(Double(absdate - EPOCH) / 365.24682220597794)
        var year = approx
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
        if absdate == nil {
            absdate = hebrew2abs(year: self.yy, month: self.mm, day: self.dd)
        }
        return absdate!
    }

    // Converts this Hebrew Date to a Gregorian Date object.
    public func greg() -> Date {
        return abs2greg(absdate: self.abs(), calendar: .current)
    }

    // Dow returns the day of the week specified by hd.
    public func dow() -> DayOfWeek {
        let day = Int(self.abs() % 7)
        return DayOfWeek(rawValue: day)!
    }

    // Next returns the next Hebrew date.
    public func next() -> HDate {
        return HDate(absdate: self.abs() + 1)
    }

    // Prev returns the previous Hebrew date.
    public func prev() -> HDate {
        return HDate(absdate: self.abs() - 1)
    }

    // Before returns an HDate representing the dayOfWeek before
    // the Hebrew date specified by hd.
    public func before(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: self.abs() - 1))
    }

    // OnOrBefore returns an HDate corresponding to the dayOfWeek on or before
    // the Hebrew date specified by hd.
    public func onOrBefore(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: self.abs()))
    }

    // Nearest returns an HDate representing the nearest dayOfWeek to
    // the Hebrew date specified by hd.
    public func nearest(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: self.abs() + 3))
    }

    // OnOrAfter returns an HDate corresponding to the dayOfWeek on or after
    // the Hebrew date specified by hd.
    public func onOrAfter(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: self.abs() + 6))
    }

    // After returns an HDate corresponding to the dayOfWeek after
    // the Hebrew date specified by hd.
    public func after(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: self.abs() + 7))
    }

    public func monthName() -> String {
        switch self.mm {
        case .NISAN: return "Nisan"
        case .IYYAR: return "Iyyar"
        case .SIVAN: return "Sivan"
        case .TAMUZ: return "Tamuz"
        case .AV: return "Av"
        case .ELUL: return "Elul"
        case .TISHREI: return "Tishrei"
        case .CHESHVAN: return "Cheshvan"
        case .KISLEV: return "Kislev"
        case .TEVET: return "Tevet"
        case .SHVAT: return "Sh'vat"
        case .ADAR_I:
            return isLeapYear(year: self.yy) ? "Adar I" : "Adar"
        case .ADAR_II:
            return "Adar II"
        }
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

extension HDate: CustomStringConvertible {
    public var description: String {
        return "\(dd) \(monthName()) \(yy)"
    }
}
