//
//  WeightView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.

import SwiftUI
import TabularData



struct ContentView: View {
    @State var temperature: Int? // = nil, is that required?
    @State var weight: Int? //= 2400
    @State var elevation: Int?
    @State var qnh: Int?
    
    @State private var showPressAltAlert = false

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
            ZStack{
                Image("GApanel")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Text("C172P Take Off Performance")
                        .font(.custom("Noteworthy Bold", size: 26))
                        .foregroundColor(.white)
                    Spacer()
                    
                    // MARK: Calculate
                    Button {
                        let todDataFrame = TODDataFrame(dataFrame: dataFrame)
                        let torDataFrame = TORDataFrame(dataFrame: dataFrame)

                        guard let weight = weight, let temperature = temperature, let elevation = elevation, let qnh = qnh  else { return }
           
                        let pressureAltitude = correctedAltitude(for: elevation, and: qnh)
                        if pressureAltitude > 2000 { showPressAltAlert = true }
                            
                     
                        ///firstly calc calm TOD then correct for windComponent
                        ftTOD = Double(feetTOD(dataFrame: todDataFrame, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                        ftTOD = ftTOD * WindComponent(component: wind.component)
                        ftTOR = Double(feetTOR(dataFrame: torDataFrame, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                        ftTOR = ftTOR * WindComponent(component: wind.component)

                        if isGrass {//add 15% of TOR for grass runway
                            let extraGrassFeet = ftTOR * 0.15
                            ftTOD += extraGrassFeet
                            ftTOR += extraGrassFeet
                        }

                        guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date? else {
                           let calcTime = Date()
                            userDefaults.set(calcTime, forKey: "calcTime")
                            showResults = true
                            return
                        }
                        ///there's already a calcTime but no need to update it if it was done very recently, and better not to update it due other work that UserDefaults do in background
                            let elapsedTimeSinceCalc = calcTime.timeIntervalSinceNow
                        if elapsedTimeSinceCalc < -100 {    ///100s min time between calcTime updates should be ok.
                            let newCalcTime = Date()
                            userDefaults.set(newCalcTime, forKey: "calcTime")
                        }
                        showResults = true
                        }
                    label: {
                        Text("  Calculate  ")
                                .foregroundColor(.white).bold()
                            .font(.custom("Noteworthy Bold", size: 25))
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 4).bold()
                            )
                            .background(Color.gray)
                    }///end of Button
                    .padding(80)
                }//end of second layer VStack
                VStack{//this layer is on top of the image and then the Calculate button
                    Spacer()
                    WeightView(weight: $weight)
                        .padding(10)
                    TemperatureView(temperature: $temperature)
                        .padding(10)
                    ElevationView(elevation: $elevation)
                        .padding(10)
                    QNHView(qnh: $qnh)
                        .padding()
                    WindView(wind: wind)
                        .padding(10)
                    SurfaceView(isGrass: $isGrass)
                        .padding(10)
                    Spacer()
                }//end of top layer VStack
            }//end of ZStack
            .onChange(of: scenePhase) { newPhase in
                print("scenePhase in ContentView changed")
                if newPhase == .active {
                    guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date? else { return}
                    ///above guard returns if there's no calcTime because calc has not been done yet. Even if fields are populated that's ok, they've not been used for a calculation yet.
                    ///now check for a valid calcTime but need to check if it's expired:
                    if calcTime.timeIntervalSinceNow < -3600 {
                        ///it's expired so reset values to nil
                        userDefaults.set(nil, forKey: "calcTime")
                        weight = nil
                        temperature = nil
                        elevation = nil
                        qnh = nil
                        wind.component = "calm"
                    }
                }
            }
            .sheet(isPresented: $showResults) {
                ResultsView(showResults: $showResults, ftTOD: $ftTOD,  ftTOR: $ftTOR)
            }
            .alert("Pressure Altitude is above 2000ft, use POH data", isPresented: $showPressAltAlert) {
                Button("OK", role: .cancel) { }
            }
    }///end of body
}///end of struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


