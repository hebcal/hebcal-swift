/*
 * Zmanim Java API
 * Copyright © 2004-2026 Eliyahu Hershfeld
 *
 * This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General
 * Public License as published by the Free Software Foundation; version 2.1 of the License.
 *
 * This library is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 * You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA,
 * or connect to: https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
 */

// Swift port of com.kosherjava.zmanim.util.NOAACalculator and its
// AstronomicalCalculator base class from https://github.com/KosherJava/zmanim

import Foundation

/// A calendar date with no time or time zone, equivalent to `java.time.LocalDate`.
public struct LocalDate: Equatable {
    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    /// The calendar date of `date` as observed in `timeZone`.
    public init(date: Date, timeZone: TimeZone) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        self.init(year: comps.year!, month: comps.month!, day: comps.day!)
    }

    func plusDays(_ days: Int) -> LocalDate {
        let date = startOfDayUTC.addingTimeInterval(Double(days) * 86400)
        return LocalDate(date: date, timeZone: TimeZone(identifier: "UTC")!)
    }

    /// Midnight UTC at the start of this date.
    var startOfDayUTC: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    /// Day of year (1-365) for this month and day in the common year 2050, as
    /// `localDate.withYear(2050).getDayOfYear()`; February 29 maps to February 28.
    var dayOfYearIn2050: Int {
        let cumulativeDays = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
        let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        return cumulativeDays[month - 1] + min(day, daysInMonth[month - 1])
    }
}

/// A location on Earth, a subset of `com.kosherjava.zmanim.util.GeoLocation`.
public struct GeoLocation {
    public var latitude: Double
    public var longitude: Double
    /// Elevation in meters above sea level.
    public var elevation: Double
    public var timeZone: TimeZone

    public init(latitude: Double, longitude: Double, elevation: Double = 0, timeZone: TimeZone) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
        self.timeZone = timeZone
    }

    /// The offset in milliseconds between local mean time at this longitude and the standard time zone offset.
    public func getLocalMeanTimeOffset(_ instant: Date) -> Double {
        let timezoneOffsetMillis = Double(timeZone.secondsFromGMT(for: instant)) * 1000
        return longitude * 4 * 60_000 - timezoneOffsetMillis
    }

    /// Adjustment to the date for locations whose time zone is across the antimeridian, such as Samoa.
    /// Returns 1 to roll the date forward, -1 to roll it back, 0 otherwise.
    public func getAntimeridianAdjustment(_ instant: Date) -> Int {
        let localHoursOffset = getLocalMeanTimeOffset(instant) / 3_600_000
        if localHoursOffset >= 20 {
            return 1
        } else if localHoursOffset <= -20 {
            return -1
        }
        return 0
    }
}

/// Implementation of sunrise and sunset methods to calculate astronomical times based on the
/// [NOAA](https://noaa.gov) algorithm, which is based on equations from *Astronomical Algorithms*
/// by Jean Meeus. Added to the algorithm is an adjustment of the zenith to account for elevation.
public struct NOAACalculator {
    /// The zenith of astronomical sunrise and sunset. The sun is 90° from the vertical 0°.
    public static let geometricZenith: Double = 90
    public static let civilZenith: Double = 96
    public static let nauticalZenith: Double = 102
    public static let astronomicalZenith: Double = 108

    private static let julianDayJan1_2000: Double = 2451545.0
    private static let julianDaysPerCentury: Double = 36525.0

    enum SolarEvent {
        case sunrise, sunset, noon, midnight
    }

    /// Refraction in degrees at the horizon. Defaults to 34 arcminutes.
    public var refraction: Double = 34 / 60.0

    /// Earth radius in KM (IUGG mean radius R1 = (2a + b) / 3, WGS-84), used for the elevation adjustment.
    public var earthRadius: Double = 6371.0088

    /// When `true` (the default), sunrise and sunset use the Sun's apparent radius for the date
    /// from ``getApparentSolarRadius(_:)`` rather than the fixed ``solarRadius``.
    public var useApparentSolarRadius: Bool = true

