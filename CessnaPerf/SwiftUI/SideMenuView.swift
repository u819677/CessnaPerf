//
//  SideMenuView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 23/05/2023.
//


import SwiftUI

struct SideMenuView: View {
    @State var showPDFUIView: Bool = false
    @Binding var showSideMenuView: Bool
    var body: some View {
        VStack {
            Text("Source data used in this app:")
                .font(.title2)
                .foregroundColor(.black)
               // .frame(width: 150)
            Divider()
               // .frame(width: 100, height: 2)
                .background(Color.black)
            
            Button {showPDFUIView =  true
                showSideMenuView = false
            }
        label: {
                Text("C172P    \(Image(systemName: "chevron.forward"))")
                    .foregroundColor(.black)
                .font(.title2)
                //.frame(width: 120)
            }
            Divider()
                //.frame(width: 100, height: 2)
                .background(Color.black)
          //  Text (
//                .padding(.horizontal, 16)
//
//            Link(destination: URL(string: "https//apple.com")!){Text("Apple")}
//                .foregroundColor(.white)
            Spacer()
        }
        
       // .padding(32)
        .background(Color(skyBlue))
        .edgesIgnoringSafeArea(.bottom)
        //.ignoresSafeArea(.all)
        .sheet(isPresented: $showPDFUIView) {
//            WindPicker(showPicker: $showPicker, windComponent: $wind.component)
            PDFUIView(showPDFUIView: $showPDFUIView)  //showDataView: $showDataView)
        }
        
        .frame(width: UIScreen.main.bounds.width/2)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(showSideMenuView: .constant(true))
    }
}
//let skyBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
