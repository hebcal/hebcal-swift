//
//  Translations.swift
//  Created by Michael Radwin on 8/23/21.
//

import Foundation

public enum TranslationLang: Int, CaseIterable, Codable {
    case en = 0, ashkenazi = 1, he = 2, heNikud = 3
}

public func lookupTranslation2(str: String) -> String {
    return Bundle.main.localizedString(forKey: str, value: nil, table: nil)
}

public func lookupTranslation(str: String, lang: TranslationLang) -> String {
    switch lang {
    case .en:
        return str
    case .ashkenazi:
        if let msg = ashkenaziTranslations[str] {
            return msg
        } else {
            return str
        }
    case .he:
        if let msg = heTranslations[str] {
            return msg
        } else {
            return str
        }
    case .heNikud:
        if let msg = parshaNikud[str] {
            return msg
        } else {
            if let msg2 = heTranslations[str] {
                return msg2
            } else {
                return str
            }
        }
    }
}

let ashkenaziTranslations = [
    "Shabbat": "Shabbos",
    "Achrei Mot": "Achrei Mos",
    "Bechukotai": "Bechukosai",
    "Beha'alotcha": "Beha'aloscha",
    "Bereshit": "Bereshis",
    "Chukat": "Chukas",
    "Erev Shavuot": "Erev Shavuos",
    "Erev Sukkot": "Erev Sukkos",
    "Ki Tavo": "Ki Savo",
    "Ki Teitzei": "Ki Seitzei",
    "Ki Tisa": "Ki Sisa",
    "Matot": "Matos",
    "Purim Katan": "Purim Koton",
    "Tazria": "Sazria",
    "Tevet": "Teves",
    "Shabbat Chazon": "Shabbos Chazon",
    "Shabbat HaChodesh": "Shabbos HaChodesh",
    "Shabbat HaGadol": "Shabbos HaGadol",
    "Shabbat Nachamu": "Shabbos Nachamu",
    "Shabbat Parah": "Shabbos Parah",
    "Shabbat Shekalim": "Shabbos Shekalim",
    "Shabbat Shuva": "Shabbos Shuvah",
    "Shabbat Zachor": "Shabbos Zachor",
    "Shavuot": "Shavuos",
    "Shavuot I": "Shavuos I",
    "Shavuot II": "Shavuos II",
    "Shemot": "Shemos",
    "Shmini Atzeret": "Shmini Atzeres",
    "Simchat Torah": "Simchas Torah",
    "Sukkot": "Sukkos",
    "Sukkot I": "Sukkos I",
    "Sukkot II": "Sukkos II",
    "Sukkot II (CH''M)": "Sukkos II (CH''M)",
    "Sukkot III (CH''M)": "Sukkos III (CH''M)",
    "Sukkot IV (CH''M)": "Sukkos IV (CH''M)",
    "Sukkot V (CH''M)": "Sukkos V (CH''M)",
    "Sukkot VI (CH''M)": "Sukkos VI (CH''M)",
    "Sukkot VII (Hoshana Raba)": "Sukkos VII (Hoshana Raba)",
    "Ta'anit Bechorot": "Ta'anis Bechoros",
    "Ta'anit Esther": "Ta'anis Esther",
    "Toldot": "Toldos",
    "Vaetchanan": "Vaeschanan",
    "Yitro": "Yisro",
    "Parashat": "Parshas",
    "Leil Selichot": "Leil Selichos",
    "Shabbat Mevarchim Chodesh": "Shabbos Mevorchim Chodesh",
    "Shabbat Shirah": "Shabbos Shirah"
]

let maqaf = "־"

