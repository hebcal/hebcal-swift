//
//  Created by Michael J. Radwin on 8/3/22.
//

import Foundation

/// Start of the first Daf Yomi cycle, 11 September 1923.
private let osday = greg2abs(year: 1923, month: 9, day: 11)
/// Start of the 8th cycle, 24 June 1975, after which Shekalim has 22 dapim instead of 13.
private let nsday = greg2abs(year: 1975, month: 6, day: 24)

public struct Daf: Equatable, Sendable {
    public let name: String
    public let blatt: Int
    public init(name: String, blatt: Int) {
        self.name = name
        self.blatt = blatt
    }
}

private let shas: [Daf] = [
    Daf(name: "Berachot", blatt: 64),
    Daf(name: "Shabbat", blatt: 157),
    Daf(name: "Eruvin", blatt: 105),
    Daf(name: "Pesachim", blatt: 121),
    Daf(name: "Shekalim", blatt: 22),
    Daf(name: "Yoma", blatt: 88),
    Daf(name: "Sukkah", blatt: 56),
    Daf(name: "Beitzah", blatt: 40),
    Daf(name: "Rosh Hashana", blatt: 35),
    Daf(name: "Taanit", blatt: 31),
    Daf(name: "Megillah", blatt: 32),
    Daf(name: "Moed Katan", blatt: 29),
    Daf(name: "Chagigah", blatt: 27),
    Daf(name: "Yevamot", blatt: 122),
    Daf(name: "Ketubot", blatt: 112),
    Daf(name: "Nedarim", blatt: 91),
    Daf(name: "Nazir", blatt: 66),
    Daf(name: "Sotah", blatt: 49),
    Daf(name: "Gitin", blatt: 90),
    Daf(name: "Kiddushin", blatt: 82),
    Daf(name: "Baba Kamma", blatt: 119),
    Daf(name: "Baba Metzia", blatt: 119),
    Daf(name: "Baba Batra", blatt: 176),
    Daf(name: "Sanhedrin", blatt: 113),
    Daf(name: "Makkot", blatt: 24),
    Daf(name: "Shevuot", blatt: 49),
    Daf(name: "Avodah Zarah", blatt: 76),
    Daf(name: "Horayot", blatt: 14),
    Daf(name: "Zevachim", blatt: 120),
    Daf(name: "Menachot", blatt: 110),
    Daf(name: "Chullin", blatt: 142),
    Daf(name: "Bechorot", blatt: 61),
    Daf(name: "Arachin", blatt: 34),
    Daf(name: "Temurah", blatt: 34),
    Daf(name: "Keritot", blatt: 28),
    Daf(name: "Meilah", blatt: 22),
    Daf(name: "Kinnim", blatt: 4),
    Daf(name: "Tamid", blatt: 9),
    Daf(name: "Midot", blatt: 5),
    Daf(name: "Niddah", blatt: 73)
]

public enum DafYomiError: Error {
    case beforeCycleBegan
}

/// The Babylonian Talmud page studied on `date` in the Daf Yomi cycle.
/// Throws `DafYomiError.beforeCycleBegan` before 11 September 1923.
public func dafYomi(date: Date) throws -> Daf {
    let cday = greg2abs(date: date)
    if cday < osday {
        throw DafYomiError.beforeCycleBegan
    }
    let cycleNum: Int64
    let dayNum: Int
    if cday >= nsday { // "new" cycle
        cycleNum = 8 + (cday - nsday) / 2711
        dayNum = Int(cday - nsday) % 2711
    } else { // old cycle
        cycleNum = 1 + (cday - osday) / 2702
        dayNum = Int(cday - osday) % 2702
    }

    // Find the daf, taking note that the cycle changed slightly after cycle 7.
    var total = 0
    for (index, tractate) in shas.enumerated() {
        // Shekalim had 13 dapim in the old cycles
        let tractateBlatt = (cycleNum <= 7 && tractate.name == "Shekalim") ? 13 : tractate.blatt
        total += tractateBlatt - 1
        guard dayNum < total else {
            continue
        }
        var blatt = (tractateBlatt + 1) - (total - dayNum)
        // Kinnim, Tamid and Midot are printed after Meilah and continue its page numbers
        switch index {
        case 36: blatt += 21
        case 37: blatt += 24
        case 38: blatt += 32
        default: break
        }
        return Daf(name: tractate.name, blatt: blatt)
    }
    // Unreachable: dayNum is less than the total number of dapim
    return Daf(name: shas[shas.count - 1].name, blatt: 0)
}
