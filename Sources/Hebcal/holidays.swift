//
//  holidays.swift
//  Created by Michael Radwin on 8/29/21.
//

import Foundation

public struct HolidayFlags: OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    static public let NONE = HolidayFlags([])
    static public let CHAG = HolidayFlags(rawValue: 0x000001)
    static public let LIGHT_CANDLES = HolidayFlags(rawValue: 0x000002)
    static public let YOM_TOV_ENDS = HolidayFlags(rawValue: 0x000004)
    static public let CHUL_ONLY = HolidayFlags(rawValue: 0x000008) // chutz l'aretz (Diaspora)
    static public let IL_ONLY = HolidayFlags(rawValue: 0x000010) // b'aretz (Israel)
    static public let LIGHT_CANDLES_TZEIS = HolidayFlags(rawValue: 0x000020)
    static public let CHANUKAH_CANDLES = HolidayFlags(rawValue: 0x000040)
    static public let ROSH_CHODESH = HolidayFlags(rawValue: 0x000080)
    static public let MINOR_FAST = HolidayFlags(rawValue: 0x000100)
    static public let SPECIAL_SHABBAT = HolidayFlags(rawValue: 0x000200)
    static public let PARSHA_HASHAVUA = HolidayFlags(rawValue: 0x000400)
    static public let DAF_YOMI = HolidayFlags(rawValue: 0x000800)
    static public let OMER_COUNT = HolidayFlags(rawValue: 0x001000)
    static public let MODERN_HOLIDAY = HolidayFlags(rawValue: 0x002000)
    static public let MAJOR_FAST = HolidayFlags(rawValue: 0x004000)
    static public let SHABBAT_MEVARCHIM = HolidayFlags(rawValue: 0x008000)
    static public let MOLAD = HolidayFlags(rawValue: 0x010000)
    static public let USER_EVENT = HolidayFlags(rawValue: 0x020000)
    static public let HEBREW_DATE = HolidayFlags(rawValue: 0x040000)
    static public let MINOR_HOLIDAY = HolidayFlags(rawValue: 0x080000)
    static public let EREV = HolidayFlags(rawValue: 0x100000)
    static public let CHOL_HAMOED = HolidayFlags(rawValue: 0x200000)
}

public struct HEvent: Comparable {
    public static func < (lhs: HEvent, rhs: HEvent) -> Bool {
        return lhs.hdate < rhs.hdate
    }

    public static func == (lhs: HEvent, rhs: HEvent) -> Bool {
        return lhs.desc == rhs.desc && lhs.hdate == rhs.hdate && lhs.flags == rhs.flags
    }

    public let hdate: HDate
    public let desc: String
    public let flags: HolidayFlags
    public let emoji: String?
    public init(hdate: HDate, desc: String, flags: HolidayFlags? = .NONE, emoji: String? = nil) {
        self.hdate = hdate
        self.desc = desc
        self.flags = flags ?? .NONE
        self.emoji = emoji
    }
}

struct Holiday {
    let mm: HebrewMonth
    let dd: Int
    let desc: String
    let flags: HolidayFlags
    let emoji: String?
    public init(mm: HebrewMonth, dd: Int, desc: String, flags: HolidayFlags? = .NONE, emoji: String? = nil) {
        self.mm = mm
        self.dd = dd
        self.desc = desc
        self.flags = flags ?? .NONE
        self.emoji = emoji
    }
}

let chanukahEmoji = "🕎"

