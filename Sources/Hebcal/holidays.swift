//
//  holidays.swift
//  Created by Michael Radwin on 8/29/21.
//

import Foundation

public struct HolidayFlags: OptionSet, Sendable {
    public let rawValue: Int32
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    public static let NONE = HolidayFlags([])
    public static let CHAG = HolidayFlags(rawValue: 0x000001)
    public static let LIGHT_CANDLES = HolidayFlags(rawValue: 0x000002)
    public static let YOM_TOV_ENDS = HolidayFlags(rawValue: 0x000004)
    public static let CHUL_ONLY = HolidayFlags(rawValue: 0x000008) // chutz l'aretz (Diaspora)
    public static let IL_ONLY = HolidayFlags(rawValue: 0x000010) // b'aretz (Israel)
    public static let LIGHT_CANDLES_TZEIS = HolidayFlags(rawValue: 0x000020)
    public static let CHANUKAH_CANDLES = HolidayFlags(rawValue: 0x000040)
    public static let ROSH_CHODESH = HolidayFlags(rawValue: 0x000080)
    public static let MINOR_FAST = HolidayFlags(rawValue: 0x000100)
    public static let SPECIAL_SHABBAT = HolidayFlags(rawValue: 0x000200)
    public static let PARSHA_HASHAVUA = HolidayFlags(rawValue: 0x000400)
    public static let DAF_YOMI = HolidayFlags(rawValue: 0x000800)
    public static let OMER_COUNT = HolidayFlags(rawValue: 0x001000)
    public static let MODERN_HOLIDAY = HolidayFlags(rawValue: 0x002000)
    public static let MAJOR_FAST = HolidayFlags(rawValue: 0x004000)
    public static let SHABBAT_MEVARCHIM = HolidayFlags(rawValue: 0x008000)
    public static let MOLAD = HolidayFlags(rawValue: 0x010000)
    public static let USER_EVENT = HolidayFlags(rawValue: 0x020000)
    public static let HEBREW_DATE = HolidayFlags(rawValue: 0x040000)
    public static let MINOR_HOLIDAY = HolidayFlags(rawValue: 0x080000)
    public static let EREV = HolidayFlags(rawValue: 0x100000)
    public static let CHOL_HAMOED = HolidayFlags(rawValue: 0x200000)
    public static let YOM_KIPPUR_KATAN = HolidayFlags(rawValue: 0x800000)
    public static let BEHAB = HolidayFlags(rawValue: 0x10000000)
}

