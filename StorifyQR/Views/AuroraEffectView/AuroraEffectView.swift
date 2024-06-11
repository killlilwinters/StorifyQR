//
//  AuroraEffectView.swift
//  StorifyQR
//
//  Created by Maks Winters on 11.06.2024.
//
// https://medium.com/@danielgalasko/an-aurora-gradient-animation-in-swiftui-633fd4071b72
//

import SwiftUI
import Combine

struct CenterCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let smallestDimension = min(rect.width, rect.height)
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: smallestDimension / 2, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
        return path
    }
}

private struct MovingCircle: Shape, Animatable {
    
    var originOffset: CGPoint
    
    var animatableData: CGPoint.AnimatableData {
        get {
            originOffset.animatableData
        }
        set {
            originOffset.animatableData = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let adjustedX = rect.width * originOffset.x
        let adjustedY = rect.height * originOffset.y
        let smallestDimension = min(rect.width, rect.height)
        path.addArc(center: CGPoint(x: adjustedX, y: adjustedY), radius: smallestDimension / 2.5, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
        return path
    }
    
}

class CircleAnimator: ObservableObject {
    
    // 1.
    class Circle: Identifiable {
        internal init(position: CGPoint, color: Color) {
            self.position = position
            self.color = color
        }
        var position: CGPoint
        let id = UUID().uuidString
        let color: Color
    }
    
    @Published private(set) var circles: [Circle] = []
    
    // 2.
    init(colors: [Color]) {
        circles = colors.map({ color in
            Circle(position: .init(x: CGFloat.random(in: 0 ... 1), y: CGFloat.random(in: 0 ... 1)), color: color)
        })
    }
    
    // 3.
    func animate() {
        objectWillChange.send()
        for circle in circles {
            circle.position.x = CGFloat.random(in: 0 ... 1)
            circle.position.y = CGFloat.random(in: 0 ... 1)
        }
        
    }
}

struct AuroraEffectView: View {
    let animationSpeed: Double
    let timerDuration: TimeInterval
    let blurRadius: CGFloat
    
    let backgroundTint: Color?
    
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @ObservedObject private var animator: CircleAnimator
    
    var body: some View {
        ZStack {
            ForEach(animator.circles) { circle in
                MovingCircle(originOffset: circle.position)
                    .foregroundColor(circle.color)
            }
        }
        .blur(radius: blurRadius)
        .background(backgroundTint)
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onAppear {
            animateCircles()
            timer = Timer.publish(every: timerDuration, on: .main, in: .common).autoconnect()
        }
        .onReceive(timer) { _ in
            animateCircles()
        }
    }
    
    private func animateCircles() {
        withAnimation(.easeInOut(duration: animationSpeed)) {
            animator.animate()
        }
    }
    
    init(colors: [Color],
         backgroundTint: Color?,
         timerDuration: TimeInterval = 1,
         animationSpeed: Double = 4,
         blurRadius: CGFloat = 15) {
        self.timerDuration = timerDuration
        self.animationSpeed = animationSpeed
        self.blurRadius = blurRadius
        
        self.backgroundTint = backgroundTint
        self.timer = Timer.publish(every: timerDuration, on: .main, in: .common).autoconnect()
        self.animator = CircleAnimator(colors: colors)
    }
}


#Preview {
    AuroraEffectView(colors: [.blue], backgroundTint: nil)
}