    /// A fixed solar radius in degrees. Setting it turns off ``useApparentSolarRadius``.
    public var solarRadius: Double = 16 / 60.0 {
        didSet { useApparentSolarRadius = false }
    }

    public init() {}

    // MARK: - AstronomicalCalculator

    func getElevationAdjustment(_ elevation: Double) -> Double {
        return toDegrees(acos(earthRadius / (earthRadius + (elevation / 1000))))
    }

    func adjustZenith(_ zenith: Double, _ elevation: Double, _ localDate: LocalDate?) -> Double {
        var adjustedZenith = zenith
        if zenith == NOAACalculator.geometricZenith { // only adjust if it is exactly sunrise or sunset
            if useApparentSolarRadius, let localDate = localDate {
                adjustedZenith = zenith + (getApparentSolarRadius(localDate) + refraction + getElevationAdjustment(elevation))
            } else {
                adjustedZenith = zenith + (solarRadius + refraction + getElevationAdjustment(elevation))
            }
        }
        return adjustedZenith
    }

    /// The Sun's apparent angular semi-diameter in degrees for the given date.
    public func getApparentSolarRadius(_ localDate: LocalDate?) -> Double {
        guard let localDate = localDate else { return 16 / 60.0 }
        return NOAACalculator.solarRadiusByDayOfYear[localDate.dayOfYearIn2050 - 1]
    }

    // MARK: - NOAACalculator

    /// Sunrise in UTC hours (0 ≤ h < 24), or NaN if the sun does not reach `zenith` on this date.
    public func getUTCSunrise(_ localDate: LocalDate, _ geoLocation: GeoLocation, zenith: Double, adjustForElevation: Bool) -> Double {
        return getUTCSunRiseSet(localDate, geoLocation, zenith, adjustForElevation, .sunrise)
    }

    /// Sunset in UTC hours (0 ≤ h < 24), or NaN if the sun does not reach `zenith` on this date.
    public func getUTCSunset(_ localDate: LocalDate, _ geoLocation: GeoLocation, zenith: Double, adjustForElevation: Bool) -> Double {
        return getUTCSunRiseSet(localDate, geoLocation, zenith, adjustForElevation, .sunset)
    }

    private func getUTCSunRiseSet(_ localDate: LocalDate, _ geoLocation: GeoLocation, _ zenith: Double,
                                  _ adjustForElevation: Bool, _ solarEvent: SolarEvent) -> Double {
        let elevation = adjustForElevation ? geoLocation.elevation : 0
        let adjustedZenith = adjustZenith(zenith, elevation, localDate)
        var riseSet = NOAACalculator.getSunRiseSetUTC(localDate, geoLocation.latitude, -geoLocation.longitude,
                                                      adjustedZenith, solarEvent)
        riseSet = riseSet / 60
        return javaMod(javaMod(riseSet, 24) + 24, 24) // ensure that the time is >= 0 and < 24
    }

    private static func getJulianDay(_ localDate: LocalDate) -> Double {
        var year = localDate.year
        var month = localDate.month
        let day = localDate.day
        if month <= 2 {
            year -= 1
            month += 12
        }
        let a = year / 100
        let b = 2 - a + a / 4
        return floor(365.25 * Double(year + 4716)) + floor(30.6001 * Double(month + 1)) + Double(day) + Double(b) - 1524.5
    }

    private static func getJulianCenturiesFromJulianDay(_ julianDay: Double) -> Double {
        return (julianDay - julianDayJan1_2000) / julianDaysPerCentury
    }

    private static func getSunGeometricMeanLongitude(_ julianCenturies: Double) -> Double {
        let longitude = 280.46646 + julianCenturies * (36000.76983 + 0.0003032 * julianCenturies)
        return javaMod(javaMod(longitude, 360) + 360, 360) // return a longitude is in the range of 0 - 360
    }