let staticHolidays: [Holiday] = [
    Holiday(mm: .TISHREI, dd: 1, desc: "Rosh Hashana",
            flags: [.CHAG,  .LIGHT_CANDLES_TZEIS], emoji: "🍏🍯"),
    Holiday(mm: .TISHREI, dd: 2, desc: "Rosh Hashana II",
            flags: [.CHAG,  .YOM_TOV_ENDS], emoji: "🍏🍯"),
    Holiday(mm: .TISHREI, dd: 9, desc: "Erev Yom Kippur",
            flags: [.EREV, .LIGHT_CANDLES]),
    Holiday(mm: .TISHREI, dd: 10, desc: "Yom Kippur",
            flags: [.CHAG, .MAJOR_FAST, .YOM_TOV_ENDS]),
    Holiday(mm: .TISHREI, dd: 14, desc: "Erev Sukkot", flags: [.EREV, .LIGHT_CANDLES]),

    Holiday(mm: .TISHREI, dd: 15, desc: "Sukkot I", flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS]),
    Holiday(mm: .TISHREI, dd: 16, desc: "Sukkot II", flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS]),
    Holiday(mm: .TISHREI, dd: 17, desc: "Sukkot III (CH''M)", flags: [.CHUL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 18, desc: "Sukkot IV (CH''M)", flags: [.CHUL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 19, desc: "Sukkot V (CH''M)", flags: [.CHUL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 20, desc: "Sukkot VI (CH''M)", flags: [.CHUL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 22, desc: "Shmini Atzeret",
            flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS]),
    Holiday(mm: .TISHREI, dd: 23, desc: "Simchat Torah",
            flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS]),

    Holiday(mm: .TISHREI, dd: 15, desc: "Sukkot I", flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS]),
    Holiday(mm: .TISHREI, dd: 16, desc: "Sukkot II (CH''M)", flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 17, desc: "Sukkot III (CH''M)", flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 18, desc: "Sukkot IV (CH''M)", flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 19, desc: "Sukkot V (CH''M)", flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 20, desc: "Sukkot VI (CH''M)", flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 22, desc: "Shmini Atzeret",
            flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS]),

    Holiday(mm: .TISHREI, dd: 21, desc: "Sukkot VII (Hoshana Raba)",
            flags: [.LIGHT_CANDLES, .CHOL_HAMOED]),
    Holiday(mm: .KISLEV, dd: 24, desc: "Chanukah: 1 Candle",
            flags: [.EREV, .MINOR_HOLIDAY, .CHANUKAH_CANDLES],
            emoji: chanukahEmoji),
    Holiday(mm: .TEVET, dd: 10, desc: "Asara B'Tevet", flags: .MINOR_FAST),
    Holiday(mm: .SHVAT, dd: 15, desc: "Tu BiShvat", flags: .MINOR_HOLIDAY, emoji: "🌳"),
    Holiday(mm: .ADAR_II, dd: 13, desc: "Erev Purim", flags: [.EREV, .MINOR_HOLIDAY], emoji: "🎭️📜"),
    Holiday(mm: .ADAR_II, dd: 14, desc: "Purim", flags: .MINOR_HOLIDAY, emoji: "🎭️📜"),
    Holiday(mm: .NISAN, dd: 14, desc: "Erev Pesach", flags: [.EREV, .LIGHT_CANDLES]),
    // Pesach Israel
    Holiday(mm: .NISAN, dd: 15, desc: "Pesach I",
            flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS]),
    Holiday(mm: .NISAN, dd: 16, desc: "Pesach II (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .NISAN, dd: 17, desc: "Pesach III (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .NISAN, dd: 18, desc: "Pesach IV (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .NISAN, dd: 19, desc: "Pesach V (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .NISAN, dd: 20, desc: "Pesach VI (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED, .LIGHT_CANDLES]),
    Holiday(mm: .NISAN, dd: 21, desc: "Pesach VII",
            flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS]),
    // Pesach chutz l'aretz
    Holiday(mm: .NISAN, dd: 15, desc: "Pesach I",
            flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS]),
    Holiday(mm: .NISAN, dd: 16, desc: "Pesach II",
            flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS]),
    Holiday(mm: .NISAN, dd: 17, desc: "Pesach III (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .NISAN, dd: 18, desc: "Pesach IV (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .NISAN, dd: 19, desc: "Pesach V (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .NISAN, dd: 20, desc: "Pesach VI (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED, .LIGHT_CANDLES]),
    Holiday(mm: .NISAN, dd: 21, desc: "Pesach VII",
            flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS]),
    Holiday(mm: .NISAN, dd: 22, desc: "Pesach VIII",
            flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS]),

    Holiday(mm: .IYYAR, dd: 14, desc: "Pesach Sheni", flags: .MINOR_HOLIDAY),
    Holiday(mm: .IYYAR, dd: 18, desc: "Lag BaOmer", flags: .MINOR_HOLIDAY, emoji: "🔥"),
    Holiday(mm: .SIVAN, dd: 5, desc: "Erev Shavuot",
            flags: [.EREV, .LIGHT_CANDLES], emoji: "⛰️🌸"),
    Holiday(mm: .SIVAN, dd: 6, desc: "Shavuot",
            flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS], emoji: "⛰️🌸"),
    Holiday(mm: .SIVAN, dd: 6, desc: "Shavuot I",
            flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS], emoji: "⛰️🌸"),
    Holiday(mm: .SIVAN, dd: 7, desc: "Shavuot II",
            flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS], emoji: "⛰️🌸"),
    Holiday(mm: .AV, dd: 15, desc: "Tu B'Av",
            flags: .MINOR_HOLIDAY, emoji: "❤️"),
    Holiday(mm: .ELUL, dd: 1, desc: "Rosh Hashana LaBehemot",
            flags: .MINOR_HOLIDAY, emoji: "🐑"),
    Holiday(mm: .ELUL, dd: 29, desc: "Erev Rosh Hashana",
            flags: [.EREV, .LIGHT_CANDLES], emoji: "🍏🍯"),
]


