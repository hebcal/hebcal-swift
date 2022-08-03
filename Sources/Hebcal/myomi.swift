//
//  Created by Michael J. Radwin on 8/3/22.
//

import Foundation

struct MishnaYomi {
    let k: String
    let v: [Int8]
}

let mishnayot: [MishnaYomi] = [
  MishnaYomi(k:"Berakhot", v: [5,8,6,7,5,8,5,8,5]),
  MishnaYomi(k: "Peah", v: [6,8,8,11,8,11,8,9]),
  MishnaYomi(k: "Demai", v: [4,5,6,7,11,12,8]),
  MishnaYomi(k: "Kilayim", v: [9,11,7,9,8,9,8,6,10]),
  MishnaYomi(k: "Sheviit", v: [8,10,10,10,9,6,7,11,9,9]),
  MishnaYomi(k: "Terumot", v: [10,6,9,13,9,6,7,12,7,12,10]),
  MishnaYomi(k: "Maasrot", v: [8,8,10,6,8]),
  MishnaYomi(k: "Maaser Sheni", v: [7,10,13,12,15]),
  MishnaYomi(k: "Challah", v: [9,8,10,11]),
  MishnaYomi(k: "Orlah", v: [9,17,9]),
  MishnaYomi(k: "Bikkurim", v: [11,11,12,5]),
  MishnaYomi(k: "Shabbat", v: [11,7,6,2,4,10,4,7,7,6,6,6,7,4,3,8,8,3,6,5,3,6,5,5]),
  MishnaYomi(k: "Eruvin", v: [10,6,9,11,9,10,11,11,4,15]),
  MishnaYomi(k: "Pesachim", v: [7,8,8,9,10,6,13,8,11,9]),
  MishnaYomi(k: "Shekalim", v: [7,5,4,9,6,6,7,8]),
  MishnaYomi(k: "Yoma", v: [8,7,11,6,7,8,5,9]),
  MishnaYomi(k: "Sukkah", v: [11,9,15,10,8]),
  MishnaYomi(k: "Beitzah", v: [10,10,8,7,7]),
  MishnaYomi(k: "Rosh Hashanah", v: [9,9,8,9]),
  MishnaYomi(k: "Taanit", v: [7,10,9,8]),
  MishnaYomi(k: "Megillah", v: [11,6,6,10]),
  MishnaYomi(k: "Moed Katan", v: [10,5,9]),
  MishnaYomi(k: "Chagigah", v: [8,7,8]),
  MishnaYomi(k: "Yevamot", v: [4,10,10,13,6,6,6,6,6,9,7,6,13,9,10,7]),
  MishnaYomi(k: "Ketubot", v: [10,10,9,12,9,7,10,8,9,6,6,4,11]),
  MishnaYomi(k: "Nedarim", v: [4,5,11,8,6,10,9,7,10,8,12]),
  MishnaYomi(k: "Nazir", v: [7,10,7,7,7,11,4,2,5]),
  MishnaYomi(k: "Sotah", v: [9,6,8,5,5,4,8,7,15]),
  MishnaYomi(k: "Gittin", v: [6,7,8,9,9,7,9,10,10]),
  MishnaYomi(k: "Kiddushin", v: [10,10,13,14]),
  MishnaYomi(k: "Bava Kamma", v: [4,6,11,9,7,6,7,7,12,10]),
  MishnaYomi(k: "Bava Metzia", v: [8,11,12,12,11,8,11,9,13,6]),
  MishnaYomi(k: "Bava Batra", v: [6,14,8,9,11,8,4,8,10,8]),
  MishnaYomi(k: "Sanhedrin", v: [6,5,8,5,5,6,11,7,6,6,6]),
  MishnaYomi(k: "Makkot", v: [10,8,16]),
  MishnaYomi(k: "Shevuot", v: [7,5,11,13,5,7,8,6]),
  MishnaYomi(k: "Eduyot", v: [14,10,12,12,7,3,9,7]),
  MishnaYomi(k: "Avodah Zarah", v: [9,7,10,12,12]),
  MishnaYomi(k: "Avot", v: [18,16,18,22,23,11]),
  MishnaYomi(k: "Horayot", v: [5,7,8]),
  MishnaYomi(k: "Zevachim", v: [4,5,6,6,8,7,6,12,7,8,8,6,8,10]),
  MishnaYomi(k: "Menachot", v: [4,5,7,5,9,7,6,7,9,9,9,5,11]),
  MishnaYomi(k: "Chullin", v: [7,10,7,7,5,7,6,6,8,4,2,5]),
  MishnaYomi(k: "Bekhorot", v: [7,9,4,10,6,12,7,10,8]),
  MishnaYomi(k: "Arakhin", v: [4,6,5,4,6,5,5,7,8]),
  MishnaYomi(k: "Temurah", v: [6,3,5,4,6,5,6]),
  MishnaYomi(k: "Keritot", v: [7,6,10,3,8,9]),
  MishnaYomi(k: "Meilah", v: [4,9,8,6,5,6]),
  MishnaYomi(k: "Tamid", v: [4,5,9,3,6,3,4]),
  MishnaYomi(k: "Middot", v: [9,6,8,7,4]),
  MishnaYomi(k: "Kinnim", v: [4,5,6]),
  MishnaYomi(k: "Kelim", v: [9,8,8,4,11,4,6,11,8,8,9,8,8,8,6,8,17,9,10,7,3,10,5,17,9,9,12,10,8,4]),
  MishnaYomi(k: "Oholot", v: [8,7,7,3,7,7,6,6,16,7,9,8,6,7,10,5,5,10]),
  MishnaYomi(k: "Negaim", v: [6,5,8,11,5,8,5,10,3,10,12,7,12,13]),
  MishnaYomi(k: "Parah", v: [4,5,11,4,9,5,12,11,9,6,9,11]),
  MishnaYomi(k: "Tahorot", v: [9,8,8,13,9,10,9,9,9,8]),
  MishnaYomi(k: "Mikvaot", v: [8,10,4,5,6,11,7,5,7,8]),
  MishnaYomi(k: "Niddah", v: [7,7,7,7,9,14,5,4,11,8]),
  MishnaYomi(k: "Makhshirin", v: [6,11,8,10,11,8]),
  MishnaYomi(k: "Zavim", v: [6,4,3,7,12]),
  MishnaYomi(k: "Tevul Yom", v: [5,8,6,7]),
  MishnaYomi(k: "Yadayim", v: [5,4,5,8]),
  MishnaYomi(k: "Oktzin", v: [6,10,12]),
]

