import Foundation
import SunCalc

public enum HavdalahOpinion {
    case minutesAfterSunset(minutes: Int)
    case degreesBelowHorizon(angle: Double) // e.g., 8.5 or 8.75
}

public struct Zmanim {

    public static func getCandleLightingTime(for date: Date, latitude: Double, longitude: Double, timeZone: TimeZone, isJerusalem: Bool = false) -> Date? {
        let sunCalc = SunCalc.getTimes(date: date, latitude: latitude, longitude: longitude)

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
        let sunCalc = SunCalc.getTimes(date: date, latitude: latitude, longitude: longitude)
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

                let position = SunCalc.getSunPosition(timeAndDate: currentDateToTest, latitude: latitude, longitude: longitude)
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
