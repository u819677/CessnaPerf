//
//  WeightView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.

import SwiftUI
import TabularData

enum ActiveSheet: Identifiable, Equatable {
    case firstSheet
    case displayResults//(results)//can't do this, due results is not known here
    case displayWindPicker
    //case addTopic
    //case addNewQuestion
    //case questionAnswerView(Question)
    var id: String {//this is for the enum's id
        let mirror = Mirror(reflecting: self)
        if let label = mirror.children.first?.label {
            return label
        } else {
            return "\(self)"
        }
    }
}

struct ContentView: View {
    
    @FocusState  var focused: Bool?
    @State private var activeSheet: ActiveSheet?
    
    @StateObject var checkCalc: CheckCalc = CheckCalc()
    
    @State var weightEntry: String = "2400"
    @State var isWeightValid: Bool = true
    @State var tempEntry: String = "    "
    @State var isTempValid: Bool = true
    @State var elevationEntry: String = "   "
    @State var isElevationValid: Bool = true
    @State var qnhEntry: String = "    "
    @State var isQNHValid: Bool = true
    @StateObject var wind: Wind = Wind()
    @State var showResults: Bool = false
    
    @State var ftTOD: Double = 0.0
    @State var ftROLL: Double = 0.0
    
   // @FocusState private var showKeyboard: Bool //= false
    //focus state needs to be in environment?
    
    var dataFrame = DataFrame()
    
    let userDefaults = UserDefaults.standard
    
    
    init() {
        let fileURL = Bundle.main.url(forResource: "C172Perf", withExtension: "csv")
        do {
            self.dataFrame = try DataFrame(contentsOfCSVFile: fileURL!)
            //print(dataFrame)
            print(TODDataFrame(dataFrame: dataFrame))
            print(TORDataFrame(dataFrame: dataFrame))
        } catch {
            print("url loading failed")
        }
        //userDefaults.set(Date(), forKey: "timeStamp")
    }
    
    var body: some View {
        //  ScrollView {
        ZStack{
            Image("C172Panel")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focused = nil
                  print("ran focused = nil")
                }
            //.padding(10)
            VStack{
                Text("C172P Take Off Performance")
                
                    .font(.custom("Noteworthy Bold", size: 26))
                    .foregroundColor(.white)
                    .padding(5)
                
                
// MARK: Calculate Button
                
                Button {
                    let todDataFrame = TODDataFrame(dataFrame: dataFrame)
                    let torDataFrame = TORDataFrame(dataFrame: dataFrame)
                    
                    let (elevation, validPA) = correctedPA(elevationEntry: elevationEntry, qnhEntry: qnhEntry)
                    let temperature = Int(tempEntry)!
                    let weight = Int(weightEntry)!
                    if validPA == false {
                        print("pa out of range")
                        return
                    }
                    //first calc calm tod then correct for windComponent
                    ftTOD = Double(todFeet(dataFrame: todDataFrame, elevation: elevation, temperature: temperature, weight: weight))
                    ftTOD = ftTOD * WindComponent(component: wind.windComponent)
                    ftROLL = Double(torFeet(dataFrame: torDataFrame, elevation: elevation, temperature: temperature, weight: weight))
                    ftROLL = ftROLL * WindComponent(component: wind.windComponent)
                    let extraGrassFeet = ftROLL * 0.15
                    ftTOD += extraGrassFeet
                    //showResults = true
                    activeSheet = .displayResults
                }label: {
                    Text("  Calculate  ")
                        .foregroundColor(.white)
                        .font(.custom("Noteworthy Bold", size: 25))
                        .padding(5)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white, lineWidth: 2)
                        )
                        .background(Color.gray)
                }//end of Button
                
                Spacer()
            }
            VStack{
                
                Spacer()
                WeightView(weightEntry: $weightEntry, isWeightValid: $isWeightValid, focused: $focused)
                    .padding(10)
                
                
                
                TemperatureView(temperatureEntry: $tempEntry, isTempValid: $isTempValid, focused: $focused)
                    .padding(10)
                
                ElevationView(elevationEntry: $elevationEntry, isElevationValid: $isElevationValid, focused: $focused)
                    .padding(10)
                QNHView(qnhEntry: $qnhEntry, isQNHValid: $isQNHValid, focused: $focused)
                WindView(wind: wind)
                    .padding(10)
                
                // )
                
                    .padding(12)
                //Spacer()
                Spacer()
                Spacer()
                
            }
            .environmentObject(checkCalc)
            
        }
        .sheet(item: $activeSheet){
            item in
           // SheetView(item: item, results: ftTOD)
            sheetView(with: item)
        }
//        .sheet(isPresented: $showResults) {
//
//            ResultsView(ftTOD: $ftTOD)
//            // Color.green
//
//        }
        // .edgesIgnoringSafeArea(.all)
    }//end of body
        @ViewBuilder
        private func sheetView(with item: ActiveSheet) -> some View {
            switch item {
            case .firstSheet:
                Color.red
            case .displayResults:
                ResultsView(ftTOD: $ftTOD)
               // Color.green
            case .displayWindPicker:
                Color.blue
            }
        }
    
}//end of struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
class CheckCalc: ObservableObject {
    @Published var isValid: Bool = true
}
//struct SheetView: View {
//    var item: ActiveSheet
//   // @Binding var activeSheet: ActiveSheet?
//    var results: Double
//    var body: some View {
//        switch item {
//        case .firstSheet:
//            Color.red
////        case .displayResults:
////            ResultsView(ftTOD: 1000.0)//$results)//, activeSheet: activeSheet)
//        case .displayWindPicker:
//            Color.green
//            default:
//            Color.brown
//        }
//    }
//}
