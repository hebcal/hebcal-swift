// Swift port of the sunrise/sunset subset of com.kosherjava.zmanim.AstronomicalCalendar
// from https://github.com/KosherJava/zmanim (LGPL 2.1)

import Foundation

/// Sunrise, sunset and related times for one date at one location, computed with ``NOAACalculator``.
/// Each accessor returns `nil` where the sun does not reach the requested position
/// (for example, sunset during polar day).
public struct AstronomicalCalendar {
    public let geoLocation: GeoLocation
    public let localDate: LocalDate
    public var calculator: NOAACalculator

    public init(geoLocation: GeoLocation, localDate: LocalDate, calculator: NOAACalculator = NOAACalculator()) {
        self.geoLocation = geoLocation
        self.localDate = localDate
        self.calculator = calculator
    }

    /// Calendar for the date that `date` falls on in the location's time zone.
    public init(geoLocation: GeoLocation, date: Date, calculator: NOAACalculator = NOAACalculator()) {
        self.init(geoLocation: geoLocation,
                  localDate: LocalDate(date: date, timeZone: geoLocation.timeZone),
                  calculator: calculator)
    }

    /// Sunrise, adjusted for the location's elevation.
    public func getSunrise() -> Date? {
        return getInstantFromTime(getUTCSunrise(NOAACalculator.geometricZenith), .sunrise)
    }

    /// Sunrise at sea level, ignoring elevation.
    public func getSeaLevelSunrise() -> Date? {
        return getInstantFromTime(getUTCSeaLevelSunrise(NOAACalculator.geometricZenith), .sunrise)
    }

    /// Sunset, adjusted for the location's elevation.
    public func getSunset() -> Date? {
        return getInstantFromTime(getUTCSunset(NOAACalculator.geometricZenith), .sunset)
    }

    /// Sunset at sea level, ignoring elevation.
    public func getSeaLevelSunset() -> Date? {
        return getInstantFromTime(getUTCSeaLevelSunset(NOAACalculator.geometricZenith), .sunset)
    }

    /// Time in the morning when the sun is at `offsetZenith` degrees from the vertical,
    /// e.g. 96 for civil dawn (6° below the horizon).
    public func getSunriseOffsetByDegrees(_ offsetZenith: Double) -> Date? {
        return getInstantFromTime(getUTCSunrise(offsetZenith), .sunrise)
    }

    /// Time in the evening when the sun is at `offsetZenith` degrees from the vertical,
    /// e.g. 98.5 for tzeit 8.5° below the horizon.
    public func getSunsetOffsetByDegrees(_ offsetZenith: Double) -> Date? {
        return getInstantFromTime(getUTCSunset(offsetZenith), .sunset)
    }

    /// Solar noon (transit).
    public func getSunTransit() -> Date? {
        return getInstantFromTime(calculator.getUTCNoon(getAdjustedLocalDate(), geoLocation), .noon)
    }

    public func getUTCSunrise(_ zenith: Double) -> Double {
        return calculator.getUTCSunrise(getAdjustedLocalDate(), geoLocation, zenith: zenith, adjustForElevation: true)
    }

    public func getUTCSeaLevelSunrise(_ zenith: Double) -> Double {
        return calculator.getUTCSunrise(getAdjustedLocalDate(), geoLocation, zenith: zenith, adjustForElevation: false)
    }

    public func getUTCSunset(_ zenith: Double) -> Double {
        return calculator.getUTCSunset(getAdjustedLocalDate(), geoLocation, zenith: zenith, adjustForElevation: true)
    }

    public func getUTCSeaLevelSunset(_ zenith: Double) -> Double {
        return calculator.getUTCSunset(getAdjustedLocalDate(), geoLocation, zenith: zenith, adjustForElevation: false)
    }

    func getAdjustedLocalDate() -> LocalDate {
        let offset = geoLocation.getAntimeridianAdjustment(getMidnightLastNight())
        return offset == 0 ? localDate : localDate.plusDays(offset)
    }

    func getMidnightLastNight() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = geoLocation.timeZone
        let comps = DateComponents(year: localDate.year, month: localDate.month, day: localDate.day)
        return calendar.date(from: comps)!
    }

    /// Converts a UTC time in fractional hours to an instant on the adjusted local date,
    /// rolling the date when the event falls on the previous or next UTC day.
    func getInstantFromTime(_ time: Double, _ solarEvent: NOAACalculator.SolarEvent) -> Date? {
        if time.isNaN {
            return nil
        }

        var date = getAdjustedLocalDate()
        let localTimeHours = (geoLocation.longitude / 15) + time

        if solarEvent == .sunrise && localTimeHours > 18 {
            date = date.plusDays(-1)
        } else if solarEvent == .sunset && localTimeHours < 6 {
            date = date.plusDays(1)
        } else if solarEvent == .midnight && localTimeHours < 12 {
            date = date.plusDays(1)
        } else if solarEvent == .noon {
            if localTimeHours < 0 {
                date = date.plusDays(1)
            } else if localTimeHours > 24 {
                date = date.plusDays(-1)
            }
        }

        let nanos = (time * 3_600_000_000_000).rounded()
        return date.startOfDayUTC.addingTimeInterval(nanos / 1_000_000_000)
    }
}
