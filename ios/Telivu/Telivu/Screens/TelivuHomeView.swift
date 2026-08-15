import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

struct TelivuHomeView: View {
    @StateObject private var model = TelivuHomeModel()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isFileImporterPresented = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                TelivuTopBar(languageAction: model.acknowledgeLanguage)

                if dynamicTypeSize.isAccessibilitySize {
                    ScrollView { screenBody(in: proxy.size, compact: true) }
                        .scrollIndicators(.hidden)
                } else {
                    screenBody(in: proxy.size, compact: proxy.size.height < 760)
                }
            }
            .background(TelivuColor.paper)
            .foregroundStyle(TelivuColor.ink)
            .overlay(alignment: .bottom) {
                if let notice = model.notice {
                    TelivuSelectionNotice(message: notice)
                        .padding(.horizontal, TelivuLayout.horizontalInset)
                        .padding(.bottom, TelivuSpacing.medium)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear { scheduleNoticeDismissal(for: notice) }
                }
            }
            .animation(.easeOut(duration: 0.18), value: model.notice)
        }
        .background(TelivuColor.paper.ignoresSafeArea())
        .fileImporter(
            isPresented: $isFileImporterPresented,
            allowedContentTypes: [.pdf, .image],
            allowsMultipleSelection: false
        ) { result in
            if case let .success(urls) = result, let file = urls.first {
                model.acknowledgeFile(named: file.lastPathComponent)
            }
        }
        .onChange(of: selectedPhoto) { _, item in
            if item != nil { model.acknowledgeImage() }
        }
    }

    private func screenBody(in size: CGSize, compact: Bool) -> some View {
        let stageHeight = compact ? 235.0 : min(300.0, max(260.0, size.height * 0.355))
        let talkSize = compact ? TelivuLayout.compactTalkSize : TelivuLayout.talkSize

        return VStack(spacing: 0) {
            TelivuSessionMetadata()

            TelivuAvatarStage(state: model.voiceState, height: stageHeight)
                .padding(.top, compact ? 8 : 11)

            VStack(alignment: .leading, spacing: 0) {
                Text("VOICE FIRST · TYPE LESS")
                    .telivuTechnicalLabel()
                    .fontWeight(.bold)
                    .foregroundStyle(TelivuColor.graphite)

                Text("Tell me what’s going on.")
                    .font(TelivuFont.hero)
                    .fontWeight(.regular)
                    .tracking(-1.35)
                    .lineSpacing(-3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, compact ? 6 : 8)
                    .accessibilityAddTraits(.isHeader)

                Text(model.voiceState.supportCopy)
                    .font(TelivuFont.support)
                    .foregroundStyle(TelivuColor.graphite)
                    .lineSpacing(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, compact ? 6 : 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, compact ? 12 : 17)
            .overlay(alignment: .bottom) {
                Rectangle().fill(TelivuColor.lineSoft).frame(height: 1)
            }

            if !dynamicTypeSize.isAccessibilitySize {
                Spacer(minLength: compact ? 8 : 12)
            }

            VStack(spacing: 8) {
                HStack(spacing: 11) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        TelivuAttachmentLabel(kind: .image)
                    }
                    .buttonStyle(TelivuFlatPressStyle())
                    .accessibilityLabel("Add image")

                    TelivuTalkButton(
                        isListening: model.isListening,
                        size: talkSize,
                        action: model.toggleListening
                    )

                    Button { isFileImporterPresented = true } label: {
                        TelivuAttachmentLabel(kind: .file)
                    }
                    .buttonStyle(TelivuFlatPressStyle())
                    .accessibilityLabel("Add file")
                }

                HStack(spacing: 10) {
                    Text(model.voiceState.actionTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(TelivuColor.ink)
                    Text("·")
                    Text(model.voiceState.actionDetail)
                }
                .font(TelivuFont.micro)
                .tracking(0.25)
                .foregroundStyle(TelivuColor.graphite)
                .textCase(.uppercase)
                .accessibilityElement(children: .combine)

                Text("NOT FOR DIAGNOSIS OR EMERGENCIES.")
                    .font(TelivuFont.micro)
                    .tracking(0.35)
                    .foregroundStyle(TelivuColor.graphite.opacity(0.70))
                    .padding(.top, compact ? 0 : 4)
            }
            .padding(.top, compact ? 3 : 0)
        }
        .padding(.horizontal, TelivuLayout.horizontalInset)
        .padding(.top, compact ? 10 : 15)
        .padding(.bottom, TelivuSpacing.standard)
        .frame(maxWidth: .infinity, minHeight: dynamicTypeSize.isAccessibilitySize ? nil : size.height - TelivuLayout.topBarHeight, alignment: .top)
    }

    private func scheduleNoticeDismissal(for message: String) {
        Task {
            try? await Task.sleep(for: .seconds(3.2))
            guard model.notice == message else { return }
            model.notice = nil
        }
    }
}

#Preview("iPhone 15") {
    TelivuHomeView()
        .preferredColorScheme(.light)
}

#Preview("Accessibility text") {
    TelivuHomeView()
        .environment(\.dynamicTypeSize, .accessibility3)
        .preferredColorScheme(.light)
}
