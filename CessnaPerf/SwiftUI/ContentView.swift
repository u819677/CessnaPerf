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
    @State var isGrass: Bool = false
    @State var showResults: Bool = false
    
    @State var ftTOD: Double = 0.0
    @State var ftROLL: Double = 0.0
    
   // @FocusState private var showKeyboard: Bool //= false
    //focus state needs to be in environment?
    
    var dataFrame = DataFrame()
    
    @Environment(\.scenePhase) var scenePhase
    let userDefaults = UserDefaults.standard
    
    
    init() {
        let fileURL = Bundle.main.url(forResource: "C172Perf", withExtension: "csv")
        do {
            self.dataFrame = try DataFrame(contentsOfCSVFile: fileURL!)

            print(TODDataFrame(dataFrame: dataFrame))
            print(TORDataFrame(dataFrame: dataFrame))
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
                    ///firstly calc calm tod then correct for windComponent
                    ftTOD = Double(todFeet(dataFrame: todDataFrame, elevation: elevation, temperature: temperature, weight: weight))
                    ftTOD = ftTOD * WindComponent(component: wind.windComponent)
                    ftROLL = Double(torFeet(dataFrame: torDataFrame, elevation: elevation, temperature: temperature, weight: weight))
                    ftROLL = ftROLL * WindComponent(component: wind.windComponent)
                    let extraGrassFeet = ftROLL * 0.15
                    if isGrass {//add 15% for grass runway
                        ftTOD += extraGrassFeet
                    }
                    userDefaults.set(Date(), forKey: "calcTime")
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
                SurfaceView(isGrass: $isGrass)
                    .padding(10)
                Spacer()
                Spacer()
                
            }
            .environmentObject(checkCalc)
        }
        .onChange(of: scenePhase) { newPhase in
            print("scenePhase changed")
            if newPhase == .active {
                
                guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date?
                else {
                    return  ///because calc has not been done yet so there's no calcTime
                }
                let calcExpiryTime = calcTime.addingTimeInterval(3600)///calc is valid for 1 hour
                let now = Date()
                if calcExpiryTime < now {
                    ///it's expired so reset to nil
                    userDefaults.set(nil, forKey: "calcTime")
                    weightEntry = "2400"
                    tempEntry = ""
                    elevationEntry = ""
                    qnhEntry = ""
                    wind.windComponent = "calm"
                }
            }
        }
        .sheet(item: $activeSheet){
            item in
            sheetView(with: item)
        }

    }//end of body
        @ViewBuilder
        private func sheetView(with item: ActiveSheet) -> some View {
            switch item {
            case .firstSheet:
                Color.red
            case .displayResults:
                ResultsView(ftTOD: $ftTOD)
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

