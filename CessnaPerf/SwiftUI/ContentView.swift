//
//  WeightView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.

import SwiftUI
import TabularData

enum ActiveSheet: Identifiable, Equatable {
    case firstSheet
    case displayResults
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
    @State private var activeSheet: ActiveSheet?
    
    @StateObject var checkCalc: CheckCalc = CheckCalc()
    
    @State var weightEntry: String = "2400"
    @State var isWeightValid: Bool = true
    @State var tempEntry: String = "15"
    @State var isTempValid: Bool = true
    @State var elevationEntry: String = "1000"
    @State var isElevationValid: Bool = true
    @State var qnhEntry: String = "1013"
    @State var isQNHValid: Bool = true
    @StateObject var wind: Wind = Wind()
    @State var showResults: Bool = false
    
    @State var ftTOD: Double = 0.0
    @State var ftROLL: Double = 0.0
    
    var dataFrame = DataFrame()
    init() {
        let fileURL = Bundle.main.url(forResource: "C172Perf", withExtension: "csv")
        do {
            self.dataFrame = try DataFrame(contentsOfCSVFile: fileURL!)
            print(dataFrame)
        } catch {
            print("url loading failed")
        }
    }
    
    var body: some View {
        //  ScrollView {
        ZStack{
            Image("C172Panel")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            //.padding(10)
            VStack{
                Text("C172P Take Off Performance")
                
                    .font(.custom("Noteworthy Bold", size: 26))
                    .foregroundColor(.white)
                    .padding(5)
                
                
                // MARK: Calculate Button
                
                Button {
                    let (elevation, validPA) = correctedPA(elevationEntry: elevationEntry, qnhEntry: qnhEntry)
                    let temperature = Int(tempEntry)!
                    let weight = Int(weightEntry)!
                    if validPA == false {
                        print("pa out of range")
                        return
                    }
                    ftTOD = Double(todFeet(dataFrame: dataFrame, elevation: elevation, temperature: temperature, weight: weight))
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
                WeightView(weightEntry: $weightEntry, isWeightValid: $isWeightValid)
                    .padding(10)
                
                
                
                TemperatureView(temperatureEntry: $tempEntry, isTempValid: $isTempValid)
                    .padding(10)
                
                ElevationView(elevationEntry: $elevationEntry, isElevationValid: $isElevationValid)
                    .padding(10)
                QNHView(qnhEntry: $qnhEntry, isQNHValid: $isQNHValid)
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
            SheetView(item: item, results: ftTOD)
        }
//        .sheet(isPresented: $showResults) {
//
//            ResultsView(ftTOD: $ftTOD)
//            // Color.green
//
//        }
        // .edgesIgnoringSafeArea(.all)
    }//end of body
    //    @ViewBuilder
    //    private func sheetView(with item: ActiveSheet) -> some View {
    //        switch item {
    //        case .firstSheet:
    //            Color.red
    //        case .displayResults:
    //            Color.green
    //        case .displayWindPicker:
    //            Color.blue
    //        }
    //    }
    
}//end of struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
class CheckCalc: ObservableObject {
    @Published var isValid: Bool = true
}
struct SheetView: View {
    var item: ActiveSheet
   // @Binding var activeSheet: ActiveSheet?
    var results: Double
    var body: some View {
        switch item {
        case .firstSheet:
            Color.red
        case .displayResults:
            ResultsView(ftTOD: 1000.0)//$results)//, activeSheet: activeSheet)
        case .displayWindPicker:
            Color.green
        }
    }
}
