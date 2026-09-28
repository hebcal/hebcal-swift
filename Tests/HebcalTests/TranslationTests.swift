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
