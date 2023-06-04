//
//  ResultsView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//


import SwiftUI

struct ResultsView: View {
    @Environment(\.dismiss) var dismiss
    
   // @Environment(\.aircraftType) var aircraftType
 
    @Binding var ftTOD: Double
    @Binding var ftTOR: Double
    @EnvironmentObject var cessna: Cessna
   // @Binding var aircraft: String
    var body: some View {
        ZStack{
            Image("airfield")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
               // .offset(x: -100, y: 0)
        VStack{

            //this is a multi-line string literal, line breaks are required
            Text("""
                Aircraft type: \(cessna.type)
                TOR = \(String(format: "%.0f", ftTOR)) ft
                TOD = \(String(format: "%.0f", ftTOD)) ft
                """)
            .foregroundColor(.white)
            .font(.custom("Noteworthy-Bold", size: 25))
                Text("""
                TODR ( = TOD x 1.25)
                       = \(String(format: "%.0f",(ftTOD * 1.25 / 3.28) )) metres
                
                """)
                .padding(10)
                .frame(width: 300)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(skyBlue)))
                .font(.custom("Noteworthy-Bold", size: 25))
                .foregroundColor(.black)
                .padding(30)
            Button(" OK  "){
                dismiss()
            }
            .font(.custom("Noteworthy Bold", size: 30))
            .foregroundColor(.white)
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 3)
            )
            // .shadow(radius: 5)
        }.frame(width: 320, height: 400, alignment: .center)
        }//.aircraftType(aircraft)
            //.environment(\.aircraftType, "Glider")
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView( ftTOD: .constant(2000), ftTOR: .constant(2000))//, //aircraft: .constant("C152"))
    }
}
