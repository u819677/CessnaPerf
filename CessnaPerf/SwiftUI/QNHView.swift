//
//  QNHView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//


import SwiftUI

struct QNHView: View {
    @EnvironmentObject var checkCalc: CheckCalc
    @Binding var qnhEntry: String
    @Binding var isQNHValid: Bool
    var focused: FocusState<Bool?>.Binding
    
    @State var isEditing: Bool = false
    @State var hadFocus: Bool = false
    @State var boolCount: Int = 0
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                Text("           QNH:   ")
                    .font(.custom("Noteworthy Bold", size: 25))
                TextField("    ", text: $qnhEntry)
                {
                    isEditing in //self.isEditing = isEditing
                    if isEditing == true {
                        isQNHValid = true
                    }else {
                        if checkQNH(qnhEntry) == false {
                            isQNHValid = false
                        }
                    }
                }  .focused(focused, equals: true)
//                onCommit: {     //this is the new(ish) trailing closure syntax
//                }
              
                .keyboardType(.asciiCapableNumberPad)
                .font(.custom("Noteworthy Bold", size: 25))
                .padding()
                //.position(x: 50, y: 12)//generates a new view
                .frame(width: 120, height: 28)
//                .background((!hadFocus || boolCount == 2) && isQNHValid ? Color.clear : Color.red.opacity(0.7))
                .background(isQNHValid ? Color.clear : Color.red.opacity(0.7))
                .border(Color.black, width: 0.5)
                .font(.custom("Noteworthy Bold", size: 25))
                Text("hPa")
                    //  .foregroundColor(.white)
                    .font(.custom("Noteworthy Bold", size: 25))
            }//end HStack
    
            .frame(width: 320, height: 35)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(lightBlue)))
            .onTapGesture {
                qnhEntry = ""
                isQNHValid = true
                checkCalc.isValid = true
                //  hadFocus = true
            }
        }
    }
}
func checkQNH(_ qnhInput: String) -> Bool {
    if qnhInput.isEmpty {
        return true
    }
    if let intQNH = Int(qnhInput) {
        if intQNH >= 950 && intQNH <= 1050 {
            return true
        }else {
            return false
        }
    }
    return false
}
//struct QNHView_Previews: PreviewProvider {
//    static var previews: some View {
//        QNHView(qnhEntry: .constant( "1013"), isQNHValid: .constant(true))
//    }
//}
