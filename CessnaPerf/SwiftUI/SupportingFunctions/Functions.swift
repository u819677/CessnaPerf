//
//  Functions.swift
//  CessnaPerf
//
//  Created by Richard Clark on 02/05/2023.
//

import TabularData
import SwiftUI

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

func Factor( for component: String) -> Double {
    //these are the multipliers for the wind components
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
func TODDataFrame(dataFrame: DataFrame) -> DataFrame {
    let todData = dataFrame.selecting(columnNames: "weight", "pa", "TOD0", "TOD10", "TOD20", "TOD30", "TOD40", "TOD40.1" )
    return todData
}
func TORDataFrame(dataFrame: DataFrame) -> DataFrame {
    let torData = dataFrame.selecting(columnNames: "weight", "pa", "TOR0", "TOR10", "TOR20", "TOR30", "TOR40", "TOR40.1" )
    return torData
}

let skyBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
let C172P = "C172P" //this could be used to remove risk of typo but not sure it adds much. 

struct DataEntryViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Noteworthy-Bold", size: 25))
            //.keyboardType(.numberPad)
            .frame(width: 320,height: 40)
           // .border(Color.black, width: 0.5)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(skyBlue)))

    }
}
struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading,10)
            .frame(width: 110, height: 28)
            .border(Color.black, width: 0.5)
            .keyboardType(.numberPad)

    }
}
extension View {
    func dataEntryModifier() -> some View {
        modifier(DataEntryViewModifier())
    }
    func textFieldModifier() -> some View {
        modifier(TextFieldModifier())
    }
}
