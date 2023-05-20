//
//  ResultsView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//


import SwiftUI

struct ResultsView: View {
    @Binding var showResults: Bool
    @Binding var ftTOD: Double
    @Binding var ftTOR: Double
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
   // @Binding var activeSheet: ActiveSheet
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
            //now follows a multi-line string literal, line breaks are required
            Text("""
                TOR = \(String(format: "%.0f", ftTOR)) ft
                TOD = \(String(format: "%.0f", ftTOD)) ft
                """)
            .foregroundColor(.white)
            .font(.custom("Noteworthy-Bold", size: 25))
                Text("""
                TODR (= TOD x 1.25)
                       = \(String(format: "%.0f",(ftTOD * 1.25 / 3.28) )) metres
                """)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(lightBlue)))
               // .background(lightBlue)
                
           
                
                .font(.custom("Noteworthy-Bold", size: 25))
                .foregroundColor(.black)
            .padding(30)
            Button(" OK  "){
               // presentationMode.wrappedValue.dismiss()
                showResults = false
            }
            //.font(.largeTitle)
            .font(.custom("Noteworthy Bold", size: 30))
            .foregroundColor(.white)
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 5)
              
                .stroke(Color.white, lineWidth: 3)
                     )
           // .shadow(radius: 5)
        }.frame(width: 320, height: 400, alignment: .center)
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(showResults: .constant(true), ftTOD: .constant(2000), ftTOR: .constant(2000))
        //Color.red
    }
}
