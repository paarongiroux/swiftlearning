//
//  ContentView.swift
//  Animations
//
//  Created by Aaron Giroux on 1/22/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingRed = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width:200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

// add an extension called pivot to AnyTransition that defines how to create a transition with the CornerRotateModifier
extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

struct HideSquareTransition: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}

struct NameSnake: View {
    let letters = Array("Aaron Giroux")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
}

struct DraggingCard: View {
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.3)) {
                            dragAmount = .zero
                            
                        }
                    }
            )
//            .animation(.spring(response: 0.25, dampingFraction: 0.625), value: dragAmount) // uncomment this to get spring animations during drag as well
    }
}

struct MultipleAnimationButton: View {
    @State private var enabled = false
    
    var body: some View {
        Button("Tap Me") {
            enabled.toggle()
        }
        .frame(width: 300, height: 200)
        .background(enabled ? .blue : .red)
        .animation(.default, value: enabled) // each animation modifier controls everything before it up to the previous animation modifier
//        .animation(nil, value: enabled) // this will enable animations on color changes
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.spring(response: 1, dampingFraction: 0.825), value: enabled)
        
    }
}

struct RotatingButton: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        Button("Tap Me") {
            withAnimation(.spring(response: 2, dampingFraction: 0.825)) {
                animationAmount += 360
            }
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(Circle())
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 1, y: 0, z: 0))
    }
}

// note that this one binds the animation to animation amount in the STEPPER ONLY
// meaning the animation gets triggered via stepper but not by button tap
struct TapMeStepper: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        print(animationAmount)
        
        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(), in: 1...10 )
            Spacer()
            Button("Tap Me") {
                animationAmount += 1
            }
            .padding(40)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)
        }
        .padding()
    }
}

// this binds the animation to the animationAmount itself.
// anything that changes animation amount will trigger the animation on the button.
struct TapMeButton: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        Button("Tap Me") { }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
            .stroke(.red)
            .scaleEffect(animationAmount)
            .opacity( 2 - animationAmount)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animationAmount)
        )
        .onAppear {
            animationAmount = 1.5
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
