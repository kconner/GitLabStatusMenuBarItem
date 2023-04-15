//
//  MarqueeViewModifier.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-15.
//

import SwiftUI

enum MarqueeAnimationMode {
    case immediately
    case whileFocused
}

struct MarqueeViewModifier: ViewModifier {
    @State private var animate: Bool = false
    let mode: MarqueeAnimationMode
    let iterations: Int
    let delayMillis: Int
    let initialDelayMillis: Int
    let spacing: CGFloat
    let velocity: CGFloat

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .measure(width: geometry.size.width)
                .clipped()
                .offset(x: animate ? -geometry.size.width - spacing : 0)
                .animation(Animation.linear(duration: Double(geometry.size.width + spacing) / Double(velocity))
                                .repeatCount(iterations, autoreverses: false)
                                .delay(Double(initialDelayMillis) / 1000.0))
                .onAppear {
                    if mode == .immediately {
                        animate.toggle()
                    }
                }
                .focusable(mode == .whileFocused)
                .onFocusChange { focused in
                    if mode == .whileFocused {
                        animate = focused
                    }
                }
        }
    }
}

extension View {
    func marquee(mode: MarqueeAnimationMode = .immediately,
                 iterations: Int = Int.max,
                 delayMillis: Int = 1000,
                 initialDelayMillis: Int = 0,
                 spacing: CGFloat = 0,
                 velocity: CGFloat = 50) -> some View {
        self.modifier(MarqueeViewModifier(mode: mode,
                                          iterations: iterations,
                                          delayMillis: delayMillis,
                                          initialDelayMillis: initialDelayMillis,
                                          spacing: spacing,
                                          velocity: velocity))
    }
}

struct MarqueeViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
            .marquee(mode: .whileFocused, iterations: 2, delayMillis: 1000, initialDelayMillis: 500, spacing: 100, velocity: 100)
            .frame(width: 100)
    }
}
