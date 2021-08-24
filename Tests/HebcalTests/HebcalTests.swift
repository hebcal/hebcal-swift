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
    }
