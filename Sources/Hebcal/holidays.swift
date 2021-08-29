//
//  holidays.swift
//  Created by Michael Radwin on 8/29/21.
//

import Foundation

public struct HolidayFlags: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

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

public struct HEvent {
    public let hdate: HDate
    public let desc: String
    public let flags: HolidayFlags
}

public func getHolidaysForYear(year: Int) -> [HEvent] {
    var events = [HEvent]()
    let RH = HDate(yy: year, mm: .TISHREI, dd: 1)
    let pesach = HDate(yy: year, mm: .NISAN, dd: 15)

    // standard holidays that don't shift based on year
    events.append(contentsOf: [
        HEvent(hdate: RH, desc: "Rosh Hashana", flags: [.CHAG,  .LIGHT_CANDLES_TZEIS]),
        HEvent(hdate: HDate(yy: year, mm: .TISHREI, dd: 2),
               desc: "Rosh Hashana II",
               flags: [.CHAG,  .YOM_TOV_ENDS]),
        HEvent(hdate: HDate(yy: year, mm: .TISHREI, dd: 3 + (RH.dow() == .THU ? 1 : 0)),
               desc: "Tzom Gedaliah", flags: .MINOR_FAST),
        HEvent(hdate: HDate(yy: year, mm: .TISHREI, dd: 9),
               desc: "Erev Yom Kippur", flags: [.EREV, .LIGHT_CANDLES]),
        HEvent(hdate: HDate(yy: year, mm: .TISHREI, dd: 10),
               desc: "Yom Kippur", flags: [.CHAG, .MAJOR_FAST, .YOM_TOV_ENDS]),
    ])
    return events
}