    private static func getSunGeometricMeanAnomaly(_ julianCenturies: Double) -> Double {
        return 357.52911 + julianCenturies * (35999.05029 - 0.0001537 * julianCenturies)
    }

    private static func getEarthOrbitEccentricity(_ julianCenturies: Double) -> Double {
        return 0.016708634 - julianCenturies * (0.000042037 + 0.0000001267 * julianCenturies)
    }

    private static func getSunEquationOfCenter(_ julianCenturies: Double) -> Double {
        let m = getSunGeometricMeanAnomaly(julianCenturies)
        let sinm = sinDegrees(m)
        let sin2m = sinDegrees(m + m)
        let sin3m = sinDegrees(m + m + m)
        return sinm * (1.914602 - julianCenturies * (0.004817 + 0.000014 * julianCenturies)) + sin2m
            * (0.019993 - 0.000101 * julianCenturies) + sin3m * 0.000289
    }

    private static func getSunTrueLongitude(_ julianCenturies: Double) -> Double {
        let sunLongitude = getSunGeometricMeanLongitude(julianCenturies)
        let center = getSunEquationOfCenter(julianCenturies)
        return sunLongitude + center
    }

    private static func getSunApparentLongitude(_ julianCenturies: Double) -> Double {
        let sunTrueLongitude = getSunTrueLongitude(julianCenturies)
        let omega = 125.04 - 1934.136 * julianCenturies
        return sunTrueLongitude - 0.00569 - 0.00478 * sinDegrees(omega)
    }

    private static func getMeanObliquityOfEcliptic(_ julianCenturies: Double) -> Double {
        let seconds = 21.448 - julianCenturies
            * (46.8150 + julianCenturies * (0.00059 - julianCenturies * (0.001813)))
        return 23.0 + (26.0 + (seconds / 60.0)) / 60.0
    }

    private static func getObliquityCorrection(_ julianCenturies: Double) -> Double {
        let obliquityOfEcliptic = getMeanObliquityOfEcliptic(julianCenturies)
        let omega = 125.04 - 1934.136 * julianCenturies
        return obliquityOfEcliptic + 0.00256 * cosDegrees(omega)
    }

    private static func getSunDeclination(_ julianCenturies: Double) -> Double {
        let obliquityCorrection = getObliquityCorrection(julianCenturies)
        let lambda = getSunApparentLongitude(julianCenturies)
        let sint = sinDegrees(obliquityCorrection) * sinDegrees(lambda)
        return asinDegrees(sint)
    }

    private static func getEquationOfTime(_ julianCenturies: Double) -> Double {
        let epsilon = getObliquityCorrection(julianCenturies)
        let geomMeanLongSun = getSunGeometricMeanLongitude(julianCenturies)
        let eccentricityEarthOrbit = getEarthOrbitEccentricity(julianCenturies)
        let geomMeanAnomalySun = getSunGeometricMeanAnomaly(julianCenturies)
        var y = tanDegrees(epsilon / 2.0)
        y *= y
        let sin2l0 = sinDegrees(2.0 * geomMeanLongSun)
        let sinm = sinDegrees(geomMeanAnomalySun)
        let cos2l0 = cosDegrees(2.0 * geomMeanLongSun)
        let sin4l0 = sinDegrees(4.0 * geomMeanLongSun)
        let sin2m = sinDegrees(2.0 * geomMeanAnomalySun)
        let equationOfTime = y * sin2l0 - 2.0 * eccentricityEarthOrbit * sinm + 4.0 * eccentricityEarthOrbit * y
            * sinm * cos2l0 - 0.5 * y * y * sin4l0 - 1.25 * eccentricityEarthOrbit * eccentricityEarthOrbit * sin2m
        return toDegrees(equationOfTime) * 4.0
    }

    private static func getSunHourAngle(_ latitude: Double, _ solarDeclination: Double, _ zenith: Double,
                                        _ solarEvent: SolarEvent) -> Double {
        let ratio = cosDegrees(zenith) / (cosDegrees(latitude) * cosDegrees(solarDeclination)) - tanDegrees(latitude)
            * tanDegrees(solarDeclination)
        var hourAngle = acos(ratio)
        if solarEvent == .sunset {
            hourAngle = -hourAngle
        }
        return hourAngle
    }

