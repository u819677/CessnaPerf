//
//  SideMenuView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 23/05/2023.
//


import SwiftUI

struct SideMenuView: View {
    @Binding var showSideMenuView: Bool
    @State var showFileView: Bool = false
    @State var dataFile: String?
    var body: some View {
        VStack{//} (alignment: .trailing){
            Spacer()
            VStack(spacing: 15){
            Text("Source data:")
                .font(.title2)
                .foregroundColor(.black)
            Divider()
                .background(Color.black)
            Button {
                dataFile = "C152"
                showFileView = true
                showSideMenuView = false
            }
        label: {
            Text("C152    \(Image(systemName: "chevron.forward"))")
                .foregroundColor(.black)
                .font(.title2)
                .padding(.trailing, -30)
        }
            Divider()
                .background(Color.black)
            Button {
                dataFile = "C172P"
                showFileView =  true
               showSideMenuView = false
            }
                
        label: {
            Text("C172P    \(Image(systemName: "chevron.forward"))")
                .foregroundColor(.black)
                .font(.title2)
                .padding(.trailing, -20)
        }
            Divider()
                .background(Color.black)
            Button {dataFile = "C182RG"
                showFileView = true
                showSideMenuView = false
            }
        label: {
            Text("C182RG    \(Image(systemName: "chevron.forward"))")
                .foregroundColor(.black)
                .font(.title2)
                .padding(.trailing, -5)
        }
            Divider()
                .background(Color.black)
        }
         Spacer()
            RadioButtonView().padding(.bottom, 20)
        }
        .sheet(isPresented: $showFileView) {
            FileView(dataFile: $dataFile)
        }
        .frame(width: UIScreen.main.bounds.width/2)
        .background(Color(skyBlue))
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(showSideMenuView: .constant(true), dataFile: "C172P")
            .environmentObject(Cessna())
    }
}
