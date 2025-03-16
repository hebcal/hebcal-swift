    import XCTest
    @testable import Hebcal

    final class HebcalTests: XCTestCase {

        func testelapsedDays() {
            XCTAssertEqual(elapsedDays(year: 5780), 2110760)
            XCTAssertEqual(elapsedDays(year: 5708), 2084447)
            XCTAssertEqual(elapsedDays(year: 3762), 1373677)
            XCTAssertEqual(elapsedDays(year: 3671), 1340455)
            XCTAssertEqual(elapsedDays(year: 1234), 450344)
            XCTAssertEqual(elapsedDays(year: 123), 44563)
            XCTAssertEqual(elapsedDays(year: 2), 356)
            XCTAssertEqual(elapsedDays(year: 1), 1)
        }

        func testisLeapYear() {
            XCTAssertEqual(isLeapYear(year: 5779), true)
            XCTAssertEqual(isLeapYear(year: 5782), true)
            XCTAssertEqual(isLeapYear(year: 5784), true)
            XCTAssertEqual(isLeapYear(year: 5780), false)
            XCTAssertEqual(isLeapYear(year: 5781), false)
            XCTAssertEqual(isLeapYear(year: 5783), false)
            XCTAssertEqual(isLeapYear(year: 5778), false)
            XCTAssertEqual(isLeapYear(year: 5749), true)
            XCTAssertEqual(isLeapYear(year: 5511), false)
            XCTAssertEqual(isLeapYear(year: 5252), true)
            XCTAssertEqual(isLeapYear(year: 4528), true)
            XCTAssertEqual(isLeapYear(year: 4527), false)
        }

        func testdaysInYear() {
            XCTAssertEqual(daysInYear(year: 5779), 385)
            XCTAssertEqual(daysInYear(year: 5780), 355)
            XCTAssertEqual(daysInYear(year: 5781), 353)
            XCTAssertEqual(daysInYear(year: 5782), 384)
            XCTAssertEqual(daysInYear(year: 5783), 355)
            XCTAssertEqual(daysInYear(year: 5784), 383)
            XCTAssertEqual(daysInYear(year: 5785), 355)
            XCTAssertEqual(daysInYear(year: 5786), 354)
            XCTAssertEqual(daysInYear(year: 5787), 385)
            XCTAssertEqual(daysInYear(year: 5788), 355)
            XCTAssertEqual(daysInYear(year: 5789), 354)
            XCTAssertEqual(daysInYear(year: 3762), 383)
            XCTAssertEqual(daysInYear(year: 3671), 354)
            XCTAssertEqual(daysInYear(year: 1234), 353)
            XCTAssertEqual(daysInYear(year: 123), 355)
            XCTAssertEqual(daysInYear(year: 2), 355)
            XCTAssertEqual(daysInYear(year: 1), 355)
        }

        func testdaysInMonth() {
            XCTAssertEqual(daysInMonth(month: .IYYAR, year: 5780), 29)
            XCTAssertEqual(daysInMonth(month: .SIVAN, year: 5780), 30)
            XCTAssertEqual(daysInMonth(month: .CHESHVAN, year: 5782), 29)
            XCTAssertEqual(daysInMonth(month: .CHESHVAN, year: 5783), 30)
            XCTAssertEqual(daysInMonth(month: .KISLEV, year: 5783), 30)
            XCTAssertEqual(daysInMonth(month: .KISLEV, year: 5784), 29)
        }

        func testhebrew2abs() {
            XCTAssertEqual(hebrew2abs(year: 5769, month: .CHESHVAN, day: 15), 733359)
            XCTAssertEqual(hebrew2abs(year: 5708, month: .IYYAR, day: 6), 711262)
            XCTAssertEqual(hebrew2abs(year: 3762, month: .TISHREI, day: 1), 249)
            XCTAssertEqual(hebrew2abs(year: 3761, month: .NISAN, day: 1), 72)
            XCTAssertEqual(hebrew2abs(year: 3761, month: .TEVET, day: 18), 1)
            XCTAssertEqual(hebrew2abs(year: 3761, month: .TEVET, day: 17), 0)
            XCTAssertEqual(hebrew2abs(year: 3761, month: .TEVET, day: 16), -1)
            XCTAssertEqual(hebrew2abs(year: 3761, month: .TEVET, day: 1), -16)
            XCTAssertEqual(hebrew2abs(year: 9999, month: .ELUL, day: 29), 2278650)
        }

        func testabs2hebrew() {
            XCTAssertEqual(HDate(absdate: 733359), HDate(yy: 5769, mm: .CHESHVAN, dd: 15))
            XCTAssertEqual(HDate(absdate: 711262), HDate(yy: 5708, mm: .IYYAR, dd: 6))
            XCTAssertEqual(HDate(absdate: 249), HDate(yy: 3762, mm: .TISHREI, dd: 1))
            XCTAssertEqual(HDate(absdate: 1), HDate(yy: 3761, mm: .TEVET, dd: 18))
            XCTAssertEqual(HDate(absdate: 0), HDate(yy: 3761, mm: .TEVET, dd: 17))
            XCTAssertEqual(HDate(absdate: -16), HDate(yy: 3761, mm: .TEVET, dd: 1))
        }

        func testHDateAbs() {
            XCTAssertEqual(733359, HDate(yy: 5769, mm: .CHESHVAN, dd: 15).abs())
            XCTAssertEqual(711262, HDate(yy: 5708, mm: .IYYAR, dd: 6).abs())
            XCTAssertEqual(249, HDate(yy: 3762, mm: .TISHREI, dd: 1).abs())
            XCTAssertEqual(1, HDate(yy: 3761, mm: .TEVET, dd: 18).abs())
            XCTAssertEqual(0, HDate(yy: 3761, mm: .TEVET, dd: 17).abs())
            XCTAssertEqual(-16, HDate(yy: 3761, mm: .TEVET, dd: 1).abs())
        }

        func testHDateCtor() {
            let date = Date(timeIntervalSince1970: 1307032496)
            let hdate = HDate(yy: 5771, mm: .IYYAR, dd: 29)
            XCTAssertEqual(hdate, HDate(date: date, calendar: .current))
            XCTAssertEqual(hdate, HDate(date: date, calendar: Calendar(identifier: .gregorian)))
            XCTAssertEqual(hdate, HDate(date: date, calendar: Calendar(identifier: .iso8601)))
        }

        func testHDateRender() {
            let hdate = HDate(yy: 5771, mm: .TEVET, dd: 29)
            XCTAssertEqual("29 Tevet 5771", hdate.render(lang: .en))
            XCTAssertEqual("29 Teves 5771", hdate.render(lang: .ashkenazi))
            XCTAssertEqual("כ״ט טבת תשע״א", hdate.render(lang: .he))
        }

        func testlookupTranslation() {
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.en), "Noach")
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.ashkenazi), "Noach")
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.he), "נח")
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.heNikud), "נֹחַ")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.en), "Bechukotai")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.ashkenazi), "Bechukosai")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.he), "בחקתי")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.heNikud), "בְּחֻקֹּתַי")
        }

        func testlookupTranslationApos() {
            XCTAssertEqual(lookupTranslation(str: "Sh'vat", lang: TranslationLang.en), "Sh’vat")
            XCTAssertEqual(lookupTranslation(str: "Sh'vat", lang: TranslationLang.ashkenazi), "Sh’vat")
            XCTAssertEqual(lookupTranslation(str: "Sh'vat", lang: TranslationLang.he), "שבט")

            XCTAssertEqual(lookupTranslation(str: "Ta'anit Bechorot", lang: TranslationLang.en), "Ta’anit Bechorot")
            XCTAssertEqual(lookupTranslation(str: "Ta'anit Bechorot", lang: TranslationLang.ashkenazi), "Ta’anis Bechoros")
            XCTAssertEqual(lookupTranslation(str: "Ta'anit Bechorot", lang: TranslationLang.he), "תענית בכורות")
        }

        func testHebnum() {
            XCTAssertEqual(hebnumToString(number: 5781), "תשפ״א")
            XCTAssertEqual(hebnumToString(number: 2), "ב׳")
            XCTAssertEqual(hebnumToString(number: 14), "י״ד")
            XCTAssertEqual(hebnumToString(number: 15), "ט״ו")
            XCTAssertEqual(hebnumToString(number: 16), "ט״ז")
            XCTAssertEqual(hebnumToString(number: 17), "י״ז")
            XCTAssertEqual(hebnumToString(number: 29), "כ״ט")
        }

        func testAllHolidays() {
            XCTAssertEqual(getAllHolidaysForYear(year: 5783).count, 106)
        }

        func testHolidays() {
            let holidaysDiaspora = getHolidaysForYear(year: 5782, il: false)
            XCTAssertEqual(holidaysDiaspora.count, 87)
            let holidaysIL = getHolidaysForYear(year: 5782, il: true)
            XCTAssertEqual(holidaysIL.count, 90)
            XCTAssertEqual(getHolidaysForYear(year: 5783, il: false).count, 85)
            XCTAssertEqual(getHolidaysForYear(year: 5783, il: true).count, 88)
            XCTAssertEqual(getHolidaysForYear(year: 5784, il: false).count, 86)
            XCTAssertEqual(getHolidaysForYear(year: 5784, il: true).count, 89)
        }

        func testModernHolidaysIL() {
            let holidaysIL = getHolidaysForYear(year: 5783, il: true).filter {
                $0.flags.contains(.MODERN_HOLIDAY)
            }
            var actual = [String]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            for ev in holidaysIL {
                let date = dateFormatter.string(from: ev.hdate.greg())
                actual.append(date + " " + ev.desc)
            }
            let expected = [
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
            ]
            XCTAssertEqual(actual.count, expected.count)
            for i in 0...actual.count-1 {
                XCTAssertEqual(actual[i], expected[i])
            }
        }
        func testModernHolidaysDiaspora() {
            let holidaysDiaspora = getHolidaysForYear(year: 5783, il: false).filter {
                $0.flags.contains(.MODERN_HOLIDAY)
            }
            var actual = [String]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            for ev in holidaysDiaspora {
                let date = dateFormatter.string(from: ev.hdate.greg())
                actual.append(date + " " + ev.desc)
            }
            let expected = [
                "2022-11-23 Sigd",
                "2023-04-01 Yom HaAliyah",
                "2023-04-18 Yom HaShoah",
                "2023-04-25 Yom HaZikaron",
                "2023-04-26 Yom HaAtzma'ut",
                "2023-05-19 Yom Yerushalayim",
            ]
            XCTAssertEqual(actual.count, expected.count)
            for i in 0...actual.count-1 {
                XCTAssertEqual(actual[i], expected[i])
            }
        }

        func testModernFriSatMovetoThu() {
            let holidays = getHolidaysForYear(year: 5781, il: true)
            if let ev = holidays.first(where: { $0.desc == "Yitzhak Rabin Memorial Day" }) {
                XCTAssertEqual(ev.hdate.description, "11 Cheshvan 5781")
            }
        }

        func testHolidaysOnDate() {
            var h = getHolidaysOnDate(hdate: HDate(yy: 5785, mm: .SHVAT, dd: 15), il: false)
            XCTAssertEqual(h.count, 1)
            XCTAssertEqual(h[0].desc, "Tu BiShvat")
            h = getHolidaysOnDate(hdate: HDate(yy: 5785, mm: .SIVAN, dd: 2), il: true)
            XCTAssertEqual(h.count, 0)
            h = getHolidaysOnDate(hdate: HDate(yy: 5785, mm: .SIVAN, dd: 1), il: true)
            XCTAssertEqual(h.count, 1)
            XCTAssertEqual(h[0].desc, "Rosh Chodesh Sivan")
        }

        func testHolidaysOnDate2() {
            let events = getAllHolidaysForYear(year: 5782)
            let hdate = HDate(yy: 5782, mm: .TISHREI, dd: 16)
            let h = getHolidaysOnDate(events: events, hdate: hdate, il: true)
            XCTAssertEqual(h.count, 1)
            XCTAssertEqual(h[0].desc, "Sukkot II (CH''M)")
            let h2 = getHolidaysOnDate(events: events, hdate: hdate, il: false)
            XCTAssertEqual(h2.count, 1)
            XCTAssertEqual(h2[0].desc, "Sukkot II")
        }

        func testGetHolidaysForYearArrayDiaspora() {
            let events = getHolidaysForYear(year: 5771, il: false)
            var actual = [[String]]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            for ev in events {
                let date = dateFormatter.string(from: ev.hdate.greg())
                actual.append([date, ev.desc])
            }
            let expected = [
                ["2010-09-09", "Rosh Hashana"],
                ["2010-09-10", "Rosh Hashana II"],
                ["2010-09-11", "Shabbat Shuva"],
                ["2010-09-12", "Tzom Gedaliah"],
                ["2010-09-17", "Erev Yom Kippur"],
                ["2010-09-18", "Yom Kippur"],
                ["2010-09-22", "Erev Sukkot"],
                ["2010-09-23", "Sukkot I"],
                ["2010-09-24", "Sukkot II"],
                ["2010-09-25", "Sukkot III (CH''M)"],
                ["2010-09-26", "Sukkot IV (CH''M)"],
                ["2010-09-27", "Sukkot V (CH''M)"],
                ["2010-09-28", "Sukkot VI (CH''M)"],
                ["2010-09-29", "Sukkot VII (Hoshana Raba)"],
                ["2010-09-30", "Shmini Atzeret"],
                ["2010-10-01", "Simchat Torah"],
                ["2010-10-08", "Rosh Chodesh Cheshvan"],
                ["2010-10-09", "Rosh Chodesh Cheshvan"],
                ["2010-11-04", "Sigd"],
                ["2010-11-07", "Rosh Chodesh Kislev"],
                ["2010-11-08", "Rosh Chodesh Kislev"],
                ["2010-12-01", "Chanukah: 1 Candle"],
                ["2010-12-02", "Chanukah: 2 Candles"],
                ["2010-12-03", "Chanukah: 3 Candles"],
                ["2010-12-04", "Chanukah: 4 Candles"],
                ["2010-12-05", "Chanukah: 5 Candles"],
                ["2010-12-06", "Chanukah: 6 Candles"],
                ["2010-12-07", "Chanukah: 7 Candles"],
                ["2010-12-07", "Rosh Chodesh Tevet"],
                ["2010-12-08", "Chanukah: 8 Candles"],
                ["2010-12-08", "Rosh Chodesh Tevet"],
                ["2010-12-09", "Chanukah: 8th Day"],
                ["2010-12-17", "Asara B'Tevet"],
                ["2011-01-06", "Rosh Chodesh Sh'vat"],
                ["2011-01-15", "Shabbat Shirah"],
                ["2011-01-20", "Tu BiShvat"],
                ["2011-02-04", "Rosh Chodesh Adar I"],
                ["2011-02-05", "Rosh Chodesh Adar I"],
                ["2011-02-18", "Purim Katan"],
                ["2011-03-05", "Shabbat Shekalim"],
                ["2011-03-06", "Rosh Chodesh Adar II"],
                ["2011-03-07", "Rosh Chodesh Adar II"],
                ["2011-03-17", "Ta'anit Esther"],
                ["2011-03-19", "Erev Purim"],
                ["2011-03-19", "Shabbat Zachor"],
                ["2011-03-20", "Purim"],
                ["2011-03-21", "Shushan Purim"],
                ["2011-03-26", "Shabbat Parah"],
                ["2011-04-02", "Shabbat HaChodesh"],
                ["2011-04-05", "Rosh Chodesh Nisan"],
                ["2011-04-16", "Shabbat HaGadol"],
                ["2011-04-18", "Erev Pesach"],
                ["2011-04-18", "Ta'anit Bechorot"],
                ["2011-04-19", "Pesach I"],
                ["2011-04-20", "Pesach II"],
                ["2011-04-21", "Pesach III (CH''M)"],
                ["2011-04-22", "Pesach IV (CH''M)"],
                ["2011-04-23", "Pesach V (CH''M)"],
                ["2011-04-24", "Pesach VI (CH''M)"],
                ["2011-04-25", "Pesach VII"],
                ["2011-04-26", "Pesach VIII"],
                ["2011-05-02", "Yom HaShoah"],
                ["2011-05-04", "Rosh Chodesh Iyyar"],
                ["2011-05-05", "Rosh Chodesh Iyyar"],
                ["2011-05-09", "Yom HaZikaron"],
                ["2011-05-10", "Yom HaAtzma'ut"],
                ["2011-05-18", "Pesach Sheni"],
                ["2011-05-22", "Lag BaOmer"],
                ["2011-06-01", "Yom Yerushalayim"],
                ["2011-06-03", "Rosh Chodesh Sivan"],
                ["2011-06-07", "Erev Shavuot"],
                ["2011-06-08", "Shavuot I"],
                ["2011-06-09", "Shavuot II"],
                ["2011-07-02", "Rosh Chodesh Tamuz"],
                ["2011-07-03", "Rosh Chodesh Tamuz"],
                ["2011-07-19", "Tzom Tammuz"],
                ["2011-08-01", "Rosh Chodesh Av"],
                ["2011-08-06", "Shabbat Chazon"],
                ["2011-08-08", "Erev Tish'a B'Av"],
                ["2011-08-09", "Tish'a B'Av"],
                ["2011-08-13", "Shabbat Nachamu"],
                ["2011-08-15", "Tu B'Av"],
                ["2011-08-30", "Rosh Chodesh Elul"],
                ["2011-08-31", "Rosh Hashana LaBehemot"],
                ["2011-08-31", "Rosh Chodesh Elul"],
                ["2011-09-24", "Leil Selichot"],
                ["2011-09-28", "Erev Rosh Hashana"],
            ]
            XCTAssertEqual(actual.count, expected.count)
            for i in 0...actual.count-1 {
                XCTAssertEqual(actual[i], expected[i])
            }
        }

        func testGetHolidaysForYearArrayIL() {
            let events = getHolidaysForYear(year: 5720, il: true)
            var actual = [[String]]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            for ev in events {
                let date = dateFormatter.string(from: ev.hdate.greg())
                actual.append([date, ev.desc])
            }
            let expected = [
                ["1959-10-03", "Rosh Hashana"],
                ["1959-10-04", "Rosh Hashana II"],
                ["1959-10-05", "Tzom Gedaliah"],
                ["1959-10-10", "Shabbat Shuva"],
                ["1959-10-11", "Erev Yom Kippur"],
                ["1959-10-12", "Yom Kippur"],
                ["1959-10-16", "Erev Sukkot"],
                ["1959-10-17", "Sukkot I"],
                ["1959-10-18", "Sukkot II (CH''M)"],
                ["1959-10-19", "Sukkot III (CH''M)"],
                ["1959-10-20", "Sukkot IV (CH''M)"],
                ["1959-10-21", "Sukkot V (CH''M)"],
                ["1959-10-22", "Sukkot VI (CH''M)"],
                ["1959-10-23", "Sukkot VII (Hoshana Raba)"],
                ["1959-10-24", "Shmini Atzeret"],
                ["1959-11-01", "Rosh Chodesh Cheshvan"],
                ["1959-11-02", "Rosh Chodesh Cheshvan"],
                ["1959-12-01", "Rosh Chodesh Kislev"],
                ["1959-12-02", "Rosh Chodesh Kislev"],
                ["1959-12-25", "Chanukah: 1 Candle"],
                ["1959-12-26", "Chanukah: 2 Candles"],
                ["1959-12-27", "Chanukah: 3 Candles"],
                ["1959-12-28", "Chanukah: 4 Candles"],
                ["1959-12-29", "Chanukah: 5 Candles"],
                ["1959-12-30", "Chanukah: 6 Candles"],
                ["1959-12-31", "Chanukah: 7 Candles"],
                ["1959-12-31", "Rosh Chodesh Tevet"],
                ["1960-01-01", "Chanukah: 8 Candles"],
                ["1960-01-01", "Rosh Chodesh Tevet"],
                ["1960-01-02", "Chanukah: 8th Day"],
                ["1960-01-10", "Asara B'Tevet"],
                ["1960-01-30", "Rosh Chodesh Sh'vat"],
                ["1960-02-13", "Tu BiShvat"],
                ["1960-02-13", "Shabbat Shirah"],
                ["1960-02-27", "Shabbat Shekalim"],
                ["1960-02-28", "Rosh Chodesh Adar"],
                ["1960-02-29", "Rosh Chodesh Adar"],
                ["1960-03-10", "Ta'anit Esther"],
                ["1960-03-12", "Erev Purim"],
                ["1960-03-12", "Shabbat Zachor"],
                ["1960-03-13", "Purim"],
                ["1960-03-14", "Shushan Purim"],
                ["1960-03-19", "Shabbat Parah"],
                ["1960-03-26", "Shabbat HaChodesh"],
                ["1960-03-29", "Rosh Chodesh Nisan"],
                ["1960-04-09", "Shabbat HaGadol"],
                ["1960-04-11", "Erev Pesach"],
                ["1960-04-11", "Ta'anit Bechorot"],
                ["1960-04-12", "Pesach I"],
                ["1960-04-13", "Pesach II (CH''M)"],
                ["1960-04-14", "Pesach III (CH''M)"],
                ["1960-04-15", "Pesach IV (CH''M)"],
                ["1960-04-16", "Pesach V (CH''M)"],
                ["1960-04-17", "Pesach VI (CH''M)"],
                ["1960-04-18", "Pesach VII"],
                ["1960-04-25", "Yom HaShoah"],
                ["1960-04-27", "Rosh Chodesh Iyyar"],
                ["1960-04-28", "Rosh Chodesh Iyyar"],
                ["1960-05-01", "Yom HaZikaron"],
                ["1960-05-02", "Yom HaAtzma'ut"],
                ["1960-05-11", "Pesach Sheni"],
                ["1960-05-15", "Lag BaOmer"],
                ["1960-05-27", "Rosh Chodesh Sivan"],
                ["1960-05-31", "Erev Shavuot"],
                ["1960-06-01", "Shavuot"],
                ["1960-06-25", "Rosh Chodesh Tamuz"],
                ["1960-06-26", "Rosh Chodesh Tamuz"],
                ["1960-07-12", "Tzom Tammuz"],
                ["1960-07-25", "Rosh Chodesh Av"],
                ["1960-07-30", "Shabbat Chazon"],
                ["1960-08-01", "Erev Tish'a B'Av"],
                ["1960-08-02", "Tish'a B'Av"],
                ["1960-08-06", "Shabbat Nachamu"],
                ["1960-08-08", "Tu B'Av"],
                ["1960-08-23", "Rosh Chodesh Elul"],
                ["1960-08-24", "Rosh Hashana LaBehemot"],
                ["1960-08-24", "Rosh Chodesh Elul"],
                ["1960-09-17", "Leil Selichot"],
                ["1960-09-21", "Erev Rosh Hashana"],
            ]
            XCTAssertEqual(actual.count, expected.count)
            for i in 0...actual.count-1 {
                XCTAssertEqual(actual[i], expected[i])
            }
        }
        func testMishnaYomi() {
            let index = MishnaYomiIndex()
            let calendar = Calendar.current

            let day1 = calendar.date(from: DateComponents(year: 1947, month: 5, day: 20))!
            let my1 = index.lookup(date: day1)
            XCTAssertEqual(my1.0, Mishna(tractate: "Berakhot", chap: 1, verse: 1))
            XCTAssertEqual(my1.1, Mishna(tractate: "Berakhot", chap: 1, verse: 2))
            XCTAssertEqual(formatMishnaYomi(pair: my1), "Berakhot 1:1-2")

            let day7 = calendar.date(from: DateComponents(year: 1947, month: 5, day: 26))!
            let my7 = index.lookup(date: day7)
            XCTAssertEqual(my7.0, Mishna(tractate: "Berakhot", chap: 2, verse: 8))
            XCTAssertEqual(my7.1, Mishna(tractate: "Berakhot", chap: 3, verse: 1))
            XCTAssertEqual(formatMishnaYomi(pair: my7), "Berakhot 2:8-3:1")

            let day10 = calendar.date(from: DateComponents(year: 1947, month: 5, day: 29))!
            let my10 = index.lookup(date: day10)
            XCTAssertEqual(my10.0, Mishna(tractate: "Berakhot", chap: 3, verse: 6))
            XCTAssertEqual(my10.1, Mishna(tractate: "Berakhot", chap: 4, verse: 1))
            XCTAssertEqual(formatMishnaYomi(pair: my10), "Berakhot 3:6-4:1")

            let day2022 = calendar.date(from: DateComponents(year: 2022, month: 8, day: 1))!
            let my2022 = index.lookup(date: day2022)
            XCTAssertEqual(my2022.0, Mishna(tractate: "Terumot", chap: 11, verse: 3))
            XCTAssertEqual(my2022.1, Mishna(tractate: "Terumot", chap: 11, verse: 4))
            XCTAssertEqual(formatMishnaYomi(pair: my2022), "Terumot 11:3-4")

            let day2024 = calendar.date(from: DateComponents(year: 2024, month: 4, day: 5))!
            let my2024 = index.lookup(date: day2024)
            XCTAssertEqual(my2024.0, Mishna(tractate: "Nedarim", chap: 11, verse: 12))
            XCTAssertEqual(my2024.1, Mishna(tractate: "Nazir", chap: 1, verse: 1))
            XCTAssertEqual(formatMishnaYomi(pair: my2024), "Nedarim 11:12-Nazir 1:1")
        }
        func testDafYomi() {
            let calendar = Calendar.current
            let day1 = calendar.date(from: DateComponents(year: 1995, month: 12, day: 17))!
            XCTAssertEqual(try dafYomi(date: day1), Daf(name: "Avodah Zarah", blatt: 68))
            let day2 = calendar.date(from: DateComponents(year: 2020, month: 6, day: 18))!
            XCTAssertEqual(try dafYomi(date: day2), Daf(name: "Shabbat", blatt: 104))
            let day3 = calendar.date(from: DateComponents(year: 2021, month: 3, day: 23))!
            XCTAssertEqual(try dafYomi(date: day3), Daf(name: "Shekalim", blatt: 2))
        }
        func testPurimMeshulash() {
            let events = getHolidaysForYear(year: 5785, il: false)
            if let ev = events.first(where: { $0.desc == "Shushan Purim" }) {
                XCTAssertEqual(ev.hdate.description, "15 Adar 5785")
            } else {
                XCTFail()
            }
            if let ev = events.first(where: { $0.desc == "Purim Meshulash" }) {
                XCTAssertEqual(ev.hdate.description, "16 Adar 5785")
            } else {
                XCTFail()
            }
        }
    }