    /// Topocentric elevation of the sun in degrees (corrected for atmospheric refraction) at `instant`.
    public func getSolarElevation(_ instant: Date, _ geoLocation: GeoLocation) -> Double {
        return getSolarElevationAzimuth(instant, geoLocation, false)
    }

    /// Azimuth of the sun in degrees clockwise from north at `instant`.
    public func getSolarAzimuth(_ instant: Date, _ geoLocation: GeoLocation) -> Double {
        return getSolarElevationAzimuth(instant, geoLocation, true)
    }

    private func getSolarElevationAzimuth(_ instant: Date, _ geoLocation: GeoLocation, _ isAzimuth: Bool) -> Double {
        let lat = geoLocation.latitude
        let lon = geoLocation.longitude
        let utcDate = LocalDate(date: instant, timeZone: TimeZone(identifier: "UTC")!)
        let fractionalDay = instant.timeIntervalSince(utcDate.startOfDayUTC) / 86400.0
        let jd = NOAACalculator.getJulianDay(utcDate) + fractionalDay
        let jc = NOAACalculator.getJulianCenturiesFromJulianDay(jd)
        let decl = NOAACalculator.getSunDeclination(jc)
        let eot = NOAACalculator.getEquationOfTime(jc)
        let trueSolarTime = javaMod((fractionalDay + eot / 1440.0 + lon / 360.0) + 2, 1)
        let hourAngle = trueSolarTime * 2 * Double.pi - Double.pi
        let cosZenith = sinDegrees(lat) * sinDegrees(decl) + cosDegrees(lat) * cosDegrees(decl) * cos(hourAngle)
        let zenithDeg = acosDegrees(max(-1, min(1, cosZenith)))
        let elevation = (90.0 - zenithDeg) + adjustElevationForRefraction(90.0 - zenithDeg)
        let azimuth: Double
        let azDenom = cosDegrees(lat) * sinDegrees(zenithDeg)
        if abs(azDenom) > 0.001 {
            let az = (sinDegrees(lat) * cosDegrees(zenithDeg) - sinDegrees(decl)) / azDenom
            azimuth = 180 - acosDegrees(max(-1, min(1, az))) * (hourAngle > 0 ? -1 : 1)
        } else {
            azimuth = lat > 0 ? 180 : 0
        }
        return isAzimuth ? javaMod(azimuth + 360, 360) : elevation
    }

    private func adjustElevationForRefraction(_ elevation: Double) -> Double {
        if elevation > 85.0 {
            return 0.0
        }
        let te = tanDegrees(elevation)
        let correction: Double
        if elevation > 5.0 {
            correction = 58.1 / te - 0.07 / pow(te, 3) + 0.000086 / pow(te, 5)
        } else if elevation > -0.575 {
            correction = 1735.0 + elevation * (-518.2 + elevation * (103.4 + elevation * (-12.79 + 0.711 * elevation)))
        } else {
            correction = -20.774 / te
        }
        return correction / 3600.0
    }

    /// Solar noon (transit) in UTC hours (0 ≤ h < 24).
    public func getUTCNoon(_ localDate: LocalDate, _ geoLocation: GeoLocation) -> Double {
        var noon = NOAACalculator.getSolarNoonMidnightUTC(NOAACalculator.getJulianDay(localDate), -geoLocation.longitude, .noon)
        noon = noon / 60
        return javaMod(javaMod(noon, 24) + 24, 24) // ensure that the time is >= 0 and < 24
    }

    /// Solar midnight in UTC hours (0 ≤ h < 24).
    public func getUTCMidnight(_ localDate: LocalDate, _ geoLocation: GeoLocation) -> Double {
        var midnight = NOAACalculator.getSolarNoonMidnightUTC(NOAACalculator.getJulianDay(localDate), -geoLocation.longitude, .midnight)
        midnight = midnight / 60
        return javaMod(javaMod(midnight, 24) + 24, 24) // ensure that the time is >= 0 and < 24
    }