public struct HEvent: Comparable, Sendable {
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

/// A holiday on a fixed Hebrew date.
private struct Holiday {
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

private let chanukahEmoji = "🕎"
private let sukkotEmoji = "🌿🍋"
private let pesachEmoji = "🫓"

private let staticHolidays: [Holiday] = [
    Holiday(mm: .TISHREI, dd: 1, desc: "Rosh Hashana",
            flags: [.CHAG,  .LIGHT_CANDLES_TZEIS], emoji: "🍏🍯"),
    Holiday(mm: .TISHREI, dd: 2, desc: "Rosh Hashana II",
            flags: [.CHAG,  .YOM_TOV_ENDS], emoji: "🍏🍯"),
    Holiday(mm: .TISHREI, dd: 9, desc: "Erev Yom Kippur",
            flags: [.EREV, .LIGHT_CANDLES]),
    Holiday(mm: .TISHREI, dd: 10, desc: "Yom Kippur",
            flags: [.CHAG, .MAJOR_FAST, .YOM_TOV_ENDS]),
    Holiday(mm: .TISHREI, dd: 14, desc: "Erev Sukkot",
            flags: [.EREV, .LIGHT_CANDLES],
            emoji: sukkotEmoji),

    Holiday(mm: .TISHREI, dd: 15, desc: "Sukkot I",
            flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 16, desc: "Sukkot II",
            flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 17, desc: "Sukkot III (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 18, desc: "Sukkot IV (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 19, desc: "Sukkot V (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 20, desc: "Sukkot VI (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 22, desc: "Shmini Atzeret",
            flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS]),
    Holiday(mm: .TISHREI, dd: 23, desc: "Simchat Torah",
            flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS]),

    Holiday(mm: .TISHREI, dd: 15, desc: "Sukkot I",
            flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 16, desc: "Sukkot II (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 17, desc: "Sukkot III (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 18, desc: "Sukkot IV (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 19, desc: "Sukkot V (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 20, desc: "Sukkot VI (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .TISHREI, dd: 22, desc: "Shmini Atzeret",
            flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS]),

    Holiday(mm: .TISHREI, dd: 21, desc: "Sukkot VII (Hoshana Raba)",
            flags: [.LIGHT_CANDLES, .CHOL_HAMOED],
            emoji: sukkotEmoji),
    Holiday(mm: .KISLEV, dd: 24, desc: "Chanukah: 1 Candle",
            flags: [.EREV, .MINOR_HOLIDAY, .CHANUKAH_CANDLES],
            emoji: chanukahEmoji),
    Holiday(mm: .TEVET, dd: 10, desc: "Asara B'Tevet", flags: .MINOR_FAST),
    Holiday(mm: .SHVAT, dd: 15, desc: "Tu BiShvat", flags: .MINOR_HOLIDAY, emoji: "🌳"),
    Holiday(mm: .ADAR_II, dd: 13, desc: "Erev Purim", flags: [.EREV, .MINOR_HOLIDAY], emoji: "🎭️📜"),
    Holiday(mm: .ADAR_II, dd: 14, desc: "Purim", flags: .MINOR_HOLIDAY, emoji: "🎭️📜"),
    Holiday(mm: .ADAR_II, dd: 15, desc: "Shushan Purim", flags: .MINOR_HOLIDAY, emoji: "🎭️📜"),
    Holiday(mm: .NISAN, dd: 14, desc: "Erev Pesach", flags: [.EREV, .LIGHT_CANDLES],
            emoji: "🫓🍷"),
    // Pesach Israel
    Holiday(mm: .NISAN, dd: 15, desc: "Pesach I",
            flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 16, desc: "Pesach II (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 17, desc: "Pesach III (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 18, desc: "Pesach IV (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 19, desc: "Pesach V (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 20, desc: "Pesach VI (CH''M)",
            flags: [.IL_ONLY, .CHOL_HAMOED, .LIGHT_CANDLES],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 21, desc: "Pesach VII",
            flags: [.IL_ONLY, .CHAG, .YOM_TOV_ENDS],
            emoji: pesachEmoji),
    // Pesach chutz l'aretz
    Holiday(mm: .NISAN, dd: 15, desc: "Pesach I",
            flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS],
            emoji: "🫓🍷"),
    Holiday(mm: .NISAN, dd: 16, desc: "Pesach II",
            flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 17, desc: "Pesach III (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 18, desc: "Pesach IV (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 19, desc: "Pesach V (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 20, desc: "Pesach VI (CH''M)",
            flags: [.CHUL_ONLY, .CHOL_HAMOED, .LIGHT_CANDLES],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 21, desc: "Pesach VII",
            flags: [.CHUL_ONLY, .CHAG, .LIGHT_CANDLES_TZEIS],
            emoji: pesachEmoji),
    Holiday(mm: .NISAN, dd: 22, desc: "Pesach VIII",
            flags: [.CHUL_ONLY, .CHAG, .YOM_TOV_ENDS],
            emoji: pesachEmoji),

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


/// An Israeli national holiday, with rules for moving it off Friday/Saturday.
private struct ModernHoliday {
    let h: Holiday
    let firstYear: Int
    let chul: Bool
    let friSatMovetoThu: Bool
    let satPostponeToSun: Bool
    let friPostponeToSun: Bool
}


private let staticModernHolidays: [ModernHoliday] = [
    ModernHoliday(h: Holiday(mm: .IYYAR, dd: 28, desc: "Yom Yerushalayim"),
                  firstYear: 5727,
                  chul: true,
                  friSatMovetoThu: false,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .KISLEV, dd: 6, desc: "Ben-Gurion Day"),
                  firstYear: 5737,
                  chul: false,
                  friSatMovetoThu: false,
                  satPostponeToSun: true, friPostponeToSun: true),
    ModernHoliday(h: Holiday(mm: .SHVAT, dd: 30, desc: "Family Day"),
                  firstYear: 5750,
                  chul: false,
                  friSatMovetoThu: false,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .CHESHVAN, dd: 12, desc: "Yitzhak Rabin Memorial Day"),
                  firstYear: 5758,
                  chul: false,
                  friSatMovetoThu: true,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .IYYAR, dd: 10, desc: "Herzl Day"),
                  firstYear: 5764,
                  chul: false,
                  friSatMovetoThu: false,
                  satPostponeToSun: true, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .TAMUZ, dd: 29, desc: "Jabotinsky Day"),
                  firstYear: 5765,
                  chul: false,
                  friSatMovetoThu: false,
                  satPostponeToSun: true, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .CHESHVAN, dd: 29, desc: "Sigd"),
                  firstYear: 5769,
                  chul: true,
                  friSatMovetoThu: true,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .NISAN, dd: 10, desc: "Yom HaAliyah"),
                  firstYear: 5777,
                  chul: true,
                  friSatMovetoThu: false,
                  satPostponeToSun: false, friPostponeToSun: false),
    ModernHoliday(h: Holiday(mm: .CHESHVAN, dd: 7, desc: "Yom HaAliyah School Observance"),
                  firstYear: 5777,
                  chul: false,
                  friSatMovetoThu: false,
                  satPostponeToSun: false, friPostponeToSun: false),
    // https://www.gov.il/he/departments/policies/2012_des5234
    ModernHoliday(h: Holiday(mm: .TEVET, dd: 21, desc: "Hebrew Language Day"),
                  firstYear: 5773,
                  chul: false,
                  friSatMovetoThu: true,
                  satPostponeToSun: false, friPostponeToSun: false),
    // https://fs.knesset.gov.il/25/law/25_lsr_14184773.pdf
    // (Published in Sefer HaChukim No. 3567 on 8 Av 5786 / July 22, 2026)
    ModernHoliday(h: Holiday(mm: .TISHREI, dd: 24, desc: "Swords of Iron War Memorial Day"),
                  firstYear: 5786,
                  chul: true,
                  friSatMovetoThu: false,
                  satPostponeToSun: true, friPostponeToSun: false),
]


