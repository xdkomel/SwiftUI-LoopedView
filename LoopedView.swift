//
//  LoopedView.swift
//  TestApp
//
//  Created by Camille Khubbetdinov on 76..2021.
//

import Foundation
import SwiftUI

struct LoopedView<Content>: View where Content: View {
    @Binding var isRotating: Bool
    @Binding var rotationsPerSecond: Double
    @State var initialAngle = 0.0
    @ViewBuilder var content: () -> Content
    
    let timePublisher = Timer.publish(
        every: 0.1,
        on: .current,
        in: .default
    ).autoconnect()
    
    var body: some View {
        content()
            .rotationEffect(Angle(degrees: initialAngle))
            .onReceive(timePublisher, perform: { _ in
                if isRotating {
                    withAnimation(.linear(duration: 1.0)) {
                        initialAngle += 36.0*rotationsPerSecond
                    }
                    initialAngle = initialAngle.truncatingRemainder(dividingBy: 360.0)
                }
            })
    }
}

struct ExampleView: View {
    @State var isRotating = false
    @State var rotationsPerSecond = 1.0
    var body: some View {
        VStack {
            LoopedView(
                isRotating: $isRotating,
                rotationsPerSecond: $rotationsPerSecond
            ) {
                Text("The text being rotated with speed \(rotationsPerSecond)")
            }
            Slider(value: $rotationsPerSecond, in: 0.0...5.0)
            Button("Stop rotating") { isRotating.toggle() }
        }.padding()
    }
}
