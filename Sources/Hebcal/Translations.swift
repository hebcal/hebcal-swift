//
//  Translations.swift
//  Created by Michael Radwin on 8/23/21.
//

import Foundation

public enum TranslationLang: Int, CaseIterable, Codable {
    case en = 0, ashkenazi = 1, he = 2
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
]
