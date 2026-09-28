import Foundation
import Testing
@testable import Hebcal

struct HolidayTests {
    /// Each event as "yyyy-MM-dd desc", with the Gregorian date in the current time zone.
    static func dated(_ events: [HEvent]) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return events.map { "\(formatter.string(from: $0.hdate.greg())) \($0.desc)" }
    }

    @Test func allHolidaysCount() {
        #expect(getAllHolidaysForYear(year: 5783).count == 106)
    }

    @Test(arguments: [
        (5782, false, 87), (5782, true, 90),
        (5783, false, 85), (5783, true, 88),
        (5784, false, 86), (5784, true, 89),
    ])
    func holidaysForYearCount(year: Int, il: Bool, expected: Int) {
        #expect(getHolidaysForYear(year: year, il: il).count == expected)
    }

    @Test func modernHolidaysIL() {
        let events = getHolidaysForYear(year: 5783, il: true).filter { $0.flags.contains(.MODERN_HOLIDAY) }
        #expect(Self.dated(events) == [
            "2022-11-01 Yom HaAliyah School Observance",
            "2022-11-06 Yitzhak Rabin Memorial Day",
            "2022-11-23 Sigd",
            "2022-11-30 Ben-Gurion Day",
            "2023-02-21 Family Day",
            "2023-04-01 Yom HaAliyah",
            "2023-04-18 Yom HaShoah",
            "2023-04-25 Yom HaZikaron",
            "2023-04-26 Yom HaAtzma'ut",
            "2023-05-01 Herzl Day",
            "2023-05-19 Yom Yerushalayim",
            "2023-07-18 Jabotinsky Day",
        ])
    }

    @Test func modernHolidaysDiaspora() {
        let events = getHolidaysForYear(year: 5783, il: false).filter { $0.flags.contains(.MODERN_HOLIDAY) }
        #expect(Self.dated(events) == [
            "2022-11-23 Sigd",
            "2023-04-01 Yom HaAliyah",
            "2023-04-18 Yom HaShoah",
            "2023-04-25 Yom HaZikaron",
            "2023-04-26 Yom HaAtzma'ut",
            "2023-05-19 Yom Yerushalayim",
        ])
    }

    @Test func modernFriSatMoveToThu() throws {
        let holidays = getHolidaysForYear(year: 5781, il: true)
        let ev = try #require(holidays.first { $0.desc == "Yitzhak Rabin Memorial Day" })
        #expect(ev.hdate.description == "11 Cheshvan 5781")
    }

    @Test func purimMeshulash() throws {
        let events = getHolidaysForYear(year: 5785, il: false)
        let shushanPurim = try #require(events.first { $0.desc == "Shushan Purim" })
        #expect(shushanPurim.hdate.description == "15 Adar 5785")
        let meshulash = try #require(events.first { $0.desc == "Purim Meshulash" })
        #expect(meshulash.hdate.description == "16 Adar 5785")
    }

    @Test(arguments: [
        (HDate(yy: 5785, mm: .SHVAT, dd: 15), false, ["Tu BiShvat"]),
        (HDate(yy: 5785, mm: .SIVAN, dd: 2), true, []),
        (HDate(yy: 5785, mm: .SIVAN, dd: 1), true, ["Rosh Chodesh Sivan"]),
    ])
    func holidaysOnDate(hdate: HDate, il: Bool, expected: [String]) {
        #expect(getHolidaysOnDate(hdate: hdate, il: il).map(\.desc) == expected)
    }

    @Test func holidaysOnDateFromPrecomputedEvents() {
        let events = getAllHolidaysForYear(year: 5782)
        let hdate = HDate(yy: 5782, mm: .TISHREI, dd: 16)
        #expect(getHolidaysOnDate(events: events, hdate: hdate, il: true).map(\.desc) == ["Sukkot II (CH''M)"])
        #expect(getHolidaysOnDate(events: events, hdate: hdate, il: false).map(\.desc) == ["Sukkot II"])
    }

    @Test func holidaysForYearDiaspora() {
        #expect(Self.dated(getHolidaysForYear(year: 5771, il: false)) == [
            "2010-09-09 Rosh Hashana",
            "2010-09-10 Rosh Hashana II",
            "2010-09-11 Shabbat Shuva",
            "2010-09-12 Tzom Gedaliah",
            "2010-09-17 Erev Yom Kippur",
            "2010-09-18 Yom Kippur",
            "2010-09-22 Erev Sukkot",
            "2010-09-23 Sukkot I",
            "2010-09-24 Sukkot II",
            "2010-09-25 Sukkot III (CH''M)",
            "2010-09-26 Sukkot IV (CH''M)",
            "2010-09-27 Sukkot V (CH''M)",
            "2010-09-28 Sukkot VI (CH''M)",
            "2010-09-29 Sukkot VII (Hoshana Raba)",
            "2010-09-30 Shmini Atzeret",
            "2010-10-01 Simchat Torah",
            "2010-10-08 Rosh Chodesh Cheshvan",
            "2010-10-09 Rosh Chodesh Cheshvan",
            "2010-11-04 Sigd",
            "2010-11-07 Rosh Chodesh Kislev",
            "2010-11-08 Rosh Chodesh Kislev",
            "2010-12-01 Chanukah: 1 Candle",
            "2010-12-02 Chanukah: 2 Candles",
            "2010-12-03 Chanukah: 3 Candles",
            "2010-12-04 Chanukah: 4 Candles",
            "2010-12-05 Chanukah: 5 Candles",
            "2010-12-06 Chanukah: 6 Candles",
            "2010-12-07 Chanukah: 7 Candles",
            "2010-12-07 Rosh Chodesh Tevet",
            "2010-12-08 Chanukah: 8 Candles",
            "2010-12-08 Rosh Chodesh Tevet",
            "2010-12-09 Chanukah: 8th Day",
            "2010-12-17 Asara B'Tevet",
            "2011-01-06 Rosh Chodesh Sh'vat",
            "2011-01-15 Shabbat Shirah",
            "2011-01-20 Tu BiShvat",
            "2011-02-04 Rosh Chodesh Adar I",
            "2011-02-05 Rosh Chodesh Adar I",
            "2011-02-18 Purim Katan",
            "2011-03-05 Shabbat Shekalim",
            "2011-03-06 Rosh Chodesh Adar II",
            "2011-03-07 Rosh Chodesh Adar II",
            "2011-03-17 Ta'anit Esther",
            "2011-03-19 Erev Purim",
            "2011-03-19 Shabbat Zachor",
            "2011-03-20 Purim",
            "2011-03-21 Shushan Purim",
            "2011-03-26 Shabbat Parah",
            "2011-04-02 Shabbat HaChodesh",
            "2011-04-05 Rosh Chodesh Nisan",
            "2011-04-16 Shabbat HaGadol",
            "2011-04-18 Erev Pesach",
            "2011-04-18 Ta'anit Bechorot",
            "2011-04-19 Pesach I",
            "2011-04-20 Pesach II",
            "2011-04-21 Pesach III (CH''M)",
            "2011-04-22 Pesach IV (CH''M)",
            "2011-04-23 Pesach V (CH''M)",
            "2011-04-24 Pesach VI (CH''M)",
            "2011-04-25 Pesach VII",
            "2011-04-26 Pesach VIII",
            "2011-05-02 Yom HaShoah",
            "2011-05-04 Rosh Chodesh Iyyar",
            "2011-05-05 Rosh Chodesh Iyyar",
            "2011-05-09 Yom HaZikaron",
            "2011-05-10 Yom HaAtzma'ut",
            "2011-05-18 Pesach Sheni",
            "2011-05-22 Lag BaOmer",
            "2011-06-01 Yom Yerushalayim",
            "2011-06-03 Rosh Chodesh Sivan",
            "2011-06-07 Erev Shavuot",
            "2011-06-08 Shavuot I",
            "2011-06-09 Shavuot II",
            "2011-07-02 Rosh Chodesh Tamuz",
            "2011-07-03 Rosh Chodesh Tamuz",
            "2011-07-19 Tzom Tammuz",
            "2011-08-01 Rosh Chodesh Av",
            "2011-08-06 Shabbat Chazon",
            "2011-08-08 Erev Tish'a B'Av",
            "2011-08-09 Tish'a B'Av",
            "2011-08-13 Shabbat Nachamu",
            "2011-08-15 Tu B'Av",
            "2011-08-30 Rosh Chodesh Elul",
            "2011-08-31 Rosh Hashana LaBehemot",
            "2011-08-31 Rosh Chodesh Elul",
            "2011-09-24 Leil Selichot",
            "2011-09-28 Erev Rosh Hashana",
        ])
    }

    @Test func holidaysForYearIL() {
        #expect(Self.dated(getHolidaysForYear(year: 5720, il: true)) == [
            "1959-10-03 Rosh Hashana",
            "1959-10-04 Rosh Hashana II",
            "1959-10-05 Tzom Gedaliah",
            "1959-10-10 Shabbat Shuva",
            "1959-10-11 Erev Yom Kippur",
            "1959-10-12 Yom Kippur",
            "1959-10-16 Erev Sukkot",
            "1959-10-17 Sukkot I",
            "1959-10-18 Sukkot II (CH''M)",
            "1959-10-19 Sukkot III (CH''M)",
            "1959-10-20 Sukkot IV (CH''M)",
            "1959-10-21 Sukkot V (CH''M)",
            "1959-10-22 Sukkot VI (CH''M)",
            "1959-10-23 Sukkot VII (Hoshana Raba)",
            "1959-10-24 Shmini Atzeret",
            "1959-11-01 Rosh Chodesh Cheshvan",
            "1959-11-02 Rosh Chodesh Cheshvan",
            "1959-12-01 Rosh Chodesh Kislev",
            "1959-12-02 Rosh Chodesh Kislev",
            "1959-12-25 Chanukah: 1 Candle",
            "1959-12-26 Chanukah: 2 Candles",
            "1959-12-27 Chanukah: 3 Candles",
            "1959-12-28 Chanukah: 4 Candles",
            "1959-12-29 Chanukah: 5 Candles",
            "1959-12-30 Chanukah: 6 Candles",
            "1959-12-31 Chanukah: 7 Candles",
            "1959-12-31 Rosh Chodesh Tevet",
            "1960-01-01 Chanukah: 8 Candles",
            "1960-01-01 Rosh Chodesh Tevet",
            "1960-01-02 Chanukah: 8th Day",
            "1960-01-10 Asara B'Tevet",
            "1960-01-30 Rosh Chodesh Sh'vat",
            "1960-02-13 Tu BiShvat",
            "1960-02-13 Shabbat Shirah",
            "1960-02-27 Shabbat Shekalim",
            "1960-02-28 Rosh Chodesh Adar",
            "1960-02-29 Rosh Chodesh Adar",
            "1960-03-10 Ta'anit Esther",
            "1960-03-12 Erev Purim",
            "1960-03-12 Shabbat Zachor",
            "1960-03-13 Purim",
            "1960-03-14 Shushan Purim",
            "1960-03-19 Shabbat Parah",
            "1960-03-26 Shabbat HaChodesh",
            "1960-03-29 Rosh Chodesh Nisan",
            "1960-04-09 Shabbat HaGadol",
            "1960-04-11 Erev Pesach",
            "1960-04-11 Ta'anit Bechorot",
            "1960-04-12 Pesach I",
            "1960-04-13 Pesach II (CH''M)",
            "1960-04-14 Pesach III (CH''M)",
            "1960-04-15 Pesach IV (CH''M)",
            "1960-04-16 Pesach V (CH''M)",
            "1960-04-17 Pesach VI (CH''M)",
            "1960-04-18 Pesach VII",
            "1960-04-25 Yom HaShoah",
            "1960-04-27 Rosh Chodesh Iyyar",
            "1960-04-28 Rosh Chodesh Iyyar",
            "1960-05-01 Yom HaZikaron",
            "1960-05-02 Yom HaAtzma'ut",
            "1960-05-11 Pesach Sheni",
            "1960-05-15 Lag BaOmer",
            "1960-05-27 Rosh Chodesh Sivan",
            "1960-05-31 Erev Shavuot",
            "1960-06-01 Shavuot",
            "1960-06-25 Rosh Chodesh Tamuz",
            "1960-06-26 Rosh Chodesh Tamuz",
            "1960-07-12 Tzom Tammuz",
            "1960-07-25 Rosh Chodesh Av",
            "1960-07-30 Shabbat Chazon",
            "1960-08-01 Erev Tish'a B'Av",
            "1960-08-02 Tish'a B'Av",
            "1960-08-06 Shabbat Nachamu",
            "1960-08-08 Tu B'Av",
            "1960-08-23 Rosh Chodesh Elul",
            "1960-08-24 Rosh Hashana LaBehemot",
            "1960-08-24 Rosh Chodesh Elul",
            "1960-09-17 Leil Selichot",
            "1960-09-21 Erev Rosh Hashana",
        ])
    }
}
