//
//  WindView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//

import SwiftUI

struct WindView: View {
    let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
    @ObservedObject var wind: Wind
    @State var showPicker: Bool = false
    var body: some View {
      //  NavigationView{   //doesn't go here! The Navigation is from Content view, so that is where it needs to be!
        HStack{
            
            //NavigationLink(destination: WindPicker(windComponent: $wind.windComponent)){
            Text("Wind:     \(wind.windComponent) ")
                .font(.custom("Noteworthy Bold", size: 25))
                .foregroundColor(.black)
                .padding()
            
            
                .padding()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.black)
                .padding()
        }
            .frame(width: 320, height: 35)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(lightBlue)))
            //}//end HStack
            .onTapGesture {
                showPicker = true
                print("tapped WindView")
            }
                .sheet(isPresented: $showPicker) {
                    WindPicker(showPicker: $showPicker, windComponent: $wind.windComponent)
                    //ResultsView(ftTOD: $ftTOD)
                    // Color.green
        
                }
        }
    }
//}
class Wind: ObservableObject {
    @Published var windComponent: String = "calm"
}
//struct WindView_Previews: PreviewProvider {
//    static var previews: some View {
//        WindView(wind: )
//    }
//}
