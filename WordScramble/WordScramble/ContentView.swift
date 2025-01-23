//
//  ContentView.swift
//  WordScramble
//
//  Created by Aaron Giroux on 1/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    ForEach(usedWords, id:\.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord) // onSubmit gets triggerend when ANY text is submitted. (when return key is pressed on a TextField)
            .onAppear(perform: startGame) // triggers when the view first appears
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("Reset") {
                    startGame()
                }
            }
            Text("Score: \(score)")
        }
        
    }
    
    func startGame() {
        usedWords = [String]()
        newWord = ""
        score = 0
        // find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // split the string on newline
                let allWords = startWords.components(separatedBy: "\n")
                // get a random word from allwords with silkworm as default
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        // a problem occured, terminate the app
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    // checks if word can be made from the letters of rootWord
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    // checks if word is a real english word
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        // set range from start to end of word
        let range = NSRange(location: 0, length: word.utf16.count)
        // find misspellings in the word
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        guard answer.count >= 3 else {
            wordError(title: "Word is too short", message: "Keep words to three or more letters")
            return
        }
        guard answer != rootWord else {
            wordError(title: "Root word", message: "You've just entered the root word")
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title:"Word not recognized", message: "You can't just make them up...")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        score += answer.count
        newWord = ""
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
