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
    
    //MARK: body
    var body: some View {
        HStack {
            Text("  QNH:     ")
                .font(.custom("Noteworthy-Bold", size: 25))
            TextField("", text: $qnhEntry)
                .textFieldModifier()
                .focused($textFieldHasFocus, equals: true)
                .onChange(of: textFieldHasFocus) { _ in
                    if qnh == nil { qnhEntry = "" }
                }
                .toolbar {toolbarItems()}
                .background(isValid ? Color.clear : Color.red.opacity(0.7))
            Text("hPa")
            // .navigationBarHidden(true)//not sure what this does or if needed
        }//end of HStack
        .dataEntryModifier()
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
//MARK: Toolbar
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        if textFieldHasFocus ?? false {  //this is a conditional builder, only avail in iOS16
            ToolbarItemGroup(placement: .keyboard) {
                Button{
                    qnhEntry = ""
                    qnh = nil
                    textFieldHasFocus = nil
                }
            label: {Text("Cancel").bold() }.foregroundColor(.black).font(.system(size: 18))
                Button{
                    isValid = checkQNH(for: qnhEntry)
                    if isValid { qnh = Int(qnhEntry)
                    } else {  qnh = nil }
                    textFieldHasFocus = nil
                }
            label: {Text("Enter").bold() }.foregroundColor(.black).font(.system(size: 18))
            }   //end ToolbarItemGroup
        }   //end if
    }
    //MARK: checkQNH
    func checkQNH(for qnhInput: String) -> Bool {
        if qnhInput.isEmpty {
            return true
        }
        if let intQNH = Int(qnhInput) {
            if intQNH >= 950 && intQNH <= 1050 {
                return true
            }else {  return false }
        }
        return false
    }
}

struct QNHView_Previews: PreviewProvider {
    static var previews: some View {
        QNHView(qnh: .constant(1013))
    }
}


