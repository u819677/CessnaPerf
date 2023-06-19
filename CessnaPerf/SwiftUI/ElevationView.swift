//
//  ElevationView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 19/05/2023.
//
import SwiftUI

struct ElevationView: View {
    
    @State var elevationEntry: String = ""
    @State var isValid: Bool = true
    @FocusState var textFieldHasFocus: Bool?
    @Binding var elevation: Int?
    
    @Environment(\.scenePhase) var scenePhase
    let userDefaults = UserDefaults.standard
    
    //MARK: body
    var body: some View {
        HStack {
            Text("  Elevation:     ")
            TextField("", text: $elevationEntry)//.multilineTextAlignment(.trailing)
                .textFieldModifier()
                .focused($textFieldHasFocus, equals: true)
                .onChange(of: textFieldHasFocus) { _ in
                    if elevation == nil { elevationEntry = "" }
                }
                .toolbar {toolbarItems()}
                .background(isValid ? Color.clear : Color.red.opacity(0.7))
            Text("ft")
            /// .navigationBarHidden(true)//not sure what this does or if needed
        }//end of HStack
        .dataEntryModifier()
        .onTapGesture {
            elevationEntry = ""
            isValid = true
            textFieldHasFocus = true
            elevation = nil
        }
        .onChange(of: scenePhase) { _ in
            guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date?  else { return }
            ///because calc has not been done yet so there's no calcTime
            if calcTime.timeIntervalSinceNow < -3600 {
                elevationEntry = ""
            }
        }
    }
    //MARK: Toolbar
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        if textFieldHasFocus ?? false {  //this is a conditional builder, only avail in iOS16
            ToolbarItemGroup(placement: .keyboard) {
                Button{
                    elevationEntry = ""
                    elevation = nil
                    textFieldHasFocus = nil
                }
            label: {Text("Cancel").bold() }.foregroundColor(.black).font(.system(size: 18))///overrides the custom font. But why this not required in Temperature View??? v strange.
                Button{
                    isValid = checkElevation(for: elevationEntry)
                    if isValid { elevation = Int(elevationEntry)
                    } else { elevation = nil }
                    textFieldHasFocus = nil
                }
            label: {Text("Enter").bold() }.foregroundColor(.black).font(.system(size: 18))///overrides the custom font
            }   //end ToolbarItemGroup
        }   //end if
    }
    //MARK: checkElevation
    func checkElevation(for elevationInput: String) -> Bool {
        if elevationInput.isEmpty { return true }
        if let intElevation = Int(elevationInput) {
            if intElevation >= 0 && intElevation <= 2000 {
                return true
            } else { return false }
        }
        return false
    }
}

struct ElevationView_Previews: PreviewProvider {
    static var previews: some View {
        ElevationView(elevation: .constant(11)).environmentObject(Cessna())
    }
}

