//
//  ContentView.swift
//  BetterRest
//
//  Created by Aaron Giroux on 1/19/25.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var bedtime: String {
        return ""
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("When do you want to wake up?") {
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    Section("Desired amount of sleep") {
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    Section("Daily coffee intake") {
                        Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
                            ForEach(1...20, id: \.self) {
                                Text("\($0)")
                            }
                        }
                    }
                }
                Text("Your ideal bedtime is: ")
                Text(calculateBedtime())
                    .font(.title2)
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedtime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60 // convert to seconds since midnight
            let minute = (components.minute ?? 0) * 60 // convert to seconds since last hour
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount)) // the model spits out the time the user should go to bed (in seconds past midnight)
            
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Sorry, there was an error calculating your bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
