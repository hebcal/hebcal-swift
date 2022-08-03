//
//  Created by Michael J. Radwin on 8/3/22.
//

import Foundation

let osdate0 = DateComponents(year: 1923, month: 9, day: 11)
let osdate = Calendar.current.date(from: osdate0)!
let osday = greg2abs(date: osdate)

let nsdate0 = DateComponents(year: 1975, month: 6, day: 24)
let nsdate = Calendar.current.date(from: nsdate0)!
let nsday = greg2abs(date: nsdate)

public struct Daf : Equatable {
    let name: String
    var blatt: Int
}

let shas0: [Daf] = [
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

public func dafYomi(date: Date) throws -> Daf {
    let cday = greg2abs(date: date)
    if (cday < osday) {
        throw DafYomiError.beforeCycleBegan
    }
    var cno: Int64
    var dno: Int
    if (cday >= nsday) { // "new" cycle
      cno = 8 + ( (cday - nsday) / 2711 )
      dno = Int(cday - nsday) % 2711
    } else { // old cycle
      cno = 1 + ( (cday - osday) / 2702 )
      dno = Int(cday - osday) % 2702
    }

    // Find the daf taking note that the cycle changed slightly after cycle 7.

    var total = 0
    var blatt = 0
    var count = -1

    var shas = shas0
    // Fix Shekalim for old cycles
    if (cno <= 7) {
      shas[4].blatt = 13
    } else {
      shas[4].blatt = 22
    }

    // Find the daf
    var j = 0
    let dafcnt = 40
    while (j < dafcnt) {
      count += 1
      total = total + shas[j].blatt - 1
      if (dno < total) {
        blatt = (shas[j].blatt + 1) - (total - dno)
        // fiddle with the weird ones near the end
        switch (count) {
          case 36:
            blatt = blatt + 21
            break;
          case 37:
            blatt = blatt + 24
            break;
          case 38:
            blatt = blatt + 32
            break;
          default:
            break;
        }
        // Bailout
        j = 1 + dafcnt
      }
      j += 1
    }
    return Daf(name: shas[count].name, blatt: blatt)
}
