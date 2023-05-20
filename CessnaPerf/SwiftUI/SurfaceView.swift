//
//  SurfaceView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 09/05/2023.
//

import SwiftUI

struct SurfaceView: View {
    @Binding var isGrass: Bool // = false
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var body: some View {
        
        Toggle("", isOn: $isGrass)
            .toggleStyle(
                SurfaceToggle(isGrass: $isGrass,
                              thumbColor: Color(UIColor.systemGray2)))
    }
}

struct SurfaceView_Previews: PreviewProvider {
    static var previews: some View {
        SurfaceView(isGrass: .constant(false))
    }
}
struct SurfaceToggle: ToggleStyle {
    @Binding var isGrass: Bool
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    var thumbColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Text("   Runway surface")
                .font(.custom("Noteworthy Bold", size: 24))
                .foregroundColor(isGrass ? Color.black : Color.white)
                .offset(x:0, y: -3)
            Spacer()
            Button(action: { configuration.isOn.toggle() })
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .strokeBorder( Color.white )
                    )
                    .frame(width: 50, height: 29)
                    .overlay (
                        Circle()
                            .fill(thumbColor)
                            .overlay(Circle()
                                .strokeBorder( Color.white )
                            )
                            .shadow(radius: 1, x:0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(.easeInOut, value: 1.0)
            }
        }            .frame(width: 320, height: 35)
            .background(isGrass ? Image("grass").resizable() : Image("tarmac").resizable())
            .animation(.easeInOut, value: 0.5)
            .background(RoundedRectangle(cornerRadius: 10))
            .cornerRadius(10)
            .clipped()
    }
}
