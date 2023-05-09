//
//  SurfaceView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 09/05/2023.
//

import SwiftUI

struct SurfaceView: View {
    @Binding var isTarmac: Bool // = false
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var body: some View {
        
        VStack{
//            Toggle( isOn: $isTarmac) {
//
//                Text("   Runway surface")
//                    .font(.custom("Noteworthy Bold", size: 24))
//                    .foregroundColor(isTarmac ? .black : .white)
//                    .offset(x:0, y: -3)
//            }
//            .frame(width: 320, height: 35)
//            .background(!isTarmac ? Image("grass").resizable() : Image("tarmac").resizable())
//            .background(RoundedRectangle(cornerRadius: 10))
//            .cornerRadius(10)
//            .clipped()
//            .overlay(RoundedRectangle(cornerRadius: 10)
//                .strokeBorder(isTarmac ? Color.white : Color.black)//,
//            )
//            .toggleStyle(SwitchToggleStyle(tint: isTarmac ? Color(lightBlue) : .red)
//            )
            Toggle("", isOn: $isTarmac)
            
            
            
            
                .toggleStyle(
                    ColoredToggleStyle(isTarmac: $isTarmac,
                                       label: "My Colored Toggle",
                                       onColor: .green,
                                       offColor: .red,
                                       thumbColor: Color(UIColor.systemGray2)))
                                      // thumbColor: Color(.black)))
        }
    }
}

struct SurfaceView_Previews: PreviewProvider {
    static var previews: some View {
        SurfaceView(isTarmac: .constant(true))
    }
}
struct ColoredToggleStyle: ToggleStyle {
    @Binding var isTarmac: Bool //
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var label = "test"
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Text("   Runway surface")
                .font(.custom("Noteworthy Bold", size: 24))
                .foregroundColor(isTarmac ? Color.white : Color.black)
                .offset(x:0, y: -3)
            Spacer()
            Button(action: { configuration.isOn.toggle() })
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    //.fill(Color(lightBlue))
                    .fill(Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        //.strokeBorder(isTarmac ? Color.white : Color.black)
                        .strokeBorder( Color.white )
                             )
                    .frame(width: 50, height: 29)
                    .overlay (
                        Circle()
                            .fill(thumbColor)
  
                            .overlay(Circle()
                               // .strokeBorder(isTarmac ? Color.white : Color.black)
                                .strokeBorder( Color.white )
                                     )
                            .shadow(radius: 1, x:0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(.easeInOut, value: 0.1)
            }
        }            .frame(width: 320, height: 35)
            .background(isTarmac ? Image("tarmac").resizable() : Image("grass").resizable())// : Image("tarmac").resizable())
            .background(RoundedRectangle(cornerRadius: 10))
            .cornerRadius(10)
            .clipped()
//            .overlay(RoundedRectangle(cornerRadius: 10)
//                .strokeBorder( Color.black)//,
//            )
        .font(.title)
        .padding(.horizontal)
    }
}
