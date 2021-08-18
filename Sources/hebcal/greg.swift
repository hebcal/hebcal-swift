//
//  greg.swift
//  
//
//  Created by Michael Radwin on 8/17/21.
//

import Foundation

let FEB = 2
let DEC = 12

let monthLengths = [
    [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
    [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
]

func isGregLeapYear(year: Int) -> Bool {
    return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0)
}

/*
 * Return the day number within the year of the date DATE.
 * For example, dayOfYear({1,1,1987}) returns the value 1
 * while dayOfYear({12,31,1980}) returns 366.
 */
func dayOfYear(date: SimpleDate) -> Int {
    var days = date.dd + 31 * (date.mm - 1)
    if date.mm > FEB {
        days -= (4 * date.mm + 23) / 10
        if isGregLeapYear(year: date.yy) {
            days = days + 1
        }
    }
    return days
}

/*
 * The number of days elapsed between the Gregorian date 12/31/1 BC and DATE.
 * The Gregorian date Sunday, December 31, 1 BC is imaginary.
 */
func greg2abs(date: SimpleDate) -> Int64 {
    let year = Int64(date.yy - 1)
    let days = Int64(dayOfYear(date: date))
    return days +   /* days this year */
        365 * year  +  /* + days in prior years */
        ((year / 4) -    /* + Julian Leap years */
            (year / 100) +    /* - century years */
            (year / 400))  /* + Gregorian leap years */
}

/*
 * See the footnote on page 384 of ``Calendrical Calculations, Part II:
 * Three Historical Calendars'' by E. M. Reingold,  N. Dershowitz, and S. M.
 * Clamen, Software--Practice and Experience, Volume 23, Number 4
 * (April, 1993), pages 383-404 for an explanation.
 */
func abs2greg(absdate: Int64) -> SimpleDate {
    let d0 = absdate - 1
    let n400 = d0 / 146097
    let d1 = d0 % 146097
    let n100 = d1 / 36524
    let d2 = d1 % 36524
    let n4 = d2 / 1461
    let d3 = d2 % 1461
    let n1 = d3 / 365
    
    var day = Int((d3 % 365) + 1)
    var year = Int(400 * n400 + 100 * n100 + 4 * n4 + n1)
    
    if 4 == n100 || 4 == n1 {
        return SimpleDate(yy: year, mm: DEC, dd: 31)
    } else {
        year = year + 1
        var month = 1
        while case let mlen = monthLengths[isGregLeapYear(year: year) ? 1 : 0][month], mlen < day {
            day -= mlen
            month = month + 1
        }
        return SimpleDate(yy: year, mm: month, dd: day)
    }
}
