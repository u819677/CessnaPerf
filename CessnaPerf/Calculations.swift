//
//  Calculations.swift
//  CessnaPerf
//
//  Created by Richard Clark on 01/05/2023.
//
import TabularData

func todFeet(dataFrame: DataFrame, elevation: Int, temperature: Int, weight: Int) -> Int {
    let (lowerElevationRow2400, lowerTemperatureColumn) = lowerElevationAndTemperatureBoundaryIndicees(elevation: elevation, temperature: temperature)
    let lowerElevationRow2200 = lowerElevationRow2400 + 4
    let lowerElevationRow2000 = lowerElevationRow2200 + 4
    
    let tod2400 = todActualElevationActualTemperature(dataFrame: dataFrame, elevation: elevation, lowerElevationRow: lowerElevationRow2400, temperature: temperature, lowerTemperatureColumn: lowerTemperatureColumn)
    let tod2200 = todActualElevationActualTemperature(dataFrame: dataFrame, elevation: elevation, lowerElevationRow: lowerElevationRow2200, temperature: temperature, lowerTemperatureColumn: lowerTemperatureColumn)
    let tod2000 = todActualElevationActualTemperature(dataFrame: dataFrame, elevation: elevation, lowerElevationRow: lowerElevationRow2000, temperature: temperature, lowerTemperatureColumn: lowerTemperatureColumn)
    
    let tod = todForActualWeight(weight: weight, tod2400: tod2400, tod2200: tod2200, tod2000: tod2000)
    return tod
}

func lowerElevationAndTemperatureBoundaryIndicees(elevation: Int, temperature: Int) -> (Int, Int) {
    var lowerElevationRow: Int = 0
    var lowerTemperatureColumn: Int = 0
    switch elevation {
    case 0...999:
        lowerElevationRow = 0
    case 1000...1999:
        lowerElevationRow = 1
    case 2000:
        lowerElevationRow = 2
    default:
        print("elevation out of range")
    }
    switch temperature {
    case 0...9:
        lowerTemperatureColumn = 2
    case 10...19:
        lowerTemperatureColumn = 3
    case 20...29:
        lowerTemperatureColumn = 4
    case 30...39:
        lowerTemperatureColumn = 5
    case 40:
        lowerTemperatureColumn = 6
    default:
        print("temperature out of range")
    }
    return (lowerElevationRow,lowerTemperatureColumn)
}

func todActualElevationActualTemperature(dataFrame: DataFrame, elevation: Int, lowerElevationRow: Int, temperature: Int, lowerTemperatureColumn: Int) ->
Int {
    let lowerElevationLowerTemperatureDist = dataFrame.rows[lowerElevationRow][lowerTemperatureColumn] as! Int
    let lowerElevationHigherTemperatureDist = dataFrame.rows[lowerElevationRow][lowerTemperatureColumn + 1] as! Int
    let lowerElevationActualTemperatureDist = lowerElevationLowerTemperatureDist + (lowerElevationHigherTemperatureDist - lowerElevationLowerTemperatureDist) * (temperature % 10) / 10
    
    let higherElevationLowerTemperatureDist = dataFrame.rows[lowerElevationRow + 1][lowerTemperatureColumn] as! Int
    let higherElevationHigherTemperatureDist = dataFrame.rows[lowerElevationRow + 1][lowerTemperatureColumn + 1] as! Int
    let higherElevationActualTemperatureDist = higherElevationLowerTemperatureDist + (higherElevationHigherTemperatureDist - higherElevationLowerTemperatureDist) * (temperature % 10) / 10
    
    let todActualElevationActualTemperature = lowerElevationActualTemperatureDist + (higherElevationActualTemperatureDist - lowerElevationActualTemperatureDist) * (elevation % 1000) / 1000
    
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

func correctedPA(elevationEntry: String, qnhEntry: String) -> (Int, Bool) {
    //MARK:- calculate pa
    if qnhEntry == "1013" {
        return (Int(elevationEntry)!, true)
    } else {
        var pa = Double(elevationEntry)!    //need to protect here for pa < 0 as well as  pa > 2000
        let qnhCorrection = ((Double(qnhEntry)!) - 1013.2) * -27.3
        pa = pa + qnhCorrection
        if pa > 2000.0 || pa < 0.0 {
            return (Int(pa), false)
        } else {
            print(" pa is \(pa)")
            return (Int(pa), true)
            
 
        }
    }
}
