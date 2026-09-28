import Foundation
import Testing
@testable import Hebcal

struct LearningScheduleTests {
    static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
    }

    @Test(arguments: [
        (date(1995, 12, 17), Daf(name: "Avodah Zarah", blatt: 68)),
        (date(2020, 6, 18), Daf(name: "Shabbat", blatt: 104)),
        (date(2021, 3, 23), Daf(name: "Shekalim", blatt: 2)),
    ])
    func dafYomi(date: Date, expected: Daf) throws {
        #expect(try Hebcal.dafYomi(date: date) == expected)
    }

    @Test func dafYomiBeforeFirstCycle() {
        #expect(throws: DafYomiError.beforeCycleBegan) {
            try Hebcal.dafYomi(date: Self.date(1923, 9, 10))
        }
    }

    @Test(arguments: [
        (date(1947, 5, 20), Mishna(tractate: "Berakhot", chap: 1, verse: 1),
         Mishna(tractate: "Berakhot", chap: 1, verse: 2), "Berakhot 1:1-2"),
        (date(1947, 5, 26), Mishna(tractate: "Berakhot", chap: 2, verse: 8),
         Mishna(tractate: "Berakhot", chap: 3, verse: 1), "Berakhot 2:8-3:1"),
        (date(1947, 5, 29), Mishna(tractate: "Berakhot", chap: 3, verse: 6),
         Mishna(tractate: "Berakhot", chap: 4, verse: 1), "Berakhot 3:6-4:1"),
        (date(2022, 8, 1), Mishna(tractate: "Terumot", chap: 11, verse: 3),
         Mishna(tractate: "Terumot", chap: 11, verse: 4), "Terumot 11:3-4"),
        (date(2024, 4, 5), Mishna(tractate: "Nedarim", chap: 11, verse: 12),
         Mishna(tractate: "Nazir", chap: 1, verse: 1), "Nedarim 11:12-Nazir 1:1"),
    ])
    func mishnaYomi(date: Date, first: Mishna, second: Mishna, formatted: String) {
        let pair = MishnaYomiIndex().lookup(date: date)
        #expect(pair.0 == first)
        #expect(pair.1 == second)
        #expect(formatMishnaYomi(pair: pair) == formatted)
    }
}
