import Foundation

public enum HavdalahOpinion {
    case minutesAfterSunset(minutes: Int)
    case degreesBelowHorizon(angle: Double) // e.g., 8.5 or 8.75
}

/// Candle-lighting and Havdalah times, matching the rounding conventions of
/// `@hebcal/core` (`Zmanim.sunsetOffset()`, `Zmanim.tzeit()` and `HavdalahEvent`).
/// Times are computed with ``NOAACalculator`` using sea-level sunset.
public struct Zmanim {

    /// Candle lighting: 18 minutes before sunset (40 in Jerusalem), with sunset's seconds discarded.
    /// Returns `nil` if the sun does not set on that date.
    public static func getCandleLightingTime(for date: Date, latitude: Double, longitude: Double, timeZone: TimeZone, isJerusalem: Bool = false) -> Date? {
        let astro = astronomicalCalendar(for: date, latitude: latitude, longitude: longitude, timeZone: timeZone)
        guard let sunset = astro.getSeaLevelSunset() else {
            // Sunset might not occur in polar regions
            return nil
        }
        return sunsetOffset(sunset, minutes: isJerusalem ? -40 : -18)
    }

    /// Havdalah as a fixed number of minutes after sunset, or when the sun reaches an angle
    /// below the horizon (tzeit hakochavim), rounded to the nearest minute.
    /// Returns `nil` if the sun does not reach that point on that date.
    public static func getHavdalahTime(for date: Date, latitude: Double, longitude: Double, timeZone: TimeZone, opinion: HavdalahOpinion) -> Date? {
        let astro = astronomicalCalendar(for: date, latitude: latitude, longitude: longitude, timeZone: timeZone)

        switch opinion {
        case .minutesAfterSunset(let minutes):
            guard let sunset = astro.getSeaLevelSunset() else { return nil }
            return sunsetOffset(sunset, minutes: minutes)
        case .degreesBelowHorizon(let angle):
            // Angle should be below the horizon. Take absolute value of input 'angle' to be safe.
            let zenith = NOAACalculator.geometricZenith + abs(angle)
            guard let tzeit = astro.getSunsetOffsetByDegrees(zenith) else { return nil }
            return roundTime(tzeit)
        }
    }

    private static func astronomicalCalendar(for date: Date, latitude: Double, longitude: Double, timeZone: TimeZone) -> AstronomicalCalendar {
        let geoLocation = GeoLocation(latitude: latitude, longitude: longitude, timeZone: timeZone)
        return AstronomicalCalendar(geoLocation: geoLocation, date: date)
    }

    /// Sunset plus `minutes`, discarding sunset's seconds. For positive offsets
    /// (Havdalah), rounds up to the next minute if sunset is at :30 seconds or later.
    static func sunsetOffset(_ sunset: Date, minutes: Int) -> Date {
        let seconds = floor(sunset.timeIntervalSince1970)
        var offset = minutes
        if offset > 0 && secondOfMinute(seconds) >= 30 {
            offset += 1
        }
        let truncated = seconds - secondOfMinute(seconds)
        return Date(timeIntervalSince1970: truncated + Double(offset) * 60)
    }

    /// Discards milliseconds and rounds to the nearest minute (:30 seconds rounds up).
    static func roundTime(_ date: Date) -> Date {
        let seconds = floor(date.timeIntervalSince1970)
        let sec = secondOfMinute(seconds)
        let delta = sec >= 30 ? 60 - sec : -sec
        return Date(timeIntervalSince1970: seconds + delta)
    }

    private static func secondOfMinute(_ epochSeconds: Double) -> Double {
        let sec = epochSeconds.truncatingRemainder(dividingBy: 60)
        return sec < 0 ? sec + 60 : sec
    }
}
