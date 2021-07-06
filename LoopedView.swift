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
    @State var initialAngle = 0.0
    @State var rotationsPerSecond: Double = 1.0
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
                withAnimation(.linear(duration: 1.0)) {
                    initialAngle += 36.0*rotationsPerSecond
                }
                initialAngle = initialAngle.truncatingRemainder(dividingBy: 360.0)
            })
    }
}
