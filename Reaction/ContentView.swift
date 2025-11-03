//
//  ContentView.swift
//  Reaction
//
//  Created by Kevin on 2025/11/3.
//  Update for the first push
//

import SwiftUI

struct ContentView: View {

    enum GameState {
        case idle
        case waiting
        case ready
        case tooSoon
        case finished
    }

    @State private var gameState: GameState = .idle
    @State private var statusText: String = "Test your reaction"
    @State private var reactionText: String? = nil

    @State private var timer: Timer? = nil
    @State private var startTime: Date? = nil

    var body: some View {
        ZStack {
            backgroundColor
                // remove the white padding in top and bottom
                .ignoresSafeArea()
                // ensure all screen is pressable..
                .contentShape(Rectangle())
                .onTapGesture {
                    handleTap()
                }

            VStack(spacing: 24) {
                Text("Reaction Test")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Text(statusText)
                    .font(.title3)
                    .foregroundColor(.white)

                if let reactionText {
                    Text(reactionText)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }

                Button(buttonTitle) {
                    startOrRestart()
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(20)
            }
            .padding()
        }
    }

    // Start with red, play with green, stopped with blue
    private var backgroundColor: Color {
        switch gameState {
        case .idle, .waiting, .tooSoon:
            return .red
        case .ready:
            return .green
        case .finished:
            return .blue
        }
    }

    // 標題
    private var buttonTitle: String {
        switch gameState {
        case .idle:
            return "Start"
        case .waiting, .ready:
            return "Cancel / Restart"
        case .tooSoon, .finished:
            return "Restart"
        }
    }

    private func startOrRestart() {
        // initial status
        timer?.invalidate()
        timer = nil
        reactionText = nil
        startTime = nil
        gameState = .waiting
        statusText = "Started!! Please hit till the screen turn green."

        let delay = Double.random(in: 2.0...5.0)
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            if timer == nil { return }
            gameState = .ready
            statusText = "Hit now!!!!!"
            startTime = Date()
        }
    }

    private func handleTap() {
        switch gameState {
            // no react if no start
        case .idle:
            break

        case .waiting:
            timer?.invalidate()
            timer = nil
            gameState = .tooSoon
            statusText = "Too early..."
            reactionText = nil
            startTime = nil

        case .ready:
            guard let startTime else { return }
            let end = Date()
            let interval = end.timeIntervalSince(startTime)
            let ms = Int(interval * 1000)

            gameState = .finished
            statusText = "Test done"
            reactionText = "Reaction time:\(ms) ms"

            timer?.invalidate()
            timer = nil

        case .tooSoon, .finished:
            break
        }
    }
}


#Preview {
    ContentView()
}
