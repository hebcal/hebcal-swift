import Foundation
import SunCalcSwift

public enum HavdalahOpinion {
    case minutesAfterSunset(minutes: Int)
    case degreesBelowHorizon(angle: Double) // e.g., 8.5 or 8.75
}

public struct Zmanim {

    public static func getCandleLightingTime(for date: Date, latitude: Double, longitude: Double, timeZone: TimeZone, isJerusalem: Bool = false) -> Date? {
        let sunCalc = SunCalc(date: date, latitude: latitude, longitude: longitude)

        guard let sunset = sunCalc.sunset else {
            // Sunset might not occur in polar regions
            return nil
        }

        let offsetInMinutes: Int
        if isJerusalem {
            offsetInMinutes = 40
        } else {
            offsetInMinutes = 18
        }

        var calendar = Calendar.current
        calendar.timeZone = timeZone

        return calendar.date(byAdding: .minute, value: -offsetInMinutes, to: sunset)
    }

    public static func getHavdalahTime(for date: Date, latitude: Double, longitude: Double, timeZone: TimeZone, opinion: HavdalahOpinion) -> Date? {
        let sunCalc = SunCalc(date: date, latitude: latitude, longitude: longitude)
        var calendar = Calendar.current
        calendar.timeZone = timeZone

        switch opinion {
        case .minutesAfterSunset(let minutes):
            guard let sunset = sunCalc.sunset else { return nil }
            return calendar.date(byAdding: .minute, value: minutes, to: sunset)
        case .degreesBelowHorizon(let angle):
            guard let sunset = sunCalc.sunset else { return nil }

            // Iterate minute by minute for up to 2 hours (120 minutes) past sunset
            // to find when the sun's altitude reaches the specified angle below the horizon.
            for i in 0...(120) {
                guard let currentDateToTest = calendar.date(byAdding: .minute, value: i, to: sunset) else {
                    // Should not happen if sunset is valid and i is reasonable
                    continue
                }

                // Note: SunCalc's getPosition takes a Date object, but its calculations are based on the
                // date instance it was initialized with for its primary .sunset, .sunrise etc. properties.
                // To get the position at a *specific time* (currentDateToTest), we need to use that specific time.
                // The SunCalcSwift library's SunCalc.getPosition might implicitly use the date it was initialized with,
                // or it might correctly use the date passed to the method.
                // The original suncalc.js `getPosition` takes a date argument that overrides the instance's date.
                // Let's assume SunCalcSwift behaves similarly or use a fresh SunCalc instance if needed.
                // For safety, creating a new SunCalc instance for each iteration or ensuring getPosition uses the passed date is better.
                // However, the provided SunCalcSwift's SunCalc class is initialized with a date and other properties are based on that.
                // Let's try passing the date to getPosition, assuming it overrides. If not, a new instance per iteration is needed.
                // After reviewing SunCalcSwift source, `getPosition` indeed takes a `date` parameter and uses it.

                let position = sunCalc.getPosition(date: currentDateToTest, latitude: latitude, longitude: longitude)
                let altitudeDegrees = position.altitude * 180 / .pi // Convert radians to degrees

                // Angle should be negative (below horizon). Take absolute value of input 'angle' to be safe.
                if altitudeDegrees <= -abs(angle) {
                    return currentDateToTest
                }
            }
            // Target angle not reached within 120 minutes of sunset
            return nil
        }
    }
}
