//
//  Sedra.swift
//  
//
//  Created by Michael Radwin on 8/17/21.
//

import Foundation

enum YearType: Int, CaseIterable, Codable {
    case INCOMPLETE = 0, REGULAR, COMPLETE
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
    "Ha'Azinu",
];

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

/* parsha doubler */
func D(n: Int) -> Int {
    return -n
}

/* parsha undoubler */
func U(n: Int) -> Int {
    return -n
}

func isValidDouble(n: Int) -> Bool {
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
let Sat_short = [
    -1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, D(n: 21), 23, 24, -1, 25, D(n: 26), D(n: 28), 30, D(n: 31), 33, 34, 35, 36, 37, 38, 39, 40, D(n: 41), 43, 44, 45, 46, 47,
    48, 49, 50 ]

let Sat_long = [
    -1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, D(n: 21), 23, 24, -1, 25, D(n: 26), D(n: 28), 30, D(n: 31), 33, 34, 35, 36, 37, 38, 39, 40, D(n: 41), 43, 44, 45, 46, 47,
    48, 49, D(n: 50) ]

let Mon_short = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
    18, 19, 20, D(n: 21), 23, 24, -1, 25, D(n: 26), D(n: 28), 30, D(n: 31), 33, 34, 35, 36, 37, 38, 39, 40, D(n: 41), 43, 44, 45, 46, 47, 48,
    49, D(n: 50) ]

let Mon_long = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, D(n: 21), 23, 24, -1, 25, D(n: 26), D(n: 28),
    30, D(n: 31), 33, -1, 34, 35, 36, 37, D(n: 38), 40, D(n: 41), 43, 44, 45, 46, 47, 48, 49, D(n: 50) ]

let Thu_normal = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
    18, 19, 20, D(n: 21), 23, 24, -1, -1, 25, D(n: 26), D(n: 28), 30, D(n: 31), 33, 34, 35, 36, 37, 38, 39, 40, D(n: 41), 43, 44, 45, 46, 47,
    48, 49, 50 ]
let Thu_normal_Israel = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, D(n: 21), 23, 24, -1, 25, D(n: 26), D(n: 28), 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, D(n: 41), 43, 44, 45,
    46, 47, 48, 49, 50 ]

let Thu_long = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
    18, 19, 20, 21, 22, 23, 24, -1, 25, D(n: 26), D(n: 28), 30, D(n: 31), 33, 34, 35, 36, 37, 38, 39, 40, D(n: 41), 43, 44, 45, 46, 47,
    48, 49, 50 ]

let Sat_short_leap = [
    -1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, D(n: 41),
    43, 44, 45, 46, 47, 48, 49, D(n: 50) ]

let Sat_long_leap = [
    -1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, -1, 34, 35, 36, 37, D(n: 38), 40, D(n: 41),
    43, 44, 45, 46, 47, 48, 49, D(n: 50) ]

let Mon_short_leap = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, -1, 34, 35, 36, 37, D(n: 38), 40, D(n: 41), 43,
    44, 45, 46, 47, 48, 49, D(n: 50) ]

let Mon_short_leap_Israel = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    D(n: 41), 43, 44, 45, 46, 47, 48, 49, D(n: 50) ]

let Mon_long_leap = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, D(n: 41),
    43, 44, 45, 46, 47, 48, 49, 50 ]
let Mon_long_leap_Israel = [
    51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50 ]

let Thu_short_leap = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, -1, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
    43, 44, 45, 46, 47, 48, 49, 50 ]

let Thu_long_leap = [
    52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
    17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, -1, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
    43, 44, 45, 46, 47, 48, 49, D(n: 50) ]

