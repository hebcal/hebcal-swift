import Foundation
import Testing
@testable import Hebcal

struct CalendarMathTests {
    @Test(arguments: [
        (5780, 2110760), (5708, 2084447), (3762, 1373677), (3671, 1340455),
        (1234, 450344), (123, 44563), (2, 356), (1, 1),
    ] as [(Int, Int64)])
    func elapsedDays(year: Int, expected: Int64) {
        #expect(Hebcal.elapsedDays(year: year) == expected)
    }

    @Test(arguments: [5779, 5782, 5784, 5749, 5252, 4528])
    func leapYear(year: Int) {
        #expect(isLeapYear(year: year))
        #expect(monthsInYear(year: year) == 13)
    }

    @Test(arguments: [5780, 5781, 5783, 5778, 5511, 4527])
    func nonLeapYear(year: Int) {
        #expect(!isLeapYear(year: year))
        #expect(monthsInYear(year: year) == 12)
    }

    @Test(arguments: [
        (5779, 385), (5780, 355), (5781, 353), (5782, 384), (5783, 355), (5784, 383),
        (5785, 355), (5786, 354), (5787, 385), (5788, 355), (5789, 354),
        (3762, 383), (3671, 354), (1234, 353), (123, 355), (2, 355), (1, 355),
    ])
    func daysInYear(year: Int, expected: Int) {
        #expect(Hebcal.daysInYear(year: year) == expected)
    }

    @Test(arguments: [
        (HebrewMonth.IYYAR, 5780, 29), (.SIVAN, 5780, 30),
        (.CHESHVAN, 5782, 29), (.CHESHVAN, 5783, 30),
        (.KISLEV, 5783, 30), (.KISLEV, 5784, 29),
    ])
    func daysInMonth(month: HebrewMonth, year: Int, expected: Int) {
        #expect(Hebcal.daysInMonth(month: month, year: year) == expected)
    }
}

struct HDateTests {
    /// Hebrew dates and their absolute (R.D.) day numbers.
    static let absDates: [(Int, HebrewMonth, Int, Int64)] = [
        (5769, .CHESHVAN, 15, 733359),
        (5708, .IYYAR, 6, 711262),
        (3762, .TISHREI, 1, 249),
        (3761, .NISAN, 1, 72),
        (3761, .TEVET, 18, 1),
        (3761, .TEVET, 17, 0),
        (3761, .TEVET, 16, -1),
        (3761, .TEVET, 1, -16),
        (9999, .ELUL, 29, 2278650),
    ]

    @Test(arguments: absDates)
    func hebrewToAbs(year: Int, month: HebrewMonth, day: Int, abs: Int64) {
        #expect(hebrew2abs(year: year, month: month, day: day) == abs)
        #expect(HDate(yy: year, mm: month, dd: day).abs() == abs)
    }

    @Test(arguments: absDates)
    func absToHebrew(year: Int, month: HebrewMonth, day: Int, abs: Int64) {
        #expect(HDate(absdate: abs) == HDate(yy: year, mm: month, dd: day))
    }

    @Test(arguments: [
        Calendar.current,
        Calendar(identifier: .gregorian),
        Calendar(identifier: .iso8601),
    ])
    func fromDate(calendar: Calendar) {
        let date = Date(timeIntervalSince1970: 1307032496)
        #expect(HDate(date: date, calendar: calendar) == HDate(yy: 5771, mm: .IYYAR, dd: 29))
    }

    @Test func adar2InNonLeapYearIsAdar() {
        let hd = HDate(yy: 5785, mm: .ADAR_II, dd: 14)
        #expect(hd.mm == .ADAR_I)
        #expect(hd.description == "14 Adar 5785")
    }

    @Test func codableRoundTrip() throws {
        let hd = HDate(yy: 5785, mm: .TISHREI, dd: 1)
        let data = try JSONEncoder().encode(hd)
        let decoded = try JSONDecoder().decode(HDate.self, from: data)
        #expect(decoded == hd)
        #expect(decoded.abs() == hd.abs())

        // Older versions of the library read `absdate` if present, so keep writing it
        let json = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        #expect(json["absdate"] as? Int64 == hd.abs())
    }

