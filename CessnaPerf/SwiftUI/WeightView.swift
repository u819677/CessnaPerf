//
//  WeightView.swift
//  from TextFieldDismissal
//
//  Created by Richard Clark on 19/05/2023.
//

import SwiftUI

struct WeightView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var cessna: Cessna
    @EnvironmentObject var dataEntryFields: DataEntryFields
    let userDefaults = UserDefaults.standard
    
    @State var weightEntry: String = ""//2400"
    @State var isValid: Bool = true
    @FocusState var textFieldHasFocus: Bool?
    @Binding var weight: Int? //= 2400
    
    var body: some View {
        HStack {
            Text("  Weight:     ")
                .font(.custom("Noteworthy-Bold", size: 25))
            TextField("", text: $weightEntry)
                .font(.custom("Noteworthy-Bold", size: 25))
                .focused($textFieldHasFocus, equals: true)
                .onChange(of: textFieldHasFocus) { _ in
                    if weight == nil { weightEntry = "" }///to force user to press Enter 
                }
                .onChange(of: dataEntryFields.clearAll) { _ in
                    weightEntry = ""
                    dataEntryFields.clearAll = false
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
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(skyBlue)))
        .onTapGesture {
            weightEntry = ""
            isValid = true
            weight = nil
            textFieldHasFocus = true
        }
        
        .onChange(of: scenePhase) { _ in
            guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date? else { return }
            ///because calc has not been done yet so there's no calcTime
            if calcTime.timeIntervalSinceNow < -3600 {
                weightEntry = ""///forces a re-compute incase take off conditions have changed since earler calculation
            }
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
                    print("weight in WeightView toolbar is \(String(describing: weight))")
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
        let type = cessna.type
        print("checkTOW in WeightView ran and cessna.type is \(cessna.type)")
        var lowerWeight: Int
        var higherWeight: Int
        switch type {
        case "C172P":
            lowerWeight = 2000; higherWeight = 2400 
        case "C182RG":
            lowerWeight = 2500; higherWeight = 3100
        default:
            lowerWeight = 0; higherWeight = 0/// this makes the compiler happy by ensuring that these vars are guaranteed to be initialised.
        }
        if let intTOW = Int(weightEntry) {
           // if intTOW  >= 2000 && intTOW <= 2400 {
                if intTOW >= lowerWeight && intTOW <= higherWeight {
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

