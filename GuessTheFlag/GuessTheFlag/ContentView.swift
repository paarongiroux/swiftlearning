//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Aaron Giroux on 1/17/25.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var alertMsg = ""
    @State private var score = 0
    @State private var questions = 0
    @State private var alertButton = "Continue"
    
    @State private var animationAmount = 0.0
    @State private var selected = -1
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    Button {
                        flagTapped(0)
                        animationAmount += 360
                        
                    } label: {
                        FlagImage(country: countries[0])
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                    }
                    
                    Button {
                        flagTapped(1)
                        animationAmount += 360
                        
                    } label: {
                        FlagImage(country: countries[1])
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                    }
                    Button {
                        flagTapped(2)
                        animationAmount += 360
                        
                    } label: {
                        FlagImage(country: countries[2])
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button(alertButton, action: askQuestion)
        } message: {
            Text(alertMsg)
        }
    }
    
    func flagTapped(_ number: Int) {
        questions += 1
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            alertMsg = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            alertMsg = "The correct answer was \(countries[correctAnswer])"
        }
        if questions == 8 {
            scoreTitle = "Congratulations"
            alertMsg = "Final score: \(score) out of \(questions)"
            alertButton = "Restart"
        }
        showingScore = true
    }
    
    func askQuestion() {
        selected = -1
        if (questions == 8) {
            score = 0
            questions = 0
            alertButton = "Continue"
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(radius: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
