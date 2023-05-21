//
//  WeightView.swift
//  from TextFieldDismissal
//
//  Created by Richard Clark on 19/05/2023.
//

import SwiftUI

struct WeightView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var weightEntry: String = ""//2400"
    @State var isValid: Bool = true
    @FocusState var textFieldHasFocus: Bool? {
        didSet {
            print("focus was set")//seems to trigger when focus actively is set back to nil, not when focus is lost
        }
          
            //weightEntry = ""
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                textFieldHasFocus = true

    }
    @Binding var weight: Int? //= 2400
    let userDefaults = UserDefaults.standard
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var body: some View {
        HStack {
            Text("  Weight:     ")
                .font(.custom("Noteworthy-Bold", size: 25))
            TextField("", text: $weightEntry)
                .font(.custom("Noteworthy-Bold", size: 25))
                .focused($textFieldHasFocus, equals: true)
                .onChange(of: textFieldHasFocus) { _ in
                        if weight == nil {
                            weightEntry = ""
                    }
                }
                .keyboardType(.numberPad)
                .toolbar {toolbarItems()}
                
                .padding()
                .position(x: 50, y: 12)
                .frame(width: 120, height: 28)
                .border(Color.black, width: 0.5)
                .background(isValid ? Color.clear : Color.red.opacity(0.7))
            Text("lbs")
                .font(.custom("Noteworthy-Bold", size: 25))
            // .navigationBarHidden(true)//not sure what this does or if needed
        }  //end of HStack
       
        .frame(width: 320,height: 35)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(lightBlue)))
        .onTapGesture {
            weightEntry = ""
            isValid = true
            weight = nil
            textFieldHasFocus = true
        }
        .onChange(of: scenePhase) { _ in
            print("scenePhase changed in WeightView")
            guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date?
            else {
                return  ///because calc has not been done yet so there's no calcTime
            }
            print("calcTime in WeightView is \(String(describing: calcTime))")
        }
    }  //end of body

    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        if textFieldHasFocus ?? false {  //this is a conditional builder, only avail in iOS16
            ToolbarItemGroup(placement: .keyboard) {
                Button{
                    weightEntry = ""
                    weight = nil
                    textFieldHasFocus = nil
                }
            label: {Text("Cancel").bold() }
                Button{
                    print(String(describing: weight))
                    isValid = checkTOW(of: weightEntry)
                    if isValid {
                        weight = Int(weightEntry)
                    } else {
                        weight = nil
                    }
                    textFieldHasFocus = nil
                }
            label: {Text("Enter").bold() }
            }   //end ToolbarItemGroup
        }   //end if
    }

    private func checkTOW(of weightEntry: String) -> Bool {
        if weightEntry.isEmpty {
            return false
        }
        if let intTOW = Int(weightEntry) {
            if intTOW  >= 2000 && intTOW <= 2400 {
                return true
            } else {
                return false
            }
        }
        return false
    }//end of checkTOW
}

//struct WeightView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeightView()
//    }
//}

