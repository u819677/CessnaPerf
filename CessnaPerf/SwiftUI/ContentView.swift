//
//  WeightView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.

import SwiftUI
import TabularData

struct ContentView: View {
    // MARK: Properties
    @State var temperature: Int?
    @State var weight: Int?
    @State var elevation: Int?
    @State var qnh: Int?
    @State var wind: String = "calm"
    
    @State var showSideMenuView: Bool = false {
        didSet {
            if showSideMenuView == false {
                ///save the type that is selected at the point of leaving the sideMenuView
                userDefaults.set(cessna.type, forKey: "aircraftType")
            }
        }
    }
    @State private var showPressAltAlert = false
    
    @State var isGrass: Bool = false
    
    @State var showResults: Bool = false
    
    @State var ftTOD: Double = 0.0
    @State var ftTOR: Double = 0.0
    
    var dataFrameC172P = DataFrame()
    var dataFrameC182RG = DataFrame()
    var dataFrameC152 = DataFrame()
    
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.isFocused) var isFocused
    let userDefaults = UserDefaults.standard

    @StateObject var cessna = Cessna(){
        didSet {
            print("cessna didset in ContentView ran")
        }
    }
    init() {
        let fileURLC172P = Bundle.main.url(forResource: "C172Pdata", withExtension: "csv")
        let fileURLC182RG = Bundle.main.url(forResource: "C182RGdata", withExtension: "csv")
        let fileURLC152 = Bundle.main.url(forResource: "C152data", withExtension: "csv")
        
        do {self.dataFrameC172P = try DataFrame(contentsOfCSVFile: fileURLC172P!) }
        catch {print("C172 url loading failed") }
  
        do { self.dataFrameC182RG = try DataFrame(contentsOfCSVFile: fileURLC182RG!)}
        catch {print("C182 url loading failed")}
            
        do {self.dataFrameC152 = try DataFrame(contentsOfCSVFile: fileURLC152!)}
        catch {print("C152 url loading failed")}
            
        guard (userDefaults.object(forKey: "aircraftType") as! String?) != nil
        else { userDefaults.set("C172P", forKey: "aircraftType")
            return }
    }
 
    //MARK: body
    var body: some View {
        NavigationView {
            ZStack{
                Image("GApanel2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .ignoresSafeArea(.keyboard)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-50)

                VStack{
                    Text(showSideMenuView ? "" : "\(cessna.type) Take Off Perf")
                        .font(.custom("Noteworthy Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(.top)
                    Spacer()
               
                    // MARK: Compute button logic
                    Button {
                        print("cessna.type is \(cessna.type)")
                        if cessna.type == "C152" {weight = 1670}///tried setting this in WeightView but didn't get back here
                        ///
                        let todDataFrameC172 = TODDataFrame(dataFrame: dataFrameC172P)
                        let torDataFrameC172 = TORDataFrame(dataFrame: dataFrameC172P)
                        let todDataFrameC182 = TODDataFrame(dataFrame: dataFrameC182RG)
                        let torDataFrameC182 = TORDataFrame(dataFrame: dataFrameC182RG)
                        let todDataFrameC152 = TODDataFrame(dataFrame: dataFrameC152)
                        let torDataFrameC152 = TORDataFrame(dataFrame: dataFrameC152)
                        
                        guard let weight = weight, let temperature = temperature, let elevation = elevation, let qnh = qnh  else { return }
                        
                        let pressureAltitude = correctedAltitude(for: elevation, and: qnh)
                        if pressureAltitude > 2000 { showPressAltAlert = true }
                        
                        switch cessna.type {
                        case "C172P":
                            ///firstly calc calm TOD then correct for windComponent, then repeat for TOR
                            ftTOD = Double(todC172P(dataFrame: todDataFrameC172, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                            ftTOD = ftTOD * Factor(for: wind)
                            ftTOR = Double(torC172P(dataFrame: torDataFrameC172, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                            ftTOR = ftTOR * Factor(for: wind)
                            
                        case "C182RG":
                            ///firstly calc calm TOD then correct for windComponent, then repeat for TOR
                            ftTOD = Double(todC182RG(dataFrame: todDataFrameC182, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                            ftTOD = ftTOD * Factor(for: wind)
                            ftTOR = Double(torC182RG(dataFrame: torDataFrameC182, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                            ftTOR = ftTOR * Factor(for: wind)
                            
                        case "C152":
                            ftTOD = Double(todC152(dataFrame: todDataFrameC152, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                            ftTOD = ftTOD * Factor(for: wind)
                            ftTOR = Double(torC152(dataFrame: torDataFrameC152, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                            ftTOR = ftTOR * Factor(for: wind)
                        default:
                            return
                        }

                        if isGrass {//add 15% of TOR in case of grass runway
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
                        ///there's already a calcTime so need to update it if it was done very recently, and anyway it's better not to update it too often due other work that UserDefaults do in background. This is to stop crashing in case of mashing the Compute button.
                        let elapsedTimeSinceCalc = calcTime.timeIntervalSinceNow
                        if elapsedTimeSinceCalc < -100 {    ///100s min time between calcTime updates should be ok.
                            let newCalcTime = Date()
                            userDefaults.set(newCalcTime, forKey: "calcTime")
                        }
                        showResults = true
                    }
                    //MARK: Calculate button View
                label: {
                    Text("  Compute  ")
                        //.background(.gray)
                        .foregroundColor(.white).bold()
                        .font(.custom("Noteworthy Bold", size: 25))
                       // .background(.gray)
                        .padding(5)
                   //    .background(.red)
                        //.background(Color.gray)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white, lineWidth: 4).bold()
                        )
                        .background {Color.gray}
                       // .background(Color.gray)
                }///end of Button
                .opacity(showSideMenuView ? 0.0 : 1.0)
                .padding()
                }//end of second layer VStack
                .ignoresSafeArea(.keyboard)///this stops Compute button moving up behind keyboard
               // .border(.green, width: 4)
                //MARK: textFields layer
                    VStack{//this layer is on top of the image and then the Calculate button
                        Spacer()
                        WeightView(weight: $weight)
                            .padding(10)
                        TemperatureView(temperature: $temperature)
                            .padding(10)
                        ElevationView(elevation: $elevation)
                            .padding(10)
                        QNHView(qnh: $qnh)
                            .padding(10)
                        WindView(wind: $wind)
                            .padding(10)
                        SurfaceView(isGrass: $isGrass)
                            .padding(10)
                        Spacer()
                    }.padding(.top, 70)///need something like this to prevent top textField go out of view when keyboard
                .opacity(showSideMenuView ? 0.0 : 1.0)//end of top layer VStack
                //.border(Color.blue, width: 2)
                Color.black
                    .opacity(showSideMenuView ? 0.5 : 0.0)
                    .onTapGesture {
                        showSideMenuView = false
                    }

           //MARK: SideView layer
          
                SideMenuView(showSideMenuView: $showSideMenuView)
                    .offset(x:showSideMenuView ? -UIScreen.main.bounds.width/4 : -UIScreen.main.bounds.width )
                    .animation(.easeInOut(duration: 0.4), value: showSideMenuView)
  
                //MARK: toolbar
                .toolbar {
                    if showSideMenuView == false {
                        ToolbarItemGroup(placement: .bottomBar) {
                            HStack{
                                Text("")
                                Spacer()///pushes ellipsis toolbar icon to the right edge
                                Button{ showSideMenuView = true }
                            label: {
                                Image(systemName: "ellipsis") //Image(systemName: "text.justify")
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.black)
                                    .background(Color(skyBlue))
                                    .mask(Circle())                                
                            }
                            }//end of HStack
                            .padding(.bottom, 25)
                        }
                    }
                }//end of .toolbar
            }//end of ZStack
            //MARK: userDefaults update
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
                        wind = "calm"
                    }
                }
            }
            .onChange(of: isFocused) { _ in
                print("isFocused changed")
            }//doesn't seem to trigger
            .sheet(isPresented: $showResults) {
                ResultsView(ftTOD: $ftTOD,  ftTOR: $ftTOR)
            }
            .alert("Pressure Altitude is above 2000ft, use POH data", isPresented: $showPressAltAlert) {
                Button("OK", role: .cancel) { }
            }
        }//end NavView
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)///this is prob needed to lock the whole ZStack although still needs the -50 for height of image
       // .border(Color.white, width: 2)
        .environmentObject(cessna)
    }///end of body
}///end of struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class Cessna: ObservableObject {
    @Published var type: String = "C172P"
    init() {
        let userDefaults = UserDefaults.standard
        guard let type = userDefaults.object(forKey: "aircraftType") as! String? else {return}///this is checking to see the last used aircraft type. If not then the default is C172P otherwise it's set to previously used type.
        self.type = type
    }
}

