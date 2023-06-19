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
    
    @State var keyboardShowing: Bool = false    //allows to hide some Views when keyboard visible
    var dataFrameC172P = DataFrame(), dataFrameC182RG = DataFrame(), dataFrameC152 = DataFrame()
    
    @Environment(\.scenePhase) var scenePhase
    
    let userDefaults = UserDefaults.standard
    
    @StateObject var cessna = Cessna()///this allows access to Cessna class from various child views
    //MARK: init
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
                    Text(showSideMenuView ? "" : "\(cessna.type) Take Off Perf")///clears the title for the side menu
                        .font(.custom("Noteworthy Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(.top)
                    Spacer()

                .sheet(isPresented: $showResults) { ///this can go elsewhere but seems good idea to put close to Button
                    ResultsView(ftTOD: $ftTOD,  ftTOR: $ftTOR)
                }
                .opacity(showSideMenuView ? 0.0 : 1.0)
                }//end of second layer VStack
                .ignoresSafeArea(.keyboard)///this stops Compute button moving up behind keyboard
                
                //MARK: textFields layer
                VStack{//this layer is on top of the image and then the Calculate button
                    Spacer()
                    WeightView(weight: $weight).padding(10)
                    TemperatureView(temperature: $temperature).padding(10)
                    ElevationView(elevation: $elevation).padding(10)
                    QNHView(qnh: $qnh).padding(10)
                    WindView(wind: $wind).padding(10)
                    SurfaceView(isGrass: $isGrass).padding(10).opacity(keyboardShowing ? 0 : 1)//.animation(.easeInOut, value: 10)
                   
                        Button{
                            compute()} label: {
                                computeLabel
                            }.padding(30).opacity(keyboardShowing ? 0 : 1)
                    Spacer()
                }.padding(.top, 70)///need something like this to prevent top textField go out of view when keyboard
                    .opacity(showSideMenuView ? 0.0 : 1.0)//end of top layer VStack
                    .ignoresSafeArea(.keyboard)
                Color.black
                    .opacity(showSideMenuView ? 0.5 : 0.0)
                    .onTapGesture {
                        showSideMenuView = false    ///the way to clear away the side menu view
                    }
                
                //MARK: SideView layer
                
                SideMenuView(showSideMenuView: $showSideMenuView)
                    .offset(x:showSideMenuView ? -UIScreen.main.bounds.width/4 : -UIScreen.main.bounds.width )
                    .animation(.easeInOut(duration: 0.4), value: showSideMenuView)
                
           
                   
            }//end of ZStack
            //MARK: toolbar
            .toolbar {
                if showSideMenuView == false {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer().allowsHitTesting(false)
                       // Button("TEST") {}
                       // HStack{
//                                    Text("")
//                                        .border(.white,width: 2)
                         //   Spacer()///pushes ellipsis toolbar icon to the right edge
                            Button{ showSideMenuView = true }
                        label: {
                            Image(systemName: "ellipsis") //Image(systemName: "text.justify") //(is another option)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                                .background(Color(skyBlue))
                                .mask(Circle())
                                .padding()//.bottom,20)
                        }
                     //   }//end of HStack
                       // .frame(width: UIScreen.main.bounds.width)
                      //  .padding(.bottom, 25)
                        //.border(.green, width: 4)
                    }
                }
            }//end of .toolbar
          //  .border(.black, width: 5)
            
            
            //MARK: userDefaults update
            .onChange(of: scenePhase) { newPhase in///scope comes here if maybe app has been asleep then woken up
                if newPhase == .active {
                    guard let calcTime = userDefaults.object(forKey: "calcTime") as! Date? else { return}
                    ///above guard returns if there's no calcTime because calc has not been done yet. Even if fields are populated that's ok, they've not been used for a calculation yet.
                    ///now check for a valid calcTime but need to check if it's expired:
                    if calcTime.timeIntervalSinceNow < -3600 {
                        ///calcTime is more than one hour old so calculation needs to be done again: so reset all values to nil
                        userDefaults.set(nil, forKey: "calcTime")
                        weight = nil
                        temperature = nil
                        elevation = nil
                        qnh = nil
                        wind = "calm"
                    }
                }
            }
        }//end NavView
        .alert("Pressure Altitude is above 2000ft: use POH data", isPresented: $showPressAltAlert) {
            Button("OK", role: .cancel) { }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)///this is prob needed to lock the whole ZStack although still needs the -50 for height of image
        .environmentObject(cessna)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            print("keyboardWillShowNotification")
            keyboardShowing = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            print("keyboardWillHideNotification")
            keyboardShowing = false
        }
    }///end of body
    
    ///
    //MARK: Compute Button
    @ViewBuilder var computeLabel: some View {
        Text("Compute")
            .padding(10)
            .foregroundColor(.white).bold()
            //.border(.white, width: 3)
            .font(.custom("Noteworthy Bold", size: 25))
           
            .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 4).bold()
            )
            .background {Color.gray} /// a lot of different ways to add this background, this is only way that works and doesn't 'leak' to the edge of the view
    }
    func compute() -> Void {
        if cessna.type == "C152" {weight = 1670}///tried setting this in WeightView but didn't get back here
        let todDataFrameC172P = TODDataFrame(dataFrame: dataFrameC172P)
        let torDataFrameC172P = TORDataFrame(dataFrame: dataFrameC172P)
        
        let todDataFrameC182RG = TODDataFrame(dataFrame: dataFrameC182RG)
        let torDataFrameC182RG = TORDataFrame(dataFrame: dataFrameC182RG)
        
        let todDataFrameC152 = TODDataFrame(dataFrame: dataFrameC152)
        let torDataFrameC152 = TORDataFrame(dataFrame: dataFrameC152)
        
        guard let weight = weight, let temperature = temperature, let elevation = elevation, let qnh = qnh  else { return }
        
        let pressureAltitude = correctedAltitude(for: elevation, and: qnh)
        if pressureAltitude > 2000 {
            showPressAltAlert = true
            return  ///Without this return cannot display results sheet!
        }
        
        switch cessna.type {
            /// for each type: firstly calc calm TOD then correct for windComponent.  Then repeat using TOR figures.
        case "C172P":
            ftTOD = Double(todC172P(dataFrame: todDataFrameC172P, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
            ftTOD = ftTOD * Factor(for: wind)
            ftTOR = Double(torC172P(dataFrame: torDataFrameC172P, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
            ftTOR = ftTOR * Factor(for: wind)
            
        case "C182RG":
            ftTOD = Double(todC182RG(dataFrame: todDataFrameC182RG, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
            ftTOD = ftTOD * Factor(for: wind)
            ftTOR = Double(torC182RG(dataFrame: torDataFrameC182RG, pressureAltitude: pressureAltitude, temperature: temperature, weight: weight))
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
            print("no calcTime was in userDefaults")
            return
        }
        ///there's already a calcTime so need to update it if it was done very recently, and anyway it's better not to update it too often due other work that UserDefaults do in background. This is to stop crashing in case of mashing the Compute button.
        let elapsedTimeSinceCalc = calcTime.timeIntervalSinceNow
        if elapsedTimeSinceCalc < -100 {    ///only create new calcTime if existing calcTime is more than 100s old
            let newCalcTime = Date()
            userDefaults.set(newCalcTime, forKey: "calcTime")
        }
        showResults = true
    }//end of Compute button
    
    
    
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