let heTranslations = [
    "Berachot": "ברכות",
    "Eruvin": "עירובין",
    "Pesachim": "פסחים",
    "Shekalim": "שקלים",
    "Yoma": "יומא",
    "Sukkah": "סוכה",
    "Beitzah": "ביצה",
    "Taanit": "תענית",
    "Megillah": "מגילה",
    "Moed Katan": "מועד קטן",
    "Chagigah": "חגיגה",
    "Yevamot": "יבמות",
    "Ketubot": "כתובות",
    "Nedarim": "נדרים",
    "Nazir": "נזיר",
    "Sotah": "סוטה",
    "Gitin": "גיטין",
    "Kiddushin": "קידושין",
    "Baba Kamma": "בבא קמא",
    "Baba Metzia": "בבא מציעא",
    "Baba Batra": "בבא בתרא",
    "Sanhedrin": "סנהדרין",
    "Makkot": "מכות",
    "Shevuot": "שבועות",
    "Avodah Zarah": "עבודה זרה",
    "Horayot": "הוריות",
    "Zevachim": "זבחים",
    "Menachot": "מנחות",
    "Chullin": "חולין",
    "Bechorot": "בכורות",
    "Arachin": "ערכין",
    "Temurah": "תמורה",
    "Keritot": "כריתות",
    "Meilah": "מעילה",
    "Kinnim": "קינים",
    "Tamid": "תמיד",
    "Midot": "מדות",
    "Niddah": "נדה",
    "Shabbat": "שבת",
    "Parashat": "פרשת",
    "-": maqaf,
    "Achrei Mot": "אחרי מות",
    "Balak": "בלק",
    "Bamidbar": "במדבר",
    "Bechukotai": "בחקתי",
    "Beha'alotcha": "בהעלתך",
    "Behar": "בהר",
    "Bereshit": "בראשית",
    "Beshalach": "בשלח",
    "Bo": "בא",
    "Chayei Sara": "חיי שרה",
    "Chukat": "חקת",
    "Devarim": "דברים",
    "Eikev": "עקב",
    "Emor": "אמור",
    "Ha'Azinu": "האזינו",
    "Kedoshim": "קדשים",
    "Ki Tavo": "כי־תבוא",
    "Ki Teitzei": "כי־תצא",
    "Ki Tisa": "כי תשא",
    "Korach": "קורח",
    "Lech-Lecha": "לך־לך",
    "Masei": "מסעי",
    "Matot": "מטות",
    "Metzora": "מצרע",
    "Miketz": "מקץ",
    "Mishpatim": "משפטים",
    "Nasso": "נשא",
    "Nitzavim": "נצבים",
    "Noach": "נח",
    "Pekudei": "פקודי",
    "Pinchas": "פינחס",
    "Re'eh": "ראה",
    "Sh'lach": "שלח־לך",
    "Shemot": "שמות",
    "Shmini": "שמיני",
    "Shoftim": "שופטים",
    "Tazria": "תזריע",
    "Terumah": "תרומה",
    "Tetzaveh": "תצוה",
    "Toldot": "תולדות",
    "Tzav": "צו",
    "Vaera": "וארא",
    "Vaetchanan": "ואתחנן",
    "Vayakhel": "ויקהל",
    "Vayechi": "ויחי",
    "Vayeilech": "וילך",
    "Vayera": "וירא",
    "Vayeshev": "וישב",
    "Vayetzei": "ויצא",
    "Vayigash": "ויגש",
    "Vayikra": "ויקרא",
    "Vayishlach": "וישלח",
    "Vezot Haberakhah": "וזאת הברכה",
    "Yitro": "יתרו",
    "Asara B'Tevet": "עשרה בטבת",
    "Candle lighting": "הדלקת נרות",
    "Chanukah": "חנוכה",
    "Chanukah: 1 Candle": "חנוכה: א׳ נר",
    "Chanukah: 2 Candles": "חנוכה: ב׳ נרות",
    "Chanukah: 3 Candles": "חנוכה: ג׳ נרות",
    "Chanukah: 4 Candles": "חנוכה: ד׳ נרות",
    "Chanukah: 5 Candles": "חנוכה: ה׳ נרות",
    "Chanukah: 6 Candles": "חנוכה: ו׳ נרות",
    "Chanukah: 7 Candles": "חנוכה: ז׳ נרות",
    "Chanukah: 8 Candles": "חנוכה: ח׳ נרות",
    "Chanukah: 8th Day": "חנוכה: יום ח׳",
    "Days of the Omer": "עומר",
    "Omer": "עומר",
    "day of the Omer": "בעומר",
    "Erev Pesach": "ערב פסח",
    "Erev Purim": "ערב פורים",
    "Erev Rosh Hashana": "ערב ראש השנה",
    "Erev Shavuot": "ערב שבועות",
    "Erev Simchat Torah": "ערב שמחת תורה",
    "Erev Sukkot": "ערב סוכות",
    "Erev Tish'a B'Av": "ערב תשעה באב",
    "Erev Yom Kippur": "ערב יום כפור",
    "Havdalah": "הבדלה",
    "Lag BaOmer": "ל״ג בעומר",
    "Leil Selichot": "סליחות",
    "Pesach": "פסח",
    "Pesach I": "פסח א׳",
    "Pesach II": "פסח ב׳",
    "Pesach II (CH''M)": "פסח ב׳ (חוה״מ)",
    "Pesach III (CH''M)": "פסח ג׳ (חוה״מ)",
    "Pesach IV (CH''M)": "פסח ד׳ (חוה״מ)",
    "Pesach Sheni": "פסח שני",
    "Pesach V (CH''M)": "פסח ה׳ (חוה״מ)",
    "Pesach VI (CH''M)": "פסח ו׳ (חוה״מ)",
    "Pesach VII": "פסח ז׳",
    "Pesach VIII": "פסח ח׳",
    "Purim": "פורים",
    "Purim Katan": "פורים קטן",
    "Rosh Chodesh": "ראש חודש",
    "Adar": "אדר",
    "Adar I": "אדר א׳",
    "Adar II": "אדר ב׳",
    "Av": "אב",
    "Cheshvan": "חשון",
    "Elul": "אלול",
    "Iyyar": "אייר",
    "Kislev": "כסלו",
    "Nisan": "ניסן",
    "Sh'vat": "שבט",
    "Sivan": "סיון",
    "Tamuz": "תמוז",
    "Tevet": "טבת",
    "Tishrei": "תשרי",
    "Rosh Hashana": "ראש השנה",
    "Rosh Hashana I": "ראש השנה א׳",
    "Rosh Hashana II": "ראש השנה ב׳",
    "Shabbat Chazon": "שבת חזון",
    "Shabbat HaChodesh": "שבת החדש",
    "Shabbat HaGadol": "שבת הגדול",
    "Shabbat Machar Chodesh": "שבת מחר חודש",
    "Shabbat Nachamu": "שבת נחמו",
    "Shabbat Parah": "שבת פרה",
    "Shabbat Rosh Chodesh": "שבת ראש חודש",
    "Shabbat Shekalim": "שבת שקלים",
    "Shabbat Shuva": "שבת שובה",
    "Shabbat Zachor": "שבת זכור",
    "Shavuot": "שבועות",
    "Shavuot I": "שבועות א׳",
    "Shavuot II": "שבועות ב׳",
    "Shmini Atzeret": "שמיני עצרת",
    "Shushan Purim": "שושן פורים",
    "Sigd": "סיגד",
    "Simchat Torah": "שמחת תורה",
    "Sukkot": "סוכות",
    "Sukkot I": "סוכות א׳",
    "Sukkot II": "סוכות ב׳",
    "Sukkot II (CH''M)": "סוכות ב׳ (חוה״מ)",
    "Sukkot III (CH''M)": "סוכות ג׳ (חוה״מ)",
    "Sukkot IV (CH''M)": "סוכות ד׳ (חוה״מ)",
    "Sukkot V (CH''M)": "סוכות ה׳ (חוה״מ)",
    "Sukkot VI (CH''M)": "סוכות ו׳ (חוה״מ)",
    "Sukkot VII (Hoshana Raba)": "סוכות ז׳ (הושענא רבה)",
    "Ta'anit Bechorot": "תענית בכורות",
    "Ta'anit Esther": "תענית אסתר",
    "Tish'a B'Av": "תשעה באב",
    "Tu B'Av": "טו באב",
    "Tu BiShvat": "טו בשבט",
    "Tu B'Shvat": "טו בשבט",
    "Tzom Gedaliah": "צום גדליה",
    "Tzom Tammuz": "צום תמוז",
    "Yom HaAtzma'ut": "יום העצמאות",
    "Yom HaShoah": "יום השואה",
    "Yom HaZikaron": "יום הזכרון",
    "Yom Kippur": "יום כפור",
    "Yom Yerushalayim": "יום ירושלים",
    "Yom HaAliyah": "יום העלייה",
    "Yom HaAliyah School Observance": "שמירת בית הספר ליום העלייה",
    "Rosh Hashana LaBehemot": "ראש השנה למעשר בהמה",
    "Tish'a B'Av (observed)": "תשעה באב נדחה",
    "Shabbat Mevarchim Chodesh": "שבת מברכים חודש",
    "Shabbat Shirah": "שבת שירה",
    "Family Day": "יוֹם המשפחה",
    "Yitzhak Rabin Memorial Day": "יוֹם הַזִּכָּרוֹן ליצחק רבין",
    "Jabotinsky Day": "יוֹם ז׳בוטינסקי",
    "Herzl Day": "יוֹם הרצל",
    "Ben-Gurion Day": "יוֹם בן־גוריון",
]

