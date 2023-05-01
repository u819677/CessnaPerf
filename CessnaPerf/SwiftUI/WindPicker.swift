//
//  WindPicker.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//

//
//  UIPicker.swift
//  PickerTesting
//
//  Created by Richard Clark on 01/05/2023.
//

import SwiftUI
import UIKit
import Foundation

struct WindPicker: View {

    @Binding var windComponent: String // = "calm"
    init(windComponent: Binding<String>){
        self._windComponent = windComponent
    }
   
    
    
   // @State var selected = "two"
    var body: some View {
        ZStack {
     
            Image("windsock")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .offset(x: -100, y: 0)
             
        CustomPicker(selected: self.$windComponent)
        }
    }
}

struct WindPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPicker(selected: .constant("testing"))
    }
}
struct CustomPicker : UIViewRepresentable {
    @Binding var selected : String
    func makeCoordinator() -> CustomPicker.Coordinator {
        
        return CustomPicker.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
        
    }
    class Coordinator : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent : CustomPicker
        init(parent1 : CustomPicker) {
            parent = parent1
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return components.count
            
        }
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
//        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//            return data[row]
//        }
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
           // let view = UIView()//not sure why need complexity of following mod to view
            let lightBlue = UIColor(hue: 0.5472, saturation: 0.42, brightness: 0.97, alpha: 1.0)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 50))
            
            let label = UILabel(frame: CGRect(x:0, y:0, width: view.bounds.width, height: view.bounds.height))
            
            label.text = components[row]
            label.textColor = .black
            label.textAlignment = .center
           // label.font = .systemFont(ofSize: 25, weight: .bold)
                //label.font(custom("Noteworthy Bold", size: 25))
            label.font = UIFont(name: "NoteworthyBold", size: 25)
            view.backgroundColor = lightBlue
 
            view.addSubview(label)
            
            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height / 5
            
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor.white.cgColor
            return view
        }
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width - 100
        }
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 50
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selected = components[row]
        }
        
    }
}
var components = ["9kt HW", "6kts HW", "3kts HW", "calm", "2kts TW", "4kts TW", "6kts TW", "8kts TW" , "10kts TW"]
//var components = ["one", "two", "three"]
