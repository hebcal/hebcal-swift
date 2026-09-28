import Foundation
import Testing
@testable import Hebcal

struct OmerTests {
    static let days = Array(1...49)

    /// The Omer event for `omerDay` in 5785, starting 16 Nisan.
    static func event(_ omerDay: Int) -> OmerEvent {
        let first = HDate(yy: 5785, mm: .NISAN, dd: 16)
        return OmerEvent(hdate: HDate(absdate: first.abs() + Int64(omerDay - 1)), omerDay: omerDay)
    }

    @Test(arguments: days)
    func render(day: Int) {
        let ev = Self.event(day)
        let i = day - 1
        #expect(ev.render(lang: .en) == OmerFixtures.en[i])
        #expect(ev.render(lang: .ashkenazi) == OmerFixtures.en[i])
        #expect(ev.render(lang: nil) == OmerFixtures.en[i])
        #expect(ev.render(lang: .heNikud) == OmerFixtures.he[i])
        #expect(ev.render(lang: .he) == OmerFixtures.heNoNikud[i])
        #expect(ev.renderBrief(lang: .en) == OmerFixtures.brief[i])
        #expect(ev.renderBrief(lang: .heNikud) == OmerFixtures.briefHe[i])
        #expect(ev.renderBrief(lang: .he) == OmerFixtures.briefHeNN[i])
    }

    @Test(arguments: days)
    func sefira(day: Int) {
        let ev = Self.event(day)
        let i = day - 1
        #expect(ev.sefira() == OmerFixtures.sefEn[i])
        #expect(ev.sefira(lang: .en) == OmerFixtures.sefEn[i])
        #expect(ev.sefira(lang: .he) == OmerFixtures.sefHe[i])
        #expect(ev.sefira(lang: .translit) == OmerFixtures.sefTr[i])
    }

    @Test(arguments: days)
    func todayIs(day: Int) {
        let ev = Self.event(day)
        let i = day - 1
        #expect(ev.getTodayIs(lang: .en) == OmerFixtures.todayEn[i])
        #expect(ev.getTodayIs(lang: .ashkenazi) == OmerFixtures.todayEn[i])
        #expect(ev.getTodayIs(lang: .heNikud) == OmerFixtures.todayHe[i])
        #expect(ev.getTodayIs(lang: .he) == OmerFixtures.todayHeNN[i])
    }

    /// Compares Unicode scalars, not just canonical equivalence, so the output
    /// matches @hebcal/core byte for byte.
    @Test(arguments: days)
    func hebrewScalarsMatch(day: Int) {
        let ev = Self.event(day)
        let i = day - 1
        #expect(Array(ev.getTodayIs(lang: .heNikud).unicodeScalars) == Array(OmerFixtures.todayHe[i].unicodeScalars))
        #expect(Array(ev.sefira(lang: .he).unicodeScalars) == Array(OmerFixtures.sefHe[i].unicodeScalars))
        #expect(Array(ev.getAnaBekoachWord().unicodeScalars) == Array(OmerFixtures.ana[i].unicodeScalars))
    }

    @Test(arguments: days)
    func weeksEmojiAndWords(day: Int) {
        let ev = Self.event(day)
        let i = day - 1
        #expect(ev.getWeeks() == OmerFixtures.weeks[i])
        #expect(ev.getDaysWithinWeeks() == OmerFixtures.daysWithinWeeks[i])
        #expect(ev.getEmoji() == OmerFixtures.emoji[i])
        #expect(ev.getLamnatzeachWord() == OmerFixtures.word[i])
        #expect(ev.getLamnatzeachLetter() == OmerFixtures.letter[i])
        #expect(ev.getAnaBekoachWord() == OmerFixtures.ana[i])
        #expect(ev.url() == URL(string: "https://www.hebcal.com/omer/5785/\(day)"))
    }

    @Test func examples() {
        let ev = OmerEvent(hdate: HDate(yy: 5784, mm: .NISAN, dd: 16), omerDay: 1)
        #expect(ev.render(lang: .en) == "1st day of the Omer")
        #expect(ev.render(lang: .heNikud) == "א׳ בָּעוֹמֶר")
        #expect(ev.sefira(lang: .translit) == "Chesed sheb'Chesed")
        #expect(ev.getTodayIs(lang: .en) == "Today is 1 day of the Omer")
        #expect(ev.desc == "Omer 1")
        #expect(ev.flags == .OMER_COUNT)

        let day8 = OmerEvent(hdate: HDate(yy: 5784, mm: .NISAN, dd: 23), omerDay: 8)
        #expect(day8.sefira(lang: .en) == "Lovingkindness within Might")
        #expect(day8.sefira(lang: .he) == "חֶֽסֶד שֶׁבִּגְבוּרָה")
        #expect(day8.sefira(lang: .translit) == "Chesed shebiGevurah")

        let day10 = OmerEvent(hdate: HDate(yy: 5784, mm: .NISAN, dd: 25), omerDay: 10)
        #expect(day10.getTodayIs(lang: .en) == "Today is 10 days, which are 1 week and 3 days of the Omer")
        #expect(day10.getTodayIs(lang: .heNikud) == "הַיּוֹם עֲשָׂרָה יָמִים, שֶׁהֵם שָׁבֽוּעַ אֶחָד וּשְׁלוֹשָׁה יָמִים לָעֽוֹמֶר")
    }

    @Test func toHEvent() {
        let hev = Self.event(37).toHEvent()
        #expect(hev.desc == "Omer 37")
        #expect(hev.flags == .OMER_COUNT)
        #expect(hev.emoji == "㊲")
        #expect(hev.hdate == HDate(yy: 5785, mm: .IYYAR, dd: 22))
    }

    @Test func initFromHDate() {
        #expect(OmerEvent(hdate: HDate(yy: 5784, mm: .NISAN, dd: 15)) == nil)
        #expect(OmerEvent(hdate: HDate(yy: 5784, mm: .NISAN, dd: 16))?.omer == 1)
        #expect(OmerEvent(hdate: HDate(yy: 5784, mm: .IYYAR, dd: 18))?.omer == 33)
        #expect(OmerEvent(hdate: HDate(yy: 5784, mm: .SIVAN, dd: 5))?.omer == 49)
        #expect(OmerEvent(hdate: HDate(yy: 5784, mm: .SIVAN, dd: 6)) == nil)
        #expect(OmerEvent(hdate: HDate(yy: 5784, mm: .TISHREI, dd: 1)) == nil)
    }

    @Test(arguments: [0, 50, -1])
    func validatingOmerDay(day: Int) {
        let hdate = HDate(yy: 5785, mm: .NISAN, dd: 16)
        #expect(throws: OmerError.dayOutOfRange) {
            try OmerEvent(hdate: hdate, validatingOmerDay: day)
        }
    }

    @Test func urlOutOfRange() {
        #expect(OmerEvent(hdate: HDate(yy: 4999, mm: .NISAN, dd: 16), omerDay: 1).url() == nil)
        #expect(OmerEvent(hdate: HDate(yy: 6760, mm: .NISAN, dd: 16), omerDay: 1).url() == nil)
        #expect(OmerEvent(hdate: HDate(yy: 6759, mm: .NISAN, dd: 16), omerDay: 1).url() != nil)
    }
}
