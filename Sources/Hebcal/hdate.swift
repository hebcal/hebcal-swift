//
//  hdate.swift
//
//
//  Created by Michael Radwin on 8/17/21.
//

import Foundation

public enum HebrewMonth: Int, CaseIterable, Codable, Sendable {
    case NISAN = 1, IYYAR, SIVAN, TAMUZ, AV, ELUL,
         TISHREI, CHESHVAN, KISLEV, TEVET, SHVAT, ADAR_I, ADAR_II
}

public enum DayOfWeek: Int, CaseIterable, Codable, Sendable {
    case SUN = 0, MON, TUE, WED, THU, FRI, SAT
}

/// Absolute (R.D.) day number of the day before 1 Tishrei 1.
private let epoch: Int64 = -1373428

/// `absdate` modulo 7 in the range 0...6 (Swift's `%` is negative for negative
/// `absdate`), which is the day of the week with 0 = Sunday.
func dayOfWeekIndex(_ absdate: Int64) -> Int {
    let r = Int(absdate % 7)
    return r < 0 ? r + 7 : r
}

public enum HDateError: Error, Equatable, Sendable {
    /// The date is before 1 Tishrei 1, the first day of the Hebrew calendar.
    case beforeFirstHebrewDate
    /// The day is not between 1 and the number of days in the month.
    case dayOutOfRange
}

/// Whether the Hebrew `year` is a leap year (has 13 months).
public func isLeapYear(year: Int) -> Bool {
    return (1 + year * 7) % 19 < 7
}

/// Number of months in the Hebrew `year`: 12, or 13 in a leap year.
public func monthsInYear(year: Int) -> Int {
    return isLeapYear(year: year) ? 13 : 12
}

/// Days from the Sunday before the start of the Hebrew calendar to the mean
/// conjunction of Tishrei in the Hebrew `year`, after applying the postponements
/// (dechiyot).
///
/// Not cached: the calculation is ~20 integer operations (~9 ns), cheaper than
/// any thread-safe cache would be. (A former `[Int: Int64]` dictionary cache was
/// mutated without synchronization and crashed when HDates were created on
/// several threads at once.)
func elapsedDays(year: Int) -> Int64 {
    let prevYear = year - 1

    let mElapsed = Int64(
        235 * (prevYear / 19) +             // months in complete 19-year cycles
        12 * (prevYear % 19) +              // regular months in this cycle
        ((prevYear % 19) * 7 + 1) / 19)     // leap months in this cycle

    let pElapsed = 204 + 793 * (mElapsed % 1080)
    let hElapsed = 5 + 12 * mElapsed + 793 * (mElapsed / 1080) + pElapsed / 1080
    let parts = (pElapsed % 1080) + 1080 * (hElapsed % 24)
    let day = 1 + 29 * mElapsed + hElapsed / 24

    var altDay = day
    if parts >= 19440 ||
        (day % 7 == 2 && parts >= 9924 && !isLeapYear(year: year)) ||
        (day % 7 == 1 && parts >= 16789 && isLeapYear(year: prevYear)) {
        altDay += 1
    }

    // Lo ADU Rosh: Rosh Hashana never falls on Sunday, Wednesday or Friday
    switch altDay % 7 {
    case 0, 3, 5: return altDay + 1
    default: return altDay
    }
}

/// Number of days in the Hebrew `year`.
public func daysInYear(year: Int) -> Int {
    return Int(elapsedDays(year: year + 1) - elapsedDays(year: year))
}

/// Whether Cheshvan has 30 days in the Hebrew `year`.
public func longCheshvan(year: Int) -> Bool {
    return daysInYear(year: year) % 10 == 5
}

/// Whether Kislev has 29 days in the Hebrew `year`.
public func shortKislev(year: Int) -> Bool {
    return daysInYear(year: year) % 10 == 3
}

/// Number of days (29 or 30) in the Hebrew `month` of `year`.
public func daysInMonth(month: HebrewMonth, year: Int) -> Int {
    switch month {
    case .IYYAR, .TAMUZ, .ELUL, .TEVET, .ADAR_II:
        return 29
    case .ADAR_I:
        return isLeapYear(year: year) ? 30 : 29
    case .CHESHVAN:
        return longCheshvan(year: year) ? 30 : 29
    case .KISLEV:
        return shortKislev(year: year) ? 29 : 30
    default:
        return 30
    }
}