func getSedraArray(leap: Bool, rhDay: DayOfWeek, yearType: YearType, il: Bool) -> [Int] {
    if !leap {
        switch rhDay {
        case .SAT:
            if yearType == .INCOMPLETE {
                return Sat_short
            } else if yearType == .COMPLETE {
                return Sat_long
            }
        case .MON:
            if yearType == .INCOMPLETE {
                return Mon_short
            } else if yearType == .COMPLETE {
                return il ? Mon_short : Mon_long
            }
        case .TUE:
            if yearType == .REGULAR {
                return il ? Mon_short : Mon_long
            }
        case .THU:
            if yearType == .REGULAR {
                return il ? Thu_normal_Israel : Thu_normal
            } else if yearType == .COMPLETE {
                return Thu_long
            }
        default:
            fatalError("improper sedra year type calculated \(leap) \(rhDay) \(yearType) \(il)")
        }
    } else {
        /* leap year */
        switch rhDay {
        case .SAT:
            if yearType == .INCOMPLETE {
                return Sat_short_leap
            } else if yearType == .COMPLETE {
                return il ? Sat_short_leap : Sat_long_leap
            }
        case .MON:
            if yearType == .INCOMPLETE {
                return il ? Mon_short_leap_Israel : Mon_short_leap
            } else if yearType == .COMPLETE {
                return il ? Mon_long_leap_Israel : Mon_long_leap
            }
        case .TUE:
            if yearType == .REGULAR {
                return il ? Mon_long_leap_Israel : Mon_long_leap
            }
        case .THU:
            if yearType == .INCOMPLETE {
                return Thu_short_leap
            } else if yearType == .COMPLETE {
                return Thu_long_leap
            }
        default:
            fatalError("improper sedra year type calculated \(leap) \(rhDay) \(yearType) \(il)")
        }
    }
    return []
}

public class Sedra {
    let year: Int
    let il: Bool
    let firstSaturday: Int64
    let theSedraArray: [Int]
    
    public init(year: Int, il: Bool) {
        self.year = year
        self.il = il
        let longC = longCheshvan(year: year)
        let shortK = shortKislev(year: year)
        let yearType:YearType = (longC && !shortK) ? .COMPLETE :
            (!longC && shortK) ? .INCOMPLETE :
            .REGULAR
        let rh = hebrew2abs(year: year, month: HebrewMonth.TISHREI, day: 1)
        let rhDay:DayOfWeek = DayOfWeek(rawValue: Int(rh % 7))!
        firstSaturday = dayOnOrBefore(dayOfWeek: DayOfWeek.SAT, absdate: rh + 6)
        let leap = isLeapYear(year: year)
        theSedraArray = getSedraArray(leap: leap, rhDay: rhDay, yearType: yearType, il: il)
    }

    public func lookup(absdate: Int64, lang: TranslationLang) -> String? {
        let abs = dayOnOrBefore(dayOfWeek: DayOfWeek.SAT, absdate: absdate + 6)
        let weekNum = Int((abs - self.firstSaturday) / 7)
        if weekNum >= self.theSedraArray.count {
            let nextYear = Sedra(year: self.year + 1, il: self.il)
            return nextYear.lookup(absdate: absdate, lang: lang)
        }
        let index = self.theSedraArray[weekNum]
        if index >= 0 {
            let parshaName = parshiot[index]
            return lookupTranslation(str: parshaName, lang: lang)
        } else if index == -1 {
            return nil
        } else {
            // undouble
            let p1 = U(n: index)
            let p2 = p1 + 1
            return lookupTranslation(str: parshiot[p1], lang: lang) +
                lookupTranslation(str: "-", lang: lang) + lookupTranslation(str: parshiot[p2], lang: lang)
        }
    }

    public func lookup(hdate: HDate, lang: TranslationLang) -> String? {
        return self.lookup(absdate: hdate.abs(), lang: lang)
    }

    public func find(_ parsha: Int) -> HDate? {
        if parsha > 53 || (parsha < 0 && !isValidDouble(n: parsha)) {
            return nil
        }
        if let idx = self.theSedraArray.firstIndex(of: parsha) {
            return HDate(absdate: self.firstSaturday + Int64(idx * 7))
        }
        return nil
    }
}
