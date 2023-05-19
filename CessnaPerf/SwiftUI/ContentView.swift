//
//  WeightView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.

import SwiftUI
import TabularData



struct ContentView: View {
    @State var temperature: Int? // = nil, is that required?
    @State var weight: Int?
    @State var elevation: Int?
    
    @State private var showPressAltAlert = false
    
    @FocusState  var focused: Bool?
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
    @State var ftTOR: Double = 0.0
    
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
       // NavigationStack {
            ZStack{
                Image("C172Panel")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        focused = nil
                    }
                VStack{
                    Text("C172P Take Off Performance")
                        .font(.custom("Noteworthy Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(5)

                    // MARK: Calculate Button
                    Button {
                        if !isWeightValid || !isTempValid || !isElevationValid || !isQNHValid {
                            print("somethings not valid")
                            return
                        }
                        let todDataFrame = TODDataFrame(dataFrame: dataFrame)
                        let torDataFrame = TORDataFrame(dataFrame: dataFrame)
                        
                        let (elevation, validPA) = correctedPA(elevationEntry: elevationEntry, qnhEntry: qnhEntry)
                       // let temperature = Int(tempEntry)!
                        guard let temperature = temperature else {
                            return  //so this would disable the calcultion 
                        }
                        let weight = Int(weightEntry)!

                        if validPA == false {
                            showPressAltAlert = true
                           // return
                        }
                        ///firstly calc calm tod then correct for windComponent
                        ftTOD = Double(todFeet(dataFrame: todDataFrame, elevation: elevation, temperature: temperature, weight: weight))
                        ftTOD = ftTOD * WindComponent(component: wind.component)
                        ftTOR = Double(torFeet(dataFrame: torDataFrame, elevation: elevation, temperature: temperature, weight: weight))
                        ftTOR = ftTOR * WindComponent(component: wind.component)
                        
                        if isGrass {//add 15% of TOR for grass runway
                            let extraGrassFeet = ftTOR * 0.15
                            ftTOD += extraGrassFeet
                            ftTOR += extraGrassFeet
                        }
                        userDefaults.set(Date(), forKey: "calcTime")
                        showResults = true
                        
                        }label: {
                        Text("  Calculate  ")
                            .foregroundColor(.white)
                            .font(.custom("Noteworthy Bold", size: 25))
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 2)
                            )
                            .background(Color.gray)
                    }///end of Button
                    
                    Spacer()
                }
                VStack{
                    
                    Spacer()
                   // oldWeightView(weightEntry: $weightEntry, isWeightValid: $isWeightValid, focused: $focused)
                    WeightView(weight: $weight)
                        .padding(10)
                    
                   // oldTemperatureView(temperatureEntry: $tempEntry, isTempValid: $isTempValid, focused: $focused)
                    TemperatureView(temperature: $temperature)
                        .padding(10)
                    
                   // oldElevationView(elevationEntry: $elevationEntry, isElevationValid: $isElevationValid, focused: $focused)
                    ElevationView(elevation: $elevation)
                        .padding(10)
                    oldQNHView(qnhEntry: $qnhEntry, isQNHValid: $isQNHValid, focused: $focused)
                        .padding()
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
                        wind.component = "calm"
                    }
                }
            }
            .sheet(isPresented: $showResults) {
                ResultsView(showResults: $showResults, ftTOD: $ftTOD,  ftTOR: $ftTOR)
            }
            .alert("Pressure Alt is above 2000ft", isPresented: $showPressAltAlert) {
                Button("OK", role: .cancel) { }
            }
    }///end of body
}///end of struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
class CheckCalc: ObservableObject {
    @Published var isValid: Bool = true
}

