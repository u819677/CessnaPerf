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
    let userDefaults = UserDefaults.standard
    @State var weightEntry: String = ""//2400"
    @State var isValid: Bool = true
    @FocusState var textFieldHasFocus: Bool?
    @Binding var weight: Int?
    
 //MARK: body
    var body: some View {
        HStack {
            Text(cessna.type != "C152" ? "  Weight:    " : "Weight:      1670  lbs").padding(.bottom, 4)///just to lift the tail of the g up into the blue
            if cessna.type != "C152" {///C152 does not accept user entry; POH only gives figures for 1670lbs
                TextField("", text: $weightEntry)
                    .textFieldModifier()
                    .focused($textFieldHasFocus, equals: true)
                    .onChange(of: textFieldHasFocus) { _ in
                        if weight == nil { weightEntry = "" }///to force user to press Enter
                    }
                    .toolbar {toolbarItems()}//.font(.system(size: 18))///overrides the custom font
                    .background(isValid ? Color.clear : Color.red.opacity(0.7))
                Text("lbs")
            }
        }  //end of HStack
        .dataEntryModifier()
        .onTapGesture { ///prep for a new entry
            weightEntry = ""
            isValid = true
            weight = nil
            textFieldHasFocus = true
        }
        .onChange(of: cessna.type) { _ in
            weightEntry = ""    ///clears the weight after there's been a type change in RadioButtonView
            weight = nil
        }
        .onChange(of: scenePhase) { _ in
            guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date? else { return }
            ///return because calc has not been done yet so there's no calcTime
            if calcTime.timeIntervalSinceNow < -3600 {
                weightEntry = ""///forces a re-compute (a precaution since take off conditions may have changed since earler calculation)
                weight = nil ///need to clear previous value
            }
        }
    }  //end of body
    
    //MARK: Toolbar
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        if textFieldHasFocus ?? false {  //this is a conditional builder, only avail in iOS16 //need if to avoid multiple Cancel and Enter Buttons
            ToolbarItemGroup(placement: .keyboard) {
                Button{
                    weightEntry = ""
                    weight = nil
                    textFieldHasFocus = nil
                }
            label: {Text("Cancel").bold() }.foregroundColor(.black).font(.system(size: 18))///overrides the custom font
                Button{
                    isValid = checkTOW(for: weightEntry)
                    if isValid {
                        weight = Int(weightEntry)
                    } else {
                        weight = nil
                    }
                    textFieldHasFocus = nil
                }
            label: {Text("Enter").bold()}.foregroundColor(.black).font(.system(size: 18))///overrides the custom font
            }   //end ToolbarItemGroup
        }   //end if
    }
    //MARK: checkTOW
    private func checkTOW(for weightEntry: String) -> Bool {
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
            lowerWeight = 0; higherWeight = 0/// this keeps the compiler happy by ensuring that these vars are guaranteed to be initialised.
        }
        if let intTOW = Int(weightEntry) {
            if intTOW >= lowerWeight && intTOW <= higherWeight {
                return true
            } else { return false }
        }
        return false
    }//end of checkTOW
}

struct WeightView_Previews: PreviewProvider {
    static var previews: some View {
        WeightView(weight: .constant(9999)).environmentObject(Cessna())
    }
}

