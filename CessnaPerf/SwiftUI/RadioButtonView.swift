//
//  RadioButtonView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 26/05/2023.
//
import SwiftUI

struct RadioButtonView: View {
        @State var aircraft: Int = 0
            var body: some View {
                VStack(spacing: 20) {
                    VStack{
                        Text("Select aircraft:")
                        HStack{
                            Button{aircraft = 0} label: {
                                Circle()
                                    .radioButtonStyle()
                                    .foregroundColor(aircraft == 0 ? Color.black : Color.white)
                            }
                            Text("C152")
                                .font(.title2)
                        }
                        HStack{
                            Button{aircraft = 1} label: {
                                Circle()
                                    .radioButtonStyle()
                                    .foregroundColor(aircraft == 1 ? Color.black : Color.white)
                            }
                            Text("C172")
                                .font(.title2)
                            
                        }
                        HStack{
                            Button{aircraft = 2} label: {
                                Circle()
                                    .radioButtonStyle()
                                    .foregroundColor(aircraft == 2 ? Color.black : Color.white)
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
        RadioButtonView()
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
