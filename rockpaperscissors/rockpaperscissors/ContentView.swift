//
//  ContentView.swift
//  rockpaperscissors
//
//  Created by Aaron Giroux on 1/19/25.
//

import SwiftUI

struct ContentView: View {
    let moves = ["Rock", "Paper", "Scissors"]
    let winningMap: [String: String] = [
        "Rock": "Scissors",
        "Paper": "Rock",
        "Scissors": "Paper"
    ]
    
    let emojiMap: [String: String] = [
        "Rock": "🪨",
        "Paper": "📃",
        "Scissors": "✂️"
    ]
    @State private var move = Int.random(in: 0...2)
    @State private var win = Bool.random()
    @State private var score = 0
    @State private var numQuestions = 0
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                HStack {
                    Text("Select the")
                    Text(win ? "WINNING" : "LOSING")
                        .padding(2)
                        .background(win ? .green : .red)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                    Text("response to \(moves[move])")
                }
                .font(.subheadline.weight(.semibold))
                Spacer()
                VStack (spacing: 20){
                    ForEach(0..<3) { number in
                        Button {
                            moveSelected(number)
                        } label: {
                            Text(emojiMap[moves[number]]!)
                                .font(.system(size: 100))
                        }
                    }
                }
                Spacer()
                Spacer()
                Text("Score: \(score)")
            }
            .padding()
            .navigationTitle("Rock Paper Scissors")
        }
        .alert("Congratulations", isPresented: $showAlert) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Your final score is \(score) out of \(numQuestions)")
        }
        
    }
    
    func moveSelected(_ number: Int) {
        let beats = winningMap[moves[number]]
        numQuestions += 1
        if win {
            if beats == moves[move] {
                score += 1
            }
        } else {
            if beats != moves[move] && number != move {
                score += 1
            }
        }
        move = Int.random(in: 0...2)
        win = Bool.random()
        
        if numQuestions == 10 {
            showAlert = true
        }
    }
        
    func restartGame() {
        move = Int.random(in: 0...2)
        win = Bool.random()
        numQuestions = 0
        score = 0
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
