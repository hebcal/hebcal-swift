//
//  hebnum.swift
//  
//
//  Created by Michael Radwin on 8/23/21.
//

import Foundation

private let geresh = "׳"
private let gershayim = "״"

private func num2heb(num: Int) -> String {
    switch num {
    case 1: return "א"
    case 2: return "ב"
    case 3: return "ג"
    case 4: return "ד"
    case 5: return "ה"
    case 6: return "ו"
    case 7: return "ז"
    case 8: return "ח"
    case 9: return "ט"
    case 10: return "י"
    case 20: return "כ"
    case 30: return "ל"
    case 40: return "מ"
    case 50: return "נ"
    case 60: return "ס"
    case 70: return "ע"
    case 80: return "פ"
    case 90: return "צ"
    case 100: return "ק"
    case 200: return "ר"
    case 300: return "ש"
    case 400: return "ת"
    case 500: return "תק"
    case 600: return "תר"
    case 700: return "תש"
    case 800: return "תת"
    case 900: return "תתק"
    case 1000: return "תתר"
    default: return "*INVALID*"
    }
}

/// Formats `number` in Hebrew numerals (gematriya), e.g. 5781 → "תשפ״א".
/// Thousands are dropped, 15 and 16 are written ט״ו and ט״ז, and a geresh or
/// gershayim is added.
public func hebnumToString(number: Int) -> String {
    var digits = [Int]()
    var num = number % 1000
    while num > 0 {
        if num == 15 || num == 16 {
            digits += [9, num - 9]
            break
        }
        // Largest of 400, 300, ..., 100, 90, ..., 10, 9, ..., 1 that fits
        var incr = 100
        var i = 400
        while i > num {
            if i == incr {
                incr /= 10
            }
            i -= incr
        }
        digits.append(i)
        num -= i
    }
    let letters = digits.map { num2heb(num: $0) }
    guard let last = letters.last else {
        return ""  // multiples of 1000
    }
    if letters.count == 1 {
        return last + geresh
    }
    return letters.dropLast().joined() + gershayim + last
}
