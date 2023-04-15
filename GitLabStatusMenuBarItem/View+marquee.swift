//
//  View+marquee.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-15.
//

import SwiftUI

struct MarqueeModifier: ViewModifier {
    let availableWidth: CGFloat
    let spacing: CGFloat
    let speedFactor: SpeedFactor
    
    enum SpeedFactor {
        case duration(TimeInterval)
        case velocity(CGFloat)
    }
    
    @State private var contentWidth: CGFloat?
    @State private var animate: Bool = false
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            HStack {
                content
                    .fixedSize()
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    if contentWidth == nil {
                                        self.contentWidth = geometry.size.width
                                    }
                                }
                        }
                    )
                
                if let contentWidth, contentWidth > availableWidth {
                    Spacer(minLength: spacing)
                    
                    content
                        .fixedSize()
                        .onAppear {
                            withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                                animate = true
                            }
                        }
                }
            }
            .offset(
                x: animate && (contentWidth ?? 0) > availableWidth
                    ? -(contentWidth ?? 0) - spacing
                    : 0
            )
        }
        .frame(width: 200, alignment: .leading)
        .clipped()
    }
}

struct MarqueePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0.0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func marquee(
        availableWidth: CGFloat,
        spacing: CGFloat = 10,
        speedFactor: MarqueeModifier.SpeedFactor = .velocity(100)
    ) -> some View {
        self.modifier(
            MarqueeModifier(
                availableWidth: availableWidth,
                spacing: spacing,
                speedFactor: speedFactor
            )
        )
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("This shouldn't animate.")
                .marquee(availableWidth: 200)
                .background(Color.red)

            Text("This is a very long text that should animate horizontally.")
                .marquee(availableWidth: 200)
                .frame(width: 200, alignment: .leading)
                .background(Color.yellow)
            
            HStack(spacing: 20) {
                ForEach(["One Mississippi", "Two Mississippi", "Three Mississippi", "Umpteen Mississippi"], id: \.self) { title in
                    HStack(spacing: 5) {
                        Image(systemName: "number.circle")
                        Text(title)
                    }
                    .font(.title3)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(.mint)
                    )
                    .padding(4)
                }
            }
            .marquee(availableWidth: 150, spacing: 30)
            .background(Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
