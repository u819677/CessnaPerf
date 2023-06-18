//
//  QNHView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 19/05/2023.
//

import SwiftUI

struct QNHView: View {
    @Environment(\.scenePhase) var scenePhase
    var userDefaults = UserDefaults.standard
    
    @State var qnhEntry: String = ""
    @State var isValid: Bool = true
    @FocusState var textFieldHasFocus: Bool?
    @Binding var qnh: Int?
    
    var body: some View {
        HStack {
            Text("  QNH:     ")
                .font(.custom("Noteworthy-Bold", size: 25))
            TextField("", text: $qnhEntry)
                .font(.custom("Noteworthy-Bold", size: 25))
                .focused($textFieldHasFocus, equals: true)
                .onChange(of: textFieldHasFocus) { _ in
                        if qnh == nil {
                            qnhEntry = ""
                    }
                }
                .keyboardType(.numberPad)
                .toolbar {toolbarItems()}
                .padding(.leading,10)
                .position(x: 50, y: 12)
                .frame(width: 90, height: 28)
                .border(Color.black, width: 0.5)
                .background(isValid ? Color.clear : Color.red.opacity(0.7))
            Text("hPa")
                .font(.custom("Noteworthy-Bold", size: 25))
            // .navigationBarHidden(true)//not sure what this does or if needed
        }//end of HStack
       
        .frame(width: 320,height: 35)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(skyBlue)))
        .onTapGesture {
            qnhEntry = ""
            isValid = true
            qnh = nil
            textFieldHasFocus = true
        }
        .onChange(of: scenePhase) { _ in
            guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date? else { return }
                ///because calc has not been done yet so there's no calcTime
            if calcTime.timeIntervalSinceNow < -3600 {
                qnhEntry = ""
            }
        }
    }

    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        if textFieldHasFocus ?? false {  //this is a conditional builder, only avail in iOS16
            ToolbarItemGroup(placement: .keyboard) {
                Button{
                    qnhEntry = ""
                    qnh = nil
                    textFieldHasFocus = nil
                }
            label: {Text("Cancel").bold() }.foregroundColor(.black)
                Button{
                    isValid = checkQNH(of: qnhEntry)
                    if isValid {
                        qnh = Int(qnhEntry)
                    } else {
                        qnh = nil
                    }
                    textFieldHasFocus = nil
                }
            label: {Text("Enter").bold() }.foregroundColor(.black)
            }   //end ToolbarItemGroup
        }   //end if
    }

    func checkQNH(of qnhInput: String) -> Bool {
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
}

struct QNHView_Previews: PreviewProvider {
    static var previews: some View {
        QNHView(qnh: .constant(1013))
    }
}


