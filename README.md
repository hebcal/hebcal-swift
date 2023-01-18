# hebcal-swift

Hebcal is a perpetual Jewish Calendar. This library converts between
Hebrew and Gregorian dates, and generates lists of Jewish holidays for
any year (past, present or future).

Hebcal was created in 1992 by Danny Sadinoff as a Unix/Linux program
written in C, inspired by similar functionality written in Emacs
Lisp. This Swift implementation was released in 2021 by
Michael J. Radwin.

```swift
import Foundation
import Hebcal

let now = Date()
let hdate = HDate(date: now, calendar: .current)

print(hdate.render(lang: TranslationLang.en))

let sedra = Sedra(year: hdate.yy, il: false)
let parsha = sedra.lookup(hdate: hdate, lang: TranslationLang.en)

print(parsha)
```
