//
//  TemperatureView.swift
//  C172PTakeOffPerf
//
//  Created by Richard Clark on 30/04/2023.
//

import SwiftUI

struct TemperatureView: View {
    
    @EnvironmentObject var checkCalc: CheckCalc
    @Binding var temperatureEntry: String
    @Binding var isTempValid: Bool  //order of the @Binding vars makes a difference here when the view is called!
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var body: some View {
        ZStack(alignment: .center){
            HStack(alignment: .firstTextBaseline) {
                Spacer()
                Text("          Temp:           ")
                    .padding(.leading)
                    .foregroundColor(.black)
                    .font(.custom("Noteworthy Bold", size: 25))
                TextField("enter Temp(°C)", text: $temperatureEntry)
                {
                    isEditing in
                    if isEditing == true {
                        isTempValid = true
                    } else {
                        if checkTemp(temperatureEntry) ==  false {
                            isTempValid = false
                        }
                    }
                }
                onCommit: {
                }
                
                .font(.custom("Noteworthy Bold", size: 25))
                .padding()
                .position(x: 50, y: 12)//generates a new view
                .frame(width: 80, height: 28)
                .background(isTempValid ? Color.clear : Color.red.opacity(0.7))
                .border(Color.black, width: 0.5)
                .font(.custom("Noteworthy Bold", size: 25))
                .foregroundColor(.black)
                Text("°C")
                    .padding(.trailing)
                    .font(.custom("Noteworthy Bold", size: 25))
                    .foregroundColor(.black)
                Spacer()
            }//end of HStack
            .frame(width: 320, height: 35)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(lightBlue)))
            .onTapGesture {
                temperatureEntry = ""
                isTempValid = true
                checkCalc.isValid = true
            }
        }//end of ZStack
    }
}
func checkTemp(_ tempInput: String) -> Bool {
    if tempInput.isEmpty {
        return true
    }
    if let intTemp = Int(tempInput) {
        if intTemp >= 0 && intTemp <= 40 {
            return true
        }else {
            return false
        }
    }
    return false
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView(temperatureEntry: .constant("20"), isTempValid: .constant(true))
    }
}
