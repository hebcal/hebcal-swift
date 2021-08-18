//
//  SimpleDate.swift
//  
//
//  Created by Michael Radwin on 8/17/21.
//

import Foundation

public struct SimpleDate {
    var yy: Int
    var mm: Int
    var dd: Int
}

public enum DayOfWeek: Int {
    case SUN = 0, MON, TUE, WED, THU, FRI, SAT
}
