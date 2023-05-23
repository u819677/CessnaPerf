//
//  TemperatureView.swift
//  from TextFieldDismissal
//
//  Created by Richard Clark on 19/05/2023.
//

import SwiftUI

struct TemperatureView: View {
    
    @Environment(\.scenePhase) var scenePhase
    let userDefaults = UserDefaults.standard
    
    @State var tempEntry: String = ""
    @State var isValid: Bool = true
    @FocusState var textFieldHasFocus: Bool?
    @Binding var temperature: Int?
    

    init(temperature: Binding<Int?> ) {// {, focused: FocusState<Bool?>.Binding) {//some clever init syntax here for FocusState
        UIToolbar.appearance().barTintColor = UIColor.lightGray
        self._temperature = temperature
    }
    var body: some View {
                HStack {
                    Text("         Temp:            ")
                    TextField("", text: $tempEntry)
                        .focused($textFieldHasFocus, equals: true)
                        .onChange(of: textFieldHasFocus) { _ in
                                if temperature == nil {
                                    tempEntry = ""
                            }
                        }
                        .keyboardType(.numberPad)
                        .padding()
                        .position(x: 50, y: 12)
                        .frame(width: 80, height: 28)
                        .border(Color.black, width: 0.5)
                        .background(isValid ? Color.clear : Color.red.opacity(0.7))
                    Text("°C")
                     .navigationBarHidden(true)//not sure what this does or if needed
                }//end of HStack
                .font(.custom("Noteworthy-Bold", size: 25))
                .frame(width: 320,height: 35)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(skyBlue)))
                .onTapGesture {
                    tempEntry = ""
                    isValid = true
                    temperature = nil
                    textFieldHasFocus = true 
                }
                .toolbar{toolbarItems()}
                .onChange(of: scenePhase) { _ in
                    guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date? else { return }
                    //because calc has not been done yet
                    if calcTime.timeIntervalSinceNow < -3600  {
                        tempEntry = ""
                    }
                }
    }//end of body
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        
        if textFieldHasFocus ?? false {
            ToolbarItemGroup(placement: .keyboard)
            {
                Button{
                    tempEntry = ""
                    temperature = nil
                    textFieldHasFocus = nil
                }
            label: {Text("Cancel").bold() }
                Button{
                    isValid = checkValidity(of: tempEntry)
                    if isValid {
                        temperature = Int(tempEntry)
                    } else {
                        temperature = nil
                    }
                    textFieldHasFocus = nil
                }
            label: {Text("Enter").bold() }
            }
        }//end if
    }
    private func checkValidity(of tempEntry: String) -> Bool {
        if tempEntry.isEmpty { return false }
        if let intTemp = Int(tempEntry) {   //checks that the string be made into an Int
            if intTemp >= 0 && intTemp <= 40 {
                return true
            } else { return false } //entry out of permitted range
        }
        return false        //the default case to keep compiler happy
    }
}//end of struct


//struct TemperatureView_Previews: PreviewProvider {
//    static var previews: some View {
//        TemperatureView(temperature: .constant(0), focused: true)
//    }
//}
