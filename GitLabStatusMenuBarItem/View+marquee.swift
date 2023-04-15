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
            HStack(spacing: spacing) {
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
                        .onDisappear {
                            withAnimation(.linear(duration: 0)) {
                                offset = 0
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

extension View {
    func marquee(
        spacing: CGFloat = 10,
        delay: TimeInterval = 0,
        speedBasis: MarqueeModifier.SpeedBasis = .velocity(50)
    ) -> some View {
        GeometryReader { geometry in
            self.modifier(
                MarqueeModifier(
                    availableWidth: geometry.size.width,
                    spacing: spacing,
                    delay: delay,
                    speedBasis: speedBasis
                )
            )
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Short; usually avoids animating.")
                .padding(5)
                .marquee()
                .background(Color.red)

            Text("This text pauses at the beginning of each loop of its animation.")
                .font(.headline)
                .padding(5)
                .marquee(delay: 2)
                .background(Color.yellow)
            
            HStack(spacing: 20) {
                ForEach(["One", "Two", "Three", "Four"], id: \.self) { title in
                    HStack(spacing: 5) {
                        Image(systemName: "number.circle")
                        Text(title)
                    }
                    .font(.title3.bold())
                    .padding(.vertical, 3)
                    .padding(.horizontal, 6)
                    .frame(width: 150, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(.mint)
                    )
                    .padding(4)
                }
            }
            .marquee(spacing: 20, speedBasis: .period(4))
            .background(Color.black)
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 200)
    }
}