struct ModernHoliday {
    let h: Holiday
    let firstYear: Int
    let chul: Bool
    let suppressEmoji: Bool
    let satPostponeToSun: Bool
    let friPostponeToSun: Bool
}


let staticModernHolidays: [ModernHoliday] = [
    ModernHoliday(h: Holiday(mm: .IYYAR, dd: 28, desc: "Yom Yerushalayim"),
                  firstYear: 5727,
                  chul: true,
                  suppressEmoji: false,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .KISLEV, dd: 6, desc: "Ben-Gurion Day"),
                  firstYear: 5737,
                  chul: false,
                  suppressEmoji: false,
                  satPostponeToSun: true, friPostponeToSun: true),
    ModernHoliday(h: Holiday(mm: .SHVAT, dd: 30, desc: "Family Day"),
                  firstYear: 5750,
                  chul: false,
                  suppressEmoji: true,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .CHESHVAN, dd: 12, desc: "Yitzhak Rabin Memorial Day"),
                  firstYear: 5758,
                  chul: false,
                  suppressEmoji: false,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .IYYAR, dd: 10, desc: "Herzl Day"),
                  firstYear: 5764,
                  chul: false,
                  suppressEmoji: false,
                  satPostponeToSun: true, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .TAMUZ, dd: 29, desc: "Jabotinsky Day"),
                  firstYear: 5765,
                  chul: false,
                  suppressEmoji: false,
                  satPostponeToSun: true, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .CHESHVAN, dd: 29, desc: "Sigd"),
                  firstYear: 5769,
                  chul: true,
                  suppressEmoji: true,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .NISAN, dd: 10, desc: "Yom HaAliyah"),
                  firstYear: 5777,
                  chul: true,
                  suppressEmoji: false,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .CHESHVAN, dd: 7, desc: "Yom HaAliyah School Observance"),
                  firstYear: 5777,
                  chul: false,
                  suppressEmoji: false,
                  satPostponeToSun: false, friPostponeToSun: false),
]


public func getHolidaysForYear(year: Int, il: Bool) -> [HEvent] {
    let events = getAllHolidaysForYear(year: year)
    let result = events.filter {
        (il && !$0.flags.contains(.CHUL_ONLY)) || (!il && !$0.flags.contains(.IL_ONLY))
    }
    return result
}

