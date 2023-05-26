//
//  WindView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//

import SwiftUI

struct WindView: View {

  //  @ObservedObject var wind: Wind
    @State var showPicker: Bool = false
    @Binding var wind: String
    
    var body: some View {
        HStack{
            Text("Wind:     \(wind)")
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
                showPicker = true
            }
                .sheet(isPresented: $showPicker) {
                    WindPicker(showPicker: $showPicker, wind: $wind)
                }
        }//end of body
    
    }

//struct WindView_Previews: PreviewProvider {
//    static var previews: some View {
//        WindView(wind: Wind())
//    }
//}
