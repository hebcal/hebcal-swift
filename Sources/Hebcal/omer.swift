//
//  omer.swift
//  Ported from OmerEvent in @hebcal/core (src/omer.ts).
//

import Foundation

/// Language for ``OmerEvent/sefira(lang:)``: English, Hebrew with nikud, or
/// Hebrew in Sephardic transliteration.
public enum OmerLang: String, CaseIterable, Codable, Sendable {
    case en, he, translit
}

public enum OmerError: Error, Equatable, Sendable {
    /// The day of the Omer is not between 1 and 49.
    case dayOutOfRange
}

private struct SefirotConfig {
    let infix: String
    let infix26: String
    let words: [String]
    /// Hebrew week names with the שֶׁבְּ prefix already attached, or nil to use `infix`.
    let pfxWords: [String]?
}

private let sefirot: [OmerLang: SefirotConfig] = [
    .en: SefirotConfig(
        infix: "within ",
        infix26: "within ",
        words: ["", "Lovingkindness", "Might", "Beauty", "Eternity", "Splendor", "Foundation", "Majesty"],
        pfxWords: nil),
    .he: SefirotConfig(
        infix: "",
        infix26: "",
        words: ["", "חֶֽסֶד", "גְּבוּרָה", "תִּפְאֶֽרֶת", "נֶּֽצַח", "הוֹד", "יְּסוֹד", "מַלְכוּת"],
        pfxWords: ["", "שֶׁבְּחֶֽסֶד", "שֶׁבִּגְבוּרָה", "שֶׁבְּתִפְאֶֽרֶת", "שֶׁבְּנֶֽצַח", "שֶׁבְּהוֹד", "שֶׁבִּיְסוֹד", "שֶׁבְּמַלְכוּת"]),
    .translit: SefirotConfig(
        infix: "sheb'",
        infix26: "shebi",
        words: ["", "Chesed", "Gevurah", "Tiferet", "Netzach", "Hod", "Yesod", "Malkhut"],
        pfxWords: nil),
]

/// Returns (week number 1–7, day within week 1–7).
private func weeksAndDays(_ omerDay: Int) -> (weekNum: Int, daysWithinWeeks: Int) {
    let weekNum = (omerDay - 1) / 7 + 1
    let rem = omerDay % 7
    return (weekNum, rem == 0 ? 7 : rem)
}

/// Unicode NFC, like JavaScript's `String.prototype.normalize()`.
private func normalize(_ str: String) -> String {
    return str.precomposedStringWithCanonicalMapping
}

/// Removes niqqud and trope, like `Locale.hebrewStripNikkud` in @hebcal/hdate.
func hebrewStripNikkud(_ str: String) -> String {
    let scalars = normalize(str).unicodeScalars.filter { scalar in
        let v = scalar.value
        return !((0x0590...0x05BD).contains(v) || (0x05BF...0x05C7).contains(v))
    }
    return String(String.UnicodeScalarView(scalars))
}

private func enOrdinal(_ n: Int) -> String {
    let suffixes = ["th", "st", "nd", "rd"]
    let v = n % 100
    let idx = (v - 20) % 10
    if idx >= 1 && idx <= 3 {
        return "\(n)\(suffixes[idx])"
    }
    if v >= 1 && v <= 3 {
        return "\(n)\(suffixes[v])"
    }
    return "\(n)th"
}

private func omerTodayIsEn(_ omerDay: Int) -> String {
    let (weekNumber, daysWithinWeeks) = weeksAndDays(omerDay)
    let totalDaysStr = omerDay == 1 ? "day" : "days"
    var str = "Today is \(omerDay) \(totalDaysStr)"
    if weekNumber > 1 || omerDay == 7 {
        let day7 = daysWithinWeeks == 7
        let numWeeks = day7 ? weekNumber : weekNumber - 1
        let weeksStr = numWeeks == 1 ? "week" : "weeks"
        str += ", which are \(numWeeks) \(weeksStr)"
        if !day7 {
            let daysStr = daysWithinWeeks == 1 ? "day" : "days"
            str += " and \(daysWithinWeeks) \(daysStr)"
        }
    }
    return str + " of the Omer"
}

// adapted from pip hdate package (GPL)
// https://github.com/py-libhdate/py-libhdate/blob/master/hdate/date.py

private let tens = ["", "עֲשָׂרָה", "עֶשְׂרִים", "שְׁלוֹשִׁים", "אַרְבָּעִים"]
private let ones = [
    "",
    "אֶחָד",
    "שְׁנַיִם",
    "שְׁלוֹשָׁה",
    "אַרְבָּעָה",
    "חֲמִשָּׁה",
    "שִׁשָּׁה",
    "שִׁבְעָה",
    "שְׁמוֹנָה",
    "תִּשְׁעָה",
]

