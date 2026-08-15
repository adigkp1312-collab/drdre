import PhotosUI
import SwiftUI

struct TelivuTopBar: View {
    let languageAction: () -> Void

    var body: some View {
        HStack {
            Text("TELIVU")
                .font(TelivuFont.wordmark)
                .fontWeight(.bold)
                .tracking(2.1)
                .accessibilityAddTraits(.isHeader)

            Spacer()

            Button(action: languageAction) {
                HStack(spacing: 5) {
                    Text("ENGLISH").font(TelivuFont.label).tracking(0.4)
                    Image(systemName: "chevron.down").font(.system(size: 10, weight: .regular))
                }
                .foregroundStyle(TelivuColor.graphite)
                .frame(minWidth: 92, minHeight: TelivuLayout.minimumTarget, alignment: .trailing)
                .contentShape(Rectangle())
            }
            .buttonStyle(TelivuFlatPressStyle())
            .accessibilityLabel("Current language, English")
        }
        .padding(.horizontal, TelivuLayout.horizontalInset)
        .frame(minHeight: 76)
        .overlay(alignment: .bottom) { Rectangle().fill(TelivuColor.lineSubtle).frame(height: 1) }
    }
}

struct TelivuSessionMetadata: View {
    var body: some View {
        HStack(spacing: TelivuSpacing.xs) {
            Text("NEW CONVERSATION")
            Rectangle().fill(TelivuColor.lineDefault).frame(height: 1)
            HStack(spacing: 6) {
                Rectangle().fill(TelivuColor.ink).frame(width: 6, height: 6)
                Text("PRIVATE")
            }
        }
        .telivuTechnicalLabel()
        .foregroundStyle(TelivuColor.graphite)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("New private conversation")
    }
}

struct TelivuCompanionPanel: View {
    let state: TelivuVoiceState

    var body: some View {
        ZStack {
            TelivuColor.ink
            TelivuCompanionArt(isListening: state == .listening)
                .accessibilityHidden(true)

            VStack(spacing: 0) {
                HStack {
                    Text("YOUR HEALTH COMPANION").foregroundStyle(TelivuColor.paperQuiet)
                    Spacer()
                    HStack(spacing: 6) {
                        Rectangle().fill(TelivuColor.paper).frame(width: 6, height: 6)
                        Text(state.panelStatus)
                    }
                    .foregroundStyle(TelivuColor.paper)
                }
                .telivuTechnicalLabel()
                .padding(.horizontal, 14)
                .padding(.top, 13)

                Spacer()

                Text(state.panelCaption)
                    .telivuTechnicalLabel()
                    .foregroundStyle(TelivuColor.paperQuiet)
                    .padding(.bottom, 14)
            }
        }
        .frame(height: TelivuLayout.companionHeight)
        .overlay { Rectangle().stroke(TelivuColor.ink, lineWidth: 1) }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Telivu is \(state.panelStatus.lowercased())")
    }
}

private struct TelivuCompanionArt: View {
    let isListening: Bool

    var body: some View {
        GeometryReader { proxy in
            let scale = min(proxy.size.width / 320, proxy.size.height / 215)
            ZStack {
                TelivuSignalLines()
                Circle().stroke(TelivuColor.graphite, style: StrokeStyle(lineWidth: 1, dash: [2, 5])).frame(width: 164 * scale, height: 164 * scale)
                Circle().stroke(TelivuColor.graphite.opacity(0.55), lineWidth: 1).frame(width: 186 * scale, height: 186 * scale)
                TelivuFaceDisc().fill(TelivuColor.paper).overlay { TelivuFaceDisc().stroke(TelivuColor.graphite, lineWidth: 1) }.frame(width: 112 * scale, height: 112 * scale)
                TelivuFaceMark().stroke(TelivuColor.ink, style: StrokeStyle(lineWidth: 1.5, lineCap: .square, lineJoin: .miter)).frame(width: 112 * scale, height: 112 * scale)
                TelivuDocumentMark().stroke(TelivuColor.paper, lineWidth: 1).frame(width: 25 * scale, height: 34 * scale).offset(x: 96 * scale, y: 55 * scale)
                TelivuVoiceBars(isListening: isListening).frame(width: 34 * scale, height: 54 * scale).offset(x: -112 * scale, y: 4 * scale)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

private struct TelivuSignalLines: View {
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                let w = proxy.size.width
                let h = proxy.size.height
                path.move(to: CGPoint(x: w * 0.07, y: h * 0.31)); path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.31))
                path.move(to: CGPoint(x: w * 0.04, y: h * 0.38)); path.addLine(to: CGPoint(x: w * 0.27, y: h * 0.38))
                path.move(to: CGPoint(x: w * 0.75, y: h * 0.31)); path.addLine(to: CGPoint(x: w * 0.93, y: h * 0.31))
                path.move(to: CGPoint(x: w * 0.73, y: h * 0.38)); path.addLine(to: CGPoint(x: w * 0.96, y: h * 0.38))
            }
            .stroke(TelivuColor.graphite, lineWidth: 1)
        }
    }
}

