//
//  ElevationView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//


import SwiftUI


struct ElevationView: View {
    @EnvironmentObject var checkCalc: CheckCalc
    @Binding var elevationEntry: String
    @Binding var isElevationValid: Bool
    var focused: FocusState<Bool?>.Binding
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var body: some View {
        ZStack(alignment: .center) {
            HStack{
                Text("Airfield elevn:")
                    .font(.custom("Noteworthy Bold", size: 25))
                TextField("       ", text: $elevationEntry)
                {
                    isEditing in //self.isEditing = isEditing
                    if isEditing == true {
                        isElevationValid = true
                    } else {
                        if checkElevation(elevationEntry) == false {
                            isElevationValid = false
                        }
                    }
                    if isEditing == false {
                        if checkElevation(elevationEntry) == false {
                            isElevationValid = false
                        }
                    }
                }
                .focused(focused, equals: true)
                .keyboardType(.asciiCapableNumberPad)
//                onCommit: {
//                }
                .font(.custom("Noteworthy Bold", size: 25))
                .padding()
                .position(x: 50, y: 12)//generates a new view
                .frame(width: 110, height: 28)
                .background(isElevationValid ? Color.clear : Color.red.opacity(0.7))
                .border(Color.black, width: 0.5)
                .font(.custom("Noteworthy Bold", size: 25))
                Text("ft")
                    .font(.custom("Noteworthy Bold", size: 25))
            }//end HStack
            .frame(width: 320, height: 35)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(lightBlue)))
            .onTapGesture {
                elevationEntry = ""
                isElevationValid = true
                checkCalc.isValid = true
            }
        }// end ZStack
    }
}

func checkElevation(_ elevationInput: String) -> Bool {
    if elevationInput.isEmpty {
        return true
    }
    if let intElevation = Int(elevationInput) {
        if intElevation >= 0 && intElevation <= 2000 {
            return true
        }else {
            return false
        }
    }
    return false
}
//struct PAView_Previews: PreviewProvider {
//    static var previews: some View {
//        ElevationView(elevationEntry: .constant( "1000"), isElevationValid: .constant(true))
//    }
//}
