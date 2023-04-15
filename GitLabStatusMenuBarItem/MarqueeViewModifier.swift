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

struct MarqueeText: View {
    let text: String
    let font: Font

    @State private var textSize: CGSize = .zero

    var body: some View {
        Text(text)
            .font(font)
            .background(GeometryReader { geometryProxy in
                Color.clear.preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            })
            .onPreferenceChange(SizePreferenceKey.self) { size in
                textSize = size
            }
            .frame(width: textSize.width, height: textSize.height, alignment: .leading)
    }

    private struct SizePreferenceKey: PreferenceKey {
        static var defaultValue: CGSize = .zero
        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
}

struct MarqueeViewModifier: ViewModifier {
    let mode: MarqueeAnimationMode
    let text: String
    let font: Font
    let iterations: Int
    let delayMillis: Int
    let initialDelayMillis: Int
    let spacing: CGFloat
    let velocity: CGFloat

    @FocusState private var isFocused: Bool
    @State private var animate: Bool = false

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            MarqueeText(text: text, font: font)
                .clipped()
                .offset(x: animate ? -geometry.size.width - spacing : 0)
                .onAppear {
                    if mode == .immediately {
                        withAnimation(createAnimation(for: geometry)) {
                            animate.toggle()
                        }
                    }
                }
                .onChange(of: isFocused) { focused in
                    if mode == .whileFocused {
                        withAnimation(createAnimation(for: geometry)) {
                            animate = focused
                        }
                    }
                }
                .focused(mode == .whileFocused ? focusBinding() : nil)
        }
    }
    
    private func createAnimation(for geometry: GeometryProxy) -> Animation {
        Animation.linear(duration: Double(geometry.size.width + spacing) / Double(velocity))
            .repeatCount(iterations, autoreverses: false)
            .delay(Double(initialDelayMillis) / 1000.0)
    }
    
    private func focusBinding() -> FocusState<Bool>.Binding {
        Binding<Bool>(
            get: { isFocused },
            set: { isFocused = $0 }
        )
    }
}

extension View {
    func marquee(mode: MarqueeAnimationMode = .immediately,
                 text: String,
                 font: Font = .body,
                 iterations: Int = Int.max,
                 delayMillis: Int = 1000,
                 initialDelayMillis: Int = 0,
                 spacing: CGFloat = 0,
                 velocity: CGFloat = 50) -> some View {
        self.modifier(MarqueeViewModifier(mode: mode,
                                          text: text,
                                          font: font,
                                          iterations: iterations,
                                          delayMillis: delayMillis,
                                          initialDelayMillis: initialDelayMillis,
                                          spacing: spacing,
                                          velocity: velocity))
    }
}

struct MarqueeViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            Text("Hello, World!")
                .marquee(mode: .whileFocused, text: "Hello, World!", iterations: 2, delayMillis: 1000, initialDelayMillis: 500, spacing: 100, velocity: 100)
                .frame(width: 100)
            Spacer()
        }
    }
}