private struct TelivuFaceDisc: Shape {
    func path(in rect: CGRect) -> Path { Path(ellipseIn: rect) }
}

private struct TelivuFaceMark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.20, y: rect.minY + rect.height * 0.34))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.43, y: rect.minY + rect.height * 0.34), control: CGPoint(x: rect.minX + rect.width * 0.31, y: rect.minY + rect.height * 0.25))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.57, y: rect.minY + rect.height * 0.34))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.80, y: rect.minY + rect.height * 0.34), control: CGPoint(x: rect.minX + rect.width * 0.69, y: rect.minY + rect.height * 0.25))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.50, y: rect.minY + rect.height * 0.37))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.46, y: rect.minY + rect.height * 0.62))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.54, y: rect.minY + rect.height * 0.66))
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.34, y: rect.minY + rect.height * 0.77))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.66, y: rect.minY + rect.height * 0.77), control: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.90))
        return path
    }
}

private struct TelivuDocumentMark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        path.move(to: CGPoint(x: rect.minX + 6, y: rect.minY + 10)); path.addLine(to: CGPoint(x: rect.maxX - 6, y: rect.minY + 10))
        path.move(to: CGPoint(x: rect.minX + 6, y: rect.minY + 16)); path.addLine(to: CGPoint(x: rect.maxX - 6, y: rect.minY + 16))
        path.move(to: CGPoint(x: rect.minX + 6, y: rect.minY + 22)); path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.minY + 22))
        return path
    }
}

private struct TelivuVoiceBars: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase = false

    let isListening: Bool
    private let bars: [CGFloat] = [35, 54, 24, 45]

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            ForEach(Array(bars.enumerated()), id: \.offset) { index, height in
                Rectangle().fill(TelivuColor.paper).frame(width: 3, height: height)
                    .scaleEffect(x: 1, y: isListening && !reduceMotion && !index.isMultiple(of: 2) && phase ? 0.52 : 1, anchor: .center)
            }
        }
        .animation(isListening && !reduceMotion ? .easeInOut(duration: 0.7).repeatForever(autoreverses: true) : nil, value: phase)
        .onAppear { phase = true }
    }
}

struct TelivuEditorialIntro: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("VOICE FIRST · TYPE LESS").telivuTechnicalLabel().fontWeight(.bold).foregroundStyle(TelivuColor.graphite)
            Text("Tell me what’s going on.")
                .font(TelivuFont.screenTitle).fontWeight(.regular).tracking(-1.2)
                .padding(.top, TelivuSpacing.xs).accessibilityAddTraits(.isHeader)
            Text("Speak naturally. Add a photo or report only if it helps.")
                .font(TelivuFont.body).foregroundStyle(TelivuColor.graphite).fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)
        }
        .padding(.vertical, TelivuSpacing.large)
        .overlay(alignment: .bottom) { Rectangle().fill(TelivuColor.lineSubtle).frame(height: 1) }
    }
}

