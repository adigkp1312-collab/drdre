import SwiftUI

struct TelivuTopBar: View {
    let languageAction: () -> Void

    var body: some View {
        HStack {
            Text("TELIVU")
                .font(TelivuFont.wordmark)
                .fontWeight(.bold)
                .tracking(1.4)
                .accessibilityAddTraits(.isHeader)

            Spacer()

            Button(action: languageAction) {
                HStack(spacing: 7) {
                    Text("ENGLISH")
                        .font(TelivuFont.control)
                        .tracking(0.35)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .regular))
                }
                .foregroundStyle(TelivuColor.graphite)
                .frame(minWidth: 82, minHeight: TelivuLayout.minimumTarget, alignment: .trailing)
                .contentShape(Rectangle())
            }
            .buttonStyle(TelivuFlatPressStyle())
            .accessibilityLabel("Current language, English")
        }
        .frame(height: TelivuLayout.topBarHeight)
        .padding(.horizontal, TelivuLayout.horizontalInset)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(TelivuColor.lineSoft)
                .frame(height: 1)
        }
    }
}

struct TelivuSessionMetadata: View {
    var body: some View {
        HStack(spacing: 10) {
            Text("NEW CONVERSATION")
            Rectangle()
                .fill(TelivuColor.lineStrong)
                .frame(height: 1)
            HStack(spacing: 6) {
                Rectangle()
                    .fill(TelivuColor.ink)
                    .frame(width: 6, height: 6)
                Text("PRIVATE")
            }
        }
        .telivuTechnicalLabel()
        .foregroundStyle(TelivuColor.graphite)
        .frame(minHeight: 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("New private conversation")
    }
}

struct TelivuAvatarStage: View {
    let state: TelivuVoiceState
    let height: CGFloat

    var body: some View {
        ZStack {
            TelivuColor.ink

            VStack(spacing: 0) {
                HStack {
                    Text("YOUR HEALTH COMPANION")
                        .foregroundStyle(TelivuColor.paperMuted)
                    Spacer()
                    HStack(spacing: 6) {
                        Rectangle()
                            .fill(TelivuColor.paper)
                            .frame(width: 6, height: 6)
                        Text(state.stageStatus)
                    }
                    .foregroundStyle(TelivuColor.paper)
                }
                .telivuTechnicalLabel()
                .padding(.horizontal, 14)
                .padding(.top, 13)

                Spacer(minLength: 0)

                TelivuCompanionPortrait(isListening: state == .listening)
                    .padding(.horizontal, 10)
                    .accessibilityHidden(true)

                Spacer(minLength: 0)

                Text(state.stageCaption)
                    .telivuTechnicalLabel()
                    .foregroundStyle(TelivuColor.paperQuiet)
                    .padding(.bottom, 12)
            }
        }
        .frame(height: height)
        .overlay {
            Rectangle().stroke(TelivuColor.ink, lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(state == .listening ? "Telivu is listening" : "Telivu is ready to listen")
    }
}

private struct TelivuCompanionPortrait: View {
    let isListening: Bool

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let scale = min(width / 320, height / 250)
            let canvasWidth = 320 * scale
            let canvasHeight = 250 * scale
            let x = (width - canvasWidth) / 2
            let y = (height - canvasHeight) / 2

            ZStack {
                voiceField
                portrait
                if isListening {
                    TelivuVoiceWave()
                        .frame(width: 64, height: 38)
                        .offset(y: 99)
                }
            }
            .frame(width: 320, height: 250)
            .scaleEffect(scale, anchor: .topLeading)
            .offset(x: x, y: y)
        }
    }

