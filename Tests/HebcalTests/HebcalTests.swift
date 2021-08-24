    import XCTest
    @testable import Hebcal

    final class HebcalTests: XCTestCase {
        func testExample() {
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.en), "Noach")
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.ashkenazi), "Noach")
            XCTAssertEqual(lookupTranslation(str: "Noach", lang: TranslationLang.he), "נֹחַ")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.en), "Bechukotai")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.ashkenazi), "Bechukosai")
            XCTAssertEqual(lookupTranslation(str: "Bechukotai", lang: TranslationLang.he), "בְּחֻקֹּתַי")
        }
    }
