//
//  RadioButtonView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 26/05/2023.
//
import SwiftUI

struct RadioButtonView: View {
    @EnvironmentObject var cessna: Cessna
    @EnvironmentObject var dataEntry: DataEntry

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading){
                Text("Select aircraft:")
                    .font(.title2)
                HStack{
                    Button{cessna.type = "C152"
                        dataEntry.clear = true
                    }
                label: {
                        Circle()
                            .radioButtonStyle()
                            .foregroundColor(cessna.type == "C152" ? Color.black : Color(skyBlue))
                    }
                    Text("C152")
                        .font(.title2)
                }
                HStack{
                    Button{cessna.type = "C172P"
                        dataEntry.clear = true

                    }
                label: {
                    Circle()
                        .radioButtonStyle()
                        .foregroundColor(cessna.type == "C172P" ? Color.black : Color(skyBlue))
                }
                    Text("C172P")
                        .font(.title2)
                }
                HStack{
                    Button{cessna.type = "C182RG"
                        dataEntry.clear = true

                    }
                label: {
                    Circle()
                        .radioButtonStyle()
                        .foregroundColor(cessna.type == "C182RG" ? Color.black : Color(skyBlue))
                }
                    Text("C182RG")
                        .font(.title2)
                }
            }
            .padding()
            .border(.black, width: 2)
            .padding(5)
        }
        .background(Color(skyBlue))
        //.environmentObject(Cessna())
    }//end body
        
}//end struct
struct RadioButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RadioButtonView().environmentObject(Cessna())
    }
}
struct RadioButtonStyle: ViewModifier {
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
        modifier(RadioButtonStyle())
    }
}
