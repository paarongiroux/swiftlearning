//
//  ContentView.swift
//  conversion
//
//  Created by Aaron Giroux on 1/16/25.
//

import SwiftUI

struct ContentView: View {
    @State private var inputTemp = 0.0
    
    @State private var unitTypes = ["C", "F", "K"]
    @State private var inputUnit = "C"
    @State private var outputUnit = "F"
    
    var outputTemp: Double {
        
        if (inputUnit == outputUnit) {
            return inputTemp
        }
        if (inputUnit == "C") {
            if (outputUnit == "F") {
                return inputTemp * (9.0 / 5.0) + 32.0
            } else if (outputUnit == "K") {
                return inputTemp + 273.15
            }
        } else if (inputUnit == "F") {
            if (outputUnit == "C") {
                return (inputTemp - 32.0) * 5.0 / 9.0
            } else if (outputUnit == "K") {
                return ((inputTemp - 32.0) * 5.0 / 9.0) + 273.15
            }
        } else if (inputUnit == "K") {
            if (outputUnit == "C") {
                return inputTemp - 273.15
            } else if (outputUnit == "F") {
                return (inputTemp - 273.15) * 9.0 / 5.0 + 32.0
            }
        }
        return 0.0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("insert temperature and select unit") {
                    TextField("Initial Temp", value: $inputTemp, format:.number).keyboardType(.decimalPad)
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(unitTypes, id:\.self) {
                            Text($0)
                        }
                    } . pickerStyle(.menu)
                }
                Section("select output temperature unit") {
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(unitTypes, id:\.self) {
                            Text($0)
                        }
                    } . pickerStyle(.menu)
                }
                Section("output temperature:") {
                    Text(outputTemp, format:.number)
                }
            }
            .navigationTitle("TempConvert")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
