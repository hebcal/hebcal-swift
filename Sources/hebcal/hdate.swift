//
//  hdate.swift
//  
//
//  Created by Michael Radwin on 8/17/21.
//

import Foundation

let NISAN = 1
let IYYAR = 2
let SIVAN = 3
let TAMUZ = 4
let AV = 5
let ELUL = 6
let TISHREI = 7
let CHESHVAN = 8
let KISLEV = 9
let TEVET = 10
let SHVAT = 11
let ADAR_I = 12
let ADAR_II = 13

let EPOCH: Int64 = -1373428

/**
 * Returns true if Hebrew year is a leap year
 * @param {number} year Hebrew year
 * @return {boolean}
 */
func isLeapYear(year: Int) -> Bool {
    return (1 + year * 7) % 19 < 7
}

/**
 * Number of months in this Hebrew year (either 12 or 13 depending on leap year)
 * @param {number} year Hebrew year
 * @return {number}
 */
func monthsInYear(year: Int) -> Int {
    let extra = isLeapYear(year: year) ? 1 : 0
    return 12 + extra
}

/**
 * Days from sunday prior to start of Hebrew calendar to mean
 * conjunction of Tishrei in Hebrew YEAR
 * @private
 * @param {number} year Hebrew year
 * @return {number}
 */
func elapsedDays(year: Int) -> Int64 {
    let prevYear = year - 1
    
    let mElapsedMonths = 235 * (prevYear / 19)
    let mElapsedRegularMonths = 12 * (prevYear % 19)
    let mElapsedLeapMonths = ((prevYear % 19) * 7 + 1) / 19
    
    let mElapsed: Int64 = Int64(mElapsedMonths + mElapsedRegularMonths + mElapsedLeapMonths)
    
    let pElapsed: Int64 = 204 + 793 * (mElapsed % 1080)
    
    let hElapsed: Int64 = 5 +
        12 * mElapsed +
        793 * (mElapsed / 1080) +
        (pElapsed / 1080)
    
    let parts: Int64 = (pElapsed % 1080) + 1080 * (hElapsed % 24)
    
    let day: Int64 = 1 + 29 * mElapsed + (hElapsed / 24)
    
    var altDay = day
    
    if ((parts >= 19440) ||
            ((2 == (day % 7)) && (parts >= 9924) && !(isLeapYear(year: year))) ||
            ((1 == (day % 7)) && (parts >= 16789) && isLeapYear(year: prevYear))) {
        altDay = day + 1
    }
    
    if (altDay % 7 == 0 || altDay % 7 == 3 || altDay % 7 == 5) {
        return altDay + 1
    } else {
        return altDay
    }
}

/**
 * Number of days in the hebrew YEAR
 * @param {number} year Hebrew year
 * @return {number}
 */
func daysInYear(year: Int) -> Int {
    return Int(elapsedDays(year: year + 1) - elapsedDays(year: year))
}

/**
 * true if Cheshvan is long in Hebrew year
 * @param {number} year Hebrew year
 * @return {boolean}
 */
func longCheshvan(year: Int) -> Bool {
    return daysInYear(year: year) % 10 == 5
}

/**
 * true if Kislev is short in Hebrew year
 * @param {number} year Hebrew year
 * @return {boolean}
 */
func shortKislev(year: Int) -> Bool {
    return daysInYear(year: year) % 10 == 3
}

/**
 * Number of days in Hebrew month in a given year (29 or 30)
 * @param {number} month Hebrew month (e.g. months.TISHREI)
 * @param {number} year Hebrew year
 * @return {number}
 */
func daysInMonth(month: Int, year: Int) -> Int {
    if (month == IYYAR ||
            month == TAMUZ ||
            month == ELUL ||
            month == TEVET ||
            month == ADAR_II ||
            (month == ADAR_I && !isLeapYear(year: year)) ||
            (month == CHESHVAN && !longCheshvan(year: year)) ||
            (month == KISLEV && shortKislev(year: year))) {
        return 29
    } else {
        return 30
    }
}

func hebrew2abs(year: Int, month: Int, day: Int) -> Int64 {
    var tempabs: Int64 = Int64(day)
    
    if (month < TISHREI) {
        for m in (TISHREI...monthsInYear(year: year)) {
            tempabs += Int64(daysInMonth(month: m, year: year))
        }
        for m in (NISAN..<month) {
            tempabs += Int64(daysInMonth(month: m, year: year))
        }
    } else {
        for m in (TISHREI..<month) {
            tempabs += Int64(daysInMonth(month: m, year: year))
        }
    }
    return EPOCH + elapsedDays(year: year) + tempabs - 1
}

func newYearDelay(year: Int) -> Int {
    let ny1 = elapsedDays(year: year)
    let ny2 = elapsedDays(year: year + 1)
    if (ny2 - ny1 == 356) {
        return 2
    } else {
        let ny0 = elapsedDays(year: year - 1)
        return ny1 - ny0 == 382 ? 1 : 0
    }
}

func newYear(year: Int) -> Int64 {
    return EPOCH + elapsedDays(year: year) + Int64(newYearDelay(year: year))
}

/**
 * Converts absolute R.D. days to Hebrew date
 * @private
 * @param {number} abs absolute R.D. days
 * @return {SimpleHebrewDate}
 */
func abs2hebrew(abs: Int64) -> SimpleDate {
    let approx = 1 + Int(Double(abs - EPOCH) / 365.24682220597794)
    
    var year = approx - 1
    while (newYear(year: year) <= abs) {
        year = year + 1
    }
    year = year - 1
    
    var month = abs < hebrew2abs(year: year, month: 1, day: 1) ? 7 : 1
    while (abs > hebrew2abs(year: year, month: month, day: daysInMonth(month: month, year: year))) {
        month = month + 1
    }
    
    let day = Int(1 + abs - hebrew2abs(year: year, month: month, day: 1))
    return SimpleDate(yy: year, mm: month, dd: day);
}

/**
 * Note: Applying this function to d+6 gives us the DAYNAME on or after an
 * absolute day d. Similarly, applying it to d+3 gives the DAYNAME nearest to
 * absolute date d, applying it to d-1 gives the DAYNAME previous to absolute
 * date d, and applying it to d+7 gives the DAYNAME following absolute date d.
 * @param {number} dayOfWeek
 * @param {number} absdate
 * @return {number}
 */
func dayOnOrBefore(dayOfWeek: Int, absdate: Int64) -> Int64 {
    return absdate - ((absdate - Int64(dayOfWeek)) % 7)
}