private let shnei = "שְׁנֵי"
private let yamim = "יָמִים"
private let shneiYamim = shnei + " " + yamim
private let shavuot = "שָׁבוּעוֹת"
private let yom = "יוֹם"
private let yomEchad = yom + " " + ones[1]
private let asar = "עָשָׂר"

private func omerTodayIsHe(_ omerDay: Int) -> String {
    let ten = omerDay / 10
    let one = omerDay % 10
    var str = "הַיּוֹם "
    if omerDay == 11 {
        str += "אַחַד " + asar
    } else if omerDay == 12 {
        str += "שְׁנֵים " + asar
    } else if 12 < omerDay && omerDay < 20 {
        str += ones[one] + " " + asar
    } else if omerDay > 9 {
        str += ones[one]
        if one != 0 {
            str += " "
            str += ten == 3 ? "וּ" : "וְ"
        }
    }
    if omerDay > 2 {
        if omerDay > 20 || omerDay == 10 || omerDay == 20 {
            str += tens[ten]
        }
        if omerDay < 11 {
            str += ones[one] + " " + yamim + " "
        } else {
            str += " " + yom + " "
        }
    } else if omerDay == 1 {
        str += yomEchad + " "
    } else {
        // omer == 2
        str += shneiYamim + " "
    }
    if omerDay > 6 {
        str = str.trimmingCharacters(in: .whitespaces) // remove trailing space before comma
        str += ", שֶׁהֵם "
        let weeks = omerDay / 7
        let days = omerDay % 7
        if weeks > 2 {
            str += ones[weeks] + " " + shavuot + " "
        } else if weeks == 1 {
            str += "שָׁבֽוּעַ" + " " + ones[1] + " "
        } else {
            // weeks == 2
            str += shnei + " " + shavuot + " "
        }
        if days != 0 {
            if days == 2 || days == 3 {
                str += "וּ"
            } else if days == 5 {
                str += "וַ"
            } else {
                str += "וְ"
            }
            if days > 2 {
                str += ones[days] + " " + yamim + " "
            } else if days == 1 {
                str += yomEchad + " "
            } else {
                // days == 2
                str += shneiYamim + " "
            }
        }
    }
    str += "לָעֽוֹמֶר"
    return normalize(str)
}

// From sefira.json in @hebcal/core

private let anaBekoach = [
    "אָנָּא", "בְּכֹחַ", "גְּדֻלַּת", "יְמִינְךָ", "תַּתִּיר", "צְרוּרָה", "אב״ג ית״ץ",
    "קַבֵּל", "רִנַּת", "עַמְּךָ", "שַׂגְּבֵנוּ", "טַהֲרֵנוּ", "נוֹרָא", "קר״ע שט״ן",
    "נָא", "גִבּוֹר", "דּוֹרְשֵׁי", "יִחוּדְךָ", "כְּבָבַת", "שָׁמְרֵם", "נג״ד יכ״ש",
    "בָּרְכֵם", "טַהֲרֵם", "רַחֲמֵי", "צִדְקָתְךָ", "תָּמִיד", "גָּמְלֵם", "בט״ר צת״ג",
    "חֲסִין", "קָדוֹשׁ", "בְּרֹב", "טוּבְךָ", "נַהֵל", "עֲדָתֶךָ", "חק״ב תנ״ע",
    "יָחִיד", "גֵּאֶה", "לְעַמְּךָ", "פְּנֵה", "זוֹכְרֵי", "קְדֻשָּׁתֶךָ", "יג״ל פז״ק",
    "שַׁוְעָתֵנוּ", "קַבֵּל", "וּשְׁמַע", "צַעֲקָתֵנוּ", "יוֹדֵעַ", "תַּעֲלוּמוֹת", "שק״ו צי״ת",
].map(normalize)

/// Psalm 67, verses 2–8.
private let ps67lines = [
    "אֱלֹהִים יְחָנֵּנוּ וִיבָרְכֵנוּ יָאֵר־פָּנָיו אִתָּנוּ סֶלָה",
    "לָדַעַת בָּאָרֶץ דַּרְכֶּךָ בְּכָל־גּוֹיִם יְשׁוּעָתֶךָ",
    "יוֹדוּךָ עַמִּים אֱלֹהִים יוֹדוּךָ עַמִּים כֻּלָּם",
    "יִשְׂמְחוּ וִירַנְּנוּ לְאֻמִּים כִּי־תִשְׁפֹּט עַמִּים מִישׁוֹר וּלְאֻמִּים בָּאָרֶץ תַּנחֵם סֶלָה",
    "יוֹדוּךָ עַמִּים אֱלֹהִים יוֹדוּךָ עַמִּים כֻּלָּם",
    "אֶרֶץ נָתְנָה יְבוּלָהּ יְבָרְכֵנוּ אֱלֹהִים אֱלֹהֵינוּ",
    "יְבָרְכֵנוּ אֱלֹהִים וְיִירְאוּ אוֹתוֹ כָּל־אַפְסֵי־אָרֶץ",
]

