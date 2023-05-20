//
//  Calculations.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//
import TabularData

func todFeet(dataFrame: DataFrame, pressureAltitude: Int, temperature: Int, weight: Int) -> Int {
    let (lowerAltitude2400WeightRowIndex, lowerTemperatureColumn) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: pressureAltitude, temperature: temperature)
    let lowerAltitude2200WeightRowIndex = lowerAltitude2400WeightRowIndex + 4
    let lowerAltitude2000WeightRowIndex = lowerAltitude2200WeightRowIndex + 4
    
    let tod2400 = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, lowerElevationRow: lowerAltitude2400WeightRowIndex, temperature: temperature, lowerTemperatureColumn: lowerTemperatureColumn)
    let tod2200 = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, lowerElevationRow: lowerAltitude2200WeightRowIndex, temperature: temperature, lowerTemperatureColumn: lowerTemperatureColumn)
    let tod2000 = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: pressureAltitude, lowerElevationRow: lowerAltitude2000WeightRowIndex, temperature: temperature, lowerTemperatureColumn: lowerTemperatureColumn)
    
    let tod = todForActualWeight(weight: weight, tod2400: tod2400, tod2200: tod2200, tod2000: tod2000)
    return tod
}


func torFeet(dataFrame: DataFrame, elevation: Int, temperature: Int, weight: Int) -> Int {
    let (lowerElevationRow2400, lowerTemperatureColumn) = pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: elevation, temperature: temperature)
    let lowerElevationRow2200 = lowerElevationRow2400 + 4
    let lowerElevationRow2000 = lowerElevationRow2200 + 4
    
    let tor2400 = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: elevation, lowerElevationRow: lowerElevationRow2400, temperature: temperature, lowerTemperatureColumn: lowerTemperatureColumn)
    let tor2200 = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: elevation, lowerElevationRow: lowerElevationRow2200, temperature: temperature, lowerTemperatureColumn: lowerTemperatureColumn)
    let tor2000 = feetActualPressureAltitudeActualTemperature(dataFrame: dataFrame, pressureAltitude: elevation, lowerElevationRow: lowerElevationRow2000, temperature: temperature, lowerTemperatureColumn: lowerTemperatureColumn)
    
    let tor = torForActualWeight(weight: weight, tor2400: tor2400, tor2200: tor2200, tor2000: tor2000)
    return tor
}


func pressureAltitudeAndTemperatureLowerBoundaryIndicees(pressureAltitude: Int, temperature: Int) -> (Int, Int) {
    var lowerPressureAltitudeRowIndex: Int = 0
    var lowerTemperatureColumnIndex: Int = 0
    switch pressureAltitude {
    case 0...999:
        lowerPressureAltitudeRowIndex = 0
    case 1000...1999:
        lowerPressureAltitudeRowIndex = 1
    case 2000:
        lowerPressureAltitudeRowIndex = 2
    default:
        print("elevation out of range")
    }
    switch temperature {
    case 0...9:
        lowerTemperatureColumnIndex = 2
    case 10...19:
        lowerTemperatureColumnIndex = 3
    case 20...29:
        lowerTemperatureColumnIndex = 4
    case 30...39:
        lowerTemperatureColumnIndex = 5
    case 40:
        lowerTemperatureColumnIndex = 6
    default:
        print("temperature out of range")
    }
    return (lowerPressureAltitudeRowIndex,lowerTemperatureColumnIndex)
}

func feetActualPressureAltitudeActualTemperature(dataFrame: DataFrame, pressureAltitude: Int, lowerElevationRow: Int, temperature: Int, lowerTemperatureColumn: Int) ->
Int {
    let lowerElevationLowerTemperatureDist = dataFrame.rows[lowerElevationRow][lowerTemperatureColumn] as! Int
    let lowerElevationHigherTemperatureDist = dataFrame.rows[lowerElevationRow][lowerTemperatureColumn + 1] as! Int
    let lowerElevationActualTemperatureDist = lowerElevationLowerTemperatureDist + (lowerElevationHigherTemperatureDist - lowerElevationLowerTemperatureDist) * (temperature % 10) / 10
    
    let higherElevationLowerTemperatureDist = dataFrame.rows[lowerElevationRow + 1][lowerTemperatureColumn] as! Int
    let higherElevationHigherTemperatureDist = dataFrame.rows[lowerElevationRow + 1][lowerTemperatureColumn + 1] as! Int
    let higherElevationActualTemperatureDist = higherElevationLowerTemperatureDist + (higherElevationHigherTemperatureDist - higherElevationLowerTemperatureDist) * (temperature % 10) / 10
    
    let todActualElevationActualTemperature = lowerElevationActualTemperatureDist + (higherElevationActualTemperatureDist - lowerElevationActualTemperatureDist) * (pressureAltitude % 1000) / 1000
    
    return todActualElevationActualTemperature
}

func todForActualWeight(weight: Int, tod2400: Int, tod2200: Int, tod2000: Int) -> Int {
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

func torForActualWeight(weight: Int, tor2400: Int, tor2200: Int, tor2000: Int) -> Int {
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

func correctedPA(elevation: Int?, qnh: Int?) -> Int? {
    //MARK:- calculate pa
    if qnh == 1013 {
        return elevation ?? nil
    } else {
        var pa = Double(elevation ?? 0)    //need to protect here for pa < 0 as well as  pa > 2000
        let qnhCorrection = (Double(qnh ?? 0) - 1013.2) * -27.3
        pa = pa + qnhCorrection
        if pa > 2000.0 {
            return nil
        } else if pa < 0.0  {
            pa = 0.0
            return (Int(pa))
        } else {
            return (Int(pa))
        }
    }
}
