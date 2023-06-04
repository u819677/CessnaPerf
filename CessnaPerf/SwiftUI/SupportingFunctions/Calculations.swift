//
//  Calculations.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//
import TabularData

func todC172P(dataFrame: DataFrame, pressureAltitude: Int, temperature: Int, weight: Int) -> Int {
    let (rowIndexLowerAltitude2400lbs, lowerTemperatureColumn) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: pressureAltitude, temperature: temperature)
    let rowIndexLowerAltitude2200lbs = rowIndexLowerAltitude2400lbs + 4
    let rowIndexLowerAltitude2000lbs = rowIndexLowerAltitude2200lbs + 4
    
    let tod2400lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2400lbs, temperature: temperature, columnIndexLowerTemperature: lowerTemperatureColumn)
    let tod2200lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2200lbs, temperature: temperature, columnIndexLowerTemperature: lowerTemperatureColumn)
    let tod2000lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2000lbs, temperature: temperature, columnIndexLowerTemperature: lowerTemperatureColumn)
    
    let todC172P = todForActualWeightC172P(weight: weight, tod2400: tod2400lbs, tod2200: tod2200lbs, tod2000: tod2000lbs)
    return todC172P
}


func torC172P(dataFrame: DataFrame, pressureAltitude: Int, temperature: Int, weight: Int) -> Int {
    let (rowIndexLowerAltitude2400lbs, columnIndexLowerTemperature) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: pressureAltitude, temperature: temperature)
    let rowIndexLowerAltitude2200lbs = rowIndexLowerAltitude2400lbs + 4
    let rowIndexLowerAltitude2000lbs = rowIndexLowerAltitude2200lbs + 4
    
    let tor2400lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2400lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    let tor2200lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2200lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    let tor2000lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2000lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    
    let torC172P = torForActualWeightC172P(weight: weight, tor2400: tor2400lbs, tor2200: tor2200lbs, tor2000: tor2000lbs)
    return torC172P
}

func todC182RG(dataFrame: DataFrame, pressureAltitude: Int, temperature: Int, weight: Int) -> Int {
    let (rowIndexLowerAltitude3100lbs, lowerTemperatureColumn) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: pressureAltitude, temperature: temperature)
    let rowIndexLowerAltitude2800lbs = rowIndexLowerAltitude3100lbs + 4
    let rowIndexLowerAltitude2500lbs = rowIndexLowerAltitude2800lbs + 4
    
    let tod3100lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude3100lbs, temperature: temperature, columnIndexLowerTemperature: lowerTemperatureColumn)
    let tod2800lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2800lbs, temperature: temperature, columnIndexLowerTemperature: lowerTemperatureColumn)
    let tod2500lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2500lbs, temperature: temperature, columnIndexLowerTemperature: lowerTemperatureColumn)
    
    let todC182RG = todForActualWeightC182RG(weight: weight, tod3100: tod3100lbs, tod2800: tod2800lbs, tod2500: tod2500lbs)
    return todC182RG
}


func torC182RG(dataFrame: DataFrame, pressureAltitude: Int, temperature: Int, weight: Int) -> Int {
    let (rowIndexLowerAltitude3100lbs, columnIndexLowerTemperature) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: pressureAltitude, temperature: temperature)
    let rowIndexLowerAltitude2800lbs = rowIndexLowerAltitude3100lbs + 4
    let rowIndexLowerAltitude2500lbs = rowIndexLowerAltitude2800lbs + 4
    
    let tor3100lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude3100lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    let tor2800lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2800lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    let tor2500lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2500lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    
    let torC182RG = torForActualWeightC182RG(weight: weight, tor3100: tor3100lbs, tor2800: tor2800lbs, tor2500: tor2500lbs)
    return torC182RG
}

func todC152(dataFrame: DataFrame, pressureAltitude: Int, temperature: Int, weight: Int) -> Int {
    let (rowIndexLowerAltitude1670lbs, columnIndexLowerTemperature) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: pressureAltitude, temperature: temperature)
    let tod1670lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude1670lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
//    let todC152 = todForActualWeightC152(weight: weight, tod3100: tod3100lbs, tod2800: tod2800lbs, tod2500: tod2500lbs)
    
    return tod1670lbs
}

func torC152(dataFrame: DataFrame, pressureAltitude: Int, temperature: Int, weight: Int) -> Int {
    let (rowIndexLowerAltitude1670lbs, columnIndexLowerTemperature) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: pressureAltitude, temperature: temperature)
    let tor1670lbs = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude1670lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    
    return tor1670lbs
}



func pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: Int, temperature: Int) -> (Int, Int) {
    var rowIndexLowerPressureAltitude: Int = 0
    var columnIndexLowerTemperature: Int = 0
    switch pressureAltitude {
    case 0...999:
        rowIndexLowerPressureAltitude = 0
    case 1000...1999:
        rowIndexLowerPressureAltitude = 1
    case 2000:
        rowIndexLowerPressureAltitude = 2
    default:
        print("elevation out of range")
    }
    switch temperature {
    case 0...9:
        columnIndexLowerTemperature = 2
    case 10...19:
        columnIndexLowerTemperature = 3
    case 20...29:
        columnIndexLowerTemperature = 4
    case 30...39:
        columnIndexLowerTemperature = 5
    case 40:
        columnIndexLowerTemperature = 6
    default:
        print("temperature out of range")
    }
    return (rowIndexLowerPressureAltitude,columnIndexLowerTemperature)
}