/// Converts a Hebrew date to an absolute (R.D.) day number.
public func hebrew2abs(year: Int, month: HebrewMonth, day: Int) -> Int64 {
    func days<R: Sequence<Int>>(inMonths months: R) -> Int {
        return months.reduce(0) { $0 + daysInMonth(month: HebrewMonth(rawValue: $1)!, year: year) }
    }
    let tishrei = HebrewMonth.TISHREI.rawValue
    // The year starts in Tishrei, so Nisan through Elul come after Adar.
    let daysBefore = month.rawValue < tishrei
        ? days(inMonths: tishrei...monthsInYear(year: year)) + days(inMonths: HebrewMonth.NISAN.rawValue..<month.rawValue)
        : days(inMonths: tishrei..<month.rawValue)
    return newYear(year: year) + Int64(daysBefore + day - 1)
}

/// Absolute (R.D.) day number of 1 Tishrei of the Hebrew `year`.
func newYear(year: Int) -> Int64 {
    return epoch + elapsedDays(year: year)
}

/// A date in the Hebrew calendar, on or after 1 Tishrei 1 (``HDate/minAbsDate``).
///
/// Immutable, so instances can be shared freely across threads.
public final class HDate: Comparable, Hashable, Codable, Identifiable, Sendable {
    /// Absolute (R.D.) day number of 1 Tishrei 1, the earliest supported date
    /// (Monday, 7 October 3761 BCE in the proleptic Julian calendar).
    public static let minAbsDate: Int64 = epoch + 1

    public let yy: Int
    public let mm: HebrewMonth
    public let dd: Int
    private let absdate: Int64

    /// Creates a Hebrew date. Adar II in a non-leap year is treated as Adar.
    ///
    /// - Precondition: The date is on or after 1 Tishrei 1. Use
    ///   ``init(validatingYY:mm:dd:)`` to get an error instead.
    public init(yy: Int, mm: HebrewMonth, dd: Int) {
        let month = (mm == .ADAR_II && !isLeapYear(year: yy)) ? HebrewMonth.ADAR_I : mm
        let absdate = hebrew2abs(year: yy, month: month, day: dd)
        precondition(yy >= 1 && absdate >= HDate.minAbsDate, "HDate before 1 Tishrei 1: \(dd) \(month) \(yy)")
        self.yy = yy
        self.mm = month
        self.dd = dd
        self.absdate = absdate
    }

    /// Creates a Hebrew date, checking that it is on or after 1 Tishrei 1 and that
    /// `dd` is a day of the month. Adar II in a non-leap year is treated as Adar.
    public convenience init(validatingYY yy: Int, mm: HebrewMonth, dd: Int) throws {
        guard yy >= 1 else {
            throw HDateError.beforeFirstHebrewDate
        }
        let month = (mm == .ADAR_II && !isLeapYear(year: yy)) ? HebrewMonth.ADAR_I : mm
        guard (1...daysInMonth(month: month, year: yy)).contains(dd) else {
            throw HDateError.dayOutOfRange
        }
        self.init(yy: yy, mm: month, dd: dd)
    }

    /// The Hebrew date of the Gregorian day `date` falls on in `calendar`.
    ///
    /// - Precondition: The date is on or after 1 Tishrei 1.
    public convenience init(date: Date, calendar: Calendar) {
        self.init(absdate: greg2abs(date: date, calendar: calendar))
    }

    /// The Hebrew date of the absolute (R.D.) day number `absdate`, checking that
    /// it is on or after 1 Tishrei 1 (``minAbsDate``).
    public convenience init(validatingAbsdate absdate: Int64) throws {
        guard absdate >= HDate.minAbsDate else {
            throw HDateError.beforeFirstHebrewDate
        }
        self.init(absdate: absdate)
    }

    /// The Hebrew date of the absolute (R.D.) day number `absdate`.
    ///
    /// - Precondition: `absdate >= HDate.minAbsDate` (1 Tishrei 1). Use
    ///   ``init(validatingAbsdate:)`` to get an error instead.
    public init(absdate: Int64) {
        precondition(absdate >= HDate.minAbsDate, "HDate before 1 Tishrei 1: absdate \(absdate)")
        var year = Int(Double(absdate - epoch) / 365.24682220597794)
        while newYear(year: year) <= absdate {
            year += 1
        }
        year -= 1
        var month: HebrewMonth = absdate < hebrew2abs(year: year, month: .NISAN, day: 1) ? .TISHREI : .NISAN
        while absdate > hebrew2abs(year: year, month: month, day: daysInMonth(month: month, year: year)) {
            month = HebrewMonth(rawValue: month.rawValue + 1)!
        }
        self.yy = year
        self.mm = month
        self.dd = Int(1 + absdate - hebrew2abs(year: year, month: month, day: 1))
        self.absdate = absdate
    }