    private static func getSolarNoonMidnightUTC(_ julianDay: Double, _ longitude: Double, _ solarEvent: SolarEvent) -> Double {
        // no day-half shift: the loop epoch julianDay + solNoonUTC/1440 already lands on the event
        // First pass for approximate solar noon to calculate equation of time
        let tnoon = getJulianCenturiesFromJulianDay(julianDay + longitude / 360.0)
        var equationOfTime = getEquationOfTime(tnoon)
        var solNoonUTC = (longitude * 4) - equationOfTime // minutes

        // Refine the equation of time at the calculated transit time.
        for _ in 0..<2 {
            let newt = getJulianCenturiesFromJulianDay(julianDay + solNoonUTC / 1440.0)
            equationOfTime = getEquationOfTime(newt)
            solNoonUTC = (solarEvent == .noon ? 720 : 1440) + (longitude * 4) - equationOfTime
        }
        return solNoonUTC
    }

    private static func getSunRiseSetUTC(_ localDate: LocalDate, _ latitude: Double, _ longitude: Double, _ zenith: Double,
                                         _ solarEvent: SolarEvent) -> Double {
        let julianDay = getJulianDay(localDate)

        // Find the time of solar noon at the location, and use that declination.
        // This is better than start of the Julian day
        let noonmin = getSolarNoonMidnightUTC(julianDay, longitude, .noon)
        let tnoon = getJulianCenturiesFromJulianDay(julianDay + noonmin / 1440.0)

        // First calculates sunrise and approximate length of day
        var equationOfTime = getEquationOfTime(tnoon)
        var solarDeclination = getSunDeclination(tnoon)
        var hourAngle = getSunHourAngle(latitude, solarDeclination, zenith, solarEvent)
        var delta = longitude - toDegrees(hourAngle)
        var timeDiff = 4 * delta
        var timeUTC = 720 + timeDiff - equationOfTime

        // Second pass includes fractional Julian Day in gamma calc
        let newt = getJulianCenturiesFromJulianDay(julianDay + timeUTC / 1440.0)
        equationOfTime = getEquationOfTime(newt)
        solarDeclination = getSunDeclination(newt)
        hourAngle = getSunHourAngle(latitude, solarDeclination, zenith, solarEvent)
        delta = longitude - toDegrees(hourAngle)
        timeDiff = 4 * delta
        timeUTC = 720 + timeDiff - equationOfTime
        return timeUTC
    }

    /// Time the sun is at azimuth 90° (directly east) or 270° (directly west), in UTC hours,
    /// or NaN where it never gets there (the tropics, poles, and equator).
    public func getTimeAtAzimuth(_ localDate: LocalDate, _ geoLocation: GeoLocation, targetAzimuth: Double) -> Double {
        precondition(targetAzimuth == 90.0 || targetAzimuth == 270.0,
                     "The targetAzimuth must be 90 or 270. Other azimuth values are not supported")
        let julianDay = NOAACalculator.getJulianDay(localDate)
        let solarNoonBase = 0.5 - (geoLocation.longitude / 360.0)
        var dateTime = solarNoonBase + ((targetAzimuth == 90.0) ? 0.25 : 0.75)
        for _ in 0..<3 {
            let julianCenturies = NOAACalculator.getJulianCenturiesFromJulianDay(julianDay + dateTime)
            let ratio = tanDegrees(NOAACalculator.getSunDeclination(julianCenturies)) / tanDegrees(geoLocation.latitude)
            if ratio.isNaN || ratio > 1.0 || ratio < -1.0 { // Handle Tropics, the Poles, and Equator line divisions
                return Double.nan
            }
            let offset = ((targetAzimuth == 90.0) ? -1.0 : 1.0) * (acosDegrees(ratio) / 360.0)
            dateTime = solarNoonBase + offset - (NOAACalculator.getEquationOfTime(julianCenturies) / 1440.0)
        }
        return javaMod(javaMod(dateTime * 24, 24) + 24, 24)
    }

