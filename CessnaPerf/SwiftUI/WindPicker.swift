//
//  WindPicker.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//


import SwiftUI

struct WindPicker: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var wind: String
     
    var body: some View {
        ZStack {
     
            Image("windsock")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .offset(x: -100, y: 0)

           CustomPicker(wind: $wind)
            VStack{
                Spacer()
                Button(" OK  "){
                    dismiss()
                }
                .font(.custom("Noteworthy Bold", size: 30))
                .foregroundColor(.white)
                
                .overlay(RoundedRectangle(cornerRadius: 5)
                  
                    .stroke(Color.white, lineWidth: 2)
                         )
                .padding(.bottom, 150)
            }
        }
    }
}

struct WindPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPicker(wind: .constant("testing"))
    }
}

///here's the picker being created from uikit. For some reason don't need import UIKit above...
struct CustomPicker : UIViewRepresentable {
    @Binding var wind : String
    
    
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        let selectedRow = pickerRow(selected: wind)
        picker.selectRow(selectedRow, inComponent: 0, animated: true)///this keeps the picker matched to the selection
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
    }
    
    class Coordinator : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent : CustomPicker
        init(_ customPicker : CustomPicker) {/// underscore allows just self to be used above when creating the Coordinator
            self.parent = customPicker
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return components.count
        }
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            ///this is the picker view, within which are the subviews of each element, they are set later
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 150, height: 50))
            let label = UILabel(frame: CGRect(x:0, y:0, width: view.bounds.width, height: view.bounds.height))
            
            label.text = components[row]
            label.textColor = .black
            label.textAlignment = .center

            label.font = UIFont(name: "Noteworthy-Bold", size: 25)
            view.backgroundColor = UIColor(Color(skyBlue))
 
            view.addSubview(label)
            
            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height / 5
            
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.black.cgColor
            return view
        }
        ///this sets the dimensions of the elements in the picker
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width - 100
        }
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 50
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.wind = components[row]
            print("row \(row) was selected")
        }
    }
}
var components = ["9kts HW", "6kts HW", "3kts HW", "calm", "2kts TW", "4kts TW", "6kts TW", "8kts TW" , "10kts TW"]
