//
//  Sedra.swift
//  
//
//  Created by Michael Radwin on 8/17/21.
//

import Foundation

/// Whether Cheshvan and Kislev are both short (29 days), regular (29 and 30), or both long (30).
private enum YearType {
    case incomplete, regular, complete
}

public let parshiot = [
    "Bereshit",
    "Noach",
    "Lech-Lecha",
    "Vayera",
    "Chayei Sara",
    "Toldot",
    "Vayetzei",
    "Vayishlach",
    "Vayeshev",
    "Miketz",
    "Vayigash",
    "Vayechi",
    "Shemot",
    "Vaera",
    "Bo",
    "Beshalach",
    "Yitro",
    "Mishpatim",
    "Terumah",
    "Tetzaveh",
    "Ki Tisa",
    "Vayakhel",
    "Pekudei",
    "Vayikra",
    "Tzav",
    "Shmini",
    "Tazria",
    "Metzora",
    "Achrei Mot",
    "Kedoshim",
    "Emor",
    "Behar",
    "Bechukotai",
    "Bamidbar",
    "Nasso",
    "Beha'alotcha",
    "Sh'lach",
    "Korach",
    "Chukat",
    "Balak",
    "Pinchas",
    "Matot",
    "Masei",
    "Devarim",
    "Vaetchanan",
    "Eikev",
    "Re'eh",
    "Shoftim",
    "Ki Teitzei",
    "Ki Tavo",
    "Nitzavim",
    "Vayeilech",
    "Ha'azinu",

]

/*
 let RH = "Rosh Hashana" // 0
 let YK = "Yom Kippur" // 1
 
 let SUKKOT = "Sukkot" // 0
 let CHMSUKOT = "Sukkot Shabbat Chol ha-Moed" // 0
 let SHMINI = "Shmini Atzeret" // 0
 let EOY = CHMSUKOT // always Sukkot day 3, 5 or 6
 
 let PESACH = "Pesach" // 25
 let PESACH1 = "Pesach I"
 let CHMPESACH = "Pesach Shabbat Chol ha-Moed" // 25
 let PESACH7 = "Pesach VII" // 25
 let PESACH8 = "Pesach VIII"
 let SHAVUOT = "Shavuot" // 33
 */

/// Marks a week in which parsha `n` is read together with parsha `n + 1`.
private func D(_ n: Int) -> Int {
    return -n
}

private func isValidDouble(_ n: Int) -> Bool {
    switch n {
    case -21, -26, -28, -31, -38, -41, -50: return true
    default: return false
    }
}

/*
 * These indices were originally included in the emacs 19 distribution.
 * These arrays determine the correct indices into the parsha names
 * -1 means no parsha that week.
 */
private let Sat_short = [
    -1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, D(21), 23, 24, -1, 25, D(26), D(28), 30, D(31), 33, 34, 35, 36, 37, 38, 39, 40, D(41), 43, 44, 45, 46, 47,
    48, 49, 50 ]

private let Sat_long = [
    -1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, D(21), 23, 24, -1, 25, D(26), D(28), 30, D(31), 33, 34, 35, 36, 37, 38, 39, 40, D(41), 43, 44, 45, 46, 47,
    48, 49, D(50) ]

private let Mon_short = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
    18, 19, 20, D(21), 23, 24, -1, 25, D(26), D(28), 30, D(31), 33, 34, 35, 36, 37, 38, 39, 40, D(41), 43, 44, 45, 46, 47, 48,
    49, D(50) ]

private let Mon_long = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, D(21), 23, 24, -1, 25, D(26), D(28),
    30, D(31), 33, -1, 34, 35, 36, 37, D(38), 40, D(41), 43, 44, 45, 46, 47, 48, 49, D(50) ]

private let Thu_normal = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
    18, 19, 20, D(21), 23, 24, -1, -1, 25, D(26), D(28), 30, D(31), 33, 34, 35, 36, 37, 38, 39, 40, D(41), 43, 44, 45, 46, 47,
    48, 49, 50 ]
private let Thu_normal_Israel = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, D(21), 23, 24, -1, 25, D(26), D(28), 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, D(41), 43, 44, 45,
    46, 47, 48, 49, 50 ]

private let Thu_long = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
    18, 19, 20, 21, 22, 23, 24, -1, 25, D(26), D(28), 30, D(31), 33, 34, 35, 36, 37, 38, 39, 40, D(41), 43, 44, 45, 46, 47,
    48, 49, 50 ]

private let Sat_short_leap = [
    -1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, D(41),
    43, 44, 45, 46, 47, 48, 49, D(50) ]

private let Sat_long_leap = [
    -1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, -1, 34, 35, 36, 37, D(38), 40, D(41),
    43, 44, 45, 46, 47, 48, 49, D(50) ]

private let Mon_short_leap = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, -1, 34, 35, 36, 37, D(38), 40, D(41), 43,
    44, 45, 46, 47, 48, 49, D(50) ]

