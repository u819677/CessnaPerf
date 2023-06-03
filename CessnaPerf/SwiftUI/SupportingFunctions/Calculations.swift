//
//  Calculations.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//
import TabularData

func feetTOD(dataFrame: DataFrame, pressureAltitude: Int, temperature: Int, weight: Int) -> Int {
    let (rowIndexLowerAltitude2400lbs, lowerTemperatureColumn) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: pressureAltitude, temperature: temperature)
    let rowIndexLowerAltitude2200lbs = rowIndexLowerAltitude2400lbs + 4
    let rowIndexLowerAltitude2000lbs = rowIndexLowerAltitude2200lbs + 4
    
    let todUpperWeight = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2400lbs, temperature: temperature, columnIndexLowerTemperature: lowerTemperatureColumn)
    let todMidWeight = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2200lbs, temperature: temperature, columnIndexLowerTemperature: lowerTemperatureColumn)
    let todLowerWeight = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2000lbs, temperature: temperature, columnIndexLowerTemperature: lowerTemperatureColumn)
    
    let tod = todForActualWeightC172P(weight: weight, tod2400: todUpperWeight, tod2200: todMidWeight, tod2000: todLowerWeight)
    return tod
}


func feetTOR(dataFrame: DataFrame, pressureAltitude: Int, temperature: Int, weight: Int) -> Int {
    let (rowIndexLowerAltitude2400lbs, columnIndexLowerTemperature) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: pressureAltitude, temperature: temperature)
    let rowIndexLowerAltitude2200lbs = rowIndexLowerAltitude2400lbs + 4
    let rowIndexLowerAltitude2000lbs = rowIndexLowerAltitude2200lbs + 4
    
    let torUpperWeight = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2400lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    let torMidWeight = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2200lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    let torLowerWeight = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, rowIndexLowerAltitude: rowIndexLowerAltitude2000lbs, temperature: temperature, columnIndexLowerTemperature: columnIndexLowerTemperature)
    
    let tor = torForActualWeightC172P(weight: weight, tor2400: torUpperWeight, tor2200: torMidWeight, tor2000: torLowerWeight)
    return tor
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
