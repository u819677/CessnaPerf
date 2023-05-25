//
//  AircraftView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 25/05/2023.
//

import SwiftUI


import SwiftUI

struct AircraftView: View {

   @ObservedObject var aircraft: Aircraft
    @State var showAircraftPicker: Bool = false
    
    var body: some View {
        HStack{
            Text("Aircraft: ")//      \(aircraft.type) ")
                .font(.custom("Noteworthy Bold", size: 25))
                .foregroundColor(.black)
                .padding()
                .padding()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.black)
                .padding()
        }
            .frame(width: 320, height: 35)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(skyBlue)))
            .onTapGesture {
                showAircraftPicker = true
            }
                .sheet(isPresented: $showAircraftPicker) {
                    AircraftPickerView(type: $aircraft.type , showAircraftPicker: $showAircraftPicker)
     
                }
        }//end of body
    
    }

class Aircraft: ObservableObject {
    @Published var type: String = "calm"// wind.windComponent
}


struct AircraftView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftView(aircraft: Aircraft())
    }
}
