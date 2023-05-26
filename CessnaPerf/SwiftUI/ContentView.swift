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
    
    @State var showSideMenuView: Bool = false
    @State private var showPressAltAlert = false
    
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
                    Text(showSideMenuView ? "" : "C172P Take Off Performance")
                        .font(.custom("Noteworthy Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(.top)
                    Spacer()
                    
                    // MARK: Calculate button logic
                    Button {
                        let todDataFrame = TODDataFrame(dataFrame: dataFrame)
                        let torDataFrame = TORDataFrame(dataFrame: dataFrame)
                        
                        guard let weight = weight, let temperature = temperature, let elevation = elevation, let qnh = qnh  else { return }
                        
                        let pressureAltitude = correctedAltitude(for: elevation, and: qnh)
                        if pressureAltitude > 2000 { showPressAltAlert = true }
                        
                        
                        ///firstly calc calm TOD then correct for windComponent
                        ftTOD = Double(feetTOD(dataFrame: todDataFrame, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                        ftTOD = ftTOD * WindComponent(component: wind)
                        
                        ftTOR = Double(feetTOR(dataFrame: torDataFrame, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
                        ftTOR = ftTOR * WindComponent(component: wind)
                        
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
                    //MARK: Calculate button View
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
                .opacity(showSideMenuView ? 0.0 : 1.0)
                .padding(80)
                }//end of second layer VStack
                .ignoresSafeArea(.keyboard)//this stops Calculate button moving up behind keyboard
                //MARK: textFields layer
               // ScrollView{
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
                    }.padding(.top, 50)///need something like this to prevent top textField go out of view when keyboard
              //  }
                .opacity(showSideMenuView ? 0.0 : 1.0)//end of top layer VStack
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
                                Image(systemName: "")//can't use Spacer() for some reason
                                Spacer()
                                Button{ showSideMenuView = true }
                            label: {
                                Image(systemName: "ellipsis") //Image(systemName: "text.justify")
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.black)
                                    .background(Color(skyBlue))
                                    .mask(Circle())
                                //.opacity(showSideMenuView ? 0.0 : 0.8)
                                
                            }
                            }
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
                      //  wind.component = "calm"
                        wind = "calm"
                    }
                }
            }
            .sheet(isPresented: $showResults) {
                ResultsView(showResults: $showResults, ftTOD: $ftTOD,  ftTOR: $ftTOR)
            }
            .alert("Pressure Altitude is above 2000ft, use POH data", isPresented: $showPressAltAlert) {
                Button("OK", role: .cancel) { }
            }
        }//end NavView
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)///this is prob needed to lock the whole ZStack although still needs the -50 for height of image
      //  .ignoresSafeArea()
    }///end of body
}///end of struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


