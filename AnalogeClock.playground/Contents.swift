import SwiftUI
import PlaygroundSupport

struct AnalogClockView: View {
    @State private var currentTime = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()

    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 300, height: 300)
            .overlay(GeometryReader { geometry in
                ClockView(geometry: geometry, currentTime: currentTime)
            })
            .onReceive(timer) { _ in
                currentTime = Date()
            }
    }
}
struct ClockView: View {
    let geometry: GeometryProxy
    let currentTime: Date

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: geometry.size.width, height: geometry.size.height)
            ForEach(0..<60) { tick in
                TickView(tick: tick, size: geometry.size)
                HourHandView(size: geometry.size.height * 0.7, currentTime: currentTime)
                MinuteHandView(size: geometry.size.width * 0.8, currentTime: currentTime)
                SecondHandView(size: geometry.size.width, currentTime: currentTime)
            }
        }
    }
}

struct TickView: View {
    let tick: Int
    let size: CGSize

    var body: some View {
        let _ = print(size.width)
        Rectangle()
            .fill(Color.black)
            .frame(
                width: tick % 5 == 0 ? 5: 2,
                height: tick % 5 == 0 ? 25 : 5
            )
            .offset(y: ((size.width - 50) / 2))
            .rotationEffect(.degrees(Double(tick) * 6))
    }
}

struct ClockHandView: View {
    let size: CGFloat
    let lineWidth: CGFloat
    let angle: Angle
    let color: Color

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: lineWidth, height: size / 2)
            .offset(y: -size / 4)
            .rotationEffect(angle)
    }
}

struct HourHandView: View {
    let size: CGFloat
    let currentTime: Date

    var body: some View {
        let _ = print(size)
        let hour = Calendar.current.component(.hour, from: currentTime)
        let minute = Calendar.current.component(.minute, from: currentTime)

        return ClockHandView(size: size, lineWidth: 10, angle: Angle(degrees: Double(hour % 12) * 30 + Double(minute) / 2), color: .black)
    }
}

struct MinuteHandView: View {
    let size: CGFloat
    let currentTime: Date

    var body: some View {
        let minute = Calendar.current.component(.minute, from: currentTime)

        return ClockHandView(size: size, lineWidth: 7, angle: Angle(degrees: Double(minute) * 6), color: .black)
            .opacity(0.5)
    }
}

struct SecondHandView: View {
    let size: CGFloat
    let currentTime: Date

    var body: some View {
        let second = Calendar.current.component(.second, from: currentTime)

        return ClockHandView(size: size, lineWidth: 1, angle: Angle(degrees: Double(second) * 6), color: .red)
    }
}

PlaygroundPage.current.setLiveView(AnalogClockView())
