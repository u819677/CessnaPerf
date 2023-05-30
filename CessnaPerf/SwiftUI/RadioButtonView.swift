//
//  RadioButtonView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 26/05/2023.
//
import SwiftUI

struct RadioButtonView: View {
    let userDefaults = UserDefaults.standard
//    init(){
//        print("RadioButtonView init() ran")
//        guard let savedType = userDefaults.object(forKey: "aircraftType") as! String? else {
//            aircraft = "C172"/// this shouldn't be necessary due set already in ContentView.
//            return }
//        aircraft = savedType
//            }
    @Binding var aircraft: String //= 1 //{
    
//        didSet {
//            print("didSet in RadioButtonView ran")
//            if aircraft == 0 {
//
//            }
//            if aircraft == 1 {
//
//            }
//            if aircraft == 2 {
//
//            }
//        }
    //}
//    init() {
//        guard let type = userDefaults.object(forKey: "aircraftType") as! String? else {
//            aircraft = 1
//            return}
//
//    }
            var body: some View {
                VStack(spacing: 20) {
                    VStack{
                        Text("Select aircraft:")
                        HStack{
                            Button{aircraft = "C152"
                               // userDefaults.set("C152", forKey: "aircraftType")
                            } label: {
                                Circle()
                                    .radioButtonStyle()
                                    .foregroundColor(aircraft == "C152" ? Color.black : Color(skyBlue))
                            }
                            Text("C152")
                                .font(.title2)
                        }
                        HStack{
                            Button{aircraft = "C172"
                              //  userDefaults.set("C172", forKey: "aircraftType")
                            } label: {
                                Circle()
                                    .radioButtonStyle()
                                    .foregroundColor(aircraft == "C172" ? Color.black : Color(skyBlue))
                            }
                            Text("C172")
                                .font(.title2)
                            
                        }
                        HStack{
                            Button{aircraft = "C182"
                               // userDefaults.set("C182", forKey: "aircraftType")
                            } label: {
                                Circle()
                                    .radioButtonStyle()
                                    .foregroundColor(aircraft == "C182" ? Color.black : Color(skyBlue))
                            }
                            Text("C182")
                                .font(.title2)
                        }
                    }
                    .padding()
                    .border(.black, width: 2)
                }
                .background(Color(skyBlue))
    }//end body
}//end struct
struct RadioButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RadioButtonView(aircraft: .constant("aircraft"))
    }
}
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 15, height: 15)
           
            .padding()
            .overlay(Circle()//RoundedRectangle(cornerRadius: 50)
                .stroke(Color.black
                        , lineWidth: 4)
                    .scaleEffect(0.5)
            )
    }
}


extension View {
    func radioButtonStyle() -> some View {
        modifier(Title())
    }
}