    @Test(arguments: [
        #"{"yy":5785,"mm":7,"dd":1}"#,
        #"{"yy":5785,"mm":7,"dd":1,"absdate":739162}"#,
    ])
    func decodesLegacyPayloads(json: String) throws {
        let hd = try JSONDecoder().decode(HDate.self, from: Data(json.utf8))
        #expect(hd == HDate(yy: 5785, mm: .TISHREI, dd: 1))
        #expect(hd.abs() == 739162)
    }

    @Test func firstHebrewDate() {
        #expect(HDate.minAbsDate == -1373427)
        let first = HDate(absdate: HDate.minAbsDate)
        #expect(first == HDate(yy: 1, mm: .TISHREI, dd: 1))
        #expect(first.abs() == HDate.minAbsDate)
        #expect(first.dow() == .MON)  // Molad BaHaRaD
    }

    @Test func validatingInitializers() throws {
        #expect(try HDate(validatingAbsdate: HDate.minAbsDate) == HDate(yy: 1, mm: .TISHREI, dd: 1))
        #expect(throws: HDateError.beforeFirstHebrewDate) { try HDate(validatingAbsdate: HDate.minAbsDate - 1) }

        #expect(try HDate(validatingYY: 1, mm: .TISHREI, dd: 1).abs() == HDate.minAbsDate)
        #expect(try HDate(validatingYY: 5785, mm: .ADAR_II, dd: 14).mm == .ADAR_I)
        #expect(throws: HDateError.beforeFirstHebrewDate) { try HDate(validatingYY: 0, mm: .ELUL, dd: 29) }
        #expect(throws: HDateError.dayOutOfRange) { try HDate(validatingYY: 1, mm: .TISHREI, dd: 0) }
        #expect(throws: HDateError.dayOutOfRange) { try HDate(validatingYY: 5785, mm: .IYYAR, dd: 30) }
    }

    @Test func absdateBeforeFirstHebrewDateTraps() async {
        await #expect(processExitsWith: .failure) {
            _ = HDate(absdate: HDate.minAbsDate - 1)
        }
    }

    @Test func yearBeforeFirstHebrewDateTraps() async {
        await #expect(processExitsWith: .failure) {
            _ = HDate(yy: 0, mm: .ELUL, dd: 29)
        }
    }

    @Test func decodingDateBeforeFirstHebrewDateThrows() {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(HDate.self, from: Data(#"{"yy":0,"mm":6,"dd":29}"#.utf8))
        }
    }

    @Test(arguments: [HDate.minAbsDate, -1_000_000, -8, -5, -1, 0, 1, 6, 739162])
    func dayOfWeekArithmetic(absdate: Int64) {
        // Absolute day 1 (1 January 1 CE) was a Monday, so day 0 was a Sunday.
        let expected = DayOfWeek(rawValue: Int(((absdate % 7) + 7) % 7))!
        #expect(HDate(absdate: absdate).dow() == expected)
        for dow in DayOfWeek.allCases {
            let onOrBefore = dayOnOrBefore(dayOfWeek: dow, absdate: absdate)
            #expect(onOrBefore <= absdate && absdate - onOrBefore < 7)
            if onOrBefore >= HDate.minAbsDate {
                #expect(HDate(absdate: onOrBefore).dow() == dow)
            }
        }
    }

    @Test(arguments: [1, 2, 3000, 3761])
    func earlyYears(year: Int) {
        // Rosh Hashana on or before absolute day 0 used to crash these
        #expect(!getAllHolidaysForYear(year: year).isEmpty)
        #expect(Sedra(year: year, il: false).find(0) != nil)
    }

    @Test func concurrentCreation() async {
        // Used to crash: elapsedDays() cached in a Dictionary mutated
        // without synchronization.
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<64 {
                group.addTask {
                    for year in (5700 + i * 5)...(5700 + i * 5 + 40) {
                        let hd = HDate(yy: year, mm: .TISHREI, dd: 1)
                        #expect(HDate(absdate: hd.abs()).yy == year)
                    }
                }
            }
        }
    }
}
