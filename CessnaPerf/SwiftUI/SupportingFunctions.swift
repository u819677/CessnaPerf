//
//  SupportingFunctions.swift
//  CessnaPerf
//
//  Created by Richard Clark on 02/05/2023.
//

import Foundation

func pickerRow(selected: String) -> Int {
    switch selected {
    case "calm":
        return 3
    case "9kts HW":
        return 0
    case "6kts HW":
        return 1
    case "3kts HW":
        return 2
    case "2kts TW":
        return 4
    case "4kts TW":
        return 5
    case "6kts TW":
        return 6
    case "8kts TW":
        return 7
    case "10kts TW":
        return 8
    default:
        return 99
    }
}
//["9kt HW", "6kts HW", "3kts HW", "calm", "2kts TW", "4kts TW", "6kts TW", "8kts TW" , "10kts TW"]
func WindComponent(component: String) -> Double {
    switch component {
    case "calm":
        return 1.0
    case "2kts TW":
        return 1.10
    case "4kts TW":
        return 1.20
    case "6kts TW":
        return 1.30
    case "8kts TW":
        return 1.40
    case "10kts TW":
        return 1.50
    case "3kts HW":
        return 0.9666
    case "6kts HW":
        return 0.9333
    case "9kts HW":
        return 0.90
    default:
        return 1.0
    }
}
