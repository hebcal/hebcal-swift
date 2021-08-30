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
    init(hdate: HDate, desc: String, flags: HolidayFlags? = .NONE, emoji: String? = nil) {
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
    init(mm: HebrewMonth, dd: Int, desc: String, flags: HolidayFlags? = .NONE, emoji: String? = nil) {
        self.mm = mm
        self.dd = dd
        self.desc = desc
        self.flags = flags ?? .NONE
        self.emoji = emoji
    }
}

let chanukahEmoji = "🕎"
let keyCapDigits = [
    "0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣",
]

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
    Holiday(mm: .TISHREI, dd: 22, desc: "Shmini Atzeret", flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS]),
    Holiday(mm: .TISHREI, dd: 23, desc: "Simchat Torah", flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS]),

    Holiday(mm: .TISHREI, dd: 15, desc: "Sukkot I", flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS]),
    Holiday(mm: .TISHREI, dd: 16, desc: "Sukkot II (CH''M)", flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS]),
    Holiday(mm: .TISHREI, dd: 17, desc: "Sukkot III (CH''M)", flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 18, desc: "Sukkot IV (CH''M)", flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 19, desc: "Sukkot V (CH''M)", flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 20, desc: "Sukkot VI (CH''M)", flags: [.IL_ONLY, .CHOL_HAMOED]),
    Holiday(mm: .TISHREI, dd: 22, desc: "Shmini Atzeret", flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS]),

    Holiday(mm: .TISHREI, dd: 21, desc: "Sukkot VII (Hoshana Raba)", flags: [.LIGHT_CANDLES, .CHOL_HAMOED]),
    Holiday(mm: .KISLEV, dd: 24, desc: "Chanukah: 1 Candle",
            flags: [.EREV, .MINOR_HOLIDAY, .CHANUKAH_CANDLES],
            emoji: chanukahEmoji + keyCapDigits[1]),
    Holiday(mm: .TEVET, dd: 10, desc: "Asara B'Tevet", flags: .MINOR_FAST),
    Holiday(mm: .SHVAT, dd: 15, desc: "Tu BiShvat", flags: .MINOR_HOLIDAY, emoji: "🌳"),
    Holiday(mm: .ADAR_II, dd: 13, desc: "Erev Purim", flags: [.EREV, .MINOR_HOLIDAY], emoji: "🎭️📜"),
    Holiday(mm: .ADAR_II, dd: 14, desc: "Purim", flags: .MINOR_HOLIDAY, emoji: "🎭️📜"),


]

public func getHolidaysForYear(year: Int, il: Bool) -> [HEvent] {
    var events = [HEvent]()
    // standard holidays that don't shift based on year
    for h in staticHolidays {
        if (il && h.flags.contains(.CHUL_ONLY)) || (!il && h.flags.contains(.IL_ONLY)) {
            continue
        }
        events.append(HEvent(hdate: HDate(yy: year, mm: h.mm, dd: h.dd), desc: h.desc, flags: h.flags))
    }
    // variable holidays
    let RH = HDate(yy: year, mm: .TISHREI, dd: 1)
    let pesach = HDate(yy: year, mm: .NISAN, dd: 15)
    let pesachAbs = pesach.abs()
    events.append(contentsOf: [
        HEvent(hdate: HDate(yy: year, mm: .TISHREI, dd: 3 + (RH.dow() == .THU ? 1 : 0)),
               desc: "Tzom Gedaliah", flags: .MINOR_FAST),
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: pesachAbs - 43)),
               desc: "Shabbat Shekalim", flags: .SPECIAL_SHABBAT),
        HEvent(hdate: HDate(absdate: dayOnOrBefore(dayOfWeek: .SAT, absdate: pesachAbs - 30)),
               desc: "Shabbat Zachor", flags: .SPECIAL_SHABBAT),
        HEvent(hdate: HDate(absdate: pesachAbs - (pesach.dow() == .TUE ? 33 : 31)),
               desc: "Ta'anit Esther", flags: .MINOR_FAST),
    ])

    // chanukah
    for i in 2...6 {
        events.append(
            HEvent(hdate: HDate(yy: year, mm: .KISLEV, dd: 23 + i),
                   desc: "Chanukah: \(i) Candles",
                   flags: [.MINOR_HOLIDAY, .CHANUKAH_CANDLES],
                   emoji: chanukahEmoji + keyCapDigits[i])
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
               emoji: chanukahEmoji + keyCapDigits[7]),
        HEvent(hdate: chanukah8,
               desc: "Chanukah: 8 Candles",
               flags: [.MINOR_HOLIDAY, .CHANUKAH_CANDLES],
               emoji: chanukahEmoji + keyCapDigits[8]),
        HEvent(hdate: chanukah8.next(),
               desc: "Chanukah: 8th Day",
               flags: .MINOR_HOLIDAY,
               emoji: chanukahEmoji),
    ])

    events.sort()
    return events
}