public func getAllHolidaysForYear(year: Int) -> [HEvent] {
    var events = [HEvent]()
    // standard holidays that don't shift based on year
    for h in staticHolidays {
        events.append(HEvent(hdate: HDate(yy: year, mm: h.mm, dd: h.dd),
                             desc: h.desc, flags: h.flags, emoji: h.emoji))
    }
    // variable holidays
    let RH = HDate(yy: year, mm: .TISHREI, dd: 1)
    let pesach = HDate(yy: year, mm: .NISAN, dd: 15)
    let pesachAbs = pesach.abs()
    events.append(contentsOf: [
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: 7 + RH.abs())),
               desc: "Shabbat Shuva", flags: .SPECIAL_SHABBAT,
               emoji: "🕍"),
        HEvent(hdate: HDate(yy: year, mm: .TISHREI, dd: 3 + (RH.dow() == .THU ? 1 : 0)),
               desc: "Tzom Gedaliah", flags: .MINOR_FAST),
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: pesachAbs - 43)),
               desc: "Shabbat Shekalim", flags: .SPECIAL_SHABBAT,
               emoji: "🕍"),
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: pesachAbs - 30)),
               desc: "Shabbat Zachor", flags: .SPECIAL_SHABBAT,
               emoji: "🕍"),
        HEvent(hdate: HDate(absdate: pesachAbs - (pesach.dow() == .TUE ? 33 : 31)),
               desc: "Ta'anit Esther", flags: .MINOR_FAST),
        HEvent(hdate: HDate(absdate: pesachAbs - (pesach.dow() == .SUN ? 28 : 29)),
               desc: "Shushan Purim", flags: .MINOR_HOLIDAY, emoji: "🎭️📜"),
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: pesachAbs - 14) - 7),
               desc: "Shabbat Parah", flags: .SPECIAL_SHABBAT,
               emoji: "🕍"),
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: pesachAbs - 14)),
               desc: "Shabbat HaChodesh", flags: .SPECIAL_SHABBAT,
               emoji: "🕍"),
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: pesachAbs - 1)),
               desc: "Shabbat HaGadol", flags: .SPECIAL_SHABBAT,
               emoji: "🕍"),
        HEvent(hdate: pesach.prev().dow() == .SAT ?
                HDate(absdate: dayOnOrBefore(dayOfWeek: .THU, absdate: pesachAbs)) :
                HDate(yy: year, mm: .NISAN, dd: 14),
               desc: "Ta'anit Bechorot", flags: .MINOR_FAST),
        HEvent(hdate: HDate(absdate: dayOnOrBefore(
                dayOfWeek: .SAT,
                absdate: HDate(yy: year + 1, mm: .TISHREI, dd: 1).abs() - 4)),
               desc: "Leil Selichot", flags: .MINOR_HOLIDAY, emoji: "🕍"),
    ])
    if isLeapYear(year: year) {
        events.append(HEvent(hdate: HDate(yy: year, mm: .ADAR_I, dd: 14),
                             desc: "Purim Katan", flags: .MINOR_HOLIDAY, emoji: "🎭️"))
    }
    // chanukah
    for i in 2...6 {
        events.append(
            HEvent(hdate: HDate(yy: year, mm: .KISLEV, dd: 23 + i),
                   desc: "Chanukah: \(i) Candles",
                   flags: [.MINOR_HOLIDAY, .CHANUKAH_CANDLES],
                   emoji: chanukahEmoji)
            )
    }
    let chanukah7 = shortKislev(year: year) ?
        HDate(yy: year, mm: .TEVET, dd: 1) :
        HDate(yy: year, mm: .KISLEV, dd: 30)
    let chanukah8 = chanukah7.next()
    events.append(contentsOf: [
        HEvent(hdate: chanukah7,
               desc: "Chanukah: 7 Candles",
               flags: [.MINOR_HOLIDAY, .CHANUKAH_CANDLES],
               emoji: chanukahEmoji),
        HEvent(hdate: chanukah8,
               desc: "Chanukah: 8 Candles",
               flags: [.MINOR_HOLIDAY, .CHANUKAH_CANDLES],
               emoji: chanukahEmoji),
        HEvent(hdate: chanukah8.next(),
               desc: "Chanukah: 8th Day",
               flags: .MINOR_HOLIDAY,
               emoji: chanukahEmoji),
    ])

    // Tisha BAv and the 3 weeks
    var tamuz17 = HDate(yy: year, mm: .TAMUZ, dd: 17)
    if tamuz17.dow() == .SAT {
        tamuz17 = tamuz17.next()
    }
    events.append(HEvent(hdate: tamuz17, desc: "Tzom Tammuz", flags: .MINOR_FAST))

    var av9dt = HDate(yy: year, mm: .AV, dd: 9)
    var av9title = "Tish'a B'Av"
    if av9dt.dow() == .SAT {
        av9dt = av9dt.next()
        av9title += " (observed)"
    }
    let av9abs = av9dt.abs()
    events.append(contentsOf: [
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: av9abs)),
               desc: "Shabbat Chazon", flags: .SPECIAL_SHABBAT,
               emoji: "🕍"),
        HEvent(hdate: av9dt.prev(), desc: "Erev Tish'a B'Av", flags: [.EREV, .MAJOR_FAST]),
        HEvent(hdate: av9dt, desc: av9title, flags: .MAJOR_FAST),
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: av9abs + 7)),
               desc: "Shabbat Nachamu", flags: .SPECIAL_SHABBAT,
               emoji: "🕍"),
    ])

    // modern holidays
    if year >= 5708 {
        // Yom HaAtzma'ut only celebrated after 1948
        var day: Int
        if (pesach.dow() == .SUN) {
            day = 2
        } else if (pesach.dow() == .SAT) {
            day = 3
        } else if (year < 5764) {
            day = 4
        } else if (pesach.dow() == .TUE) {
            day = 5
        } else {
            day = 4
        }
        let tmpDate = HDate(yy: year, mm: .IYYAR, dd: day)
        events.append(contentsOf: [
            HEvent(hdate: tmpDate, desc: "Yom HaZikaron", flags: .MODERN_HOLIDAY, emoji: "🇮🇱"),
            HEvent(hdate: tmpDate.next(), desc: "Yom HaAtzma'ut", flags: .MODERN_HOLIDAY, emoji: "🇮🇱"),
        ])
    }

    if year >= 5711 {
        // Yom HaShoah first observed in 1951
        var nisan27dt = HDate(yy: year, mm: .NISAN, dd: 27)
        /* When the actual date of Yom Hashoah falls on a Friday, the
         * state of Israel observes Yom Hashoah on the preceding
         * Thursday. When it falls on a Sunday, Yom Hashoah is observed
         * on the following Monday.
         * http://www.ushmm.org/remembrance/dor/calendar/
         */
        if nisan27dt.dow() == .FRI {
            nisan27dt = nisan27dt.prev()
        } else if nisan27dt.dow() == .SUN {
            nisan27dt = nisan27dt.next()
        }
        events.append(HEvent(hdate: nisan27dt, desc: "Yom HaShoah", flags: .MODERN_HOLIDAY))
    }

    for mh in staticModernHolidays {
        if year >= mh.firstYear {
            let h = mh.h
            let emoji = mh.suppressEmoji ? nil : "🇮🇱"
            let flags = mh.chul ? HolidayFlags.MODERN_HOLIDAY : [HolidayFlags.MODERN_HOLIDAY, HolidayFlags.IL_ONLY]
            var hd = HDate(yy: year, mm: h.mm, dd: h.dd)
            if mh.friPostponeToSun && hd.dow() == .FRI {
                hd = hd.next().next()
            }
            if mh.satPostponeToSun && hd.dow() == .SAT {
                hd = hd.next()
            }
            events.append(HEvent(hdate: hd, desc: h.desc, flags: flags, emoji: emoji))
        }
    }

    // Rosh Chodesh
    for i in 1...monthsInYear(year: year) {
        let isNisan = i == 1
        let prevMonthNum = isNisan ? monthsInYear(year: year - 1) : i - 1
        let prevMonth = HebrewMonth(rawValue: prevMonthNum)!
        let prevMonthNumDays = daysInMonth(month: prevMonth, year: isNisan ? year - 1 : year)
        let month = HebrewMonth(rawValue: i)!
        let monthName = HDate(yy: year, mm: month, dd: 1).monthName()
        let desc = "Rosh Chodesh \(monthName)"
        if prevMonthNumDays == 30 {
            events.append(HEvent(hdate: HDate(yy: year, mm: prevMonth, dd: 30),
                                 desc: desc, flags: .ROSH_CHODESH, emoji: "🌒"))
            events.append(HEvent(hdate: HDate(yy: year, mm: month, dd: 1),
                                 desc: desc, flags: .ROSH_CHODESH, emoji: "🌒"))
        } else if month != .TISHREI {
            events.append(HEvent(hdate: HDate(yy: year, mm: month, dd: 1),
                                 desc: desc, flags: .ROSH_CHODESH, emoji: "🌒"))
        }
    }

    let sedra = Sedra(year: year, il: false)
    let beshalachHd = sedra.find(15)!
    events.append(HEvent(hdate: beshalachHd, desc: "Shabbat Shirah", flags: .SPECIAL_SHABBAT,
                         emoji: "🕍"))

    events.sort()
    return events
}

public func getHolidaysOnDate(hdate: HDate, il: Bool) -> [HEvent] {
    let events = getAllHolidaysForYear(year: hdate.yy)
    return getHolidaysOnDate(events: events, hdate: hdate, il: il)
}

public func getHolidaysOnDate(events: [HEvent], hdate: HDate, il: Bool) -> [HEvent] {
    var result = [HEvent]()
    for ev in events {
        if ev.hdate == hdate {
            let f = ev.flags
            if (il && !f.contains(.CHUL_ONLY)) || (!il && !f.contains(.IL_ONLY)) {
                result.append(ev)
            }
        } else if ev.hdate > hdate {
            break
        }
    }
    return result
}
