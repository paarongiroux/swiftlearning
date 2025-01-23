//
//  QuestionsView.swift
//  Edutainment
//
//  Created by Aaron Giroux on 1/23/25.
//

import SwiftUI

struct QuestionsView: View {
    var mult: Int
    var numQuestions: Int
    @State private var score = 0
    @State private var currentQ = 0
    @State private var currentNum = Int.random(in: 2...12)
    @State private var answer = 0
    @State private var showingAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Question:")
                .font(.title3)
            Text("\(currentNum) x \(mult)")
                .font(.largeTitle)
            HStack {
                Text("Answer:")
                TextField("Enter your answer", value:$answer, format:.number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .onSubmit {
                        handleAnswer()
                    }
                
            }
            .padding(50)
            Text("Score: \(score)")
            
        }
        .alert(
            "Great Job!",
            isPresented: $showingAlert
        ) {
            Button("Restart") {
                score = 0
                currentQ = 0
                answer = 0
            }
            Button(role: .cancel) {
                dismiss()
            } label: {
                Text("Configure Options")
            }
        } message: {
            Text("Your final score is \(score) out of \(numQuestions)")
        }
        .navigationTitle("Questions")
    }
    
    func handleAnswer() {
        currentQ += 1
        if answer == mult * currentNum {
            score += 1
        }
        answer = 0
        if (currentQ == numQuestions) {
            showingAlert = true
        }
        
        currentNum = Int.random(in:2...12)
        
    }
}


struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView(mult:2, numQuestions:10)
    }
}