let parshaNikud = [
    "Achrei Mot": "אַחֲרֵי מוֹת",
    "Balak": "בָּלָק",
    "Bamidbar": "בְּמִדְבַּר",
    "Bechukotai": "בְּחֻקֹּתַי",
    "Beha'alotcha": "בְּהַעֲלֹתְךָ",
    "Behar": "בְּהַר",
    "Bereshit": "בְּרֵאשִׁית",
    "Beshalach": "בְּשַׁלַּח",
    "Bo": "בֹּא",
    "Chayei Sara": "חַיֵּי שָֹרָה",
    "Chukat": "חֻקַּת",
    "Devarim": "דְּבָרִים",
    "Eikev": "עֵקֶב",
    "Emor": "אֱמוֹר",
    "Ha'Azinu": "הַאֲזִינוּ",
    "Kedoshim": "קְדשִׁים",
    "Ki Tavo": "כִּי־תָבוֹא",
    "Ki Teitzei": "כִּי־תֵצֵא",
    "Ki Tisa": "כִּי תִשָּׂא",
    "Korach": "קוֹרַח",
    "Lech-Lecha": "לֶךְ־לְךָ",
    "Masei": "מַסְעֵי",
    "Matot": "מַּטּוֹת",
    "Metzora": "מְּצֹרָע",
    "Miketz": "מִקֵּץ",
    "Mishpatim": "מִּשְׁפָּטִים",
    "Nasso": "נָשׂא",
    "Nitzavim": "נִצָּבִים",
    "Noach": "נֹחַ",
    "Pekudei": "פְקוּדֵי",
    "Pinchas": "פִּינְחָס",
    "Re'eh": "רְאֵה",
    "Sh'lach": "שְׁלַח־לְךָ",
    "Shemot": "שְׁמוֹת",
    "Shmini": "שְּׁמִינִי",
    "Shoftim": "שׁוֹפְטִים",
    "Tazria": "תַזְרִיעַ",
    "Terumah": "תְּרוּמָה",
    "Tetzaveh": "תְּצַוֶּה",
    "Toldot": "תּוֹלְדוֹת",
    "Tzav": "צַו",
    "Vaera": "וָאֵרָא",
    "Vaetchanan": "וָאֶתְחַנַּן",
    "Vayakhel": "וַיַּקְהֵל",
    "Vayechi": "וַיְחִי",
    "Vayeilech": "וַיֵּלֶךְ",
    "Vayera": "וַיֵּרָא",
    "Vayeshev": "וַיֵּשֶׁב",
    "Vayetzei": "וַיֵּצֵא",
    "Vayigash": "וַיִּגַּשׁ",
    "Vayikra": "וַיִּקְרָא",
    "Vayishlach": "וַיִּשְׁלַח",
    "Vezot Haberakhah": "וְזֹאת הַבְּרָכָה",
    "Yitro": "יִתְרוֹ",
]

extension HDate {
    public func render(lang: TranslationLang?) -> String {
        let language = lang ?? TranslationLang.en
        let monthName = lookupTranslation(str: self.monthName(), lang: language)
        if language == .he {
            return hebnumToString(number: self.dd) + " " +
                monthName + " " +
                hebnumToString(number: self.yy)
        } else {
            return String(self.dd) + " " + monthName + " " + String(self.yy)
        }
    }
}
