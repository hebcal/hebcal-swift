import Testing
@testable import Hebcal

struct TranslationTests {
    @Test(arguments: [
        ("Noach", TranslationLang.en, "Noach"),
        ("Noach", .ashkenazi, "Noach"),
        ("Noach", .he, "נח"),
        ("Noach", .heNikud, "נֹחַ"),
        ("Bechukotai", .en, "Bechukotai"),
        ("Bechukotai", .ashkenazi, "Bechukosai"),
        ("Bechukotai", .he, "בחקתי"),
        ("Bechukotai", .heNikud, "בְּחֻקֹּתַי"),
        ("Rosh Chodesh Sh'vat", .he, "ראש חודש שבט"),
        ("Sunset", .he, "שקיעת החמה"),
        ("Purim Meshulash", .he, "פורים משולש"),
        ("Rosh Chodesh Sh'vat", .he, "ראש חודש שבט"),
        ("Sunset", .he, "שקיעת החמה"),
        ("Purim Meshulash", .heNikud, "פּוּרִים מְשׁוּלָּשׁ"),
        // Apostrophes become typographic in English and Ashkenazi
        ("Sh'vat", .en, "Sh’vat"),
        ("Sh'vat", .ashkenazi, "Sh’vat"),
        ("Sh'vat", .he, "שבט"),
        ("Ta'anit Bechorot", .en, "Ta’anit Bechorot"),
        ("Ta'anit Bechorot", .ashkenazi, "Ta’anis Bechoros"),
        ("Ta'anit Bechorot", .he, "תענית בכורות"),
    ])
    func lookup(str: String, lang: TranslationLang, expected: String) {
        #expect(lookupTranslation(str: str, lang: lang) == expected)
    }

    /// Plain Hebrew (.he) never carries nikud; that's what .heNikud is for.
    @Test func hebrewHolidaysHaveNoNikud() {
        // Points and cantillation marks, U+0591–U+05C7, less the maqaf (־).
        let nikud = Set((0x0591...0x05C7).compactMap(Unicode.Scalar.init)).subtracting(["\u{05BE}"])
        let withNikud = getAllHolidaysForYear(year: 5787)
            .map { lookupTranslation(str: $0.desc, lang: .he) }
            .filter { $0.unicodeScalars.contains(where: nikud.contains) }
        #expect(withNikud.isEmpty, "\(withNikud)")
    }

    @Test(arguments: [
        (TranslationLang.en, "Yom Kippur Katan Sh’vat", "Yom Kippur Katan"),
        (.ashkenazi, "Yom Kippur Katan Sh’vat", "Yom Kippur Katan"),
        (.he, "יום כיפור קטן שבט", "יום כיפור קטן"),
        (.heNikud, "יוֹם כִּפּוּר קָטָן שבט", "יוֹם כִּפּוּר קָטָן"),
    ])
    func yomKippurKatan(lang: TranslationLang, expected: String, brief: String) {
        let ev = HEvent(hdate: HDate(yy: 5771, mm: .SHVAT, dd: 29),
                        desc: "Yom Kippur Katan Sh'vat", flags: [.MINOR_FAST, .YOM_KIPPUR_KATAN])
        #expect(ev.render(lang: lang) == expected)
        #expect(ev.renderBrief(lang: lang) == brief)
    }

    @Test(arguments: [
        (TranslationLang.en, "Rosh Chodesh Sh’vat"),
        (.ashkenazi, "Rosh Chodesh Sh’vat"),
        (.he, "ראש חודש שבט"),
        (.heNikud, "רֹאשׁ חוֹדֶשׁ שבט"),
    ])
    func roshChodesh(lang: TranslationLang, expected: String) {
        let ev = HEvent(hdate: HDate(yy: 5771, mm: .SHVAT, dd: 1),
                        desc: "Rosh Chodesh Sh'vat", flags: .ROSH_CHODESH)
        #expect(ev.render(lang: lang) == expected)
        #expect(ev.renderBrief(lang: lang) == expected)
    }

    @Test(arguments: [
        (TranslationLang.en, "29 Tevet 5771"),
        (.ashkenazi, "29 Teves 5771"),
        (.he, "כ״ט טבת תשע״א"),
    ])
    func render(lang: TranslationLang, expected: String) {
        #expect(HDate(yy: 5771, mm: .TEVET, dd: 29).render(lang: lang) == expected)
    }

    @Test(arguments: [
        (5781, "תשפ״א"),
        (2, "ב׳"),
        (14, "י״ד"),
        (15, "ט״ו"),
        (16, "ט״ז"),
        (17, "י״ז"),
        (29, "כ״ט"),
    ])
    func hebrewNumerals(number: Int, expected: String) {
        #expect(hebnumToString(number: number) == expected)
    }
}
