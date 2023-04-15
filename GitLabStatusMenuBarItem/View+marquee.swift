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
    let delay: TimeInterval
    let speedBasis: SpeedBasis
    
    enum SpeedBasis {
        case period(TimeInterval)
        case velocity(CGFloat)
        
        func duration(distance: CGFloat) -> TimeInterval {
            switch self {
            case .period(let seconds):
                return seconds
            case .velocity(let pointsPerSecond):
                return distance / pointsPerSecond
            }
        }
    }
    
    @State private var contentWidth: CGFloat?
    @State private var offset: CGFloat = 0
    
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
                            withAnimation(
                                Animation.linear(duration: speedBasis.duration(distance: contentWidth + spacing))
                                    .delay(delay)
                                    .repeatForever(autoreverses: false)
                            ) {
                                offset = -(contentWidth + spacing)
                            }
                        }
                }
            }
            .offset(x: offset)
        }
        .frame(width: availableWidth, alignment: .leading)
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
        delay: TimeInterval = 0,
        speedBasis: MarqueeModifier.SpeedBasis = .velocity(50)
    ) -> some View {
        self.modifier(
            MarqueeModifier(
                availableWidth: availableWidth,
                spacing: spacing,
                delay: delay,
                speedBasis: speedBasis
            )
        )
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("This shouldn't animate.")
                .padding(5)
                .marquee(availableWidth: 200)
                .background(Color.red)

            Text("This is a very long text that should animate horizontally.")
                .padding(5)
                .marquee(availableWidth: 200, delay: 2)
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
            .marquee(availableWidth: 200, spacing: 20)
            .background(Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
