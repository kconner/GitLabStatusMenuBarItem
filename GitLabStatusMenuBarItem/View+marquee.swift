//
//  View+marquee.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-15.
//

import SwiftUI

struct MarqueeModifier: ViewModifier {
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
    
    let availableWidth: CGFloat
    let spacing: CGFloat
    let delay: TimeInterval
    let speedBasis: SpeedBasis
    
    @State private var contentWidth: CGFloat?
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
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
        .frame(width: availableWidth, alignment: .leading)
    }
}

extension View {
    func marquee(
        geometry: GeometryProxy,
        spacing: CGFloat = 10,
        delay: TimeInterval = 0,
        speedBasis: MarqueeModifier.SpeedBasis = .velocity(50)
    ) -> some View {
        self.modifier(
            MarqueeModifier(
                availableWidth: geometry.size.width,
                spacing: spacing,
                delay: delay,
                speedBasis: speedBasis
            )
        )
    }
    
    // This convenience overload does the geometry reading for you, but in so
    // doing makes intrinsic vertical size greedy. To avoid that, make your own
    // GeometryReader and pass its proxy to .marquee(geometry:…).
    func marquee(
        spacing: CGFloat = 10,
        delay: TimeInterval = 2,
        speedBasis: MarqueeModifier.SpeedBasis = .velocity(50)
    ) -> some View {
        GeometryReader { geometry in
            self.marquee(
                geometry: geometry,
                spacing: spacing,
                delay: delay,
                speedBasis: speedBasis
            )
        }
    }
}

struct MarqueeModifier_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text("Short; usually avoids animating.")
                        .padding(5)
                        .marquee(geometry: geometry)
                        .background(Color.red.gradient)
                    
                    VStack(alignment: .leading) {
                        Text("This text pauses at the beginning of each loop of its animation.")
                            .font(.headline)
                        Text("iPod 4 life")
                            .font(.subheadline)
                    }
                    .padding(5)
                    .marquee(geometry: geometry)
                    .background(Color.yellow.gradient)
                    
                    let interitemSpacing: CGFloat = 20
                    
                    HStack(spacing: interitemSpacing) {
                        ForEach(["One", "Two", "Three", "Four"], id: \.self) { title in
                            HStack(spacing: 5) {
                                Image(systemName: "music.quarternote.3")
                                Text(title)
                            }
                            .font(.title3.bold())
                            .padding(.vertical, 3)
                            .padding(.horizontal, 6)
                            .frame(width: 100, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(Color.mint.gradient)
                                    .shadow(radius: 2, y: 2)
                            )
                        }
                    }
                    .padding(.horizontal, interitemSpacing)
                    .marquee(geometry: geometry, spacing: -interitemSpacing, delay: 0, speedBasis: .period(2))
                    
                    Spacer()
                }
            }
        }
        .frame(width: 250, height: 200)
    }
}
