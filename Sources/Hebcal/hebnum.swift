//
//  File.swift
//  
//
//  Created by Michael Radwin on 8/23/21.
//

import Foundation

let GERESH = "׳"
let GERSHAYIM = "״"

func num2heb(num: Int) -> String {
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

public func hebnumToString(number: Int) -> String {
    var digits = [Int]()
    var num = number % 1000
    while num > 0 {
        if num == 15 || num == 16 {
            digits.append(9)
            digits.append(num - 9)
            break
        }
        var incr = 100
        var i = 400
        while i > num {
            if i == incr {
                incr = incr / 10
            }
            i -= incr
        }
        digits.append(i)
        num -= i
    }
    if digits.count == 1 {
        return num2heb(num: digits[0]) + GERESH
    }
    var str = ""
    for i in 0 ..< digits.count {
        if i + 1 == digits.count {
            str += GERSHAYIM
        }
        str += num2heb(num: digits[i])
    }
    return str
}