let comps = DateComponents(year: 1947, month: 5, day: 20)
let cycleStartDate = Calendar.current.date(from: comps)!
let mishnaYomiStart = greg2abs(date: cycleStartDate)

let numMishnayot = 4192
let numDays = numMishnayot / 2

public struct Mishna: Equatable {
    public let k: String
    public let v: String
    public init(k: String, v: String) {
        self.k = k
        self.v = v
    }
}

let dummy = Mishna(k: "dummy", v: "dummy")

public class MishnaYomiIndex {
    var days: [(Mishna, Mishna)] = Array(repeating: (dummy, dummy), count: numDays)
    public init() {
        var tmp = [Mishna]()
        for tractate in mishnayot {
            var chap = 1
            while chap <= tractate.v.count {
                let numv = tractate.v[chap - 1]
                var verse = 1
                while verse <= numv {
                    let chapVerse = String(chap) + ":" + String(verse)
                    tmp.append(Mishna(k: tractate.k, v: chapVerse))
                    verse += 1
                }
                chap += 1
            }
        }
        var j = 0
        while j < numDays {
            let k = j * 2
            days[j] = (tmp[k], tmp[k + 1])
            j += 1
        }
    }

    public func lookup(date: Date) -> (Mishna, Mishna) {
        let abs = greg2abs(date: date)
        let dayNum = Int(abs - mishnaYomiStart) % numDays
        return days[dayNum]
    }
}