    // swiftlint:disable line_length
    /// The Sun's apparent angular semi-diameter in degrees for each day of the (common) year 2050,
    /// precomputed from the VSOP87 Earth-Sun distance.
    private static let solarRadiusByDayOfYear: [Double] = [
        0.27108024, 0.27108486, 0.27108790, 0.27108930, 0.27108899, 0.27108695, 0.27108316, 0.27107762, 0.27107033,
        0.27106133, 0.27105062, 0.27103826, 0.27102427, 0.27100873, 0.27099168, 0.27097320, 0.27095337, 0.27093228,
        0.27091002, 0.27088667, 0.27086231, 0.27083701, 0.27081079, 0.27078369, 0.27075569, 0.27072676, 0.27069684,
        0.27066588, 0.27063378, 0.27060048, 0.27056589, 0.27052995, 0.27049261, 0.27045383, 0.27041359, 0.27037186,
        0.27032864, 0.27028396, 0.27023782, 0.27019025, 0.27014129, 0.27009098, 0.27003938, 0.26998658, 0.26993264,
        0.26987767, 0.26982177, 0.26976506, 0.26970763, 0.26964958, 0.26959099, 0.26953191, 0.26947239, 0.26941242,
        0.26935200, 0.26929108, 0.26922962, 0.26916755, 0.26910482, 0.26904136, 0.26897712, 0.26891206, 0.26884614,
        0.26877935, 0.26871165, 0.26864306, 0.26857358, 0.26850321, 0.26843197, 0.26835989, 0.26828703, 0.26821343,
        0.26813918, 0.26806437, 0.26798910, 0.26791348, 0.26783763, 0.26776167, 0.26768569, 0.26760979, 0.26753404,
        0.26745846, 0.26738308, 0.26730790, 0.26723289, 0.26715800, 0.26708320, 0.26700842, 0.26693363, 0.26685877,
        0.26678380, 0.26670870, 0.26663342, 0.26655796, 0.26648229, 0.26640640, 0.26633030, 0.26625399, 0.26617748,
        0.26610082, 0.26602406, 0.26594728, 0.26587055, 0.26579398, 0.26571769, 0.26564180, 0.26556641, 0.26549164,
        0.26541756, 0.26534425, 0.26527174, 0.26520006, 0.26512920, 0.26505915, 0.26498987, 0.26492132, 0.26485345,
        0.26478622, 0.26471959, 0.26465351, 0.26458794, 0.26452285, 0.26445820, 0.26439396, 0.26433010, 0.26426661,
        0.26420348, 0.26414070, 0.26407832, 0.26401636, 0.26395489, 0.26389400, 0.26383378, 0.26377435, 0.26371580,
        0.26365825, 0.26360179, 0.26354651, 0.26349247, 0.26343971, 0.26338825, 0.26333807, 0.26328918, 0.26324153,
        0.26319510, 0.26314983, 0.26310568, 0.26306261, 0.26302057, 0.26297951, 0.26293938, 0.26290014, 0.26286173,
        0.26282411, 0.26278725, 0.26275111, 0.26271570, 0.26268102, 0.26264710, 0.26261399, 0.26258177, 0.26255053,
        0.26252037, 0.26249137, 0.26246366, 0.26243731, 0.26241239, 0.26238897, 0.26236707, 0.26234671, 0.26232790,
        0.26231061, 0.26229481, 0.26228048, 0.26226756, 0.26225602, 0.26224581, 0.26223687, 0.26222914, 0.26222257,
        0.26221708, 0.26221262, 0.26220912, 0.26220653, 0.26220480, 0.26220392, 0.26220388, 0.26220470, 0.26220642,
        0.26220910, 0.26221282, 0.26221768, 0.26222375, 0.26223114, 0.26223991, 0.26225014, 0.26226187, 0.26227512,
        0.26228992, 0.26230626, 0.26232413, 0.26234349, 0.26236433, 0.26238659, 0.26241024, 0.26243521, 0.26246145,
        0.26248890, 0.26251746, 0.26254708, 0.26257766, 0.26260913, 0.26264141, 0.26267446, 0.26270823, 0.26274270,
        0.26277789, 0.26281382, 0.26285054, 0.26288813, 0.26292666, 0.26296622, 0.26300686, 0.26304868, 0.26309171,
        0.26313601, 0.26318159, 0.26322848, 0.26327666, 0.26332612, 0.26337685, 0.26342881, 0.26348197, 0.26353627,
        0.26359167, 0.26364809, 0.26370545, 0.26376368, 0.26382267, 0.26388233, 0.26394256, 0.26400328, 0.26406442,
        0.26412593, 0.26418777, 0.26424995, 0.26431249, 0.26437542, 0.26443880, 0.26450270, 0.26456718, 0.26463231,
        0.26469815, 0.26476474, 0.26483213, 0.26490034, 0.26496937, 0.26503922, 0.26510990, 0.26518138, 0.26525364,
        0.26532664, 0.26540034, 0.26547467, 0.26554957, 0.26562495, 0.26570072, 0.26577676, 0.26585296, 0.26592922,
        0.26600544, 0.26608154, 0.26615745, 0.26623314, 0.26630859, 0.26638382, 0.26645884, 0.26653372, 0.26660850,
        0.26668323, 0.26675798, 0.26683280, 0.26690773, 0.26698280, 0.26705803, 0.26713345, 0.26720905, 0.26728485,
        0.26736083, 0.26743698, 0.26751326, 0.26758964, 0.26766606, 0.26774245, 0.26781872, 0.26789476, 0.26797045,
        0.26804569, 0.26812035, 0.26819433, 0.26826755, 0.26833992, 0.26841141, 0.26848200, 0.26855170, 0.26862051,
        0.26868849, 0.26875567, 0.26882211, 0.26888786, 0.26895296, 0.26901746, 0.26908139, 0.26914478, 0.26920767,
        0.26927006, 0.26933199, 0.26939345, 0.26945445, 0.26951496, 0.26957497, 0.26963442, 0.26969325, 0.26975136,
        0.26980865, 0.26986502, 0.26992034, 0.26997450, 0.27002740, 0.27007895, 0.27012907, 0.27017773, 0.27022491,
        0.27027060, 0.27031483, 0.27035764, 0.27039906, 0.27043914, 0.27047794, 0.27051549, 0.27055186, 0.27058709,
        0.27062122, 0.27065430, 0.27068636, 0.27071746, 0.27074761, 0.27077684, 0.27080516, 0.27083256, 0.27085899,
        0.27088442, 0.27090875, 0.27093191, 0.27095379, 0.27097427, 0.27099326, 0.27101067, 0.27102640, 0.27104041,
        0.27105266, 0.27106312, 0.27107182, 0.27107876, 0.27108399
    ]
    // swiftlint:enable line_length
}

/// Java's floating-point `%`, which keeps the sign of the dividend.
private func javaMod(_ x: Double, _ y: Double) -> Double {
    return x.truncatingRemainder(dividingBy: y)
}

private let radiansToDegrees = 57.29577951308232
private let degreesToRadians = 0.017453292519943295

private func toDegrees(_ radians: Double) -> Double {
    return radians * radiansToDegrees
}

private func toRadians(_ degrees: Double) -> Double {
    return degrees * degreesToRadians
}

private func tanDegrees(_ angle: Double) -> Double {
    return tan(toRadians(angle))
}

private func sinDegrees(_ angle: Double) -> Double {
    return sin(toRadians(angle))
}

private func cosDegrees(_ angle: Double) -> Double {
    return cos(toRadians(angle))
}

private func acosDegrees(_ angle: Double) -> Double {
    return toDegrees(acos(angle))
}

private func asinDegrees(_ angle: Double) -> Double {
    return toDegrees(asin(angle))
}