/// The 49 words of Psalm 67:2–8, split on spaces and maqaf (־).
private let lamnatzeach: [String] = ps67lines.flatMap { line in
    line.split(whereSeparator: { $0 == " " || $0 == "־" }).map(String.init)
}

/// The 49 letters of Psalm 67:5.
private let lamnatzeachLetters: [String] =
    "ישמחווירננולאמיםכיתשפוטעמיםמישורולאמיםבארץתנחםסלה".map(String.init)

/// One of the 49 days of counting the Omer between Pesach and Shavuot
/// (16 Nisan through 5 Sivan).
///
/// Each day has an associated Sefirah pairing (e.g. *Chesed shebiGevurah*),
/// a word from Psalm 67 (Lamnatzeach), a letter from verse 5 of Psalm 67,
/// and a word/acrostic from the Ana BeKoach prayer.
///
/// ```swift
/// let ev = OmerEvent(hdate: HDate(yy: 5784, mm: .NISAN, dd: 16), omerDay: 1)
/// ev.render(lang: .en)          // "1st day of the Omer"
/// ev.render(lang: .heNikud)     // "א׳ בָּעוֹמֶר"
/// ev.sefira(lang: .translit)    // "Chesed sheb'Chesed"
/// ev.getTodayIs(lang: .en)      // "Today is 1 day of the Omer"
/// ```
public struct OmerEvent: Hashable, Sendable {
    /// Hebrew date this Omer day is counted on (the evening of).
    public let hdate: HDate
    /// Day of the Omer, 1 through 49.
    public let omer: Int
    private let weekNumber: Int
    private let daysWithinWeeks: Int

    /// Creates an Omer event for a given day (1–49).
    ///
    /// - Precondition: `omerDay` is between 1 and 49. Use
    ///   ``init(hdate:validatingOmerDay:)`` to get an error instead.
    public init(hdate: HDate, omerDay: Int) {
        precondition((1...49).contains(omerDay), "Invalid Omer day \(omerDay)")
        self.hdate = hdate
        self.omer = omerDay
        (self.weekNumber, self.daysWithinWeeks) = weeksAndDays(omerDay)
    }

    /// Creates an Omer event, throwing ``OmerError/dayOutOfRange`` if `omerDay`
    /// is not between 1 and 49.
    public init(hdate: HDate, validatingOmerDay omerDay: Int) throws {
        guard (1...49).contains(omerDay) else {
            throw OmerError.dayOutOfRange
        }
        self.init(hdate: hdate, omerDay: omerDay)
    }

    /// The Omer event for `hdate`, or nil if it is not between 16 Nisan and 5 Sivan.
    public init?(hdate: HDate) {
        let omerDay = Int(hdate.abs() - hebrew2abs(year: hdate.yy, month: .NISAN, day: 15))
        guard (1...49).contains(omerDay) else {
            return nil
        }
        self.init(hdate: hdate, omerDay: omerDay)
    }

    /// Untranslated description, e.g. "Omer 22".
    public var desc: String { "Omer \(omer)" }

    public var flags: HolidayFlags { .OMER_COUNT }

    /// This event as an ``HEvent``, for merging with holiday lists.
    public func toHEvent() -> HEvent {
        return HEvent(hdate: hdate, desc: desc, flags: flags, emoji: getEmoji())
    }

    /// The Sefirah pairing associated with this Omer day — one of the seven
    /// lower Sefirot within another, calculated as `day-within-week` of
    /// `week-within-cycle`. For example, on day 8 (week 2, day 1):
    ///  * חֶֽסֶד שֶׁבִּגְבוּרָה
    ///  * Chesed shebiGevurah
    ///  * Lovingkindness within Might
    public func sefira(lang: OmerLang = .en) -> String {
        let config = sefirot[lang]!
        let week = config.pfxWords?[weekNumber] ?? config.words[weekNumber]
        let dayWithinWeek = config.words[daysWithinWeeks]
        let infix = config.pfxWords != nil ? ""
            : (weekNumber == 2 || weekNumber == 6) ? config.infix26 : config.infix
        return normalize(dayWithinWeek + " " + infix + week)
    }

