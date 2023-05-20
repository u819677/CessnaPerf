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
                    
                    // MARK: Calculate Button
                    Button {

                        let todDataFrame = TODDataFrame(dataFrame: dataFrame)
                        let torDataFrame = TORDataFrame(dataFrame: dataFrame)

//                        if elevation == nil {
//                            return
//                        }
                        guard let elevation = elevation else {
                            return
                        }
                        guard let qnh = qnh else {
                            return
                        }
                        let pressureAltitude = correctedAltitude(for: elevation, and: qnh)
                       // elevation = correctedPA(elevation: elevation, qnh: qnh)
                        guard let temperature = temperature else {
                            return  //so this would disable the calcultion
                        }
                        guard let weight = weight else {
                            return
                        }

                        ///firstly calc calm tod then correct for windComponent
                        ftTOD = Double(todFeet(dataFrame: todDataFrame, pressureAltitude: elevation, temperature: temperature, weight: weight))
                        ftTOD = ftTOD * WindComponent(component: wind.component)
                        ftTOR = Double(torFeet(dataFrame: torDataFrame, pressureAltitude: elevation, temperature: temperature, weight: weight))
                        ftTOR = ftTOR * WindComponent(component: wind.component)

                        if isGrass {//add 15% of TOR for grass runway
                            let extraGrassFeet = ftTOR * 0.15
                            ftTOD += extraGrassFeet
                            ftTOR += extraGrassFeet
                        }
                        userDefaults.set(Date(), forKey: "calcTime")
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
                }
                VStack{
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
                    //Spacer()
//                    Button {
//
//                        let todDataFrame = TODDataFrame(dataFrame: dataFrame)
//                        let torDataFrame = TORDataFrame(dataFrame: dataFrame)
//
//                        if elevation == nil {
//                            return
//                        }
//
//                        elevation = correctedPA(elevation: elevation, qnh: qnh)
//                        guard let temperature = temperature else {
//                            return  //so this would disable the calcultion
//                        }
//                        guard let weight = weight else {
//                            return
//                        }
//
//                        ///firstly calc calm tod then correct for windComponent
//                        ftTOD = Double(todFeet(dataFrame: todDataFrame, elevation: elevation!, temperature: temperature, weight: weight))
//                        ftTOD = ftTOD * WindComponent(component: wind.component)
//                        ftTOR = Double(torFeet(dataFrame: torDataFrame, elevation: elevation!, temperature: temperature, weight: weight))
//                        ftTOR = ftTOR * WindComponent(component: wind.component)
//
//                        if isGrass {//add 15% of TOR for grass runway
//                            let extraGrassFeet = ftTOR * 0.15
//                            ftTOD += extraGrassFeet
//                            ftTOR += extraGrassFeet
//                        }
//                        userDefaults.set(Date(), forKey: "calcTime")
//                        showResults = true
//
//                        }
//                    label: {
//                        Text("  Calculate  ")
//                                .foregroundColor(.white).bold()
//                            .font(.custom("Noteworthy Bold", size: 25))
//                            .padding(5)
//                           // .background(Color.gray)
//                            .overlay(RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.white, lineWidth: 4).bold()
//                                //.background(Color.gray)
//                            )
//                           // .background(Color.gray)
//                    }///end of Button
                    ///
                    //Spacer()
                }
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


