# hebcal-swift

Hebcal is a perpetual Jewish Calendar. This library converts between
Hebrew and Gregorian dates, and generates lists of Jewish holidays for
any year (past, present or future).

Hebcal was created in 1992 by Danny Sadinoff as a Unix/Linux program
written in C, inspired by similar functionality written in Emacs
Lisp. This Swift implementation was released in 2021 by
Michael J. Radwin.

```swift
import Foundation
import Hebcal

let now = Date()
let hdate = HDate(date: now, calendar: .current)

print(hdate.render(lang: TranslationLang.en))

let sedra = Sedra(year: hdate.yy, il: false)
let parsha = sedra.lookup(hdate: hdate, lang: TranslationLang.en)

print(parsha)
```

## Zmanim Calculations (Shabbat and Havdalah Times)

This library provides functions to calculate Shabbat candle lighting times and Havdalah times based on geographic coordinates and date. These calculations are performed using the `SunCalcSwift` library.

### Candle Lighting Time

To calculate candle lighting time, use the `Zmanim.getCandleLightingTime` function. Candle lighting is typically 18 minutes before sunset. For Jerusalem, it is 40 minutes before sunset.

```swift
import Hebcal
import Foundation // For Date and TimeZone

// Ensure you are using the correct date (Friday for candle lighting)
// For example, December 1st, 2023
var components = DateComponents()
components.year = 2023
components.month = 12
components.day = 1
components.hour = 12 // Noon, to avoid DST issues with the date itself
let calendar = Calendar.current
let fridayDate = calendar.date(from: components)!

// Example for Jerusalem
let jerusalemLatitude = 31.7683
let jerusalemLongitude = 35.2137
let jerusalemTimeZone = TimeZone(identifier: "Asia/Jerusalem")!

let jerusalemCandleLighting = Zmanim.getCandleLightingTime(
    for: fridayDate,
    latitude: jerusalemLatitude,
    longitude: jerusalemLongitude,
    timeZone: jerusalemTimeZone,
    isJerusalem: true // Specify true for Jerusalem's 40-minute rule
)

if let jerusalemTime = jerusalemCandleLighting {
    // Format the date for printing
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.timeZone = jerusalemTimeZone
    print("Jerusalem Candle Lighting on \(formatter.string(from: fridayDate)): \(formatter.string(from: jerusalemTime))")
    // Example Output: Jerusalem Candle Lighting on Dec 1, 2023: 3:52:05 PM
}

// Example for New York (18 minutes before sunset)
let nyLatitude = 40.7128
let nyLongitude = -74.0060
let nyTimeZone = TimeZone(identifier: "America/New_York")!

let nyCandleLighting = Zmanim.getCandleLightingTime(
    for: fridayDate,
    latitude: nyLatitude,
    longitude: nyLongitude,
    timeZone: nyTimeZone,
    isJerusalem: false // Defaults to false, explicitly shown here
)

if let nyTime = nyCandleLighting {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.timeZone = nyTimeZone
    print("New York Candle Lighting on \(formatter.string(from: fridayDate)): \(formatter.string(from: nyTime))")
    // Example Output: New York Candle Lighting on Dec 1, 2023: 4:10:45 PM
}
```

### Havdalah Time

To calculate Havdalah time, use the `Zmanim.getHavdalahTime` function. You must specify an `HavdalahOpinion` which determines how Havdalah is calculated:

- `.minutesAfterSunset(minutes: Int)`: Havdalah is a fixed number of minutes after sunset (e.g., 42, 50, or 72 minutes).
- `.degreesBelowHorizon(angle: Double)`: Havdalah is when the sun reaches a specific angle below the horizon (e.g., 7.0833 degrees, 8.5 degrees).

```swift
import Hebcal
import Foundation // For Date and TimeZone

// Ensure you are using the correct date (Saturday for Havdalah)
// For example, December 2nd, 2023
var componentsSat = DateComponents()
componentsSat.year = 2023
componentsSat.month = 12
componentsSat.day = 2
componentsSat.hour = 12 // Noon
let calendarSat = Calendar.current
let saturdayDate = calendarSat.date(from: componentsSat)!

let nyLatitude = 40.7128
let nyLongitude = -74.0060
let nyTimeZone = TimeZone(identifier: "America/New_York")!

// Option 1: Havdalah 42 minutes after sunset
let havdalah42Min = Zmanim.getHavdalahTime(
    for: saturdayDate,
    latitude: nyLatitude,
    longitude: nyLongitude,
    timeZone: nyTimeZone,
    opinion: .minutesAfterSunset(minutes: 42)
)

if let havdalah42 = havdalah42Min {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.timeZone = nyTimeZone
    print("Havdalah (42 min) in New York on \(formatter.string(from: saturdayDate)): \(formatter.string(from: havdalah42))")
    // Example Output: Havdalah (42 min) in New York on Dec 2, 2023: 5:10:45 PM
}

// Option 2: Havdalah when the sun is 8.5 degrees below the horizon
let havdalah8_5Deg = Zmanim.getHavdalahTime(
    for: saturdayDate,
    latitude: nyLatitude,
    longitude: nyLongitude,
    timeZone: nyTimeZone,
    opinion: .degreesBelowHorizon(angle: 8.5)
)

if let havdalah8_5 = havdalah8_5Deg {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.timeZone = nyTimeZone
    print("Havdalah (8.5°) in New York on \(formatter.string(from: saturdayDate)): \(formatter.string(from: havdalah8_5))")
    // Example Output: Havdalah (8.5°) in New York on Dec 2, 2023: 5:06:15 PM (approx.)
}
```

**Note:**
- Always provide an accurate `TimeZone` for the location, as this significantly affects time calculations.
- The `for date:` parameter in these functions is used to determine the day for the solar calculations. Ensure it corresponds to the correct day of the week (Friday for candle lighting, Saturday for Havdalah).
- Calculations for locations in polar regions (where sunset/sunrise might not occur or behave differently) will return `nil` if the requested solar event does not happen or cannot be calculated.
