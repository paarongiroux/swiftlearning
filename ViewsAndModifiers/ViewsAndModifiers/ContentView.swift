//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Aaron Giroux on 1/17/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("hello world")
                .promTitle()
            GridStack(rows: 4, columns: 4) {
                row, col in
                HStack {
                    Image(systemName: "\(row * 4 + col).circle")
                    Text("R\(row) C\(col)")
                }
            }
            VStack(spacing: 10) {
                Text("First")
                    .font(.largeTitle)
                    .padding()
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(Capsule())
                CapsuleText(text: "Second")
                Text("Third")
                    .titleStyle()
                Color.blue
                    .frame(width:300, height:200)
                    .watermarked(with: "chingy")
            }
        }
    }
}

struct CapsuleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(Capsule())
    }
}

struct PromTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .padding()
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(Capsule())
    }
}

struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id:\.self) { row in
                HStack {
                    ForEach(0..<columns, id:\.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

extension View {
//    Allows me to use text.titleStyle() instead of text.modifier(Title())
    func titleStyle() -> some View {
        modifier(Title())
    }
    
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text:text))
    }
    
    func promTitle() -> some View {
        modifier(PromTitle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
