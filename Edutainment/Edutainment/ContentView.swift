//
//  ContentView.swift
//  Edutainment
//
//  Created by Aaron Giroux on 1/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var timesTableSelection = 2
    @State private var numQuestions = 10
    var questions = [5, 10, 15];
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Select a time table to practice") {
                        Stepper("\(timesTableSelection)", value: $timesTableSelection, in: 2...12)
                    }
                    Section("How many questions do you want?") {
                        Picker("", selection: $numQuestions) {
                            ForEach(questions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                }
                NavigationLink("Go!") {
                    QuestionsView(mult:timesTableSelection, numQuestions: numQuestions)
                }
            }
            .navigationTitle("Select Quiz")
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