struct TelivuAttachmentAction: View {
    enum Kind { case image, file
        var title: String { self == .image ? "ADD IMAGE" : "ADD FILE" }
        var icon: String { self == .image ? "photo" : "doc" }
    }
    let kind: Kind

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: kind.icon).font(.system(size: 18, weight: .light))
            Text(kind.title).font(TelivuFont.micro).tracking(0.25)
        }
        .foregroundStyle(TelivuColor.ink)
        .frame(maxWidth: .infinity, minHeight: TelivuLayout.attachmentHeight)
        .overlay { Rectangle().stroke(TelivuColor.ink, lineWidth: 1) }
        .contentShape(Rectangle())
    }
}

struct TelivuVoiceAction: View {
    let state: TelivuVoiceState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: state == .listening ? "stop.fill" : "mic.fill").font(.system(size: 22, weight: .regular))
                Text(state.actionTitle).font(TelivuFont.micro).tracking(0.18)
            }
            .foregroundStyle(foreground)
            .frame(width: TelivuLayout.voiceActionWidth, minHeight: TelivuLayout.attachmentHeight)
            .background(background)
            .overlay { Rectangle().stroke(TelivuColor.ink, lineWidth: state == .listening ? 2 : 1) }
            .contentShape(Rectangle())
        }
        .buttonStyle(TelivuFlatPressStyle(inverse: state != .listening))
        .accessibilityLabel(state.actionAccessibilityLabel)
        .accessibilityValue(state.panelStatus)
    }

    private var background: Color { state == .listening || state == .processing ? TelivuColor.paper : (state == .responseReady ? TelivuColor.graphite : TelivuColor.ink) }
    private var foreground: Color { state == .listening || state == .processing ? TelivuColor.ink : TelivuColor.paper }
}

struct TelivuStatusRegion: View {
    let copy: String
    var body: some View {
        Text(copy).telivuTechnicalLabel().foregroundStyle(TelivuColor.graphite).multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, minHeight: 42).accessibilityElement(children: .combine)
    }
}

struct TelivuResponseRegion: View {
    var body: some View {
        VStack(alignment: .leading, spacing: TelivuSpacing.xs) {
            Text("VOICE NOTE READY").telivuTechnicalLabel().foregroundStyle(TelivuColor.graphite)
            Text("I can help you make sense of what you noticed. This is not a diagnosis.").font(TelivuFont.body)
        }
        .padding(.vertical, TelivuSpacing.small)
        .overlay(alignment: .top) { Rectangle().fill(TelivuColor.lineSubtle).frame(height: 1) }
        .overlay(alignment: .bottom) { Rectangle().fill(TelivuColor.lineSubtle).frame(height: 1) }
    }
}

struct TelivuAttachmentSummary: View {
    let attachment: TelivuAttachment
    @Binding var selectedPhoto: PhotosPickerItem?
    let remove: () -> Void
    let replaceFile: () -> Void

    var body: some View {
        HStack(spacing: TelivuSpacing.small) {
            Text("\(attachment.kind.label) SELECTED · \(attachment.name)")
                .telivuTechnicalLabel().foregroundStyle(TelivuColor.graphite).lineLimit(2)
            Spacer(minLength: 0)
            Button("REMOVE", action: remove).font(TelivuFont.micro).foregroundStyle(TelivuColor.ink).frame(minHeight: 44)
            if attachment.kind == .image {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Text("REPLACE").font(TelivuFont.micro).foregroundStyle(TelivuColor.graphite).frame(minHeight: 44)
                }
            } else {
                Button("REPLACE", action: replaceFile).font(TelivuFont.micro).foregroundStyle(TelivuColor.graphite).frame(minHeight: 44)
            }
        }
        .padding(.vertical, TelivuSpacing.xs)
        .overlay(alignment: .top) { Rectangle().fill(TelivuColor.lineSubtle).frame(height: 1) }
    }
}

struct TelivuSafetyNote: View {
    var body: some View {
        Text("NOT FOR DIAGNOSIS OR EMERGENCIES.")
            .telivuTechnicalLabel().foregroundStyle(TelivuColor.graphite.opacity(0.72))
            .frame(maxWidth: .infinity).multilineTextAlignment(.center)
    }
}