func feetActualPressureAltitudeActualTemperature(dataFrame: DataFrame, pressureAltitude: Int, rowIndexLowerAltitude: Int, temperature: Int, columnIndexLowerTemperature: Int) -> Int {
    let feetLowerAltitudeLowerTemperature = dataFrame.rows[rowIndexLowerAltitude][columnIndexLowerTemperature] as! Int
    let feetLowerAltitudeHigherTemperature = dataFrame.rows[rowIndexLowerAltitude][columnIndexLowerTemperature + 1] as! Int
    let feetLowerAltitudeActualTemperature = feetLowerAltitudeLowerTemperature + (feetLowerAltitudeHigherTemperature - feetLowerAltitudeLowerTemperature) * (temperature % 10) / 10
    
    let feetHigherAltitudeLowerTemperature = dataFrame.rows[rowIndexLowerAltitude + 1][columnIndexLowerTemperature] as! Int
    let feetHigherAltitudeHigherTemperature = dataFrame.rows[rowIndexLowerAltitude + 1][columnIndexLowerTemperature + 1] as! Int
    let feetHigherAltitudeActualTemperature = feetHigherAltitudeLowerTemperature + (feetHigherAltitudeHigherTemperature - feetHigherAltitudeLowerTemperature) * (temperature % 10) / 10
    
    let feetActualAltitudeActualTemperature = feetLowerAltitudeActualTemperature + (feetHigherAltitudeActualTemperature - feetLowerAltitudeActualTemperature) * (pressureAltitude % 1000) / 1000
    
    return feetActualAltitudeActualTemperature
}

func todForActualWeightC172P(weight: Int, tod2400: Int, tod2200: Int, tod2000: Int) -> Int {
    var tod: Int = 0
    switch weight {
    case 2400:
        tod = tod2400
    case  2200...2399:
        tod = tod2200 +  (tod2400 - tod2200) * (weight - 2200) / 200
    case 2000...2199:
        tod = tod2000 + (tod2200 - tod2000) * (weight - 2000) / 200
    default:
        print("weight out of range")
    }
    return tod
}

func torForActualWeightC172P(weight: Int, tor2400: Int, tor2200: Int, tor2000: Int) -> Int {
    var tor: Int = 0
    switch weight {
    case 2400:
        tor = tor2400
    case  2200...2399:
        tor = tor2200 +  (tor2400 - tor2200) * (weight - 2200) / 200
    case 2000...2199:
        tor = tor2000 + (tor2200 - tor2000) * (weight - 2000) / 200
    default:
        print("weight out of range")
    }
    return tor
}

func todForActualWeightC182RG(weight: Int, tod3100: Int, tod2800: Int, tod2500: Int) -> Int {
    var tod: Int = 0
    switch weight {
    case 3100:
        tod = tod3100
    case  2800...3099:
        tod = tod2800 +  (tod3100 - tod2800) * (weight - 2800) / 300
    case 2500...2799:
        tod = tod2500 + (tod2800 - tod2500) * (weight - 2500) / 300
    default:
        print("weight out of range")
    }
    return tod
}

func torForActualWeightC182RG(weight: Int, tor3100: Int, tor2800: Int, tor2500: Int) -> Int {
    var tor: Int = 0
    switch weight {
    case 3100:
        tor = tor3100
    case  2800...3099:
        tor = tor2800 +  (tor3100 - tor2800) * (weight - 2800) / 300
    case 2000...2199:
        tor = tor2500 + (tor2800 - tor2500) * (weight - 2500) / 300
    default:
        print("weight out of range")
    }
    return tor
}

//func todForActualWeightC152()




func OldcorrectedPA(elevationEntry: String, qnhEntry: String) -> (Int, Bool) {
    //MARK:- calculate pa
    if qnhEntry == "1013" {
        return (Int(elevationEntry)!, true)
    } else {
        var pa = Double(elevationEntry)!    //need to protect here for pa < 0 as well as  pa > 2000
        let qnhCorrection = ((Double(qnhEntry)!) - 1013.2) * -27.3
        pa = pa + qnhCorrection
        if pa > 2000.0 {
            return (Int(pa), false)
        } else if pa < 0.0  {
            pa = 0.0
            //  print(" pa is \(pa)")
            return (Int(pa), true)
        } else {
            return (Int(pa), true)
        }
    }
}

func correctedAltitude(for elevation: Int, and qnh: Int) -> Int {
    //MARK:- calculate pa
    if qnh == 1013 {
        return elevation // ?? nil
    } else {
        let qnhCorrection = (Double(qnh) - 1013.2) * -27.3
        var pressureAltitude = Double(elevation) + qnhCorrection// ?? 0)    //need to protect here for pa < 0 as well as  pa > 2000
       // pa = pa + qnhCorrection
//        if pressureAltitude > 2000.0 {
//            return nil
       // } else
    if pressureAltitude < 0.0  {
            pressureAltitude = 0.0
            return (Int(pressureAltitude))
        } else {
            return (Int(pressureAltitude))
        }
    }
}
