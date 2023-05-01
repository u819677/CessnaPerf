//
//  ResultsView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//


import SwiftUI

struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var ftTOD: Double
    //@State  var trimmedFeet: String = ""
    //@State var trimmedMetres: String = ""
    //var metres: Double
//    init(ftTOD: Binding<Double>){
//        self._ftTOD = ftTOD
//        print("ftTOD in results view is \(_ftTOD)")
//       trimmedFeet = String(format: "%.1f", self.ftTOD)
//        trimmedMetres = String(format: "%.1f", self.ftTOD * 1.25 / 3.28)
//    }
    var body: some View {
        ZStack{
            Image("airfield")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
               // .offset(x: -100, y: 0)
        VStack{
            // TOD = \(trimmedFeet)ft
            Text("""
                TOD = \(String(format: "%.1f", ftTOD)) ft
                
                TODR (incl x 1.25)
                = \(String(format: "%.1f",(ftTOD * 1.25 / 3.28) )) metres
                """)
              //  = \(trimmedMetres)m
                
           
                
                .font(.custom("Noteworthy Bold", size: 25))
                .foregroundColor(.white)
            .padding(50)
            Button(" OK  "){
                presentationMode.wrappedValue.dismiss()
            }
            //.font(.largeTitle)
            .font(.custom("Noteworthy Bold", size: 30))
            .foregroundColor(.white)
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5)
              
                .stroke(Color.white, lineWidth: 2)
                     )
           // .shadow(radius: 5)
        }.frame(width: 320, height: 400, alignment: .center)
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(ftTOD: .constant(0000.0))
    }
}