    // MARK: Comparable, Hashable

    public static func < (lhs: HDate, rhs: HDate) -> Bool {
        return lhs.absdate < rhs.absdate
    }

    public static func == (lhs: HDate, rhs: HDate) -> Bool {
        return lhs.yy == rhs.yy && lhs.mm == rhs.mm && lhs.dd == rhs.dd
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(yy)
        hasher.combine(mm)
        hasher.combine(dd)
    }

    // MARK: Codable

    private enum CodingKeys: String, CodingKey {
        case yy, mm, dd, absdate
    }

    /// Decodes `yy`, `mm` and `dd`. Any encoded `absdate` is ignored and recomputed.
    /// Throws `DecodingError.dataCorrupted` for a date before 1 Tishrei 1.
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let yy = try container.decode(Int.self, forKey: .yy)
        let mm = try container.decode(HebrewMonth.self, forKey: .mm)
        let dd = try container.decode(Int.self, forKey: .dd)
        guard yy >= 1 && hebrew2abs(year: yy, month: mm, day: dd) >= HDate.minAbsDate else {
            throw DecodingError.dataCorruptedError(forKey: .yy, in: container,
                                                   debugDescription: "HDate before 1 Tishrei 1: \(dd) \(mm) \(yy)")
        }
        self.init(yy: yy, mm: mm, dd: dd)
    }

    /// Encodes `absdate` too, so payloads stay readable by older versions of this library.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(yy, forKey: .yy)
        try container.encode(mm, forKey: .mm)
        try container.encode(dd, forKey: .dd)
        try container.encode(absdate, forKey: .absdate)
    }

    // MARK: Conversions

    /// The absolute (R.D.) day number of this date.
    public func abs() -> Int64 {
        return absdate
    }

    /// This date as a `Date` at midnight in the current calendar.
    public func greg() -> Date {
        return abs2greg(absdate: absdate, calendar: .current)
    }

    /// The day of the week of this date.
    public func dow() -> DayOfWeek {
        return DayOfWeek(rawValue: dayOfWeekIndex(absdate))!
    }

    // MARK: Navigation

    /// The next Hebrew date.
    public func next() -> HDate {
        return HDate(absdate: absdate + 1)
    }

    /// The previous Hebrew date.
    public func prev() -> HDate {
        return HDate(absdate: absdate - 1)
    }

    /// The `dayOfWeek` strictly before this date.
    public func before(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: absdate - 1))
    }

    /// The `dayOfWeek` on or before this date.
    public func onOrBefore(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: absdate))
    }

    /// The `dayOfWeek` nearest to this date.
    public func nearest(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: absdate + 3))
    }

    /// The `dayOfWeek` on or after this date.
    public func onOrAfter(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: absdate + 6))
    }

    /// The `dayOfWeek` strictly after this date.
    public func after(dayOfWeek: DayOfWeek) -> HDate {
        return HDate(absdate: dayOnOrBefore(dayOfWeek: dayOfWeek, absdate: absdate + 7))
    }

    /// The untranslated month name, e.g. "Sh'vat" or "Adar I".
    public func monthName() -> String {
        switch mm {
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
        case .ADAR_I: return isLeapYear(year: yy) ? "Adar I" : "Adar"
        case .ADAR_II: return "Adar II"
        }
    }
}

/// The absolute day number of the `dayOfWeek` on or before `absdate`.
///
/// Applying this to `absdate + 6` gives the `dayOfWeek` on or after `absdate`;
/// `absdate + 3` gives the nearest; `absdate - 1` the previous; and
/// `absdate + 7` the following.
public func dayOnOrBefore(dayOfWeek: DayOfWeek, absdate: Int64) -> Int64 {
    return absdate - Int64(dayOfWeekIndex(absdate - Int64(dayOfWeek.rawValue)))
}

extension HDate: CustomStringConvertible {
    public var description: String {
        return "\(dd) \(monthName()) \(yy)"
    }
}
