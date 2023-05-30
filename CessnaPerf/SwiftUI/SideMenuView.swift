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
 
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 15){
           // Spacer()
            Text("Source data:")
                .font(.title2)
                .foregroundColor(.black)
            Divider()
                .background(Color.black)
            Button {//C152 File will go here
            }
        label: {
            Text("C152    \(Image(systemName: "chevron.forward"))")
                .foregroundColor(.black)
                .font(.title2)
        }
            Divider()
                .background(Color.black)
            Button {
                showFileView =  true
               showSideMenuView = false
            }
                
        label: {
            Text("C172P    \(Image(systemName: "chevron.forward"))")
                .foregroundColor(.black)
                .font(.title2)
        }
            Divider()
                .background(Color.black)
            Button {//C182 File will go here
            }
        label: {
            Text("C182    \(Image(systemName: "chevron.forward"))")
                .foregroundColor(.black)
                .font(.title2)
        }
            Divider()
                .background(Color.black)
        }
         Spacer()
           // Spacer()
            RadioButtonView()
                .padding()
           // Spacer()
        }
        
       // .padding(32)
       
        //.edgesIgnoringSafeArea(.bottom)
        //.ignoresSafeArea(.all)
        .sheet(isPresented: $showFileView) {
            FileView()
        }
        
        .frame(width: UIScreen.main.bounds.width/2)
        .background(Color(skyBlue))
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(showSideMenuView: .constant(true))
    }
}
