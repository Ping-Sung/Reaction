//
//  ContentView.swift
//  Reaction
//
//  Created by Kevin on 2025/11/3.
//  Update for the first push
//

import SwiftUI

struct ContentView: View {
    @State private var color: Color = .red
    @State private var timer: Timer?
    @State private var nextChange: Double = 0.0

    var body: some View {
        ZStack {
            color
                .ignoresSafeArea()
                .onAppear(perform: startColorCycle)

            VStack {
                Spacer()
                Button("Restart") {
                    restartCycle()
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(12)
                .padding(.bottom, 40)
            }
        }
    }

    // 每 2～5 秒隨機變色
    func startColorCycle() {
        scheduleNextChange()
    }

    func scheduleNextChange() {
        nextChange = Double.random(in: 2...5)
        
        timer = Timer.scheduledTimer(withTimeInterval: nextChange, repeats: false) { _ in
            toggleColor()
            scheduleNextChange()
        }
    }

    func toggleColor() {
        color = (color == .red) ? .green : .red
    }

    func restartCycle() {
        timer?.invalidate()
        color = .red
        startColorCycle()
    }
}

#Preview {
    ContentView()
}