private let Mon_short_leap_Israel = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    D(41), 43, 44, 45, 46, 47, 48, 49, D(50) ]

private let Mon_long_leap = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, D(41),
    43, 44, 45, 46, 47, 48, 49, 50 ]
private let Mon_long_leap_Israel = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50 ]

private let Thu_short_leap = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, -1, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
    43, 44, 45, 46, 47, 48, 49, 50 ]

private let Thu_long_leap = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, -1, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
    43, 44, 45, 46, 47, 48, 49, D(50) ]

private func getSedraArray(leap: Bool, rhDay: DayOfWeek, yearType: YearType, il: Bool) -> [Int] {
    switch (leap, rhDay, yearType) {
    case (false, .SAT, .incomplete): return Sat_short
    case (false, .SAT, .complete): return Sat_long
    case (false, .MON, .incomplete): return Mon_short
    case (false, .MON, .complete): return il ? Mon_short : Mon_long
    case (false, .TUE, .regular): return il ? Mon_short : Mon_long
    case (false, .THU, .regular): return il ? Thu_normal_Israel : Thu_normal
    case (false, .THU, .complete): return Thu_long

    case (true, .SAT, .incomplete): return Sat_short_leap
    case (true, .SAT, .complete): return il ? Sat_short_leap : Sat_long_leap
    case (true, .MON, .incomplete): return il ? Mon_short_leap_Israel : Mon_short_leap
    case (true, .MON, .complete): return il ? Mon_long_leap_Israel : Mon_long_leap
    case (true, .TUE, .regular): return il ? Mon_long_leap_Israel : Mon_long_leap
    case (true, .THU, .incomplete): return Thu_short_leap
    case (true, .THU, .complete): return Thu_long_leap

    default:
        // The 14 cases above are the only year types the calendar rules allow
        fatalError("improper sedra year type calculated \(leap) \(rhDay) \(yearType) \(il)")
    }
}

/// The weekly Torah portions (parshiot) read on Saturdays of one Hebrew year.
public final class Sedra: Sendable {
    let year: Int
    let il: Bool
    let firstSaturday: Int64
    let theSedraArray: [Int]

    /// The Torah reading schedule of the Hebrew `year`, for Israel (`il`) or the Diaspora.
    public init(year: Int, il: Bool) {
        self.year = year
        self.il = il
        let longC = longCheshvan(year: year)
        let shortK = shortKislev(year: year)
        let yearType: YearType = (longC && !shortK) ? .complete
            : (!longC && shortK) ? .incomplete
            : .regular
        let rh = hebrew2abs(year: year, month: .TISHREI, day: 1)
        let rhDay = DayOfWeek(rawValue: dayOfWeekIndex(rh))!
        firstSaturday = dayOnOrBefore(dayOfWeek: .SAT, absdate: rh + 6)
        theSedraArray = getSedraArray(leap: isLeapYear(year: year), rhDay: rhDay, yearType: yearType, il: il)
    }

    /// The parsha read on the Saturday on or after `absdate`, translated to `lang`,
    /// e.g. "Vayakhel-Pekudei". Returns `nil` when a holiday's reading replaces it.
    public func lookup(absdate: Int64, lang: TranslationLang) -> String? {
        let saturday = dayOnOrBefore(dayOfWeek: .SAT, absdate: absdate + 6)
        let weekNum = Int((saturday - firstSaturday) / 7)
        if weekNum >= theSedraArray.count {
            return Sedra(year: year + 1, il: il).lookup(absdate: absdate, lang: lang)
        }
        let index = theSedraArray[weekNum]
        switch index {
        case -1:
            return nil
        case 0...:
            return lookupTranslation(str: parshiot[index], lang: lang)
        default:
            // A doubled parsha: -n means parshiot n and n + 1
            let p1 = -index
            return lookupTranslation(str: parshiot[p1], lang: lang) +
                lookupTranslation(str: "-", lang: lang) +
                lookupTranslation(str: parshiot[p1 + 1], lang: lang)
        }
    }

    /// The parsha read on the Saturday on or after `hdate`. See `lookup(absdate:lang:)`.
    public func lookup(hdate: HDate, lang: TranslationLang) -> String? {
        return lookup(absdate: hdate.abs(), lang: lang)
    }

    /// The Saturday on which parsha number `parsha` (0 = Bereshit) is read this year,
    /// or a doubled parsha given as `-n` (e.g. -21 for Vayakhel-Pekudei). Returns
    /// `nil` if it isn't read on its own that year.
    public func find(_ parsha: Int) -> HDate? {
        if parsha > 53 || (parsha < 0 && !isValidDouble(parsha)) {
            return nil
        }
        guard let idx = theSedraArray.firstIndex(of: parsha) else {
            return nil
        }
        return HDate(absdate: firstSaturday + Int64(idx * 7))
    }
}