    /// e.g. "22nd day of the Omer", or "כ״ב בעומר" for `.he`.
    public func render(lang: TranslationLang?) -> String {
        switch lang ?? .en {
        case .en, .ashkenazi:
            return enOrdinal(omer) + " day of the Omer"
        case .he:
            return hebnumToString(number: omer) + " בעומר"
        case .heNikud:
            return hebnumToString(number: omer) + " בָּעוֹמֶר"
        }
    }

    /// e.g. "Omer day 22", without an ordinal number.
    public func renderBrief(lang: TranslationLang?) -> String {
        switch lang ?? .en {
        case .en, .ashkenazi:
            return "Omer day \(omer)"
        case .he:
            return "עומר יום \(omer)"
        case .heNikud:
            return "עוֹמֶר יוֹם \(omer)"
        }
    }

    /// A circled number from the Unicode “Enclosed Alphanumerics” and
    /// “Enclosed CJK Letters and Months” blocks, `①` through `㊾`.
    public func getEmoji() -> String {
        let codePoint: Int
        if omer <= 20 {
            codePoint = 9312 + omer - 1
        } else if omer <= 35 {
            // between 21 and 35 inclusive
            codePoint = 12881 + omer - 21
        } else {
            // between 36 and 49 inclusive
            codePoint = 12977 + omer - 36
        }
        return String(Character(Unicode.Scalar(codePoint)!))
    }

    /// Number of *completed* weeks of the Omer. On day 7 this returns `1`; on
    /// day 8 it also returns `1`, because the second week is still in progress.
    /// Pair with ``getDaysWithinWeeks()`` to render "N weeks and M days".
    public func getWeeks() -> Int {
        return daysWithinWeeks == 7 ? weekNumber : weekNumber - 1
    }

    /// Day within the current week, from `1` through `7`.
    public func getDaysWithinWeeks() -> Int {
        return daysWithinWeeks
    }

    /// A sentence with that evening's omer count, e.g. for day 10
    /// "Today is 10 days, which are 1 week and 3 days of the Omer", or
    /// "הַיּוֹם עֲשָׂרָה יָמִים, שֶׁהֵם שָׁבֽוּעַ אֶחָד וּשְׁלוֹשָׁה יָמִים לָעֽוֹמֶר" for `.heNikud`.
    /// `.he` gives the Hebrew without nikud.
    public func getTodayIs(lang: TranslationLang?) -> String {
        switch lang ?? .en {
        case .en, .ashkenazi:
            return omerTodayIsEn(omer)
        case .he:
            return hebrewStripNikkud(omerTodayIsHe(omer))
        case .heNikud:
            return omerTodayIsHe(omer)
        }
    }

    /// Link to this day's page on hebcal.com, or nil for years outside 5000–6759.
    public func url() -> URL? {
        let year = hdate.yy
        if year < 5000 || year > 6759 {
            return nil
        }
        return URL(string: "https://www.hebcal.com/omer/\(year)/\(omer)")
    }

    /// The word from Psalm 67 (לַמְנַצֵּחַ, "Lamnatzeach") for this Omer day.
    /// Psalm 67 contains 49 words (excluding its opening verse), one for each
    /// day of the Omer. The words are taken from verses 2–8, split on spaces
    /// and maqaf (־). Day 1 is אֱלֹהִים and day 49 is אָרֶץ.
    public func getLamnatzeachWord() -> String {
        return lamnatzeach[omer - 1]
    }

    /// The letter from verse 5 of Psalm 67 for this Omer day. Verse 5
    /// (יִשְׂמְחוּ וִירַנְּנוּ לְאֻמִּים…) contains exactly 49 letters, one for
    /// each day of the Omer, and is used as a Kabbalistic meditation during the
    /// counting. Day 1 is י and day 49 is ה.
    public func getLamnatzeachLetter() -> String {
        return lamnatzeachLetters[omer - 1]
    }

    /// The word from the Ana BeKoach prayer (אָנָּא בְּכֹחַ) for this Omer day.
    /// Ana BeKoach is a 42-word Kabbalistic prayer whose initial letters spell
    /// out the 42-letter name of God. The prayer has 7 verses of 6 words each;
    /// the 7th entry of each group is the abbreviation of the acrostic letters
    /// for that verse (e.g. `אב״ג ית״ץ` for verse 1). Together the 49 entries
    /// align with the 49 days of the Omer. Day 1 is אָנָּא and day 49 is
    /// `שק״ו צי״ת`.
    public func getAnaBekoachWord() -> String {
        return anaBekoach[omer - 1]
    }
}
