    import XCTest
    @testable import Hebcal

    final class HebcalTests: XCTestCase {
        func testlookupTranslation() {
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.en), "Noach")
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.ashkenazi), "Noach")
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.he), "נֹחַ")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.en), "Bechukotai")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.ashkenazi), "Bechukosai")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.he), "בְּחֻקֹּתַי")
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

        func testHolidays() {
            let holidaysDiaspora = getHolidaysForYear(year: 5782, il: false)
            XCTAssertEqual(holidaysDiaspora.count, 87)
            let holidaysIL = getHolidaysForYear(year: 5782, il: true)
            XCTAssertEqual(holidaysIL.count, 84)
            XCTAssertEqual(getHolidaysForYear(year: 5783, il: false).count, 85)
            XCTAssertEqual(getHolidaysForYear(year: 5783, il: true).count, 82)
            XCTAssertEqual(getHolidaysForYear(year: 5784, il: false).count, 86)
            XCTAssertEqual(getHolidaysForYear(year: 5784, il: true).count, 83)
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
                ["2010-11-06", "Sigd"],
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
    }
