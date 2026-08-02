//
//  ContentView.swift
//  Liquid Dark Glass
//
//  Created by Elliot Williams on 2025-07-18.
//

import SwiftUI

struct LiquidGlassView: View {
    @State private var waveOffset = Angle(degrees: 0)
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [.indigo, .purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            // Liquid Glass Card
            VStack {
                Text("LIQUID GLASS")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("Smooth iOS Experience")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(
                ZStack {
                    // Frosted glass effect
                    GlassBackground()
                    
                    // Liquid waves
                    LiquidWave(offset: waveOffset, amplitude: 15, frequency: 0.03)
                        .foregroundStyle(.white.opacity(0.2))
                        .blendMode(.softLight)
                    
                    LiquidWave(offset: waveOffset + Angle(degrees: 180),
                               amplitude: 10,
                               frequency: 0.02)
                        .foregroundStyle(.white.opacity(0.15))
                        .blendMode(.luminosity)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(.horizontal, 30)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 20)
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                waveOffset = Angle(degrees: 360)
            }
        }
    }
}

// Frosted glass background
struct GlassBackground: View {
    var body: some View {
        Color.clear
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.linearGradient(colors: [.white.opacity(0.5), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing))
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 5, y: 5)
    }
}

// Liquid wave shape
struct LiquidWave: Shape {
    var offset: Angle
    var amplitude: CGFloat
    var frequency: CGFloat
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height / 2
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = CGFloat(x) / width
            let sine = sin(offset.radians + Double(relativeX * frequency * 2 * .pi))
            let y = midHeight + CGFloat(sine) * amplitude
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

struct ContentView: View {
    var body: some View {
        LiquidGlassView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
