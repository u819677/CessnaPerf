//
//  ElevationView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 19/05/2023.
//
import SwiftUI

struct ElevationView: View {
    
    @State var elevationEntry: String = "2400"
    @State var isValid: Bool = true
    @FocusState var textFieldHasFocus: Bool?
    @Binding var elevation: Int?
    
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var body: some View {
        HStack {
            Text("  Elevation:     ")
                .font(.custom("Noteworthy-Bold", size: 25))
            TextField("", text: $elevationEntry)
                .font(.custom("Noteworthy-Bold", size: 25))
                .focused($textFieldHasFocus, equals: true)
                .keyboardType(.numberPad)
                .toolbar {toolbarItems()}

                .padding()
                .position(x: 50, y: 12)
                .frame(width: 120, height: 28)
                .border(Color.black, width: 0.5)
                .background(isValid ? Color.clear : Color.red.opacity(0.7))
            Text("ft")
                .font(.custom("Noteworthy-Bold", size: 25))
            // .navigationBarHidden(true)//not sure what this does or if needed
        }//end of HStack
       
        .frame(width: 320,height: 35)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(lightBlue)))
        .onTapGesture {
            elevationEntry = ""
            isValid = true
            textFieldHasFocus = true
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
            label: {Text("Cancel").bold() }
                Button{
                    isValid = checkElevation(of: elevationEntry)
                    if isValid {
                        elevation = Int(elevationEntry)
                    } else {
                        elevation = nil
                    }
                    textFieldHasFocus = nil
                }
            label: {Text("Enter").bold() }
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

//struct WeightView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeightView()
//    }
//}


