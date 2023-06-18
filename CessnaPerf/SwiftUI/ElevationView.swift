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
    
    var body: some View {
        HStack {
            Text("  Elevation:     ")
                .font(.custom("Noteworthy-Bold", size: 25))
            TextField("", text: $elevationEntry)//.multilineTextAlignment(.trailing)
                .font(.custom("Noteworthy-Bold", size: 25))
                .focused($textFieldHasFocus, equals: true)
                .onChange(of: textFieldHasFocus) { _ in
                        if elevation == nil {
                            elevationEntry = ""
                    }
                }
                .keyboardType(.numberPad)
                .toolbar {toolbarItems()}

                .padding(.leading, 10)
                //.position(x: 50, y: 12)
                .frame(width: 100, height: 28)
                .border(Color.black, width: 0.5)
                .background(isValid ? Color.clear : Color.red.opacity(0.7))
            Text("ft")
                .font(.custom("Noteworthy-Bold", size: 25))
            // .navigationBarHidden(true)//not sure what this does or if needed
        }//end of HStack
       
        .frame(width: 320,height: 35)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(skyBlue)))
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

    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        if textFieldHasFocus ?? false {  //this is a conditional builder, only avail in iOS16
            ToolbarItemGroup(placement: .keyboard) {
                Button{
                    elevationEntry = ""
                    elevation = nil
                    textFieldHasFocus = nil
                }
            label: {Text("Cancel").bold() }.foregroundColor(.black)
                Button{
                    isValid = checkElevation(of: elevationEntry)
                    if isValid {
                        elevation = Int(elevationEntry)
                    } else {
                        elevation = nil
                    }
                    textFieldHasFocus = nil
                }
            label: {Text("Enter").bold() }.foregroundColor(.black)
            }   //end ToolbarItemGroup
        }   //end if
    }

    func checkElevation(of elevationInput: String) -> Bool {
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
}

struct ElevationView_Previews: PreviewProvider {
    static var previews: some View {
        ElevationView(elevation: .constant(11)).environmentObject(Cessna())
    }
}

