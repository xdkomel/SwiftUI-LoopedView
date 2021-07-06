# SwiftUI-LoopedView

This is a SwiftUI View struct allowing to rotate any views.

### How to

```swift
struct ExampleView: View {
    @State var isRotating = false       // create something to change the rotation state
    @State var rotationsPerSecond = 1.0 // set the speed
    var body: some View {
        VStack {
            LoopedView(
                isRotating: $isRotating,
                rotationsPerSecond: $rotationsPerSecond
            ) { // the content is in the ViewBuilder block
                Text("The text being rotated with speed \(rotationsPerSecond)")
            }
            Slider(value: $rotationsPerSecond, in: 0.0...5.0) // reactively changing speed
            Button("Stop rotating") { isRotating.toggle() }   // and the rotation state itself
        }.padding()
    }
}
```
You can also specify the initial angle for the rotated view but it's not necessary.

### The Source Code
Just copy and paste in a separate file.
```swift
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
```