    private var voiceField: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 30, y: 55)); path.addLine(to: CGPoint(x: 76, y: 55))
                path.move(to: CGPoint(x: 22, y: 68)); path.addLine(to: CGPoint(x: 86, y: 68))
                path.move(to: CGPoint(x: 240, y: 55)); path.addLine(to: CGPoint(x: 288, y: 55))
                path.move(to: CGPoint(x: 232, y: 68)); path.addLine(to: CGPoint(x: 298, y: 68))
                path.move(to: CGPoint(x: 49, y: 188)); path.addLine(to: CGPoint(x: 29, y: 200))
                path.move(to: CGPoint(x: 271, y: 188)); path.addLine(to: CGPoint(x: 291, y: 200))
            }
            .stroke(TelivuColor.graphite, lineWidth: 1)

            Group {
                ArcShape(startAngle: 120, endAngle: 240)
                    .stroke(isListening ? TelivuColor.paper : TelivuColor.graphite, style: StrokeStyle(lineWidth: 1, dash: [3, 6]))
                    .frame(width: 176, height: 176)
                ArcShape(startAngle: -60, endAngle: 60)
                    .stroke(isListening ? TelivuColor.paper : TelivuColor.graphite, style: StrokeStyle(lineWidth: 1, dash: [3, 6]))
                    .frame(width: 176, height: 176)
                Circle()
                    .stroke(TelivuColor.graphite, style: StrokeStyle(lineWidth: 1, dash: [2, 4]))
                    .frame(width: 162, height: 162)
            }
        }
    }

    private var portrait: some View {
        ZStack {
            TelivuFaceDisc()
                .fill(TelivuColor.paper)
                .overlay { TelivuFaceDisc().stroke(TelivuColor.graphite, lineWidth: 1) }
                .frame(width: 150, height: 152)

            Path { path in
                path.move(to: CGPoint(x: 125, y: 111)); path.addCurve(to: CGPoint(x: 153, y: 111), control1: CGPoint(x: 134, y: 104), control2: CGPoint(x: 144, y: 104))
                path.move(to: CGPoint(x: 167, y: 111)); path.addCurve(to: CGPoint(x: 195, y: 111), control1: CGPoint(x: 176, y: 104), control2: CGPoint(x: 186, y: 104))
                path.move(to: CGPoint(x: 129, y: 121)); path.addLine(to: CGPoint(x: 147, y: 121))
                path.move(to: CGPoint(x: 173, y: 121)); path.addLine(to: CGPoint(x: 191, y: 121))
                path.move(to: CGPoint(x: 160, y: 119)); path.addCurve(to: CGPoint(x: 165, y: 150), control1: CGPoint(x: 157, y: 133), control2: CGPoint(x: 155, y: 146))
                path.move(to: CGPoint(x: 116, y: 84)); path.addCurve(to: CGPoint(x: 205, y: 84), control1: CGPoint(x: 136, y: 51), control2: CGPoint(x: 184, y: 51))
            }
            .stroke(TelivuColor.ink, style: StrokeStyle(lineWidth: 1.6, lineCap: .square, lineJoin: .miter))

            Path { path in
                if isListening {
                    path.move(to: CGPoint(x: 151, y: 163))
                    path.addCurve(to: CGPoint(x: 169, y: 163), control1: CGPoint(x: 155, y: 157), control2: CGPoint(x: 165, y: 157))
                    path.addCurve(to: CGPoint(x: 151, y: 163), control1: CGPoint(x: 167, y: 171), control2: CGPoint(x: 153, y: 171))
                } else {
                    path.move(to: CGPoint(x: 143, y: 166))
                    path.addCurve(to: CGPoint(x: 177, y: 166), control1: CGPoint(x: 154, y: 173), control2: CGPoint(x: 166, y: 173))
                }
            }
            .stroke(TelivuColor.ink, lineWidth: 2)
        }
    }
}

private struct ArcShape: Shape {
    let startAngle: Double
    let endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: min(rect.width, rect.height) / 2,
            startAngle: .degrees(startAngle),
            endAngle: .degrees(endAngle),
            clockwise: false
        )
        return path
    }
}

private struct TelivuFaceDisc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.midY), control1: CGPoint(x: rect.maxX * 0.82, y: rect.minY), control2: CGPoint(x: rect.maxX, y: rect.height * 0.24))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control1: CGPoint(x: rect.maxX, y: rect.height * 0.80), control2: CGPoint(x: rect.maxX * 0.80, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.midY), control1: CGPoint(x: rect.width * 0.20, y: rect.maxY), control2: CGPoint(x: rect.minX, y: rect.height * 0.80))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), control1: CGPoint(x: rect.minX, y: rect.height * 0.24), control2: CGPoint(x: rect.width * 0.18, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct TelivuVoiceWave: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase = false

    let color: Color
    private let levels: [CGFloat] = [10, 22, 32, 18, 12]

    init(color: Color = TelivuColor.paper) {
        self.color = color
    }

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(Array(levels.enumerated()), id: \.offset) { index, level in
                Rectangle()
                    .fill(color)
                    .frame(width: 3, height: level)
                    .scaleEffect(
                        x: 1,
                        y: reduceMotion ? 1 : (phase == index.isMultiple(of: 2) ? 1 : 0.45),
                        anchor: .center
                    )
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.62).repeatForever(autoreverses: true), value: phase)
        .onAppear { phase = true }
    }
}

struct TelivuAttachmentLabel: View {
    enum Kind: Equatable {
        case image
        case file

        var title: String { self == .image ? "ADD IMAGE" : "ADD FILE" }
        var icon: String { self == .image ? "photo" : "doc" }
    }

    let kind: Kind

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: kind.icon)
                .font(.system(size: 21, weight: .light))
            Text(kind.title)
                .font(TelivuFont.micro)
                .tracking(0.25)
        }
        .foregroundStyle(TelivuColor.ink)
        .frame(maxWidth: .infinity, minHeight: TelivuLayout.attachmentHeight)
        .background(TelivuColor.paper)
        .overlay { Rectangle().stroke(TelivuColor.lineStrong, lineWidth: 1) }
        .contentShape(Rectangle())
    }
}

struct TelivuTalkButton: View {
    let isListening: Bool
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(isListening ? TelivuColor.paper : TelivuColor.ink)

                if isListening {
                    TelivuVoiceWave(color: TelivuColor.ink)
                } else {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 33, weight: .regular))
                        .foregroundStyle(TelivuColor.paper)
                }
            }
            .frame(width: size, height: size)
            .overlay {
                Rectangle().stroke(TelivuColor.ink, lineWidth: isListening ? 2 : 1)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(TelivuFlatPressStyle(inverse: !isListening))
        .accessibilityLabel(isListening ? "Stop listening" : "Tap to talk")
        .accessibilityValue(isListening ? "Listening now" : "Ready")
    }
}

struct TelivuSelectionNotice: View {
    let message: String

    var body: some View {
        Text(message)
            .font(TelivuFont.micro)
            .tracking(0.3)
            .foregroundStyle(TelivuColor.paper)
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
            .padding(.horizontal, 15)
            .background(TelivuColor.ink)
            .overlay { Rectangle().stroke(TelivuColor.paper, lineWidth: 1) }
            .accessibilityAddTraits(.isStaticText)
    }
}
