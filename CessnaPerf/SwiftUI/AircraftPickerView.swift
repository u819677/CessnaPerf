//
//  AircraftPickerView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 25/05/2023.
//


import SwiftUI
import UIKit

struct AircraftPickerView: View {
    //@Environment(\.dismiss) var dismiss
    @Binding var type: String // = "calm"
    @Binding var showAircraftPicker: Bool
    
    init(type: Binding<String> , showAircraftPicker: Binding<Bool>) {
        self._type = type
        self._showAircraftPicker = showAircraftPicker
    }
    
    
    var body: some View {
        ZStack{
            Image("underwing")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
          //  AircraftPicker(selected: self.)
            VStack {
                Spacer()
                Button(" OK ") {
                   // dismiss()
                }
                .font(.custom("Noteworthy-Bold", size: 30))
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white, lineWidth: 2)
                )
                .padding(.bottom, 150)
            }
        }
    }
}
struct AircraftPicker: UIViewRepresentable{
   
    @Binding var selected: String
    func makeUIView(context: UIViewRepresentableContext<AircraftPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        let selectedRow = pickerRow(selected: selected)
        picker.selectRow(selectedRow, inComponent: 1, animated: true)
        return picker
    }
    func makeCoordinator() -> AircraftPicker.Coordinator {
        Coordinator(self)
    }
    func updateUIView(_ picker: UIViewType, context: UIViewRepresentableContext<AircraftPicker>) {
    }
   
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
       
            var parent: AircraftPicker
            init(_ picker: AircraftPicker) {
                parent = picker
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                return types.count
            }
            func numberOfComponents(in pickerView: UIPickerView) -> Int {
                return 1
            }
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
          //  let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 50))
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            label.text = types[row]
            label.textColor = .black
            
            label.textAlignment = .center
           // label.font = .systemFont(ofSize: 22, weight: .bold)
  
       // label.backgroundColor = UIColor(Color.lightBlue)
            label.font = UIFont(name: "Noteworthy-Bold", size: 25)
            view.backgroundColor = skyBlue
           // label.backgroundColor = .systemCyan
            view.addSubview(label)
            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height / 5
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.white.cgColor
            return view
            }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width - 150
        }
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 50
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selected = types[row]
        }
    }
}
struct AircraftPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftPickerView(type: .constant("type"), showAircraftPicker: .constant(true))
    }
}
var types = ["C152", "C172P","C182"]//
