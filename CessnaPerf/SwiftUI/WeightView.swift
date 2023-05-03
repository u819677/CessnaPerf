//
//  WeightView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.


import SwiftUI

struct WeightView: View {
    @EnvironmentObject var checkCalc: CheckCalc
    @Binding var weightEntry: String
    @Binding var isWeightValid: Bool    //this extra check is to finesse the appearance of red background in textfield
    var focused: FocusState<Bool?>.Binding
    
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var body: some View {
        ZStack(alignment: .center){
            HStack{
                Text("    Weight:   ")
                    .font(.custom("Noteworthy Bold", size: 25))
                TextField("       ", text: $weightEntry)  
                {
                    isEditing in //self.isEditing = isEditing
                    if isEditing == true {
                        isWeightValid = true
                    }
                    if isEditing == false {
                        if checkTOW(weightEntry) == false {
                            isWeightValid = false
                        }
                    }
                }.focused(focused, equals: true)
                .keyboardType(.asciiCapableNumberPad)
                //        onCommit: {   //this seems to be optional. Enter not always tapped though, so not reliable
                //        }
                
                .font(.custom("Noteworthy Bold", size: 25))
                .padding()
               // .position(x: 50, y: 12)//generates a new view
                .frame(width: 120, height: 28)
                .background(isWeightValid ? Color.clear : Color.red.opacity(0.7))
                .border(Color.black, width: 0.5)
                .font(.custom("Noteworthy Bold", size: 25))
                Text("lbs")
                    .font(.custom("Noteworthy Bold", size: 25))
            }//end HStack
            .frame(width: 320, height: 35)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(lightBlue)))
            .onTapGesture {
                weightEntry = ""
                isWeightValid = true
                checkCalc.isValid = true
            }
        }//end ZStack
    }
}

func checkTOW(_ weightInput: String) -> Bool {
    if weightInput.isEmpty {
        return true
    }
    if let intTOW = Int(weightInput) {
        if intTOW >= 2000 && intTOW <= 2400 {
            return true
        }else {
            return false
        }
    }
    return false
}
//struct WeightView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeightView(weightEntry: .constant( "2400"), isWeightValid: .constant(true), focused: <#FocusState<Bool?>.Binding#>, focused: )
//    }
//}