extension HEvent {
    /// Whether this event is observed in Israel (`il`) or the Diaspora.
    func isObserved(il: Bool) -> Bool {
        return !flags.contains(il ? .CHUL_ONLY : .IL_ONLY)
    }
}

/// The holidays of the Hebrew `year` observed in Israel (`il`) or the Diaspora, in date order.
public func getHolidaysForYear(year: Int, il: Bool) -> [HEvent] {
    return getAllHolidaysForYear(year: year).filter { $0.isObserved(il: il) }
}

/// All holidays of the Hebrew `year`, both Israel-only (`IL_ONLY`) and
/// Diaspora-only (`CHUL_ONLY`), in date order.
public func getAllHolidaysForYear(year: Int) -> [HEvent] {
    // standard holidays that don't shift based on year
    var events = staticHolidays.map {
        HEvent(hdate: HDate(yy: year, mm: $0.mm, dd: $0.dd), desc: $0.desc, flags: $0.flags, emoji: $0.emoji)
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
    if pesach.dow() == .SUN {
        events.append(HEvent(hdate: HDate(yy: year, mm: .ADAR_II, dd: 16),
                             desc: "Purim Meshulash", flags: .MINOR_HOLIDAY, emoji: "🎭️"))
    }
    if isLeapYear(year: year) {
        events.append(HEvent(hdate: HDate(yy: year, mm: .ADAR_I, dd: 14),
                             desc: "Purim Katan", flags: .MINOR_HOLIDAY, emoji: "🎭️"))
        events.append(HEvent(hdate: HDate(yy: year, mm: .ADAR_I, dd: 15),
                             desc: "Shushan Purim Katan", flags: .MINOR_HOLIDAY, emoji: "🎭️"))
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
        let day: Int
        switch pesach.dow() {
        case .SUN: day = 2
        case .SAT: day = 3
        case .TUE where year >= 5764: day = 5
        default: day = 4
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

    for mh in staticModernHolidays where year >= mh.firstYear {
        let h = mh.h
        let flags: HolidayFlags = mh.chul ? .MODERN_HOLIDAY : [.MODERN_HOLIDAY, .IL_ONLY]
        var hd = HDate(yy: year, mm: h.mm, dd: h.dd)
        let dow = hd.dow()
        if mh.friSatMovetoThu && (dow == .FRI || dow == .SAT) {
            hd = hd.onOrBefore(dayOfWeek: .THU)
        } else if mh.friPostponeToSun && dow == .FRI {
            hd = hd.next().next()
        } else if mh.satPostponeToSun && dow == .SAT {
            hd = hd.next()
        }
        events.append(HEvent(hdate: hd, desc: h.desc, flags: flags, emoji: "🇮🇱"))
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

    // Chag HaBanot falls on the first day of Rosh Chodesh Tevet (same day as Chanukah: 7 Candles)
    events.append(HEvent(hdate: chanukah7, desc: "Chag HaBanot", flags: .MINOR_HOLIDAY))
    events.append(contentsOf: yomKippurKatanEvents(year: year))
    events.append(contentsOf: behabEvents(year: year))
    if let birkatHaChama = birkatHaChamaAbs(year: year) {
        events.append(HEvent(hdate: HDate(absdate: birkatHaChama), desc: "Birkat Hachamah",
                             flags: .MINOR_HOLIDAY, emoji: "☀️"))
    }

    events.sort()
    return events
}

/// Yom Kippur Katan, the minor day of atonement on the day preceding each Rosh Chodesh.
private func yomKippurKatanEvents(year: Int) -> [HEvent] {
    var events: [HEvent] = []
    let numMonths = monthsInYear(year: year)
    // start at Iyyar because one may not fast during Nisan
    for i in HebrewMonth.IYYAR.rawValue...numMonths {
        let month = HebrewMonth(rawValue: i)!
        let nextMonth = i == numMonths ? HebrewMonth.NISAN : HebrewMonth(rawValue: i + 1)!
        // Not observed on the day before Rosh Hashana.
        // Not observed prior to Rosh Chodesh Cheshvan because Yom Kippur has just passed.
        // Not observed before Rosh Chodesh Tevet, because that day is Chanukah.
        if nextMonth == .TISHREI || nextMonth == .CHESHVAN || nextMonth == .TEVET {
            continue
        }
        var ykk = HDate(yy: year, mm: month, dd: 29)
        let dow = ykk.dow()
        if dow == .FRI || dow == .SAT {
            ykk = ykk.onOrBefore(dayOfWeek: .THU)
        }
        let nextMonthName = HDate(yy: year, mm: nextMonth, dd: 1).monthName()
        events.append(HEvent(hdate: ykk, desc: "Yom Kippur Katan \(nextMonthName)",
                             flags: [.MINOR_FAST, .YOM_KIPPUR_KATAN]))
    }
    return events
}

/// Ta'anit BeHaB: the Monday, Thursday, Monday fasts after Pesach and Sukkot.
private func behabEvents(year: Int) -> [HEvent] {
    var events: [HEvent] = []
    for month in [HebrewMonth.CHESHVAN, .IYYAR] {
        let roshChodesh = HDate(yy: year, mm: month, dd: 1).abs()
        var shabbos = dayOnOrBefore(dayOfWeek: .SAT, absdate: roshChodesh + 6)
        if shabbos == roshChodesh {
            shabbos += 7
        }
        var fastDays = [2, 5, 9].map { HDate(absdate: shabbos + Int64($0)) }
        if month == .IYYAR && fastDays[2].dd == 14 {
            fastDays[2] = HDate(yy: year, mm: .IYYAR, dd: 17)
        }
        for hd in fastDays {
            events.append(HEvent(hdate: hd, desc: "Ta'anit BeHaB", flags: [.MINOR_FAST, .BEHAB]))
        }
    }
    return events
}

/// 28 years of 365.25 days
private let birkatHaChamaCycleDays: Int64 = 10227
private let birkatHaChamaEpochOffset: Int64 = 1373429
private let birkatHaChamaRemainder: Int64 = 172

/// Birkat Hachamah appears only once every 28 years. Although almost always in
/// Nisan, it can occur in Adar II (27 Adar II 5461, 29 Adar II 5993).
private func birkatHaChamaAbs(year: Int) -> Int64? {
    let leap = isLeapYear(year: year)
    let baseRd = hebrew2abs(year: year, month: leap ? .ADAR_II : .NISAN, day: leap ? 20 : 1)
    for day in Int64(0)...40 {
        let abs = baseRd + day
        if (abs + birkatHaChamaEpochOffset) % birkatHaChamaCycleDays == birkatHaChamaRemainder {
            return abs
        }
    }
    return nil
}

/// The holidays on `hdate` observed in Israel (`il`) or the Diaspora.
public func getHolidaysOnDate(hdate: HDate, il: Bool) -> [HEvent] {
    return getHolidaysOnDate(events: getAllHolidaysForYear(year: hdate.yy), hdate: hdate, il: il)
}

/// The holidays on `hdate` observed in Israel (`il`) or the Diaspora, from
/// `events` sorted in date order (e.g. from `getAllHolidaysForYear(year:)`).
public func getHolidaysOnDate(events: [HEvent], hdate: HDate, il: Bool) -> [HEvent] {
    return events
        .prefix { $0.hdate <= hdate }
        .filter { $0.hdate == hdate && $0.isObserved(il: il) }
}
